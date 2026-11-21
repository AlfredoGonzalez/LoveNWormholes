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
6. `rule` is `{"type": "none"}` in every Era 1 stage (rules start in Era 2 per spec 4.6); ids are `1-<index>` (not the
   `s01_01` of DATA_SCHEMA.md) because Economy/Progress already use `"%d-%d"`; DATA_SCHEMA should be updated.
