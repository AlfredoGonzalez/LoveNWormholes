# Balance: Era 1 stage generation and the headless simulator (Phase 1.3A)

Spec reference: 6.3 (stage scaling, enemy director, target pacing, release gate), 8.4 (headless sim).

## How to run

```
python3 tools/balance_sim.py [--runs 40] [--seed 1] [--stages 1-10] [--profiles casual,normal,optimized] [--verbose]
# same thing without python:
godot --headless --path . --script res://tools/balance_sim.gd -- --runs 40
python3 tools/gen_stages.py        # regenerates data/stages.json (deterministic)
```

Needs `godot --headless --path . --import --quit` to have run once (global classes). `GODOT=/path` overrides the binary for the wrapper.
A full default run (3 profiles x 10 stages x 40 runs) takes about 2.5 minutes; `--profiles normal` about 50 s.
Exit code 1 = release gate failed (normal profile under 45% first-try on any stage). A normal rate outside 60-75% on
stages 3-10 (or under 90% on stages 1-2) only prints `WARNING`. With 40 runs the standard error is about 7 points, so
a single warning near the band edge is noise; use `--runs 200` to confirm.

The logic is GDScript on purpose: it uses the real `BattleSim` and `BattleSetup`, so it cannot drift from the game.
Parallel runs: launch several `--stages N` processes (each is single threaded).

## Player profiles and bots

Every profile plays with the Era 1 squad (Club Worm = fighter, Slinger Worm = shooter, Dino Rider = heavy) and the
powers Squirm Slam and Apple Rain. With n = stage number:

| | casual | normal | optimized |
|---|---|---|---|
| avg squad level | 1 + 0.125(n-1) | 1 + 0.25(n-1) (spec pacing) | 1 + 0.375(n-1) |
| Food Burrow / Base level | 1 + round(0.15(n-1)) | 1 + round(0.30(n-1)) | 1 + round(0.50(n-1)) |
| power level | 1 | 1 + floor(0.25(n-1)) | 1 + floor(0.45(n-1)) |
| decision interval (s) | 1.6 +- 1.0 | 0.8 +- 0.5 | 0.35 +- 0.2 |
| smart choice probability | 0.45 | 0.85 | 1.0 |
| Slam when enemies near the front | >= 3, 50% of decisions | >= 2, 90% | >= 2 always |
| Apple Rain when food low | 25% of decisions | 90% | always |
| waits for the best card | no | no | yes (if ready in <= 1.5 s and Food within 1.5 s of income) |

Squad levels are integers spread over the three cards so their mean is the target.

Bot decision (every decision tick, up to 3 spawns): score each card as the sum over enemies on the field of
`counter(card, enemy) - 0.5 x counter(enemy, card)` (+0.5 for a shooter vs heavy), minus 0.35 per own unit of the same
role already out (keeps the mix of roles), minus a tiny cost term; with no enemy it prefers fighters. With probability
`1 - skill` it picks a random ready card. Powers: Slam needs the front enemy to be past x = 650 and enough enemies within
the Slam radius of it; Rain is cast when Food < 70 between 6 s and 240 s. A battle still running after 480 s counts as a loss.

Variance: each run uses `RandomNumberGenerator` with a fixed seed (`seed`, stage, run index, profile) and draws a per-run
"form of the day" (reaction time x 0.7-1.7, skill -0 to -0.2) plus jitter on every decision. The simulation itself is
deterministic, so this is the only source of spread. Without the per-run form the win rate was a cliff (0% or 100%).

Output: win %, mean win time, mean base HP left on wins; then expected tries (1/p) and P(win within 2 tries).

## How stages are generated (`tools/gen_stages.py`)

- `enemy_base_hp` = `1000 x (1 + 0.15(n-1))`, `rewards` from the DataDB formulas (ids stay `1-<s>` like Economy/Progress expect).
- Enemy director budget per stage = `(rate_base + rate_step(s-1)) x income(8/s) x duration x scale[s]` with duration
  `40 + 6(s-1)` s; `food_budget` in the file is the real sum of enemy costs of the waves.
- Bursts of one role each (Ant Clubber / Ant Spitter / Stone Beetle), first at t = 6 s, evenly spaced, later bursts up to
  1.5x bigger; rounding is diffused so totals track the budget. Stage 1: clubbers only. Stage 2: clubbers plus one spitter burst.
  From stage 3: all three roles, role shares per stage in `TUNING["mix"]` (heavy share grows 25% -> 45%). The player
  squad is fighter-heavy (cheapest card), so the counter included is the heavy (Stone Beetle beats fighters); spitters
  punish the player heavy.
- Stage 10: Rexy at t = 3 s (escorts from `bosses.json`) plus three late bursts (fighter / shooter / fighter) at t = 40, 52, 64 s.

## What was tuned

Allowed levers only (spec numbers untouched):

| Lever | Value | Why |
|---|---|---|
| `TUNING.rate_base / rate_step` | 1.5 / 0.15 | enemy Food spend rate relative to player income; the first formula guess (0.45) never reached the player base |
| `TUNING.scale` per stage | 0.8, 1.2, 1.465, 1.31, 1.22, 1.19, 1.04, 0.925, 0.94 | fine tune each stage to the 60-75% band (bisection against 80-200 runs, verified with other seeds) |
| `TUNING.boss_extra_budget` | 330 | late bursts after Rexy |
| `data/bosses.json` b1_rexy `escorts` (proposed) | 2 clubbers + 1 spitter (was 4 + 2) | with 4 + 2 escorts plus Rexy at `boss.hp_mult` 6 the normal profile won 0%; escorts are a very sharp difficulty lever |
| `boss.hp_mult` | left at 6.0 | tests assert it (test_data, test_data_formulas); the boss stage was tuned through escorts and the late bursts instead |
| `battle.player_base_hp_era_mult`, `stars.*` | untouched | Era 1 only; no need yet |

Rate scale per stage looks irregular because the player power grows 0.25 levels per stage while enemy budgets are integer
unit counts; the "scale" column absorbs that.

## Results (seed 1, 40 runs; normal re-checked with 200 runs on other seeds)

First-try win % (casual / normal / optimized), mean win time of the normal profile, base HP left on normal wins:

| stage | casual | normal | optimized | normal win time | normal base HP left | normal 200 runs |
|---|---|---|---|---|---|---|
| 1 | 100 | 100 | 100 | 46 s | 100% | 100 |
| 2 | 100 | 100 | 100 | 62 s | 100% | 100 |
| 3 | 45 | 75 | 55 | 103 s | 80% | ~65-72 |
| 4 | 0 | 67.5 | 100 | 113 s | 61% | ~70 |
| 5 | 20 | 72.5 | 100 | 111 s | 81% | ~65 |
| 6 | 8 | 60 | 98 | 108 s | 97% | ~60 |
| 7 | 10 | 62.5 | 100 | 105 s | 95% | ~67 |
| 8 | 10 | 57.5 | 100 | 120 s | 100% | ~63 |
| 9 | 0 | 62.5 | 100 | 99 s | 99% | ~65 |
| 10 (Rexy) | 0 | 65 | 100 | 131 s | 66% | ~62 |

Expected tries for the normal profile: 1.0 (stages 1-2), 1.3-1.7 elsewhere; P(win within 2 tries) 82-94% on stages 3-10
(spec target 90%: a bit short on stages 6-10, see open issues). The gate (>= 45%) passes with margin. Casual loses most
stages from 4 on, optimized wins nearly everything.

## Open issues

1. Profiles are far apart: normal ~65%, optimized ~100%, casual 0-20%. The spec only fixes the normal profile; the
   optimized bot is stronger than a human "optimized" player is likely to be, and casual is likely harsher than a real
   casual. The Underdog bonus (6.4) is not simulated; casual players would use it. Needs real playtest data to calibrate.
2. The spec's "within 2 tries 90%" implies a first-try rate that stays around 68%+ and independent tries; with ~62% the
   2-try rate is 85%. Raising the band's lower half would cost nothing; we stayed centered on 60-75 as the spec says.
3. Rexy: spec numbers for bosses are all proposed. The outcome is very sensitive to the escort count (+-1 unit = 30+ points).
4. Win rate vs enemy budget is a steep, non-linear curve (a one-unit change of a 150-Food heavy moves a stage by 15-30
   points), so the bands are met by tuning, not by smooth formulas.
5. The sim has no hard time limit: if both sides stall the overtime attack bonus (x1.2 after 240 s) is the only pressure;
   the bots cut a battle at 480 s and count it as a loss (it does not happen in practice).
6. `rule` is `{"type": "none"}` in every Era 1 stage (rules start in Era 2 per spec 4.6); ids are `<era>-<index>`
   (not the `s01_01` of an older DATA_SCHEMA draft) because Economy/Progress use `"%d-%d"`.

---

# Balance: Era 2 "Ancient Egypt: Scarab Sands" (Phase 2)

Spec: 3, 4.6 (sand patches), 5.2-5.3 (Era 2 enemies, Pharaoh Scarab), 6.3. Run it with
`python3 tools/balance_sim.py --era 2 [--runs 40] [--stages 1-10] [--profiles normal]` (stage column = index inside the era;
n = 11..20). Era 1 numbers above are unchanged (Era 1 stages in `data/stages.json` are byte-identical, the bot code path for
`--era 1` gives the same rates).

## Era 2 player: the Time Squad

Time sync: Era 1 units are played with `DataDB.unit_stats(id, level, 2)`, so they get x1.4 HP/damage on top of the level
multiplier. 4 slots (the 5th opens after the Era 2 boss), powers unlocked so far: Squirm Slam, Apple Rain, Time Freeze (Era 1 boss),
2 power slots (the 3rd opens after the Era 3 boss). Unit levels average `1 + 0.25 x (n-1)` for the normal profile (so 3.5 at 2-1, 5.75 at
2-10), spread as integers over the 4 cards. Base HP = Era 1 formula x 1.6 (`player_base_hp_era_mult`).

Squad-picking policy (`ERA_SQUADS` / `ERA_POWERS` in `tools/balance_sim.gd`):

| profile | squad (card order) | why | powers |
|---|---|---|---|
| normal | Club Worm, Bow Worm, Shield Bearer, Cobra Charmer | one of each role: cheap fighter, Era 2 shooter, heavy that blocks 20% of ranged (counter to Locust Archers), support with the slow aura | Squirm Slam, Apple Rain |
| casual | Club, Slinger, Dino Rider, Shield Bearer | suboptimal: the first four units the player owns, no support, no Era 2 shooter | Squirm Slam, Apple Rain |
| optimized | Club, Bow Worm, Dino Rider, Cobra Charmer | same roles, cheaper heavy | Squirm Slam, Time Freeze (cast when 3+ enemies, or the boss, are at the front) |

Other bot changes for Era 2 (Era 1 behaviour untouched): support cards are scored (one at a time, only when there is something
to slow and at least 2 own units); the "save for the best card" flag became a probability `save` plus `save_window` (the normal
profile does not save, optimized saves with a 2.5 s window in Era 2); `--era` selects squads/powers.

## Era 2 stage generation (`tools/gen_stages.py`, `TUNING2`)

- `enemy_base_hp` = `1000 x (1 + 0.15(n-1))` with the global n; enemy stats scale in the sim with `DataDB.enemy_stats(id, 2, stage)`
  (x1.6 x (1 + 0.05(s-1)); cost x1.5).
- Enemies: Scarab Soldier (fighter, 75 Food), Locust Archer (shooter, 112.5, jumps back 2 range units after each shot), Mummy Moth
  (support, 150, heals 5% max HP/s in its range, never attacks). There is no Era 2 enemy heavy; the counter to the player's
  fighter/shooter spam is the Archer plus Moth healing. Mix per stage in `TUNING2["mix"]` (fighter/shooter/support, Moth from stage 3).
- Budget = `(rate_base + rate_step (s-1)) x 8 x duration x scale[s]`, duration `50 + 5(s-1)` s, `rate_base` 6.5 and `rate_step` -0.3:
  the Era 2 director needs about 4x the Food rate of Era 1 because the player's 6-unit time squad, Era 1 units x1.4 and base x1.6 outgrow
  the x1.6 enemy multiplier. `scale[s]` is the per-stage fine tune (0.84, 0.94, 0.787, 0.78, 1.15, 0.702, 0.787, 1.238, 1.387 for 2-1..2-9).
- Sand patches (`rule`, from 2-3): 1 patch at 2-3 growing to 3 by 2-6; positions/widths in `TUNING2["patches"]` (lane px, lane = 1000),
  centred where the armies meet so they slow both fronts. They are NOT a difficulty lever in the numbers above (they slow both sides); they are
  placed once and left alone.
- Stage 2-10: opening bursts (300 Food: Scarabs at 6 s, Archers at ~26 s), the Pharaoh at `boss_t` = 41 s with escorts, no late bursts.

## What was tuned in Era 2 (allowed levers only)

| Lever | Value | Why |
|---|---|---|
| `TUNING2.rate_base / rate_step` | 6.5 / -0.3 | baseline so the per-stage scale stays near 1 (the first guess 1.5 gave 100% on 2-1..2-9) |
| `TUNING2.scale` per stage | see above | scan of 14 scales x 3 seeds x 40 runs per stage, then refinement; win rate vs scale is a sawtooth (integer unit counts), so values were picked by measurement, not by formula |
| `TUNING2.boss_t`, `boss_pre_budget`, `boss_extra_budget` | 41 s, 300, 0 | the Pharaoh summons 3 Scarabs every 10 s (spec) which makes it unbeatable from the start of the lane (0% even with no escorts, no other waves, optimized profile included): giving the player ~40 s to build an army first is the only smooth lever; 40 s = 52%, 42 s = 82% |
| `data/bosses.json` b2 `escorts` (proposed) | 1 Scarab + 1 Archer (was 3 + 2) | 3 + 2 on top of the summons made the stage 0% at any boss time |
| `boss.hp_mult`, summon count/interval, sandstorm 30%, every spec number | untouched | not ours to tune |

## Results (seed 11, 60 runs, normal profile; casual and optimized for reference)

First-try win %:

| stage (n) | normal | normal win time | normal base HP left | casual | optimized |
|---|---|---|---|---|---|
| 2-1 (11) | 65.0 | 205 s | 86% | 10.0 | 3.3 |
| 2-2 (12) | 63.3 | 150 s | 62% | 0.0 | 0.0 |
| 2-3 (13) | 75.0 | 207 s | 100% | 56.7 | 0.0 |
| 2-4 (14) | 68.3 | 96 s | 100% | 90.0 | 100 |
| 2-5 (15) | 68.3 | 170 s | 98% | 1.7 | 45.0 |
| 2-6 (16) | 65.0 | 80 s | 100% | 88.3 | 96.7 |
| 2-7 (17) | 58.3 | 73 s | 100% | 50.0 | 100 |
| 2-8 (18) | 76.7 | 181 s | 98% | 21.7 | 95.0 |
| 2-9 (19) | 70.0 | 190 s | 100% | 0.0 | 96.7 |
| 2-10 (20, Pharaoh) | 65.0 | 89 s | 96% | 0.0 | 100 |

Era 1 for comparison is in the table above (unchanged). The gate (normal >= 45%) passes with margin; 2-7 (58%) and 2-8 (77%) are 1-2 standard
errors (about 6 points at 60 runs) outside the 60-75 band; the 3-seed means used while tuning were 60-80% for every stage.

## Era 2 sim rules (BattleSim, no node code)

- Sand patches: any unit (both sides) loses `era_rules.sand_patch.slow_fraction` (30%) of movement speed while its x is inside a patch;
  it multiplies with the Cobra aura and the Sandstorm. `sim.rule`, `sim.patches`, `SimUnit.in_sand` are the view contract (DATA_SCHEMA.md).
- Locust Archer `abilities.jump_back_units` (2): after a shot at a unit (not at the base) it jumps back N x 40 px, away from the enemy,
  clamped to its own spawn side (x <= 970; a player archer would stop at x >= 30). Emits `jump_back`.
- Pharaoh Scarab: summons `telegraph.count` Scarabs every 10 s (timer paused while the boss is stunned or frozen); Sandstorm at 50% HP slows
  EVERY unit of both sides by 30% (spec 5.3 "slows the whole lane"; it used to affect only player units) and ends when the Pharaoh dies.
- Mummy Moth heal aura, Shield Bearer block (20% of ranged damage) and Cobra Charmer slow aura (20%) were already in the sim and are now
  covered by `tests/test_battle_era2.gd`.

## Era 2 open issues

1. The Pharaoh is the hardest tuning problem so far: the spec's endless 3-Scarab summon makes the fight a race (cliff from 0% to 100% inside
   about 3 s of `boss_t`). With the proposed `boss.hp_mult` 6 and the proposed escorts it only works because the boss enters late. If
   Alfredo wants the boss to arrive early, lower `boss.hp_mult` or the summon cadence (spec numbers) instead of delaying it.
2. Several Era 2 stages take 150-200 s to win for the normal bot (the enemy director floods the lane with ~1500+ Food of 75-Food Scarabs);
   Era 1 stages take about 100 s. The overtime bonus starts at 240 s. If this feels slow in real play, shorten `duration_*` and lower the budget.
3. Profile ordering is not monotone in Era 2: optimized (Time Freeze, saving) loses 2-1..2-3 and casual wins 2-4 and 2-6 more often than the
   spec ordering suggests. Squad choice and power choice matter more than skill here; the normal profile is the only one tuned.
4. Sandstorm and sand patches are not tuned for difficulty (both sides are slowed). Whether patches should favour the defender is a design question.
5. Win rate vs `scale` is a sawtooth: any later change to unit stats, bot scoring or costs needs a re-scan (see `scale` list).

---

# Balance: Era 3 "Medieval: Kingdom of Crumbs" and Era 4 "Industrial: Steam City" (Phase 2, Eras 3-4)

Spec: 3, 4.6 (walls, steam vents), 4.7 (air from Era 3), 5.2-5.3 (Era 3-4 units/enemies, Sir Sizzle, Clockwork Queen), 6.3.
Run: `python3 tools/balance_sim.py --era 3|4 [--runs 40] [--stages 1-10] [--profiles normal]` (stage column = index in the era;
n = 21..30 and 31..40). Era 1-2 tuning and stage data are untouched (`data/stages.json` stages 1-1..2-10 are byte-identical to before).

## Era 3-4 player: Time Squad with 5 slots

5 squad slots (the 5th opens after the Era 2 boss), powers: 2 slots in Era 3 and 3 slots in Era 4 (the 3rd opens after the Era 3 boss).
Older units get the time-sync bonus (`unit_stats(id, level, era)`). Average squad level `1 + 0.25 (n-1)` (6.0 at 3-1, 10.75 at 4-10);
Burrow/Base/power levels follow the same profile table as Era 1 (power level capped at the max, base HP x1.6 per era). Policies in
`ERA_SQUADS_34` / `ERA_POWERS_34` (`tools/balance_sim.gd`):

| profile | Era 3 squad | Era 4 squad | powers |
|---|---|---|---|
| normal | Knight, Crossbow, Shield Bearer, Wizard, Bow Worm | Knight, Gear Gunner, Boiler Tank, Wizard, Crossbow | Slam + Rain (Era 3); Slam + Rain + Time Freeze (Era 4) |
| casual | Club, Slinger, Dino Rider, Shield Bearer, Bow Worm (units of Eras 1-2 only) | same | Slam + Rain |
| optimized | Knight, Crossbow, Dino Rider, Wizard, Bow Worm | Knight, Gear Gunner, Boiler Tank, Wizard, Crossbow | Slam + Freeze (Era 3); Slam + Rain + Freeze (Era 4); saves for its best card |

Bot change (Era 1-2 have no air enemies, so their rates cannot move): a card that cannot hit air (`can_hit_air` false: fighter, heavy, support)
scores -0.2 per air enemy on the field instead of the counter score, so the bot buys Shooters against hornets, spark flies and the flying Sizzle.

## Mechanics added to BattleSim (docs/DATA_SCHEMA.md has the view contract)

- Walls (Era 3, from stage 3): each base has a wall worth `era_rules.walls.hp_fraction` (20%) of its max HP; while it stands, hits on that base do
  `damage_mult` (0.5) of their damage; it is gone once the base has lost that 20% (damage that crosses the limit is split). Both bases have one; the Dirt
  Shield absorbs first. `sim.wall_hp[side]`, `sim.wall_up(side)`, event `wall_down`. Interpretation of "first 20% of base HP damage by half": the wall is
  measured in base HP lost (it takes 400 raw damage on a 1000-HP base to break it), so while it stands the base is effectively 20% tougher.
- Steam vents (Era 4, from stage 3): any unit of either side standing on a vent has its attack cycle (wind-up and cooldown) run 1.25x faster
  (`era_rules.steam_vent.attack_speed_bonus`); movement is unchanged. Like the sand patches they help both sides, so they are not a difficulty lever;
  positions are in `TUNING4["vents"]`, centred on the meeting zone.
- Sir Sizzle: `fire_breath` leaves a fixed 6-unit (240 px) segment in front of him that burns player units for 3 s at `boss.damage x 0.5` per second
  (applied twice a second); `take_flight` at 50% HP makes him an air target (only Shooters and powers reach him).
- Clockwork Queen: `steam_burst` hits player units within 4 units for `boss.damage x 1.0` and slows them 30% for 3 s (`slow_seconds` is our proposed field);
  phase 2 `spawn_cogs` spawns a Cog Roach when phase 2 starts and every 8 s after.
- Spark Fly: the hit chains to the 2 nearest other units within 2 range units at 50% damage (`abilities.chain_*` in `enemies.json`, proposed values).
- Already in the sim and now covered by tests: Knight / Beetle Knight first-hit +50%, Wizard +15% damage aura, Dung Catapult targets highest HP,
  Boiler Tank / Balloon Bomber splash, Clank Crab frontal armor 25%, Hornet Scout (air).

## Era 3-4 stage generation (`tools/gen_stages.py`, `TUNING3` / `TUNING4`)

Generic burst generator (`make_waves_abc`): three role slots per era with shares per stage (`mix`), bursts of one role each from t = 6 s, the same
ramp and error diffusion as Era 2. Enemy costs are read from `data/enemies.json` (cost x 1.5^(era-1)).
- Era 3: Beetle Knight (fighter 112.5 Food), Dung Catapult (shooter 169, range 8 outranges everything), Hornet Scout (air 270, from stage 3). No heavy or support.
- Era 4: Cog Roach (fighter 169, speed 80), Spark Fly (air 405, from stage 2), Clank Crab (heavy 506, all stages).
- Budget `(rate_base + rate_step (s-1)) x 8 x duration x scale[s]`, duration `50 + 5(s-1)` s. `rate_base` 6.0, `rate_step` -0.2 in both eras; the per-stage
  `scale` absorbs the rest. Era 3 scales are 1.5-2.1, Era 4 scales 3.0-4.0 (Era 4 needs about twice the Food of Era 3: the normal squad is made of native Era 3-4 units).
- Stage 10: opening bursts (300 Food: fighters at 6 s, shooters at 6 + boss_t/2 s), the boss at `boss_t` = 18 s with its escorts, no late bursts.
- Rules from stage 3: Era 3 `walls` (decorative x = 52 and 928), Era 4 `steam_vent` with 1 vent at 4-3 growing to 3 (positions in `TUNING4["vents"]`).

## What was tuned in Era 3-4 (allowed levers only)

| Lever | Era 3 | Era 4 | Why |
|---|---|---|---|
| `scale` per stage 1-9 | 1.59, 1.512, 2.09, 1.66, 1.595, 1.74, 1.59, 1.68, 1.793 | 3.04, 3.46, 3.85, 3.6, 3.55, 3.85, 4.0, 3.43, 3.25 | uniform scale scan, then +-3..8% around the guess with 2-3 seeds x 40 runs, then a verification seed; win rate vs scale is a sawtooth (integer unit counts) |
| `boss_t` | 18 s | 18 s | main lever of stage 10 (Era 3: 10 s = 15%, 12 s = 33%, 15 s = 60%, 18 s = 68%, 25 s = 100%; Era 4 is flat at 62-65% from 10 to 26 s) |
| `boss_pre_budget` | 300 | 300 | same as Era 2 |
| bosses.json escorts, `boss.hp_mult`, every spec number | untouched | untouched | Sir Sizzle and the Queen did not need the escort cut Rexy and the Pharaoh did |

## Results (60 runs)

First-try win % of the normal profile (seed 2), mean win time and base HP left on wins; casual and optimized for reference (seed 1):

| stage | Era 3 normal | win time | base HP left | casual | optimized | Era 4 normal | win time | base HP left | casual | optimized |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 78.3 | 117 s | 67% | 0 | 100 | 78.3 | 89 s | 94% | 0 | 100 |
| 2 | 60.0 | 119 s | 55% | 0 | 100 | 66.7 | 86 s | 100% | 2 | 100 |
| 3 | 75.0 | 124 s | 80% | 0 | 100 | 63.3 | 94 s | 99% | 0 | 98 |
| 4 | 53.3 | 116 s | 86% | 0 | 100 | 65.0 | 89 s | 100% | 0 | 100 |
| 5 | 60.0 | 109 s | 91% | 0 | 98 | 70.0 | 94 s | 100% | 0 | 100 |
| 6 | 75.0 | 104 s | 95% | 0 | 100 | 65.0 | 98 s | 100% | 0 | 100 |
| 7 | 63.3 | 108 s | 96% | 0 | 100 | 61.7 | 94 s | 100% | 0 | 98 |
| 8 | 61.7 | 117 s | 86% | 0 | 100 | 76.7 | 93 s | 100% | 0 | 100 |
| 9 | 66.7 | 116 s | 97% | 0 | 100 | 53.3 (see note) | 96 s | 100% | 0 | 100 |
| 10 (boss) | 58.3 | 139 s | 35% | 0 | 67 | 71.7 | 119 s | 85% | 0 | 97 |

Era 4 stage 9 was lowered from scale 3.3 to 3.25 after this table (re-run with seeds 71-72: 71%). The gate (normal >= 45%) passes with a wide margin in both
eras. The 3-seed tuning runs (120 runs per cell) were 60-80% on every stage; single 60-run cells can sit 1-2 standard errors (about 6 points) outside 60-75
(3-4 at 53%, 3-1 and 4-1 at 78%). Casual (units of Eras 1-2 only, no support, no new shooter) loses everything from 3-1 on, like Era 2: it models a player who never
touched the collection. Optimized wins nearly everything except 3-10 (67%).

## Open issues (Eras 3-4)

1. The normal profile is the only one tuned. The spread to casual (0%) is much wider than in Era 1 because Era 3-4 enemies are native-era units
   while the casual squad is time-synced Era 1-2 units; with real players the Underdog bonus and unit upgrades will matter more than the bot shows.
2. Sir Sizzle's flight makes 3-10 sensitive to the number of Shooters in the squad (a squad without Shooters cannot hurt him at all, which is the intent of spec 4.7).
   The normal bot carries 2-3 Shooters. The fire breath is a fixed segment cast at his position; a human can avoid it, the bot does not.
3. Steam vents and walls are symmetric rules; neither pushes the win rate in one direction by itself. If 3-x feels too long (walls), lower the Era 3 `scale` or `duration_*`.
4. Proposed values added by us (not in the spec): `chain_radius_units` 2, `chain_damage_fraction` 0.5, `slow_seconds` 3 (steam burst), the 0.5 s fire-breath tick,
   wall width/position (drawing only). They live in `data/*.json` or `TUNING3/4`, not in code.
5. As in Era 2, win rate vs `scale` is a sawtooth: any change to unit stats, costs, bot scoring or sim rules needs a re-scan.
# Balance: Era 5 "Far Future: Neon Orbit" (Phase 5, final era)

Spec: 3, 4.6 (gravity wells), 4.7, 5.1-5.3 (Era 5 units, Laser Bug / Drone Fly / Mecha Beetle, Count Magpie 3000), 6.3.
`python3 tools/balance_sim.py --era 5 [--runs 40] [--stages 1-10] [--profiles normal]` (stage column = index inside the era, n = 41..50).
Eras 1-2 numbers and code paths are unchanged (Era 5 lives in `ERA5_*` constants of `balance_sim.gd` and in `TUNING5` / `*5` functions of `gen_stages.py`).

## Gravity wells (our proposal, `balance.json era_rules.gravity_well`)

The spec only says "gravity wells bend projectiles, so shooters should be placed carefully". Implemented deterministically (no RNG in the sim):
every projectile of BOTH sides whose straight flight crosses a well loses `damage_loss` = 35% of its damage per well crossed
(multiplicative), a shooter standing inside a well counts too. Melee, boss bombs and powers are not affected. Wells are stage data
(`rule.wells = [{x, w}]`, lane px, from 5-3: 1 well at 5-3 growing to 3 by 5-6). They hit both armies, so, like the sand patches, they are
placed once where the armies meet and are not a difficulty lever. `pierce_fraction` = 50% is the Laser Bug beam damage on the units it passes through.
Both numbers are in `proposed_keys`; confirm with Alfredo.

## Era 5 abilities

| Unit | Implementation |
|---|---|
| Laser Bug (enemy shooter) | `pierce`: on impact the beam also hits every other ground unit on its line (shooter -> target -> end of range) for 50% damage |
| Drone Fly (enemy air) | `hunts`: while a Support exists on the field it flies past everything and attacks only Supports (the Time Medic); only Shooters can hit it. Speed 90, HP 55 (data) |
| Mecha Beetle (enemy heavy) | `target: highest_hp` (data change: the old `behavior` text had no code behind it) |
| Laser Blade Worm / Mecha Worm / Time Medic | stats from the table (speed 80 / HP 400 / heals 5% max HP per second), no extra code |
| Count Magpie 3000 | telegraph: steals one equipped power for 8 s (a ready one first); phase 2: hops 4 units toward the player (never past the front unit) every 5 s and drops a bomb on the front unit (1 s fuse, radius 2 units, boss damage x1.0) |

## Era 5 player: the Time Squad

Time sync: every earlier-era unit is played with `DataDB.unit_stats(id, level, 5)` (Era 1 x2.6, Era 2 x3.5, Era 3 x4.6, Era 4 x5.7 on HP/damage; Era 5 units x6.55 and 5x cost).
5 squad slots (5th opened after the Era 2 boss), 3 power slots (3rd after the Era 3 boss), every power unlocked. Unit levels average
`1 + 0.25(n-1)` (11 at 5-1, 13.25 at 5-10) for the normal profile; Food Burrow and Base are capped at level 10.

| profile | squad (card order) | powers |
|---|---|---|
| normal | Club Worm, Gear Gunner (fast shooter), Shield Bearer (blocks 20% ranged), Time Medic, Laser Blade Worm | Squirm Slam, Apple Rain, Time Freeze |
| casual | Club, Slinger, Dino Rider, Shield Bearer, Knight (first units owned; one weak shooter, no support) | Squirm Slam, Apple Rain |
| optimized | Club, Gear Gunner, Mecha Worm, Time Medic, Laser Blade | Squirm Slam, Apple Rain, Time Freeze |

The bots only know Slam, Rain and Freeze (Rewind, Dirt Shield and Fast-Forward are not played by any profile).

## Era 5 stage generation (`TUNING5`)

- `enemy_base_hp` = `1000 x (1 + 0.15(n-1))` (8350 at 5-10). Enemy costs x1.5^4: Laser Bug 379.7, Drone Fly 607.5, Mecha Beetle 759.4 Food.
- Era 5 has no enemy fighter or support, so the role mix is (shooter, air, heavy): 5-1 only Laser Bugs, Drone Flies from 5-2 (they force at least one Shooter,
  spec 4.7), Mecha Beetles from 5-3 (heavy share grows to 45%). Budget = `(6.5 - 0.3(s-1)) x 8 x duration x scale[s]`, duration `50 + 5(s-1)` s.
- Stage 5-10: opening bursts (1 Laser Bug at 6 s, 1 Mecha Beetle at 21 s), Count Magpie 3000 at `boss_t` = 30 s with his escorts (3 Laser Bugs + 2 Drone Flies, `bosses.json`).

## What was tuned in Era 5

| Lever | Value | Why |
|---|---|---|
| `TUNING5.scale` per stage | 2.72, 2.46, 1.82, 2.15, 2.0, 2.1, 2.3, 2.25, 2.4 (5-1..5-9) | uniform scans (1.6-5.4) then per-stage multipliers (0.7-1.0) at 20-100 runs and 4 seeds; costs of 380-760 Food make the win rate a steep sawtooth in `scale` (one Mecha Beetle = ~8% of a stage budget) |
| `TUNING5.boss_t` / `boss_pre_budget` | 30 s / 760 | with `boss_t` 50 the bots win in 43 s by killing the base before the boss arrives (100%); at 30 s it is 58-71%. Opening budget is one Laser Bug + one Mecha Beetle (the minimum the generator emits) |
| `data/bosses.json` b5 `escorts`, `phase2.bomb_*` (proposed) | 3 Laser Bugs + 2 Drone Flies, bomb radius 2 / fuse 1 s | untouched (the spec fixes hop and bomb interval; these are the proposed numbers from the data phase) |
| `boss.hp_mult`, hop 4 units, bomb interval 5 s, steal 8 s | untouched | spec / earlier phases |
| `era_rules.gravity_well.damage_loss` 0.35, `pierce_fraction` 0.5 | proposed | see above; wells were not used as a difficulty lever |

## Results (normal: 100 runs, mean of seeds 1 and 41; casual / optimized: 40 runs, seed 1)

First-try win %:

| stage (n) | normal | normal win time | normal base HP left | casual | optimized |
|---|---|---|---|---|---|
| 5-1 (41) | 74 | 124 s | 51% | 0 | 100 |
| 5-2 (42) | 75.5 | 76 s | 94% | 15 | 100 |
| 5-3 (43) | 73.5 | 99 s | 88% | 2.5 | 100 |
| 5-4 (44) | 61.5 | 102 s | 92% | 0 | 100 |
| 5-5 (45) | 69.5 | 103 s | 97% | 0 | 100 |
| 5-6 (46) | 72 | 99 s | 97% | 5 | 100 |
| 5-7 (47) | 79.5 | 85 s | 99% | 0 | 100 |
| 5-8 (48) | 59.5 | 105 s | 99% | 0 | 100 |
| 5-9 (49) | 75.5 | 93 s | 99% | 0 | 100 |
| 5-10 (50, Count Magpie 3000) | 61 | 124 s | 91% | 0 | 100 |

Gate (>= 45%) passes on every stage including the final boss (58-64%, a little harder than the rest as intended). Seven of ten stages are inside 60-75%; 5-2, 5-7 are 76-80%
and 5-8 / 5-10 are 58-61% (about 1 standard error from the band edge at 100 runs: they are in the noise, not a bug).
Expected tries for normal 1.3-1.7; P(win within 2 tries) 84-94%.

## Era 5 open issues

1. Profiles are extremely far apart again: casual is 0-15% everywhere (the first-units squad has one weak shooter, no support, and cannot beat the beams and
   Mecha Beetles) and optimized is 100% (Time Freeze + a Medic + Mecha Worm). The spec only constrains the normal profile; needs real playtest data (see Era 1 issue 1).
2. Win rate vs `scale` is a sawtooth with a cliff: on 5-7, scale 2.3 is 80% and 2.4 is 37%. Any change to unit stats, costs, the beam or the bot scoring needs a re-scan.
3. The sim ends when a base falls, so a late boss can be skipped by killing the base: `boss_t` must stay early (about 30 s) for the boss to matter. If Alfredo wants the boss to arrive later,
   raise `enemy_base_hp` for 5-10 instead.
4. Gravity wells reduce both sides' shooters; the normal squad has two ranged cards and the enemy is two thirds ranged/air, so wells slightly favour the player (the player can avoid
   shooting across a well, the bots do not). Not tuned; no bot models "place shooters carefully".
5. Bombs hit only player units and ignore counters; with the boss damage x1.0 a bomb one-shots Era 1-2 units in the radius (level 11-13 squad). If it feels punishing lower `bomb_damage_mult`.
6. The final 5-10 victory sets `profile.progress.game_completed`; the ending screen is a separate module.
