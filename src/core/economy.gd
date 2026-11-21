class_name Economy
extends RefCounted
## Single source of truth for currencies and economy formulas (spec 6, 8.3). Never touches UI; emits signals.
## Driven by the `balance` Dictionary of data/balance.json (DataDB.balance(); missing keys fall back to the
## spec 6 values and are recorded in `missing_keys`). Every state change is persisted through SaveService (write on every reward).
## Gems never convert to coins: there is no conversion API and spend() is per currency.

signal currency_changed(currency: String, new_value: int, delta: int)
signal unit_upgraded(unit_id: String, level: int)
signal upgrade_purchased(kind: String, id: String, level: int)
signal battle_settled(result: Dictionary)
signal offline_claimed(coins: int)
signal daily_claimed(result: Dictionary)

const CURRENCIES := ["coins", "gems", "chrono_dust", "capsules"]
const BOSS_STAGE := 10

var balance: Dictionary
var save_service: SaveService
## Every balance key that was asked for but absent from `balance` (the default was used). Tests assert it is empty.
var missing_keys: Array[String] = []

func _init(p_balance: Dictionary, p_save: SaveService) -> void:
	balance = p_balance
	save_service = p_save

var profile: Dictionary:
	get: return save_service.profile

## Dotted-path lookup in the balance dictionary, e.g. _b("upgrades.unit.cost_start", 60).
func _b(key_path: String, default):
	var cur = balance
	for part in key_path.split("."):
		if typeof(cur) != TYPE_DICTIONARY or not cur.has(part):
			if not missing_keys.has(key_path):
				missing_keys.append(key_path)
			return default
		cur = cur[part]
	return cur

func _persist() -> void:
	save_service.save()

# ---------------------------------------------------------------- currencies

func get_amount(currency: String) -> int:
	return int(profile["currencies"].get(currency, 0))

func can_afford(currency: String, amount: int) -> bool:
	return amount >= 0 and CURRENCIES.has(currency) and get_amount(currency) >= amount

func add(currency: String, amount: int, persist := true) -> bool:
	if amount < 0 or not CURRENCIES.has(currency):
		return false
	if amount == 0:
		return true
	profile["currencies"][currency] = get_amount(currency) + amount
	currency_changed.emit(currency, get_amount(currency), amount)
	if persist:
		_persist()
	return true

func spend(currency: String, amount: int, persist := true) -> bool:
	if amount < 0 or not can_afford(currency, amount):
		return false
	if amount == 0:
		return true
	profile["currencies"][currency] = get_amount(currency) - amount
	currency_changed.emit(currency, get_amount(currency), -amount)
	if persist:
		_persist()
	return true

## Adds a bundle {coins, gems, chrono_dust, capsules} with a single save. Used for rewards and purchases.
func add_bundle(bundle: Dictionary, persist := true) -> void:
	for c in CURRENCIES:
		if bundle.has(c):
			add(c, int(bundle[c]), false)
	if persist:
		_persist()

# ---------------------------------------------------------------- upgrade formulas (spec 6.2)

static func _geo(base: float, growth: float, level: int) -> int:
	## Cost to reach `level` (>= 2): round(base x growth^(level-2)).
	return int(round(base * pow(growth, level - 2)))

func unit_max_level() -> int:
	return int(_b("upgrades.unit.max_level", 20))

func unit_level(unit_id: String) -> int:
	return int(profile["units"].get(unit_id, 1))

func unit_upgrade_cost(to_level: int) -> int:
	if to_level < 2 or to_level > unit_max_level():
		return -1
	return _geo(float(_b("upgrades.unit.cost_start", 60)), float(_b("upgrades.unit.cost_growth", 1.18)), to_level)

func unit_stat_multiplier(level: int) -> float:
	return 1.0 + float(_b("scaling.unit_level_step", 0.10)) * (level - 1)

func upgrade_unit(unit_id: String) -> bool:
	var next := unit_level(unit_id) + 1
	var cost := unit_upgrade_cost(next)
	if cost < 0 or not spend("coins", cost, false):
		return false
	profile["units"][unit_id] = next
	_persist()
	unit_upgraded.emit(unit_id, next)
	return true

func burrow_level() -> int:
	return int(profile["upgrades"].get("food_burrow", 1))

func burrow_max_level() -> int:
	return int(_b("upgrades.burrow.max_level", 10))

func burrow_cost(to_level: int) -> int:
	if to_level < 2 or to_level > burrow_max_level():
		return -1
	return _geo(float(_b("upgrades.burrow.cost_start", 80)), float(_b("upgrades.burrow.cost_growth", 1.45)), to_level)

## Extra Food per second at `level` (level 1 is the unupgraded baseline, so +1.2 per level above 1).
func burrow_income_bonus(level: int) -> float:
	return float(_b("upgrades.burrow.income_per_level", 1.2)) * (level - 1)

func burrow_cap_bonus(level: int) -> float:
	return float(_b("upgrades.burrow.cap_per_level", 60)) * (level - 1)

func upgrade_burrow() -> bool:
	return _upgrade_simple("food_burrow", burrow_level(), burrow_cost(burrow_level() + 1))

func base_level() -> int:
	return int(profile["upgrades"].get("base", 1))

func base_max_level() -> int:
	return int(_b("upgrades.base.max_level", 10))

func base_cost(to_level: int) -> int:
	if to_level < 2 or to_level > base_max_level():
		return -1
	return _geo(float(_b("upgrades.base.cost_start", 100)), float(_b("upgrades.base.cost_growth", 1.45)), to_level)

func base_hp_multiplier(level: int) -> float:
	return 1.0 + float(_b("upgrades.base.hp_per_level", 0.10)) * (level - 1)

func upgrade_base() -> bool:
	return _upgrade_simple("base", base_level(), base_cost(base_level() + 1))

func _upgrade_simple(key: String, level: int, cost: int) -> bool:
	if cost < 0 or not spend("coins", cost, false):
		return false
	profile["upgrades"][key] = level + 1
	_persist()
	upgrade_purchased.emit(key, key, level + 1)
	return true

func power_level(power_id: String) -> int:
	return int(profile["upgrades"]["powers"].get(power_id, 1))

func power_max_level() -> int:
	return int(_b("upgrades.power.max_level", 5))

func power_cost(to_level: int) -> int:
	if to_level < 2 or to_level > power_max_level():
		return -1
	return _geo(float(_b("upgrades.power.cost_start", 150)), float(_b("upgrades.power.cost_growth", 1.6)), to_level)

func power_effect_multiplier(level: int) -> float:
	return 1.0 + float(_b("upgrades.power.effect_per_level", 0.12)) * (level - 1)

func power_cooldown_multiplier(level: int) -> float:
	return 1.0 - float(_b("upgrades.power.cooldown_per_level", 0.04)) * (level - 1)

func upgrade_power(power_id: String) -> bool:
	var level := power_level(power_id)
	var cost := power_cost(level + 1)
	if cost < 0 or not spend("coins", cost, false):
		return false
	profile["upgrades"]["powers"][power_id] = level + 1
	_persist()
	upgrade_purchased.emit("power", power_id, level + 1)
	return true

# ---------------------------------------------------------------- stages and rewards (spec 6.3, 6.4)

static func stage_number(era: int, stage: int) -> int:
	return (era - 1) * 10 + stage

static func stage_id(era: int, stage: int) -> String:
	return "%d-%d" % [era, stage]

func win_reward(n: int) -> int:
	return int(round(float(_b("rewards.win_coins_base", 30)) * pow(float(_b("rewards.win_coins_growth", 1.06)), n - 1)))

func loss_reward(n: int) -> int:
	return int(round(win_reward(n) * float(_b("rewards.loss_fraction", 0.4))))

func is_first_clear(era: int, stage: int) -> bool:
	return not profile["progress"]["first_clear"].get(stage_id(era, stage), false)

## Highest stage number n (1..50) cleared overall, 0 if none.
func highest_stage_cleared() -> int:
	var best := 0
	for e in profile["progress"]["highest_stage_cleared"]:
		var s := int(profile["progress"]["highest_stage_cleared"][e])
		if s > 0:
			best = maxi(best, stage_number(int(e), s))
	return best

func bosses_cleared() -> int:
	var n := 0
	for e in profile["progress"]["highest_stage_cleared"]:
		if int(profile["progress"]["highest_stage_cleared"][e]) >= BOSS_STAGE:
			n += 1
	return n

func loss_streak(era: int, stage: int) -> int:
	return int(profile["progress"]["loss_streak"].get(stage_id(era, stage), 0))

## Underdog Bonus (6.4), same rule as DataDB.underdog_stacks: nothing until `losses_to_trigger` consecutive losses,
## then each further loss adds one stack (clamp(losses - trigger, 0, max_stacks)). Returns {stacks, food_pct, base_hp_pct} (fractions).
func underdog(era: int, stage: int) -> Dictionary:
	var losses := loss_streak(era, stage)
	var before := int(_b("underdog.losses_to_trigger", 2))
	var stacks := clampi(losses - before, 0, int(_b("underdog.max_stacks", 3)))
	return {
		"stacks": stacks,
		"food_pct": stacks * float(_b("underdog.food_per_stack", 0.10)),
		"base_hp_pct": stacks * float(_b("underdog.base_hp_per_stack", 0.10)),
	}

## Applies the end of a battle: rewards, progress, loss streak. One save. `coin_multiplier` is for the
## "Double Coins" ad / Golden Pass (applied to the final Coin amount). Returns the result summary.
func settle_battle(era: int, stage: int, won: bool, stars := 0, coin_multiplier := 1) -> Dictionary:
	var n := stage_number(era, stage)
	var sid := stage_id(era, stage)
	var result := {"won": won, "coins": 0, "gems": 0, "capsules": 0, "first_clear": false, "boss_first_clear": false, "game_completed": false}
	var prog: Dictionary = profile["progress"]
	if won:
		var coins := win_reward(n)
		var first := is_first_clear(era, stage)
		if first:
			coins *= int(_b("rewards.first_clear_coins_mult", 2))
			result["gems"] = int(_b("rewards.first_clear_gems", 5))
			result["first_clear"] = true
			if stage == BOSS_STAGE:
				# Boss first clear pays the boss bundle instead of the regular first-clear gems.
				result["gems"] = int(_b("rewards.boss_first_clear_gems", 20))
				result["capsules"] = int(_b("rewards.boss_first_clear_capsules", 1))
				result["boss_first_clear"] = true
			prog["first_clear"][sid] = true
		# Relics (Lucky Clover, Golden Dewdrop): + coins %, before the ad multiplier.
		coins = int(round(coins * (1.0 + float(Relics.modifiers(profile).get("coins", 0.0)))))
		result["coins"] = coins * maxi(coin_multiplier, 1)
		var era_key := str(era)
		prog["highest_stage_cleared"][era_key] = maxi(int(prog["highest_stage_cleared"].get(era_key, 0)), stage)
		prog["stars"][sid] = maxi(int(prog["stars"].get(sid, 0)), clampi(stars, 0, 3))
		prog["loss_streak"].erase(sid)
		# Final victory (5-10, Count Magpie 3000): the game is complete. `game_completed` in the result is true only
		# the first time (the story screen shows the ending once); the profile flag stays true forever.
		if era == int(_b("campaign.eras", 5)) and stage == BOSS_STAGE:
			result["game_completed"] = not bool(prog.get("game_completed", false))
			prog["game_completed"] = true
	else:
		result["coins"] = loss_reward(n)
		prog["loss_streak"][sid] = loss_streak(era, stage) + 1
	add_bundle(result, false)
	_persist()
	battle_settled.emit(result)
	return result

## Undoes a LOSS settlement (Second Wind: the battle goes on, so the final result is the one that pays).
## Subtracts the coins that loss paid (never below 0) and decrements the stage's loss streak (never below 0;
## the entry is erased at 0). `settle_result` is the dictionary settle_battle returned. A win result is
## ignored (returns false). Persisted once; emits currency_changed (negative delta) but not battle_settled.
func revert_loss(era: int, stage: int, settle_result: Dictionary) -> bool:
	if bool(settle_result.get("won", false)) or settle_result.is_empty():
		return false
	var coins := int(settle_result.get("coins", 0))
	var take := mini(maxi(coins, 0), get_amount("coins"))
	if take > 0:
		profile["currencies"]["coins"] = get_amount("coins") - take
		currency_changed.emit("coins", get_amount("coins"), -take)
	var sid := stage_id(era, stage)
	var streak := loss_streak(era, stage) - 1
	if streak > 0:
		profile["progress"]["loss_streak"][sid] = streak
	else:
		profile["progress"]["loss_streak"].erase(sid)
	_persist()
	return true

# ---------------------------------------------------------------- offline Worm Farm (6.5)

func offline_rate_per_minute() -> float:
	return float(_b("offline.coins_per_min_base", 2)) + float(_b("offline.coins_per_min_per_stage", 0.4)) * highest_stage_cleared()

## Cap in hours: min(base + 1 per boss, max) plus IAP hours (Golden Pass +2).
func offline_cap_hours(extra_hours := 0.0) -> float:
	var h := float(_b("offline.cap_hours_base", 3)) + float(_b("offline.cap_hours_per_boss", 1)) * bosses_cleared()
	return minf(h, float(_b("offline.cap_hours_max", 8))) + extra_hours

func offline_pending(now: float, extra_hours := 0.0) -> int:
	var last := float(profile["timestamps"].get("offline_farm", 0))
	if last <= 0.0 or now <= last:
		return 0
	var minutes := minf((now - last) / 60.0, offline_cap_hours(extra_hours) * 60.0)
	return floori(minutes * offline_rate_per_minute())

## Claims the offline coins (multiplier 2 for the Double Farm ad) and restarts the timer.
func claim_offline(now: float, extra_hours := 0.0, multiplier := 1) -> int:
	var coins := offline_pending(now, extra_hours) * maxi(multiplier, 1)
	profile["timestamps"]["offline_farm"] = now
	add("coins", coins, false)
	_persist()
	offline_claimed.emit(coins)
	return coins

# ---------------------------------------------------------------- daily login (6.6)

static func day_index(now: float) -> int:
	return int(floor(now / 86400.0))

func can_claim_daily(now: float) -> bool:
	var last := float(profile["timestamps"].get("daily_claim", 0))
	return last <= 0.0 or day_index(now) > day_index(last)

func claim_daily(now: float) -> Dictionary:
	if not can_claim_daily(now):
		return {"claimed": false}
	var ts: Dictionary = profile["timestamps"]
	var last := float(ts.get("daily_claim", 0))
	var streak := int(ts.get("daily_streak", 0))
	streak = streak + 1 if (last > 0.0 and day_index(now) == day_index(last) + 1) else 1
	var bundle := {
		"capsules": int(_b("daily.login_capsules", 1)),
		"gems": int(_b("daily.login_gems", 10)),
	}
	var cycle := int(_b("daily.streak_day", 7))
	var streak_bonus := cycle > 0 and streak % cycle == 0
	if streak_bonus:
		bundle["gems"] = int(bundle["gems"]) + int(_b("daily.streak_bonus_gems", 50))
		bundle["capsules"] = int(bundle["capsules"]) + int(_b("daily.streak_bonus_capsules", 1))
	ts["daily_claim"] = now
	ts["daily_streak"] = streak
	add_bundle(bundle, false)
	_persist()
	var result := {"claimed": true, "streak": streak, "streak_bonus": streak_bonus, "reward": bundle}
	daily_claimed.emit(result)
	return result
