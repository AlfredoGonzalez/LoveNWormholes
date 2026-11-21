class_name Progress
extends RefCounted
## Read-only questions about campaign progress, answered from a save profile (SaveService.default_profile shape).
## Unlock rules come from data/balance.json campaign.* (spec 9.2) so nothing is hardcoded here.

const FEATURE_KEYS := {
	"upgrades": "campaign.unlock_upgrades_after_stage",
	"squad": "campaign.unlock_squad_after_stage",
	"shop": "campaign.unlock_shop_after_stage",
	"capsules": "campaign.unlock_capsules_after_stage",
}


static func highest_in_era(profile: Dictionary, era: int) -> int:
	return int((profile["progress"]["highest_stage_cleared"] as Dictionary).get(str(era), 0))


## Total stage number of the best stage cleared across all eras (0 if none): (era-1) x 10 + stage.
static func highest_stage_number(profile: Dictionary) -> int:
	var best := 0
	for era in range(1, DataDB.bal_i("campaign.eras", 5) + 1):
		var h := highest_in_era(profile, era)
		if h > 0:
			best = maxi(best, DataDB.stage_number(era, h))
	return best


static func is_era_unlocked(profile: Dictionary, era: int) -> bool:
	if era <= 1:
		return true
	return highest_in_era(profile, era - 1) >= DataDB.bal_i("campaign.boss_stage", 10)


static func is_stage_unlocked(profile: Dictionary, era: int, stage: int) -> bool:
	if not is_era_unlocked(profile, era) or DataDB.stage(era, stage).is_empty():
		return false
	return stage <= 1 or highest_in_era(profile, era) >= stage - 1


static func is_stage_cleared(profile: Dictionary, era: int, stage: int) -> bool:
	return highest_in_era(profile, era) >= stage


## The stage the Play button should start: the first one not cleared yet that exists in the data.
## When everything available is cleared it returns the last stage that exists.
static func next_stage(profile: Dictionary) -> Dictionary:
	var last := {"era": 1, "stage": 1}
	for era in range(1, DataDB.bal_i("campaign.eras", 5) + 1):
		for st in DataDB.stages_of_era(era):
			var idx := int(st["index"])
			last = {"era": era, "stage": idx}
			if is_stage_unlocked(profile, era, idx) and not is_stage_cleared(profile, era, idx):
				return last
	return last


## Stage number (1..50) that must be cleared before a feature appears in the menus.
static func feature_unlock_stage(feature: String) -> int:
	return DataDB.bal_i(str(FEATURE_KEYS.get(feature, "")), 0)


static func feature_unlocked(profile: Dictionary, feature: String) -> bool:
	return highest_stage_number(profile) >= feature_unlock_stage(feature)


static func stage_stars(profile: Dictionary, era: int, stage: int) -> int:
	return int((profile["progress"]["stars"] as Dictionary).get("%d-%d" % [era, stage], 0))


## PROPOSED rule (the spec shows stars on the map but never defines them): 3 stars if the player base
## kept >= 80% HP, 2 stars if >= 50%, otherwise 1. Constants live in balance.json stars.*.
static func stars_for_win(base_hp_fraction: float) -> int:
	if base_hp_fraction >= DataDB.bal_f("stars.three_min_base_hp", 0.8):
		return 3
	if base_hp_fraction >= DataDB.bal_f("stars.two_min_base_hp", 0.5):
		return 2
	return 1
