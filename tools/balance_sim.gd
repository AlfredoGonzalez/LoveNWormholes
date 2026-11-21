extends SceneTree
## Headless balance simulator (spec 6.3). Plays Era 1 stages with the REAL BattleSim + BattleSetup,
## driven by deterministic bots for three player profiles, and prints first-try win rates.
##
##   godot --headless --path . --script res://tools/balance_sim.gd -- [--runs 40] [--seed 1]
##         [--stages 1-10] [--profiles casual,normal,optimized] [--era 1]
##
## Exit code 1 when the release gate fails (normal profile under 45% on any stage). A normal-profile
## win rate outside the 60-75% first-try band only prints a WARNING (stages 3+; stages 1-2 are tutorial
## and are expected above 90%).
##
## Nothing about combat is re-implemented here: this file only decides WHAT to press and WHEN.
## All bot tunables are in PROFILES and in the Bot class, documented in docs/BALANCE.md.

const GATE_MIN := 0.45
const BAND_LO := 0.60
const BAND_HI := 0.75
const TIME_LIMIT := 480.0   # seconds of sim time; a battle still running then counts as a loss

const SQUAD := ["p1_club_worm", "p1_slinger_worm", "p1_dino_rider_worm"]
const POWERS := ["squirm_slam", "apple_rain"]

## Profile definitions. `progress` multiplies the spec pacing (average squad level = 1 + 0.25 x progress x (n-1)).
## react / jitter: seconds between bot decisions (mean, +- uniform). skill: probability that a decision
## uses the smart choice instead of a random affordable card.
const PROFILES := {
	"casual": {"progress": 0.5, "burrow_step": 0.15, "base_step": 0.15, "power_step": 0.0,
			"react": 1.6, "jitter": 1.0, "skill": 0.45, "slam_min": 3, "slam_prob": 0.5, "rain_prob": 0.25, "save": false},
	"normal": {"progress": 1.0, "burrow_step": 0.30, "base_step": 0.30, "power_step": 0.25,
			"react": 0.8, "jitter": 0.5, "skill": 0.85, "slam_min": 2, "slam_prob": 0.9, "rain_prob": 0.9, "save": false},
	"optimized": {"progress": 1.5, "burrow_step": 0.50, "base_step": 0.50, "power_step": 0.45,
			"react": 0.35, "jitter": 0.2, "skill": 1.0, "slam_min": 2, "slam_prob": 1.0, "rain_prob": 1.0, "save": true},
}


class Bot extends RefCounted:
	var p: Dictionary
	var rng := RandomNumberGenerator.new()
	var next_act := 0.0

	func _init(profile: Dictionary, seed_value: int) -> void:
		p = profile.duplicate()
		rng.seed = seed_value
		# Per-run "form of the day": how attentive this attempt is (slower or faster reactions, more or
		# fewer random card picks). This is what spreads outcomes between runs of the same profile.
		p["react"] = float(p["react"]) * rng.randf_range(0.7, 1.7)
		p["skill"] = clampf(float(p["skill"]) - rng.randf_range(0.0, 0.2), 0.0, 1.0)
		next_act = rng.randf_range(0.0, float(p["react"]))

	func act(sim: BattleSim) -> void:
		if sim.time < next_act:
			return
		next_act = sim.time + maxf(0.1, float(p["react"]) + rng.randf_range(-float(p["jitter"]), float(p["jitter"])))
		_powers(sim)
		for _i in 3:
			var c := _choose_card(sim)
			if c < 0 or not sim.spawn_player(c):
				break

	# ---- powers
	func _powers(sim: BattleSim) -> void:
		for i in sim.powers.size():
			if not sim.power_ready(i):
				continue
			var pid := str(sim.powers[i]["id"])
			if pid == "squirm_slam":
				if _slam_worthwhile(sim) and rng.randf() < float(p["slam_prob"]):
					sim.cast_power(i)
			elif pid == "apple_rain":
				# Food low and income still matters (early/mid battle, enemies still to come).
				if sim.food < 70.0 and sim.time > 6.0 and sim.time < 240.0 and rng.randf() < float(p["rain_prob"]):
					sim.cast_power(i)

	func _slam_worthwhile(sim: BattleSim) -> bool:
		var enemies := sim.alive_units(BattleSim.ENEMY)
		if enemies.is_empty():
			return false
		var front: SimUnit = enemies[0]
		for e in enemies:
			if e.x < front.x:
				front = e
		if front.x > 650.0:
			return false   # not at the front yet
		var radius := float(sim.powers[0]["effect"].get("radius_units", 3.0)) * sim.range_unit
		var near := 0
		for e in enemies:
			if absf(e.x - front.x) <= radius:
				near += 1
		return near >= int(p["slam_min"])

	# ---- cards
	func _choose_card(sim: BattleSim) -> int:
		var ready: Array = []
		for i in sim.cards.size():
			if sim.card_ready(i):
				ready.append(i)
		var enemies := sim.alive_units(BattleSim.ENEMY)
		var own := sim.alive_units(BattleSim.PLAYER)
		if ready.is_empty():
			return -1
		if rng.randf() > float(p["skill"]):
			return ready[rng.randi() % ready.size()]
		var best := -1
		var best_score := -1.0e9
		var best_all := -1
		var best_all_score := -1.0e9
		for i in sim.cards.size():
			var st: Dictionary = sim.cards[i]["stats"]
			var role := str(st["role"])
			var s := 0.0
			for e in enemies:
				s += DataDB.counter_multiplier(role, e.role) - 0.5 * DataDB.counter_multiplier(e.role, role)
				if e.role == "heavy" and role == "shooter":
					s += 0.5   # kite it
			for o in own:
				if o.role == role:
					s -= 0.35
			if enemies.is_empty():
				s += 0.3 if role == "fighter" else 0.0
			s -= float(st["cost"]) * 0.002
			if s > best_all_score:
				best_all_score = s
				best_all = i
			if i in ready and s > best_score:
				best_score = s
				best = i
		if bool(p["save"]) and best != best_all and best_all >= 0:
			# Wait for the best card when it is almost ready and food is nearly there.
			var c: Dictionary = sim.cards[best_all]
			var short := float(c["stats"]["cost"]) - sim.food
			if float(c["cd"]) <= 1.5 and short <= sim.food_income * 1.5 and sim.food < sim.food_cap * 0.9:
				return -1
		return best


func _initialize() -> void:
	var args := _parse_args(OS.get_cmdline_user_args())
	var runs := int(args.get("runs", 40))
	var base_seed := int(args.get("seed", 1))
	var era := int(args.get("era", 1))
	var profiles: Array = str(args.get("profiles", "casual,normal,optimized")).split(",")
	var rng_stages := _range(str(args.get("stages", "1-10")))
	var verbose := args.has("verbose")

	var results := {}   # profile -> stage -> {wins, runs, dur, hp}
	for prof in profiles:
		if not PROFILES.has(prof):
			push_error("unknown profile " + str(prof))
			quit(2)
			return
		results[prof] = {}
		for s in rng_stages:
			results[prof][s] = _play_stage(era, int(s), str(prof), runs, base_seed)
			if verbose:
				print("  %s stage %d: %.0f%%" % [prof, s, 100.0 * _rate(results[prof][s])])
	var rc := _report(results, profiles, rng_stages, runs)
	quit(rc)


func _parse_args(argv: PackedStringArray) -> Dictionary:
	var out := {}
	var i := 0
	while i < argv.size():
		var a := argv[i]
		if a.begins_with("--"):
			var key := a.substr(2)
			if i + 1 < argv.size() and not argv[i + 1].begins_with("--"):
				out[key] = argv[i + 1]
				i += 1
			else:
				out[key] = true
		i += 1
	return out


func _range(spec: String) -> Array:
	var out: Array = []
	for part in spec.split(","):
		if "-" in part:
			var ab := part.split("-")
			for s in range(int(ab[0]), int(ab[1]) + 1):
				out.append(s)
		else:
			out.append(int(part))
	return out


## Squad levels so that their mean is `avg` (integer levels, spread over the cards).
static func squad_levels(avg: float) -> Dictionary:
	var out := {}
	var k := SQUAD.size()
	for i in k:
		var lv := int(floor(avg - 1.0 + (float(i) + 0.5) / float(k)))
		out[SQUAD[i]] = clampi(lv + 1, 1, DataDB.bal_i("upgrades.unit.max_level"))
	return out


static func profile_opts(prof: String, n: int) -> Dictionary:
	var p: Dictionary = PROFILES[prof]
	var k := float(n - 1)
	var avg := 1.0 + DataDB.bal_f("scaling.target_avg_level_step") * float(p["progress"]) * k
	var pl := clampi(1 + int(floor(float(p["power_step"]) * k)), 1, DataDB.bal_i("upgrades.power.max_level"))
	return {
		"squad": SQUAD, "unit_levels": squad_levels(avg),
		"burrow_level": clampi(1 + int(round(float(p["burrow_step"]) * k)), 1, DataDB.bal_i("upgrades.burrow.max_level")),
		"base_level": clampi(1 + int(round(float(p["base_step"]) * k)), 1, DataDB.bal_i("upgrades.base.max_level")),
		"powers": POWERS, "power_levels": {"squirm_slam": pl, "apple_rain": pl},
	}


func _play_stage(era: int, stage_index: int, prof: String, runs: int, base_seed: int) -> Dictionary:
	var def := DataDB.stage(era, stage_index)
	var res := {"wins": 0, "runs": runs, "dur": 0.0, "hp": 0.0, "dur_all": 0.0}
	if def.is_empty():
		push_error("no stage %d-%d" % [era, stage_index])
		return res
	var n := DataDB.stage_number(era, stage_index)
	var opts := profile_opts(prof, n)
	var setup := BattleSetup.make(def, opts)
	for r in runs:
		var seed_value := base_seed * 1000003 + n * 7919 + r * 104729 + prof.hash() % 9973
		var sim := BattleSim.new(setup)
		var bot := Bot.new(PROFILES[prof], seed_value)
		while sim.result == "" and sim.time < TIME_LIMIT:
			bot.act(sim)
			sim.tick()
		res["dur_all"] += sim.time
		if sim.result == "win":
			res["wins"] += 1
			res["dur"] += sim.time
			res["hp"] += sim.player_base_hp / sim.player_base_max
	return res


static func _rate(r: Dictionary) -> float:
	return float(r["wins"]) / maxf(1.0, float(r["runs"]))


func _report(results: Dictionary, profiles: Array, stages: Array, runs: int) -> int:
	var rc := 0
	var warnings: Array = []
	print("")
	print("Balance simulator: Era 1, %d runs per cell. First-try win %% | mean win time (s) | mean base HP left on wins (%%)" % runs)
	var head := "stage |"
	for prof in profiles:
		head += " %-26s|" % prof
	print(head)
	for s in stages:
		var line := "%5d |" % s
		for prof in profiles:
			var r: Dictionary = results[prof][s]
			var w := _rate(r)
			var wins := maxf(1.0, float(r["wins"]))
			line += " %5.1f%%  %6.1fs  %5.1f%%   |" % [100.0 * w, float(r["dur"]) / wins if r["wins"] > 0 else 0.0, 100.0 * float(r["hp"]) / wins if r["wins"] > 0 else 0.0]
		print(line)
	print("")
	print("Tries needed (expected = 1/p, P(win within 2 tries) = 1-(1-p)^2):")
	for s in stages:
		var line2 := "%5d |" % s
		for prof in profiles:
			var w2 := _rate(results[prof][s])
			var exp_tries := 1.0 / w2 if w2 > 0.0 else INF
			line2 += " %-9s exp %5.2f  <=2: %5.1f%% |" % [prof, exp_tries, 100.0 * (1.0 - pow(1.0 - w2, 2.0))]
		print(line2)
	if results.has("normal"):
		for s in stages:
			var w3 := _rate(results["normal"][s])
			if w3 < GATE_MIN:
				print("GATE FAIL: normal profile stage %d first-try win %.1f%% < %.0f%%" % [s, 100.0 * w3, 100.0 * GATE_MIN])
				rc = 1
			elif int(s) >= 3 and (w3 < BAND_LO or w3 > BAND_HI):
				warnings.append("WARNING: normal profile stage %d first-try win %.1f%% outside the %.0f-%.0f%% band" % [s, 100.0 * w3, 100.0 * BAND_LO, 100.0 * BAND_HI])
			elif int(s) <= 2 and w3 < 0.90:
				warnings.append("WARNING: normal profile tutorial stage %d first-try win %.1f%% below 90%%" % [s, 100.0 * w3])
	for w4 in warnings:
		print(w4)
	print("GATE: " + ("FAIL" if rc != 0 else "ok"))
	return rc
