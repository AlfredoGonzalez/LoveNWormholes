#!/usr/bin/env python3
"""Generates data/stages.json for Eras 1-4 (stages 1-1..4-10) from formulas (spec 6.3).

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
    "rate_base": 6.5,
    "rate_step": -0.3,
    "first_t": 6.0,
    # Role shares per stage (fighter, shooter, support). Era 2 has no enemy heavy; the Mummy Moth heals, so it
    # shows up from stage 3 in small numbers.
    "mix": {1: (0.7, 0.3, 0.0), 2: (0.6, 0.4, 0.0), 3: (0.5, 0.35, 0.15), 4: (0.45, 0.35, 0.2), 5: (0.45, 0.35, 0.2),
            6: (0.4, 0.4, 0.2), 7: (0.4, 0.4, 0.2), 8: (0.4, 0.35, 0.25), 9: (0.4, 0.35, 0.25)},
    "boss_t": 41.0,            # when the Pharaoh enters (main difficulty lever of stage 10)
    "boss_pre_budget": 300.0,  # Food spent on the two opening bursts before the boss
    "boss_extra_budget": 0.0,
    "boss_extra_dt": 25.0,     # seconds after the boss for the first late burst
    # Per-stage budget multiplier (fine tuning knob, same idea as Era 1 TUNING["scale"]).
    "scale": {"1": 0.84, "2": 0.94, "3": 0.787, "4": 0.78, "5": 1.15, "6": 0.702, "7": 0.787, "8": 1.238, "9": 1.387},
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
        # Opening bursts first (the Pharaoh's summons never stop, so the player needs time to build an army),
        # then the Pharaoh at boss_t with its escorts, then late bursts. boss_t is the main difficulty lever.
        waves = []
        pre = TUNING2["boss_pre_budget"]
        for t, role, share in ((6.0, "fighter", 0.5), (6.0 + TUNING2["boss_t"] / 2.0, "shooter", 0.5)):
            e = ROLE_ENEMY2[role]
            cnt = max(1, int(round(pre * share / ENEMIES2[e]["cost"])))
            waves.append({"t": round(t, 1), "enemy": e, "count": cnt, "interval": 1.5})
        waves.append({"t": TUNING2["boss_t"], "boss": "b2_pharaoh_scarab"})
        extra = TUNING2["boss_extra_budget"]
        t = TUNING2["boss_t"] + TUNING2["boss_extra_dt"]
        for role, share in (("fighter", 0.4), ("shooter", 0.3), ("fighter", 0.3)):
            if extra <= 0.0:
                break
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


# ---- Era 3 (Medieval) and Era 4 (Industrial): enemies, tuning, generic generator -----------------------------
# Enemy cost (Food) = role/override cost x 1.5^(era-1), read from data/enemies.json so it cannot drift.
def _enemy_costs(era):
    roles = BALANCE["roles"]
    out = {}
    for e in json.load(open(os.path.join(ROOT, "data", "enemies.json")))["enemies"]:
        if int(e["era"]) != era:
            continue
        base = float(e.get("overrides", {}).get("cost", roles[e["role"]]["cost"]))
        out[e["id"]] = {"role": e["role"], "cost": base * BALANCE["scaling"]["era_cost_mult"] ** (era - 1)}
    return out


ENEMIES3 = _enemy_costs(3)
ENEMIES4 = _enemy_costs(4)
# Role slots of the generic generator: "a" fighter, "b" shooter (Era 3) or air (Era 4), "c" air (Era 3) or heavy (Era 4).
ROLE_ENEMY3 = {"a": "e3_beetle_knight", "b": "e3_dung_catapult", "c": "e3_hornet_scout"}
ROLE_ENEMY4 = {"a": "e4_cog_roach", "b": "e4_spark_fly", "c": "e4_clank_crab"}
INTERVAL_ABC = {"3": {"a": 1.5, "b": 2.0, "c": 3.0}, "4": {"a": 1.5, "b": 3.0, "c": 4.0}}

# Era 3: knights (fighter), catapults (shooter, range 8, target the highest-HP unit), hornets (air: only Shooters hit them).
TUNING3 = {
    "duration_base": 50.0, "duration_step": 5.0,
    "rate_base": 6.0, "rate_step": -0.2,
    "first_t": 6.0,
    # Shares per stage (knight, catapult, hornet).
    "mix": {1: (0.7, 0.3, 0.0), 2: (0.6, 0.4, 0.0), 3: (0.5, 0.3, 0.2), 4: (0.45, 0.3, 0.25), 5: (0.45, 0.3, 0.25),
            6: (0.4, 0.3, 0.3), 7: (0.4, 0.3, 0.3), 8: (0.4, 0.3, 0.3), 9: (0.35, 0.3, 0.35)},
    "boss_t": 18.0, "boss_pre_budget": 300.0, "boss_extra_budget": 0.0, "boss_extra_dt": 25.0,
    "scale": {"1": 1.59, "2": 1.512, "3": 2.09, "4": 1.66, "5": 1.595, "6": 1.74, "7": 1.59, "8": 1.68, "9": 1.793},
    # Walls (rule from stage 3): decorative x of the player wall and of the enemy wall (lane px, w = width). The
    # numbers that matter (20% of base HP, x0.5 damage) come from balance.era_rules.walls.
    "wall_x": (52.0, 928.0), "wall_w": 20.0,
}
# Era 4: cog roaches (fast fighter), spark flies (air, chain shock), clank crabs (frontal-armor heavy).
TUNING4 = {
    "duration_base": 50.0, "duration_step": 5.0,
    "rate_base": 6.0, "rate_step": -0.2,
    "first_t": 6.0,
    # Shares per stage (cog roach, spark fly, clank crab).
    "mix": {1: (0.7, 0.0, 0.3), 2: (0.6, 0.15, 0.25), 3: (0.5, 0.2, 0.3), 4: (0.45, 0.2, 0.35), 5: (0.45, 0.2, 0.35),
            6: (0.4, 0.25, 0.35), 7: (0.4, 0.25, 0.35), 8: (0.4, 0.25, 0.35), 9: (0.35, 0.25, 0.4)},
    "boss_t": 18.0, "boss_pre_budget": 300.0, "boss_extra_budget": 0.0, "boss_extra_dt": 25.0,
    "scale": {"1": 3.04, "2": 3.46, "3": 3.85, "4": 3.6, "5": 3.55, "6": 3.85, "7": 4.0, "8": 3.43, "9": 3.25},
    # Steam vents (rule from stage 3): (x, width) in lane px, centred where the armies meet like the Era 2 patches.
    "vents": {3: [(430, 140)], 4: [(380, 130), (600, 130)], 5: [(340, 130), (560, 130)],
              6: [(290, 120), (470, 120), (650, 120)], 7: [(280, 120), (480, 120), (680, 120)],
              8: [(260, 130), (450, 130), (640, 130)], 9: [(230, 140), (420, 140), (610, 140)],
              10: [(300, 140), (520, 140), (730, 120)]},
}
if os.environ.get("GEN_TUNING3"):  # experiments: GEN_TUNING3='{"rate_base": 1.2, "scale": {"5": 1.1}}'
    TUNING3.update(json.loads(os.environ["GEN_TUNING3"]))
if os.environ.get("GEN_TUNING4"):
    TUNING4.update(json.loads(os.environ["GEN_TUNING4"]))


def _bursts_abc(tun, s, budget, duration, first_t):
    """Generic burst split for Eras 3-4: roles a/b/c with shares tun["mix"][s]. Returns [(t, role, share)]."""
    shares = dict(zip("abc", tun["mix"][s]))
    k = 6 + s // 2
    counts = {r: shares[r] * k for r in "abc"}
    whole = {r: int(math.floor(v)) for r, v in counts.items()}
    for r in "abc":
        if shares[r] > 0:
            whole[r] = max(1, whole[r])
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
    pattern = ["a", "b", "a", "c"]
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
    role_w = {}
    for i, r in enumerate(roles):
        role_w[r] = role_w.get(r, 0.0) + weights[i]
    msum = sum(v for r, v in shares.items() if r in role_w)
    return [(first_t + gap * i, r, budget * (shares[r] / msum) * weights[i] / role_w[r]) for i, r in enumerate(roles)]


def make_waves_abc(era, s):
    tun = TUNING3 if era == 3 else TUNING4
    role_enemy = ROLE_ENEMY3 if era == 3 else ROLE_ENEMY4
    costs = ENEMIES3 if era == 3 else ENEMIES4
    boss = "b3_sir_sizzle" if era == 3 else "b4_clockwork_queen"
    ival = INTERVAL_ABC[str(era)]
    duration = tun["duration_base"] + tun["duration_step"] * (s - 1)
    rate = tun["rate_base"] + tun["rate_step"] * (s - 1)
    if s == 10:
        # Opening bursts, then the boss at boss_t with its escorts (bosses.json), then optional late bursts.
        waves = []
        pre = tun["boss_pre_budget"]
        for t, role, share in ((6.0, "a", 0.5), (6.0 + tun["boss_t"] / 2.0, "b", 0.5)):
            e = role_enemy[role]
            cnt = max(1, int(round(pre * share / costs[e]["cost"])))
            waves.append({"t": round(t, 1), "enemy": e, "count": cnt, "interval": 1.5})
        waves.append({"t": tun["boss_t"], "boss": boss})
        extra = tun["boss_extra_budget"]
        t = tun["boss_t"] + tun["boss_extra_dt"]
        for role, share in (("a", 0.4), ("b", 0.3), ("a", 0.3)):
            if extra <= 0.0:
                break
            e = role_enemy[role]
            cnt = max(1, int(round(extra * share / costs[e]["cost"])))
            waves.append({"t": round(t, 1), "enemy": e, "count": cnt, "interval": 2.0})
            t += 12.0
        return waves
    income = BALANCE["battle"]["food_income_base"]
    budget = rate * income * duration * float(tun["scale"].get(str(s), 1.0))
    waves = []
    carry = 0.0
    for t, role, share in _bursts_abc(tun, s, budget, duration, tun["first_t"]):
        e = role_enemy[role]
        cost = costs[e]["cost"]
        cnt = max(1, int(round((share + carry) / cost)))
        carry = share + carry - cnt * cost
        waves.append({"t": round(t, 1), "enemy": e, "count": cnt, "interval": ival[role]})
    return waves


def rule_for34(era, s):
    if s < 3:
        return {"type": "none"}
    if era == 3:
        # hp_fraction / damage_mult are copies of balance.era_rules.walls (the sim reads balance); walls = where to draw.
        w = BALANCE["era_rules"]["walls"]
        x0, x1 = TUNING3["wall_x"]
        return {"type": "walls", "hp_fraction": w["hp_fraction"], "damage_mult": w["damage_mult"],
                "walls": [{"x": x0, "w": TUNING3["wall_w"], "side": "player"},
                          {"x": x1, "w": TUNING3["wall_w"], "side": "enemy"}]}
    return {"type": "steam_vent", "attack_speed_bonus": BALANCE["era_rules"]["steam_vent"]["attack_speed_bonus"],
            "vents": [{"x": x, "w": w} for x, w in TUNING4["vents"][s]]}


def build_era34():
    out = []
    for era in (3, 4):
        costs = ENEMIES3 if era == 3 else ENEMIES4
        for s in range(1, 11):
            n = (era - 1) * 10 + s
            waves = make_waves_abc(era, s)
            spent = sum(costs[w["enemy"]]["cost"] * w["count"] for w in waves if "boss" not in w)
            out.append({
                "id": "%d-%d" % (era, s), "era": era, "index": s,
                "enemy_base_hp": enemy_base_hp(n),
                "food_budget": int(spent),
                "waves": waves,
                "rule": rule_for34(era, s),
                "rewards": {
                    "coins": win_coins(n),
                    "first_clear_gems": BALANCE["rewards"]["boss_first_clear_gems"] if s == 10 else BALANCE["rewards"]["first_clear_gems"],
                    "boss": s == 10,
                    "echo": s == BALANCE["campaign"]["echo_stage"],
                    "shard": False,
                },
            })
    return out


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
    stages += build_era34()
    return {"version": 1, "_comment": "Generated by tools/gen_stages.py (do not edit by hand). Eras 1-4.", "stages": stages}


def main():
    out = os.path.join(ROOT, "data", "stages.json")
    with open(out, "w") as f:
        json.dump(build(), f, indent=1)
        f.write("\n")
    print("wrote", out)


if __name__ == "__main__":
    sys.exit(main())
