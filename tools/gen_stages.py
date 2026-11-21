#!/usr/bin/env python3
"""Generates data/stages.json for Era 1 and Era 2 (stages 1-1..2-10) from formulas (spec 6.3).

Deterministic: no randomness, same output every run. Run `python3 tools/gen_stages.py` and commit the result.
Then check it with `python3 tools/balance_sim.py` (all the tuning knobs are in TUNING below).

Enemy director rule (spec 6.3): every stage has a Food budget and a wave script; the budget is spent with a
role mix that includes at least one counter to the most-used player role. The player squad is
fighter / shooter / heavy and fighters are the cheapest, most spammed role, so the counter is the Stone
Beetle (heavy beats fighter); shooters (Ant Spitter) punish the player's heavies.
"""
import json
import math
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BALANCE = json.load(open(os.path.join(ROOT, "data", "balance.json")))

# Enemy cost (Food) by id, era 1 (kill food = cost x 0.25 comes from here).
ENEMIES = {
    "e1_ant_clubber": {"role": "fighter", "cost": 50},
    "e1_ant_spitter": {"role": "shooter", "cost": 75},
    "e1_stone_beetle": {"role": "heavy", "cost": 150},
}

# ---- tuning knobs (this is where balance work happens) ------------------------------------------
TUNING = {
    # Wave script length (seconds of spawning) = base + step x (s-1)
    "duration_base": 40.0,
    "duration_step": 6.0,
    # Enemy Food spent per second = player base income (8/s) x rate, rate = base + step x (s-1)
    "rate_base": 1.5,
    "rate_step": 0.15,
    # First burst time and the gap between bursts (shrinks as stages get busier)
    "first_t": 6.0,
    # Fractions of the budget given to each role from stage 3 on (fighter, shooter, heavy)
    "mix": {3: (0.45, 0.30, 0.25), 4: (0.40, 0.30, 0.30), 5: (0.40, 0.25, 0.35), 6: (0.35, 0.30, 0.35),
            7: (0.35, 0.25, 0.40), 8: (0.30, 0.30, 0.40), 9: (0.30, 0.25, 0.45)},
    # Stage 10: extra waves after the boss and its escorts
    "boss_extra_budget": 330.0,
    "boss_extra_t": 40.0,
}
# Per-stage budget multiplier (stage index -> factor), the fine tuning knob used after the formula curve.
TUNING["scale"] = {"1": 0.8, "2": 1.2, "3": 1.465, "4": 1.31, "5": 1.22, "6": 1.19, "7": 1.04, "8": 0.925, "9": 0.94}
if os.environ.get("GEN_TUNING"):  # experiments: GEN_TUNING='{"rate_base": 1.0, "scale": {"5": 1.1}}'
    TUNING.update(json.loads(os.environ["GEN_TUNING"]))
ROLE_ENEMY = {"fighter": "e1_ant_clubber", "shooter": "e1_ant_spitter", "heavy": "e1_stone_beetle"}

# ---- Era 2 (Ancient Egypt): enemy ids/costs (cost = base cost x 1.5, era cost multiplier) -------------
ENEMIES2 = {
    "e2_scarab_soldier": {"role": "fighter", "cost": 75},
    "e2_locust_archer": {"role": "shooter", "cost": 112.5},
    "e2_mummy_moth": {"role": "support", "cost": 150},
}
ROLE_ENEMY2 = {"fighter": "e2_scarab_soldier", "shooter": "e2_locust_archer", "support": "e2_mummy_moth"}
TUNING2 = {
    "duration_base": 50.0,
    "duration_step": 5.0,
    "rate_base": 1.5,
    "rate_step": 0.1,
    "first_t": 6.0,
    # Role shares per stage (fighter, shooter, support). Era 2 has no enemy heavy; the Mummy Moth heals, so it
    # shows up from stage 3 in small numbers.
    "mix": {1: (0.7, 0.3, 0.0), 2: (0.6, 0.4, 0.0), 3: (0.5, 0.35, 0.15), 4: (0.45, 0.35, 0.2), 5: (0.45, 0.35, 0.2),
            6: (0.4, 0.4, 0.2), 7: (0.4, 0.4, 0.2), 8: (0.4, 0.35, 0.25), 9: (0.4, 0.35, 0.25)},
    "boss_extra_budget": 400.0,
    "boss_extra_t": 40.0,
    # Per-stage budget multiplier (fine tuning knob, same idea as Era 1 TUNING["scale"]).
    "scale": {"1": 1.0, "2": 1.0, "3": 1.0, "4": 1.0, "5": 1.0, "6": 1.0, "7": 1.0, "8": 1.0, "9": 1.0},
    # Sand patches (rule from stage 3): list of (x, width) in lane px (lane = 1000). Placement knob: patches sit in
    # the middle of the lane where the armies meet, so they slow the front lines of both sides.
    "patches": {3: [(420, 160)], 4: [(380, 140), (600, 140)], 5: [(330, 150), (560, 150)],
                6: [(280, 120), (460, 120), (640, 120)], 7: [(280, 140), (480, 140), (680, 140)],
                8: [(250, 150), (450, 150), (650, 150)], 9: [(220, 160), (420, 160), (620, 160)],
                10: [(300, 160), (540, 160), (740, 120)]},
}
if os.environ.get("GEN_TUNING2"):  # experiments: GEN_TUNING2='{"rate_base": 1.2, "scale": {"5": 1.1}}'
    TUNING2.update(json.loads(os.environ["GEN_TUNING2"]))


def win_coins(n):
    return int(round(BALANCE["rewards"]["win_coins_base"] * BALANCE["rewards"]["win_coins_growth"] ** (n - 1)))


def enemy_base_hp(n):
    s = BALANCE["scaling"]
    return s["enemy_base_hp_start"] * (1.0 + s["enemy_base_hp_step"] * (n - 1))


def bursts_for(s, budget, duration, first_t):
    """Split `budget` into bursts of one role each. Returns [(t, role, share)]."""
    if s == 1:
        roles = ["fighter"] * 4
    elif s == 2:
        roles = ["fighter", "fighter", "shooter", "fighter", "fighter"]
    else:
        f, sh, h = TUNING["mix"][s]
        # Largest-remainder pattern of ~8 bursts so the role shares match the mix; heavy always present.
        k = 6 + s // 2
        counts = {"fighter": f * k, "shooter": sh * k, "heavy": h * k}
        whole = {r: int(math.floor(v)) for r, v in counts.items()}
        whole["heavy"] = max(1, whole["heavy"])
        whole["shooter"] = max(1, whole["shooter"])
        rest = k - sum(whole.values())
        order = sorted(counts, key=lambda r: -(counts[r] - math.floor(counts[r])))
        for r in order:
            if rest <= 0:
                break
            whole[r] += 1
            rest -= 1
        roles = []
        left = dict(whole)
        pattern = ["fighter", "shooter", "heavy"]
        i = 0
        while sum(left.values()) > 0:
            r = pattern[i % 3]
            if left[r] > 0:
                roles.append(r)
                left[r] -= 1
            i += 1
    k = len(roles)
    gap = (duration - first_t) / max(1, k - 1) if k > 1 else 0.0
    # Later bursts are bigger (ramp) so pressure builds.
    weights = [1.0 + 0.5 * i / max(1, k - 1) for i in range(k)]
    # Share of budget per role from the mix; inside a role the ramp applies.
    out = []
    total_w = sum(weights)
    for i, r in enumerate(roles):
        out.append((first_t + gap * i, r, budget * weights[i] / total_w))
    return out


def make_waves(s):
    n = s
    duration = TUNING["duration_base"] + TUNING["duration_step"] * (s - 1)
    rate = TUNING["rate_base"] + TUNING["rate_step"] * (s - 1)
    income = BALANCE["battle"]["food_income_base"]
    if s == 10:
        waves = [{"t": 3.0, "boss": "b1_rexy"}]
        extra = TUNING["boss_extra_budget"]
        t = TUNING["boss_extra_t"]
        for role, share in (("fighter", 0.4), ("shooter", 0.3), ("fighter", 0.3)):
            e = ROLE_ENEMY[role]
            cnt = max(1, int(round(extra * share / ENEMIES[e]["cost"])))
            waves.append({"t": round(t, 1), "enemy": e, "count": cnt, "interval": 2.0})
            t += 12.0
        return waves
    budget = rate * income * duration * float(TUNING["scale"].get(str(s), 1.0))
    waves = []
    carry = 0.0  # error diffusion: rounding remainders carry to the next burst so the total tracks the budget
    for t, role, share in bursts_for(s, budget, duration, TUNING["first_t"]):
        e = ROLE_ENEMY[role]
        cost = ENEMIES[e]["cost"]
        cnt = max(1, int(round((share + carry) / cost)))
        carry = share + carry - cnt * cost
        interval = {"fighter": 1.5, "shooter": 2.0, "heavy": 4.0}[role]
        waves.append({"t": round(t, 1), "enemy": e, "count": cnt, "interval": interval})
    return waves


def food_budget(waves):
    total = 0.0
    for w in waves:
        if "boss" in w:
            continue
        total += {**ENEMIES, **ENEMIES2}[w["enemy"]]["cost"] * w["count"]
    return int(total)


def bursts_for2(s, budget, duration, first_t):
    """Era 2: split `budget` into bursts of one role each. Returns [(t, role, share)]."""
    f, sh, sup = TUNING2["mix"][s]
    k = 6 + s // 2
    counts = {"fighter": f * k, "shooter": sh * k, "support": sup * k}
    whole = {r: int(math.floor(v)) for r, v in counts.items()}
    whole["fighter"] = max(1, whole["fighter"])
    whole["shooter"] = max(1, whole["shooter"])
    if sup > 0:
        whole["support"] = max(1, whole["support"])
    rest = k - sum(whole.values())
    order = sorted(counts, key=lambda r: -(counts[r] - math.floor(counts[r])))
    for r in order:
        if rest <= 0:
            break
        if counts[r] > 0:
            whole[r] += 1
            rest -= 1
    roles = []
    left = dict(whole)
    pattern = ["fighter", "shooter", "fighter", "support"]
    i = 0
    while sum(left.values()) > 0:
        r = pattern[i % len(pattern)]
        if left[r] > 0:
            roles.append(r)
            left[r] -= 1
        i += 1
    k = len(roles)
    gap = (duration - first_t) / max(1, k - 1) if k > 1 else 0.0
    weights = [1.0 + 0.5 * i / max(1, k - 1) for i in range(k)]
    # The budget shares are per ROLE (mix), spread over that role's bursts with the ramp.
    role_w = {}
    for i, r in enumerate(roles):
        role_w[r] = role_w.get(r, 0.0) + weights[i]
    mix_share = {"fighter": f, "shooter": sh, "support": sup}
    msum = sum(v for r, v in mix_share.items() if r in role_w)
    out = []
    for i, r in enumerate(roles):
        out.append((first_t + gap * i, r, budget * (mix_share[r] / msum) * weights[i] / role_w[r]))
    return out


def make_waves2(s):
    duration = TUNING2["duration_base"] + TUNING2["duration_step"] * (s - 1)
    rate = TUNING2["rate_base"] + TUNING2["rate_step"] * (s - 1)
    if s == 10:
        waves = [{"t": 3.0, "boss": "b2_pharaoh_scarab"}]
        extra = TUNING2["boss_extra_budget"]
        t = TUNING2["boss_extra_t"]
        for role, share in (("fighter", 0.4), ("shooter", 0.3), ("fighter", 0.3)):
            e = ROLE_ENEMY2[role]
            cnt = max(1, int(round(extra * share / ENEMIES2[e]["cost"])))
            waves.append({"t": round(t, 1), "enemy": e, "count": cnt, "interval": 2.0})
            t += 12.0
        return waves
    income = BALANCE["battle"]["food_income_base"]
    budget = rate * income * duration * float(TUNING2["scale"].get(str(s), 1.0))
    waves = []
    carry = 0.0
    for t, role, share in bursts_for2(s, budget, duration, TUNING2["first_t"]):
        e = ROLE_ENEMY2[role]
        cost = ENEMIES2[e]["cost"]
        cnt = max(1, int(round((share + carry) / cost)))
        carry = share + carry - cnt * cost
        interval = {"fighter": 1.5, "shooter": 2.0, "support": 3.0}[role]
        waves.append({"t": round(t, 1), "enemy": e, "count": cnt, "interval": interval})
    return waves


def rule_for2(s):
    if s < 3:
        return {"type": "none"}
    return {"type": "sand_patch", "patches": [{"x": x, "w": w} for x, w in TUNING2["patches"][s]]}


def build():
    stages = []
    for s in range(1, 11):
        n = s
        waves = make_waves(s)
        stages.append({
            "id": "1-%d" % s,
            "era": 1,
            "index": s,
            "enemy_base_hp": enemy_base_hp(n),
            "food_budget": food_budget(waves),
            "waves": waves,
            "rule": {"type": "none"},
            "rewards": {
                "coins": win_coins(n),
                "first_clear_gems": BALANCE["rewards"]["boss_first_clear_gems"] if s == 10 else BALANCE["rewards"]["first_clear_gems"],
                "boss": s == 10,
                "echo": s == BALANCE["campaign"]["echo_stage"],
                "shard": False,
            },
        })
    for s in range(1, 11):
        n = 10 + s
        waves = make_waves2(s)
        stages.append({
            "id": "2-%d" % s,
            "era": 2,
            "index": s,
            "enemy_base_hp": enemy_base_hp(n),
            "food_budget": food_budget(waves),
            "waves": waves,
            "rule": rule_for2(s),
            "rewards": {
                "coins": win_coins(n),
                "first_clear_gems": BALANCE["rewards"]["boss_first_clear_gems"] if s == 10 else BALANCE["rewards"]["first_clear_gems"],
                "boss": s == 10,
                "echo": s == BALANCE["campaign"]["echo_stage"],
                "shard": False,
            },
        })
    return {"version": 1, "_comment": "Generated by tools/gen_stages.py (do not edit by hand). Eras 1-2.", "stages": stages}


def main():
    out = os.path.join(ROOT, "data", "stages.json")
    with open(out, "w") as f:
        json.dump(build(), f, indent=1)
        f.write("\n")
    print("wrote", out)


if __name__ == "__main__":
    sys.exit(main())
