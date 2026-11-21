extends TestCase
## Economy.revert_loss: Second Wind undoes the mercy settlement so a battle pays once.

const P := "user://t_econ_revert.json"


func _clean() -> void:
	for p in [P, "user://t_econ_revert.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)


func _eco() -> Economy:
	_clean()
	var bal := {"rewards": {"win_coins_base": 30, "win_coins_growth": 1.06, "first_clear_coins_mult": 2,
			"first_clear_gems": 5, "loss_fraction": 0.4}}
	return Economy.new(bal, SaveService.new(P))


func test_revert_undoes_a_loss() -> void:
	var e := _eco()
	var seen := []
	e.currency_changed.connect(func(c, v, d): seen.append([c, v, d]))
	var r := e.settle_battle(1, 2, false)
	assert_true(r["coins"] > 0)
	assert_eq(e.loss_streak(1, 2), 1)
	seen.clear()
	assert_true(e.revert_loss(1, 2, r))
	assert_eq(e.get_amount("coins"), 0, "mercy coins taken back")
	assert_eq(e.loss_streak(1, 2), 0, "streak back")
	assert_eq(seen, [["coins", 0, -int(r["coins"])]], "signal-safe: a negative delta")
	var s2 := SaveService.new(P)
	s2.load_profile()
	assert_eq(s2.profile["currencies"]["coins"], 0, "persisted")
	assert_true(not s2.profile["progress"]["loss_streak"].has("1-2"), "persisted streak")
	_clean()


func test_revert_decrements_only_one_and_never_below_zero() -> void:
	var e := _eco()
	e.settle_battle(1, 3, false)
	e.settle_battle(1, 3, false)
	var r := e.settle_battle(1, 3, false)
	assert_eq(e.loss_streak(1, 3), 3)
	e.revert_loss(1, 3, r)
	assert_eq(e.loss_streak(1, 3), 2)
	# Reverting with nothing left to take never goes negative.
	e.spend("coins", e.get_amount("coins"))
	e.revert_loss(1, 3, r)
	e.revert_loss(1, 3, r)
	e.revert_loss(1, 3, r)
	assert_eq(e.loss_streak(1, 3), 0)
	assert_eq(e.get_amount("coins"), 0, "coins never below 0")
	_clean()


func test_revert_ignores_wins_and_empty() -> void:
	var e := _eco()
	var w := e.settle_battle(1, 1, true, 3)
	var coins := e.get_amount("coins")
	assert_true(not e.revert_loss(1, 1, w), "a win is never reverted")
	assert_true(not e.revert_loss(1, 1, {}))
	assert_eq(e.get_amount("coins"), coins)
	_clean()


func test_loss_revert_then_win_pays_once() -> void:
	var e := _eco()
	var lose := e.settle_battle(1, 1, false)
	e.revert_loss(1, 1, lose)
	var win := e.settle_battle(1, 1, true, 2)
	assert_eq(e.get_amount("coins"), int(win["coins"]), "only the final result paid")
	assert_eq(e.loss_streak(1, 1), 0)
	_clean()
