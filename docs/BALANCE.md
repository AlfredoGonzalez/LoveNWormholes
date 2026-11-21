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
