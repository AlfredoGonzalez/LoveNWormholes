#!/usr/bin/env python3
"""Genera docs/art-prompts/ (README + un archivo por fase) a partir de docs/ART_PROMPTS_ORIGINAL.md.

El original aporta los textos de diseno (descripcion del personaje antes de "The image is a strict grid")
y las filas de animacion ("Row 1, idle loop: ..."). Este script los reorganiza en el formato nuevo:
  - una REFERENCIA por personaje (`<id>_ref.png`, pose estatica unica, 1024 px),
  - una HOJA 5x5 (25 fotogramas) por ANIMACION (`<id>_<anim>_sheet.png`, o `_x2_sheet` con lienzo doble),
  - imagenes/sprites estaticos con tamano, donde se usan y referencia a adjuntar.
Es determinista: python3 tools/gen_art_prompts.py reescribe los mismos archivos.
Despues de generar, tools/art_status.py lee los archivos generados.
"""
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ORIGINAL = os.path.join(ROOT, "docs", "ART_PROMPTS_ORIGINAL.md")
OUT = os.path.join(ROOT, "docs", "art-prompts")

# ---------------------------------------------------------------------------------------------
# 1. Parseo del original
# ---------------------------------------------------------------------------------------------
HEAD = re.compile(r"^([A-H]\d\d) · (SPRITE SHEET 5x5|SPRITE|IMAGE) · (.*?)\. Save as (\S+?)\.?(?:\s|$)")


def parse_original():
    lines = open(ORIGINAL, encoding="utf-8").read().split("\n")
    out = {}
    i = 0
    while i < len(lines):
        m = HEAD.match(lines[i])
        if m:
            oid, kind, title, path = m.groups()
            j = i + 1
            while j < len(lines) and not lines[j].startswith("```text"):
                j += 1
            k = j + 1
            body = []
            while k < len(lines) and not lines[k].startswith("```"):
                body.append(lines[k])
                k += 1
            body = " ".join(body).strip()
            out[oid] = parse_body(oid, kind, title, path, body)
            i = k
        i += 1
    return out


def parse_body(oid, kind, title, path, body):
    d = {"oid": oid, "kind": kind, "title": title, "path": path, "body": body}
    d["design"] = body.split(" Storybook")[0].strip()
    m = re.search(r"(Storybook[^.]*?friendly saturated colors\.|Storybook[^.]*?paper grain\.)", body)
    d["style"] = m.group(1) if m else ""
    d["rows"] = []
    if "Row 1," in body:
        tail = body[body.index("Row 1,"):]
        for r in re.split(r"(?:^|\s)Row \d, ", tail)[1:]:
            label, _, txt = r.partition(": ")
            d["rows"].append((label.strip(), txt.strip().rstrip(".")))
    return d


# ---------------------------------------------------------------------------------------------
# 2. Texto de movimiento: filas originales (5 fotogramas) -> tramos de 25 fotogramas
# ---------------------------------------------------------------------------------------------
SPLIT = re.compile(r"(, and then | then |, then |, and |, )")


def clauses(txt):
    parts = SPLIT.split(txt)
    out = [parts[0]]
    for sep, cl in zip(parts[1::2], parts[2::2]):
        pre = "then " if "then" in sep else ("and " if "and" in sep else "")
        out.append(pre + cl)
    return [c.strip() for c in out if c.strip()]


def fix_frame_refs(t):
    t = re.sub(r"(\b\w+) on frame 4", r"\1 once", t)
    t = t.replace(" over three frames", ", slowly, as a long visible build-up")
    t = t.replace("in the last two frames", "in the last part of the move")
    return t


def ranges(n):
    b = [round(i * 25 / n) for i in range(n + 1)]
    return [(b[i] + 1, b[i + 1]) for i in range(n)]


def beats_from_row(txt, n):
    cl = [fix_frame_refs(c) for c in clauses(txt)]
    n = max(1, min(n, len(cl)))
    base, extra = divmod(len(cl), n)
    groups, p = [], 0
    for i in range(n):
        sz = base + (1 if i < extra else 0)
        groups.append(cl[p:p + sz])
        p += sz
    res = []
    for (a, b), g in zip(ranges(n), groups):
        s = ", ".join(g)
        s = re.sub(r"^(then|and) ", "", s)
        res.append((a, b, s[0].upper() + s[1:] + "."))
    return res


BEAT_N = {"idle": 4, "walk": 4, "attack": 5, "hurt": 4, "defeat": 4,
          "cast_slam": 5, "cast_power": 5, "celebrate": 5}

ANIM_ES = {"idle": "idle (reposo)", "walk": "walk (desplazamiento)", "attack": "attack (ataque)",
           "hurt": "hurt (herido)", "defeat": "defeat (derrota)", "cast_slam": "cast_slam (poder Squirm Slam)",
           "cast_power": "cast_power (poder genérico)", "celebrate": "celebrate (celebrar)"}
STD_ANIMS = ["idle", "walk", "attack", "hurt", "defeat"]
HERO_ANIMS = ["idle", "cast_slam", "cast_power", "hurt", "celebrate"]

# ---------------------------------------------------------------------------------------------
# 3. Movimiento escrito a mano del heroe base (Squirmy). Las skins usan sus filas originales.
# ---------------------------------------------------------------------------------------------
HERO = {
    "idle": ("A calm looping idle: Squirmy stands upright like a friendly question mark and breathes; he stays in place.", None, [
        (1, 6, "Standing tall, the whole body slowly rises (inhale), the cap brim lifts a little."),
        (7, 13, "Highest point of the breath, then the body starts to sink (exhale); the right little hand gives a tiny wave around frames 9-12."),
        (14, 19, "Body at its lowest, a very small weight shift to one side, the cap brim bobs down."),
        (20, 25, "The eyes blink once (about 2 frames closed), the body rises back to exactly the pose of frame 1."),
    ]),
    "cast_slam": ("Casting Squirm Slam: Squirmy coils like a spring, rises high and slams his front half into the ground. Key moment (impact) on frame 18.", 18, [
        (1, 5, "Anticipation: the head leans back, both hands rise beside the head."),
        (6, 10, "The body coils like a spring, the lower body compresses, the cap tilts back."),
        (11, 15, "The whole front half rises high and stretches upward (tallest pose at frame 15), hands up."),
        (16, 20, "The front half slams down toward the ground with the cap tipping forward; impact at frame 18 with golden sparks and a small crack in the ground."),
        (21, 25, "Golden sparks fade, the body unwinds and returns to the idle standing pose of the first frame."),
    ]),
    "cast_power": ("Casting a generic power: Squirmy calls on a swirl of golden and teal light. Key moment (light burst) on frame 17.", 17, [
        (1, 5, "The head tilts up, he takes a breath, the little hands rise from his sides."),
        (6, 10, "Both hands stretch toward the sky with a determined open-mouth battle cry, the cap stays on."),
        (11, 15, "A swirl of golden and teal light with tiny gears grows around his body, getting bigger each frame."),
        (16, 20, "The swirl reaches its biggest size and bursts outward at frame 17 with a bright pulse, the body stays stretched up."),
        (21, 25, "The light and gears fade away, the hands lower, the body returns to the idle standing pose."),
    ]),
    "hurt": ("Getting hurt: a short flinch and a wobbling recovery; he stays in place.", None, [
        (1, 4, "The hit lands: the body flinches backward sharply, the eyes squeeze shut, the cap tips down over one eye."),
        (5, 10, "The body leans back and wobbles, the little hands flail slightly."),
        (11, 18, "The body sways forward a little (smaller motion), the cap is pushed back up."),
        (19, 25, "He recovers to the idle standing pose with the eyes open again."),
    ]),
    "celebrate": ("Celebrating: a happy jump with a fist pump, a spin and a cap tip. Key moment (top of the jump) around frame 12.", None, [
        (1, 5, "Anticipation: the body crouches and squashes down, one fist gathers beside him."),
        (6, 11, "He bounces up into a happy jump, one fist pumped in the air, the cap stays on."),
        (12, 17, "At the top he does a small spin in the air, body stretched."),
        (18, 22, "He descends and lands with a squash, a cheerful bounce."),
        (23, 25, "He straightens and gives a tiny tip of the cap, ending in the idle standing pose."),
    ]),
}

# ---------------------------------------------------------------------------------------------
# 4. Catalogo de personajes (con animacion)
# ---------------------------------------------------------------------------------------------
# id, nombre, tipo, id original, era, identidad corta (EN), nota de ataque/habilidad (EN),
# rol (ES), defeat sobresale?, vuelo?
CHARS = []


def C(cid, name, kind, orig, era, identity, atk, role, defeat_over=False, hurt_over=False, flying=False,
      pose="standing in a relaxed neutral idle pose", used=None):
    CHARS.append(dict(id=cid, name=name, kind=kind, orig=orig, era=era, identity=identity, atk=atk, role=role,
                      defeat_over=defeat_over, hurt_over=hurt_over, flying=flying, pose=pose, used=used))


# --- Heroe y skins
C("squirmy", "Squirmy (héroe)", "hero", "A01", 0,
  "Squirmy: small bright-green earthworm, lighter yellow-green belly, big round brown eyes, peach-pink cheeks, black baseball cap with a letter A.",
  "", "Héroe del jugador (Home, batalla, resultado)")
C("squirmy_skin_pirate", "Squirmy skin Pirata", "skin", "A06", 0,
  "Squirmy the bright-green worm dressed as a pirate: small black tricorn hat with a gold star and a tiny black eyepatch (no cap).",
  "", "Skin cosmética (tienda, producto skin_pirate)")
C("squirmy_skin_knight", "Squirmy skin Caballero", "skin", "A07", 0,
  "Squirmy the bright-green worm dressed as a knight: tiny shiny silver helmet with a blue plume and a small round silver shield strapped on (no cap).",
  "", "Skin cosmética (tienda, producto skin_knight)")
C("squirmy_skin_astronaut", "Squirmy skin Astronauta", "skin", "A08", 0,
  "Squirmy the bright-green worm dressed as an astronaut: round clear glass space helmet and a small white backpack with a tiny antenna (no cap).",
  "", "Skin cosmética (tienda, producto skin_astronaut)")

# --- Unidades del jugador
C("p1_club_worm", "Club Worm", "unit", "B01", 1,
  "Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, thick wooden club.",
  "Fighter, melee. A heavy overhead club smash: the club lands on the ground just in front of the worm at the key moment.",
  "Luchador (fighter), cuerpo a cuerpo")
C("p1_slinger_worm", "Slinger Worm", "unit", "B02", 1,
  "Golden-yellow earthworm soldier, cream belly, blue cloth headband, brown fur tunic, leather sling with a round gray stone.",
  "Shooter. The stone leaves the sling at the key moment and the hand ends empty. Do NOT draw the stone flying away: the game spawns it as a separate projectile sprite.",
  "Tirador (shooter), a distancia")
C("p1_dino_rider_worm", "Dino Rider Worm", "unit", "B03", 1,
  "Golden-yellow worm rider with blue headband on a chubby green baby triceratops with three small horns and a tan frill, holding a short bone lance.",
  "Heavy mount. The triceratops lowers its head and lunges forward while the rider levels and thrusts the bone lance; the whole group shifts forward and back.",
  "Pesado (heavy), montura", defeat_over=True, pose="standing on its four legs in a relaxed neutral pose, rider upright")
C("p2_shield_bearer_worm", "Shield Bearer Worm", "unit", "B04", 2,
  "Golden-yellow earthworm soldier, blue headband, gold-and-turquoise striped Egyptian headdress, big round gold shield with a turquoise scarab, short bronze spear.",
  "Heavy defender (blocks 20% of ranged damage). A shield bash forward with the spear jabbing over the top edge at the key moment; the shield always stays between the worm and the front.",
  "Pesado (heavy), bloquea 20% del daño a distancia")
C("p2_bow_worm", "Bow Worm", "unit", "B05", 2,
  "Golden-yellow earthworm archer, blue headband, white linen Egyptian headcloth with a thin gold band, small curved wooden bow with an arrow.",
  "Shooter, fast shots. The arrow is released at the key moment and the bow springs forward. Do NOT draw the arrow in flight: it is a separate projectile sprite.",
  "Tirador (shooter), a distancia")
C("p2_cobra_charmer_worm", "Cobra Charmer Worm", "unit", "B06", 2,
  "Golden-yellow earthworm musician, blue headband, turquoise turban with a small gold jewel, little wooden flute; a friendly sand-yellow cobra rising from a woven basket beside him.",
  "Support that slows enemies by 20%. The worm blows the flute harder and the cobra rises tall, flares its hood and strikes forward; a few slow teal music notes may drift forward.",
  "Apoyo (support), ralentiza 20%")
C("p3_knight_worm", "Knight Worm", "unit", "B07", 3,
  "Golden-yellow earthworm knight, blue headband, tiny shiny steel helmet with a blue plume, short sword, blue-and-white kite shield.",
  "Fighter with a +50% first hit. One big, clean diagonal sword slash with the shield tucked in; the slash arc reads as a clear swoosh.",
  "Luchador (fighter), primer golpe +50%")
C("p3_crossbow_worm", "Crossbow Worm", "unit", "B08", 3,
  "Golden-yellow earthworm archer, blue headband, brown hood, wooden crossbow with a bolt loaded.",
  "Shooter, slow heavy shot. A long aiming pause, then the bolt is released at the key moment with a hard recoil. Do NOT draw the bolt in flight.",
  "Tirador (shooter), disparo lento y fuerte")
C("p3_wizard_worm", "Wizard Worm", "unit", "B09", 3,
  "Golden-yellow earthworm wizard, blue headband, tall pointy deep-blue hat with gold stars, wand with a glowing golden star, sparkles around.",
  "Support that boosts allied damage +15%. The wand is circled and pointed forward; a small golden star burst appears only at the wand tip (the star bolt itself is a separate sprite).",
  "Apoyo (support), aura de daño +15%")
C("p4_gear_gunner_worm", "Gear Gunner Worm", "unit", "B10", 4,
  "Golden-yellow earthworm gunner, blue headband, brass goggles on the forehead, small leather vest, copper steam rifle.",
  "Fast shooter, rapid fire. TWO quick steam-rifle bursts in the sequence (first puff around frame 12, second around frame 16) each with a small recoil. Do NOT draw bullets.",
  "Tirador (shooter), cadencia alta")
C("p4_boiler_tank_worm", "Boiler Tank Worm", "unit", "B11", 4,
  "Golden-yellow worm driver with blue headband peeking from the hatch of a chunky round copper-and-brass steam tank with rivets, tall chimney and stubby cannon.",
  "Heavy with splash damage. The cannon fires one big blast with a wide round smoke puff and a small shock ring at the muzzle; the tank rocks back.",
  "Pesado (heavy), daño en área", defeat_over=True, pose="standing still on its treads, chimney puffing a little steam")
C("p4_balloon_bomber_worm", "Balloon Bomber Worm", "unit", "B12", 4,
  "Golden-yellow earthworm bomber, blue headband and brass goggles, hanging from a wicker basket under a patched teal-and-cream hot-air balloon, holding a black bomb with a lit fuse.",
  "Air unit with splash damage. The worm lifts the bomb over the basket edge and drops it straight down at the key moment; the bomb falls out of the frame (it is a separate sprite) and the balloon bobs up lighter.",
  "Aéreo (air), bombardea con daño en área", defeat_over=True, flying=True, pose="floating in a relaxed neutral pose")
C("p5_laser_blade_worm", "Laser Blade Worm", "unit", "B13", 5,
  "Golden-yellow earthworm warrior, blue headband, sleek white-and-teal helmet with a glowing cyan visor, light armor plates, glowing cyan laser sword.",
  "Fast fighter. A lunging cyan arc slash with a short bright cyan afterimage trail.",
  "Luchador (fighter), rápido")
C("p5_mecha_worm", "Mecha Worm", "unit", "B14", 5,
  "Golden-yellow worm pilot with blue headband in the glass cockpit dome of a chunky white-and-blue walking mech with stubby legs, glowing cyan joints and an arm cannon.",
  "Heavy (400 HP). The arm cannon fires a big cyan shot with a strong recoil. Draw only the muzzle flash, NOT the shot in flight.",
  "Pesado (heavy), 400 HP", defeat_over=True, pose="standing on its two stubby legs in a neutral pose")
C("p5_time_medic_worm", "Time Medic Worm", "unit", "B15", 5,
  "Golden-yellow earthworm medic, blue headband, riding a round white-and-teal hovering drone with a glowing golden-teal healing orb, tiny backpack with a gear symbol.",
  "Support that heals allies 5% per second. This is the HEAL animation, not an attack: both arms rise and a ring of golden-teal light expands outward around the drone (the ring may extend beyond the body).",
  "Apoyo (support), cura 5%/s", defeat_over=True, flying=True, pose="hovering in a relaxed neutral pose")

# --- Enemigos
C("e1_ant_clubber", "Ant Clubber", "enemy", "C01", 1,
  "Small black ant warrior, red cloth band on the head, angry snarl, leather loincloth, heavy stone club.",
  "Rushes the nearest unit. A furious overhead stone-club smash with a snarl.", "Luchador (fighter), ataca al más cercano")
C("e1_ant_spitter", "Ant Spitter", "enemy", "C02", 1,
  "Small black ant, red cloth band on the head, puffed cheeks, long bone blowpipe with a glowing green acid drop at the tip.",
  "Ranged. Cheeks puff, the blowpipe lifts, and an acid glob is spat at the key moment. Do NOT draw the glob in flight (separate projectile).",
  "Tirador (shooter), a distancia")
C("e1_stone_beetle", "Stone Beetle", "enemy", "C03", 1,
  "Chunky brown beetle with a thick gray rock-slab shell with green moss, small grumpy eyes, red cloth band on one horn.",
  "Slow tank. A long slow wind-up (rears back, lowers the horn), then a heavy ram with a dust puff at impact.",
  "Pesado (heavy), lento (velocidad 40)", defeat_over=True)
C("e2_scarab_soldier", "Scarab Soldier", "enemy", "C04", 2,
  "Golden scarab beetle soldier, shiny turquoise-edged shell, red cloth sash, small gold helmet, curved bronze blade.",
  "Melee. A diagonal bronze-blade slash.", "Luchador (fighter), cuerpo a cuerpo")
C("e2_locust_archer", "Locust Archer", "enemy", "C05", 2,
  "Slender green-and-brown locust with long bent back legs, red cloth band on the head, sly smirk, small curved bow with an arrow.",
  "Shoots, then hops backward 2 units. The arrow is released at the key moment (do NOT draw it in flight); frames 19-25 end with a small backward hop that stays inside the cell.",
  "Tirador (shooter), salta 2 casillas atrás tras disparar")
C("e2_mummy_moth", "Mummy Moth", "enemy", "C06", 2,
  "Fluffy beige moth with dusty wings loosely wrapped in old linen bandages, sleepy round eyes, red ribbon on one wing, a fresh roll of bandage in one leg.",
  "Healer (5% per second to allies). This is the HEAL animation: the bandage unrolls, is swirled, and a soft golden glow ring expands outward (it may extend beyond the body).",
  "Apoyo (support), cura 5%/s", flying=True, pose="hovering with slow wing beats, in a neutral pose")
C("e3_beetle_knight", "Beetle Knight", "enemy", "C07", 3,
  "Sturdy dark-brown beetle knight, shiny steel helmet with a red plume, steel shoulder plates, long lance, small shield with a red emblem.",
  "Lance charge, +50% first hit. The lance is pulled back and thrust forward with the whole body leaning into it.",
  "Luchador (fighter), carga con lanza")
C("e3_dung_catapult", "Dung Catapult", "enemy", "C08", 3,
  "Stout dung beetle with a tiny leather cap and a mischievous grin, pushing a small wooden two-wheeled catapult loaded with a round brown ball, red banner on it.",
  "Long-range catapult that targets the highest-HP unit. The lever is pulled, the arm swings forward and the ball is flung at the key moment. Do NOT draw the ball in flight.",
  "Tirador (shooter), catapulta de largo alcance", defeat_over=True)
C("e3_hornet_scout", "Hornet Scout", "enemy", "C09", 3,
  "Small yellow-and-black striped hornet, blurry translucent wings, tiny leather helmet, red cloth scarf, small spear.",
  "Flying unit that passes over fighters. It pulls back, then dives forward and thrusts the spear at the key moment, then swings back up.",
  "Aéreo (air), vuela sobre luchadores", defeat_over=True, flying=True, pose="hovering in a neutral pose with wings blurred")
C("e4_cog_roach", "Cog Roach", "enemy", "C10", 4,
  "Clockwork cockroach with brass plates, visible gears and rivets on its back, red cloth band on the head, cheeky grin, big iron wrench.",
  "Fast rusher (speed 80). The wrench is lifted behind the head and swung down and forward in a quick, snappy strike.",
  "Luchador (fighter), corredor rápido")
C("e4_spark_fly", "Spark Fly", "enemy", "C11", 4,
  "Mechanical firefly with a copper body, tiny propeller wings, glass-lantern abdomen crackling with blue-white electricity, red ribbon on one antenna.",
  "Flying chain-lightning unit. The lantern glows brighter, then one short zig-zag bolt of blue-white electricity zaps forward from the lantern (about one body length only; the chain jump is a separate game effect).",
  "Aéreo (air), rayo en cadena a 2 objetivos más", defeat_over=True, flying=True, pose="hovering in a neutral pose with blurred propellers")
C("e4_clank_crab", "Clank Crab", "enemy", "C12", 4,
  "Heavy steam-powered crab with riveted iron shell plates, brass pipes puffing white steam, two big riveted claws, eyes on stalks, small red flag on its back.",
  "Heavy with 25% frontal armor. Both claws are raised high and slammed down and forward with a clank and a small steam puff.",
  "Pesado (heavy), armadura frontal 25%")
C("e5_laser_bug", "Laser Bug", "enemy", "C13", 5,
  "Round armored robot beetle in dark gunmetal gray, glowing red visor, small laser cannon on its back, thin red stripes on the shell, six small legs.",
  "Shooter with a piercing beam. The back cannon swivels forward, charges with a growing red glow and fires with a recoil kick. Draw only the muzzle flash, NOT the beam (separate sprite).",
  "Tirador (shooter), rayo que atraviesa")
C("e5_drone_fly", "Drone Fly", "enemy", "C14", 5,
  "Hovering robotic fly with a dark gray metal body, large glassy lens eyes, thin transparent propeller wings, tiny claws, small blinking red light on the head.",
  "Flying hunter of support units (fast, 55 HP). It pulls back, dives forward with claws extended to grab and swipe, then returns up.",
  "Aéreo (air), caza unidades de apoyo", defeat_over=True, flying=True, pose="hovering in a neutral pose with blurred wings")
C("e5_mecha_beetle", "Mecha Beetle", "enemy", "C15", 5,
  "Huge armored rhinoceros-beetle robot in dark gunmetal gray with glowing red joints, thick legs, a big horn that doubles as a cannon, small red emblem on the shell.",
  "Heavy (450 HP) that targets the highest-HP unit. The horn lowers and glows red, then a charged shot fires from the horn with a strong recoil that pushes the body back. Draw only the muzzle flash, NOT the shot in flight.",
  "Pesado (heavy), 450 HP, ataca al de más vida", defeat_over=True)

# --- Jefes
C("b1_rexy", "Rexy the T-Rex (jefe Era 1)", "boss", "D01", 1,
  "Rexy: big chubby green T-Rex, cream belly, comically tiny arms, huge goofy toothy grin, red bandana, necklace of colorful stones.",
  "Boss. He rears back, takes a big breath and lunges with a roaring chomp; one heavy foot stamps once as he lunges (stomp feel). The game draws its stomp shockwave separately.",
  "Jefe pesado; telegrafía pisotón (aturde 1 s), fase 2 rugido", defeat_over=True)
C("b2_pharaoh_scarab", "Pharaoh Scarab (jefe Era 2)", "boss", "D02", 2,
  "Pharaoh Scarab: giant golden scarab beetle, turquoise-and-gold shell, tall striped pharaoh headdress, red cape, golden crook and flail.",
  "Boss. The flail is raised, spun once overhead and slammed down and forward with a burst of golden dust. The raised crook may glow briefly (hint of his summon power, drawn by the game).",
  "Jefe pesado; invoca 3 escarabajos, fase 2 tormenta de arena", defeat_over=True)
C("b3_sir_sizzle", "Sir Sizzle the Dragon (jefe Era 3)", "boss", "D03", 3,
  "Sir Sizzle: chubby red-orange dragon, small leathery wings, cream belly, dented tin knight helmet that is too small, smoke from the nostrils, red banner on the tail.",
  "Boss. He inhales so the belly swells, rears the head back, then breathes a big cartoon fireball forward with the helmet flying up. Phase 2 makes him fly in the game, but this sheet keeps him walking.",
  "Jefe pesado; aliento de fuego, fase 2 vuela", defeat_over=True)
C("b4_clockwork_queen", "The Clockwork Queen (jefe Era 4)", "boss", "D04", 4,
  "The Clockwork Queen: large mechanical spider, brass-and-copper body, small golden crown, visible gears and rivets, six thin jointed legs, glass-dome abdomen with swirling white steam, glowing red eyes, red silk sash.",
  "Boss. The front legs rise, the dome glows, a burst of hot steam is released forward and the front legs stab down at the key moment. The game adds the steam area separately.",
  "Jefe pesado; ráfaga de vapor (ralentiza), fase 2 genera Cog Roach", defeat_over=True, hurt_over=True)
C("b5_count_magpie_3000", "Count Magpie 3000 (jefe final Era 5)", "boss", "D05", 5,
  "Count Magpie 3000: giant mechanical magpie, chrome-and-indigo plating, glowing cyan eyes, metal top hat, gold monocle, shiny metal blade wings, red cape, glowing golden Chrono Core shard in one claw.",
  "Final boss. The wings spread wide, the shard glows brighter, the claw swings forward and releases a golden-cyan time wave at the key moment, then the wings fold back. The game adds the wave itself.",
  "Jefe pesado; roba un poder 8 s, fase 2 se teletransporta y lanza bombas", defeat_over=True, hurt_over=True)

CH = {c["id"]: c for c in CHARS}

# Fase por era / personaje
ERA_PHASE = {0: "A", 1: "A", 2: "C", 3: "E", 4: "F", 5: "G"}
for c in CHARS:
    c["phase"] = "D" if c["kind"] == "skin" else ERA_PHASE[c["era"]]

# ---------------------------------------------------------------------------------------------
# 5. Reglas de tamano y desborde
# ---------------------------------------------------------------------------------------------
SIZES = {  # kind -> (celda, hoja, celda x2, hoja x2)
    "hero": (384, 1920, 768, 3840), "skin": (384, 1920, 768, 3840),
    "unit": (256, 1280, 512, 2560), "enemy": (256, 1280, 512, 2560),
    "boss": (512, 2560, 1024, 5120),
}


def overflow(c, anim):
    """-> (bool, motivo)"""
    k = c["kind"]
    if k in ("hero", "skin"):
        why = {"cast_slam": "el cuerpo se estira hacia arriba y el golpe al suelo suelta chispas y grietas",
               "cast_power": "el remolino de luz dorada y turquesa con engranes crece alrededor del héroe",
               "celebrate": "hay un salto con giro y los brazos arriba"}
        return (anim in why), why.get(anim, "movimiento contenido junto al cuerpo")
    if k == "boss":
        if anim == "attack":
            return True, "el golpe/aliento/ráfaga del jefe llega muy lejos del cuerpo"
        if anim == "defeat":
            return True, "el jefe cae y se derrumba ocupando mucho más espacio"
        if anim == "hurt" and c["hurt_over"]:
            return True, "salen piezas, chispas o engranes despedidos"
        return False, "movimiento contenido en el cuerpo del jefe (que ya llena la celda)"
    if anim == "attack":
        return True, "golpe, proyectil, destello o efecto que se extiende fuera del cuerpo"
    if anim == "defeat" and c["defeat_over"]:
        return True, "caída o desarme con piezas, humo o chispas que se salen del cuerpo"
    if anim == "hurt" and c["hurt_over"]:
        return True, "salen piezas o chispas"
    return False, "movimiento contenido junto al cuerpo"


# ---------------------------------------------------------------------------------------------
# 6. Construccion de prompts de personajes
# ---------------------------------------------------------------------------------------------
SINGLE_STYLE_TAIL = ("Crisp clean edges. No text, no border, no shadow, no ground, no gradient. "
                     "Do not use magenta or pink anywhere on the subject. Square 1:1 image.")


def facing_of(c):
    return "left" if c["kind"] in ("enemy", "boss") else "right"


def key_of(c):
    return "#0000FF" if c["id"] == "wormina" else "#FF00FF"


def ref_prompt(c, orig):
    d = orig[c["orig"]]
    face = facing_of(c)
    filling = "filling most of the frame, " if c["kind"] == "boss" else ""
    body = (f"{d['design']} {d['style'].replace('sprite sheet', 'illustration')} One single full-body subject, {c['pose']}, three-quarter view slightly turned toward the {face}, "
            f"facing {face}, {filling}the whole body and all held items fully visible, centered with a wide empty margin, "
            f"drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. "
            "Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.")
    return body


def split_range(a, b, k):
    n = b - a + 1
    bd = [a - 1 + round(i * n / k) for i in range(k + 1)]
    return [(bd[i] + 1, bd[i + 1]) for i in range(k)]


def group_even(cl, k):
    k = max(1, min(k, len(cl)))
    base, extra = divmod(len(cl), k)
    out, p = [], 0
    for i in range(k):
        sz = base + (1 if i < extra else 0)
        out.append(cl[p:p + sz])
        p += sz
    return out


def cap(s):
    s = re.sub(r"^(then|and) ", "", s.strip())
    return s[0].upper() + s[1:]


def join(g):
    return cap(", ".join(g)) + "."


# Tipo de desplazamiento por personaje (para el ciclo de walk)
WALK_TYPE = {
    "p1_club_worm": "inch", "p1_slinger_worm": "inch", "p1_dino_rider_worm": "quad", "p2_shield_bearer_worm": "inch",
    "p2_bow_worm": "inch", "p2_cobra_charmer_worm": "inch", "p3_knight_worm": "inch", "p3_crossbow_worm": "inch",
    "p3_wizard_worm": "inch", "p4_gear_gunner_worm": "inch", "p4_boiler_tank_worm": "tread", "p4_balloon_bomber_worm": "hover",
    "p5_laser_blade_worm": "inch", "p5_mecha_worm": "mech", "p5_time_medic_worm": "hover",
    "e1_ant_clubber": "legs6", "e1_ant_spitter": "legs6", "e1_stone_beetle": "stomp", "e2_scarab_soldier": "legs6",
    "e2_locust_archer": "hop", "e2_mummy_moth": "wings", "e3_beetle_knight": "legs6", "e3_dung_catapult": "legs6",
    "e3_hornet_scout": "wings", "e4_cog_roach": "legs6", "e4_spark_fly": "wings", "e4_clank_crab": "legs6",
    "e5_laser_bug": "legs6", "e5_drone_fly": "wings", "e5_mecha_beetle": "stomp",
    "b1_rexy": "stomp", "b2_pharaoh_scarab": "legs6", "b3_sir_sizzle": "waddle", "b4_clockwork_queen": "legs6",
    "b5_count_magpie_3000": "strut",
}
WALK_T = {
    "inch": ["Contact pose: the body is stretched long and low, the head reaches forward.",
             "The tail end pulls forward along the ground while the middle of the body starts to arch up.",
             "The middle is arched at its highest like a small bridge, the head comes down.",
             "The front stretches forward again and the body flattens, ending in exactly the pose of frame 1."],
    "legs6": ["The first group of legs (front and rear on one side, middle on the other) steps forward while the others push back; the body dips a little.",
              "Weight passes over the planted legs, the body rises to its highest point.",
              "The second group of legs steps forward while the first pushes back; the body dips again.",
              "Weight passes again and the legs return to the exact positions of frame 1."],
    "quad": ["The front-left and rear-right legs lift and step while the body leans forward.",
             "Both stepping feet plant with a heavy bounce, the body sinks and the rider bounces down.",
             "The front-right and rear-left legs lift and step, the body rises.",
             "Both feet plant and the body returns to the pose of frame 1."],
    "stomp": ["The left foot lifts and the heavy body leans onto the right side.",
              "The left foot stomps down: the body drops and bounces, a small dust puff.",
              "The right foot lifts and the body leans onto the left side.",
              "The right foot stomps down and the body returns to the pose of frame 1."],
    "waddle": ["The body tilts to the right as the left foot lifts in a clumsy waddle.",
               "The left foot lands, the belly jiggles, the body tilts back to the center.",
               "The body tilts to the left as the right foot lifts.",
               "The right foot lands and the body returns to the pose of frame 1."],
    "strut": ["The left leg lifts in a proud, high step with the chest puffed out and the head forward.",
              "The left foot lands, the head bobs down a little and the cape swings.",
              "The right leg lifts in a proud, high step, the head moves back.",
              "The right foot lands and everything returns to the pose of frame 1."],
    "hop": ["The locust crouches, the long back legs fold and the body lowers.",
            "It springs forward, the back legs extend and the body stretches.",
            "At the top of a small hop it tucks, then starts to descend with the legs reaching down.",
            "It lands, absorbs the landing with a crouch and rises back to the pose of frame 1."],
    "wings": ["The wings are raised high above the back and the body tilts forward.",
              "The wings sweep down fast, the body rises slightly.",
              "The wings swing back up, the body dips.",
              "The wings sweep down again and everything returns to the pose of frame 1 (the flap goes through two full cycles in the sheet)."],
    "hover": ["The vehicle tilts forward a little and starts to glide, rising slightly.",
              "It reaches the top of a gentle bob while the hanging parts swing behind.",
              "It sinks back down a little, the hanging parts swing forward.",
              "It settles back to exactly the pose of frame 1."],
    "tread": ["The treads roll and the whole machine bounces up a little, the chimney puffs.",
              "The machine settles down, the body leans slightly forward.",
              "The treads roll on and it bounces up again with a bigger steam puff.",
              "It settles back to exactly the pose of frame 1."],
    "mech": ["The left stubby leg lifts and steps forward, the cockpit leans slightly forward.",
             "The left foot plants with a small thud, the body sinks, the pilot bounces in the dome.",
             "The right stubby leg lifts and steps forward.",
             "The right foot plants and the machine returns to the pose of frame 1."],
}
IDLE_T = {
    "ground": ["Slow inhale: the body rises slightly.",
               "The top of the breath, a tiny pause, the body starts to settle.",
               "Slow exhale: the body sinks a little below its resting height.",
               "The lowest point, a tiny settle, then the body returns to exactly the pose of frame 1."],
    "float": ["The body drifts gently up.",
              "It reaches the top of the bob and the loose parts sway to one side.",
              "It drifts gently down and the loose parts sway the other way.",
              "It settles back to exactly the pose of frame 1."],
}



# Ataques escritos a mano (5 tramos: preparacion, carga, golpe, continuacion, recuperacion). Fotograma clave: 13.
ATTACK_RANGES = [(1, 6), (7, 11), (12, 15), (16, 19), (20, 25)]
ATTACK = {
    "p1_club_worm": [
        "The body shifts its weight backward and the head leans back; the club lifts off the shoulder and rises behind the head, both little hands gripping it.",
        "The body coils back like a spring, the tail end tightens, the club reaches its highest point behind the head and the face turns into a determined grin.",
        "The front of the body whips forward and the club swings down in a fast arc, hitting the ground just in front of the worm on frame 13 with a small puff of dust.",
        "The club rests low on the ground after the hit, the body is stretched forward, the headband tails whip forward.",
        "The body pulls back upright, the club returns to the shoulder, the headband tails settle and the pose of frame 25 matches the idle."],
    "p1_slinger_worm": [
        "One eye squints to aim; the arm with the sling lifts above the head and the stone rests in the leather pouch.",
        "The sling spins in fast circles above the head (the loop is drawn in 3 or 4 distinct positions), the body leans slightly back for balance.",
        "The arm snaps forward in a whip and the stone leaves the sling on frame 13 (draw the arm fully extended and the empty open sling; no stone in flight).",
        "The arm follows through across the body, the sling swings loosely forward, the body leans forward from the effort.",
        "The arm returns down, the body relaxes and straightens, the empty sling hangs at the side, ready for idle."],
    "p1_dino_rider_worm": [
        "The triceratops steps back slightly and lowers its head so the horns point forward; the rider crouches low on its back and brings the bone lance back.",
        "The dinosaur's haunches sink like a spring and its tail lifts for balance; the rider's lance is pulled to the back of its hand.",
        "The dinosaur lunges forward with its horns low and the rider thrusts the lance straight ahead; the point of the lance and the horns meet the target on frame 13, with dust kicked up under the feet.",
        "The dinosaur's momentum carries it a little further forward, head still low, the rider leaning with the lance extended.",
        "Both settle back: the dinosaur lifts its head and steps back to its standing line, the rider straightens and lowers the lance."],
    "p2_shield_bearer_worm": [
        "The body pulls back behind the shield, the shield draws toward the chest and the spear is gathered back along the shield's upper edge.",
        "The worm braces, the body compresses, the headdress tails swing back.",
        "The shield pushes forward in a hard bash and the spear jabs over its top edge on frame 13; the headdress tails whip forward.",
        "The shield stays extended, a small shock flash at the shield's rim, the spear tip retracts slightly.",
        "The shield and spear pull back to the guard position in front of the body, the headdress tails settle and the pose matches the idle."],
    "p2_bow_worm": [
        "The bow is lifted forward at arm's length, an arrow is nocked on the string and the free hand reaches back; one eye closes to aim.",
        "The string is drawn back slowly to the cheek, the bow arm trembles slightly and the headcloth tails sway back.",
        "The string is released on frame 13: the bow springs forward, the string vibrates and the hand opens (no arrow is drawn in flight).",
        "The bow shakes briefly, the body leans forward from the release, the empty string vibrates.",
        "The arm lowers, the body relaxes and straightens, the bow returns to the side and the pose matches the idle."],
    "p2_cobra_charmer_worm": [
        "The worm takes a deep breath, the body leans back with the flute at the lips and the notes start to float up; the cobra begins to rise from the basket.",
        "The flute is blown harder, the body arches, the cobra rises tall with its eyes locked on the target and its hood starting to flare.",
        "The cobra flares its hood wide and strikes forward with its mouth open on frame 13; a few slow, heavy teal music notes burst out of the flute.",
        "The cobra's strike stays extended with the hood flared, the worm keeps blowing, the notes drift forward.",
        "The cobra pulls back and slides into the basket, the hood folds and the worm lowers the flute; the pose matches the idle."],
    "p3_knight_worm": [
        "The sword is lifted back over the shoulder and the shield tucks in toward the body; the plume tilts back.",
        "The body coils, the front leans back, the sword reaches its highest point with the blade pointing up and back.",
        "A big diagonal slash comes down and forward from the upper back to the lower front on frame 13, with a clean bright swoosh arc following the blade.",
        "The sword finishes low and forward, the body leans into the slash, the plume swings forward.",
        "The sword is raised back to the guard position, the shield returns to the front, the body straightens and the pose matches the idle."],
    "p3_crossbow_worm": [
        "The crossbow rises from the arms to eye level, the hood tip sways, one eye closes to aim.",
        "A long, steady aiming pause: the body is almost still, the crossbow is level, the finger rests on the trigger.",
        "The trigger is squeezed and the crossbow kicks back hard on frame 13; the string snaps forward (no bolt is drawn in flight), a small puff of dust at the tip.",
        "The recoil pushes the body slightly back, the crossbow tilts up and shakes.",
        "The crossbow lowers to rest in the arms again, the hood bobs, the body relaxes and the pose matches the idle."],
    "p3_wizard_worm": [
        "The wand is lifted high with one hand, the hat tip flops back and a few sparkles start to gather around the wand star.",
        "The wand traces a full circle in the air above the head (draw the faint golden trail of the circle), the star glows brighter, the body sways.",
        "The wand points forward and a golden star burst pops at its tip on frame 13 (only the burst at the tip, no bolt in flight); the hat leans back and the body recoils slightly.",
        "The sparkles scatter forward and fade, the wand shakes, the hat flops.",
        "The wand lowers, the glow returns to its soft pulse, the worm straightens the hat and the pose matches the idle."],
    "p4_gear_gunner_worm": [
        "The rifle comes off the shoulder and is raised and aimed with a cocky grin; the goggles glint.",
        "The body braces, the rifle steadies, a small curl of steam gathers at the muzzle.",
        "First puff: a bright white steam burst shoots from the muzzle on frame 13 with a small recoil kick. A quicker second burst follows right behind it by frame 16, with another kick (no bullets drawn).",
        "The rifle shakes from the recoil, the steam clouds drift forward and thin out, the goggles slip a little.",
        "The rifle lowers back to the shoulder, the steam fades, the grin relaxes and the pose matches the idle."],
    "p4_boiler_tank_worm": [
        "The tank rocks back on its treads and the cannon rises slightly; the chimney puffs a bigger cloud and the driver ducks lower into the hatch.",
        "The cannon barrel slides back into the body to load, the whole tank compresses like a spring, the rivets rattle.",
        "The cannon fires on frame 13: a flash and a big round puff of smoke at the muzzle, a small shock ring, and the whole tank rocks backward on its treads.",
        "The smoke spreads, the tank settles forward again with a bounce, the driver peeks out of the hatch.",
        "The barrel slides forward to its resting place, the chimney puffs normally again and the pose matches the idle."],
    "p4_balloon_bomber_worm": [
        "The worm leans over the basket edge, lifts the bomb with both hands and the fuse sparks brighter; the balloon tilts slightly toward him.",
        "He winds up, the bomb swings back beside the basket, the basket tilts and the ropes stretch.",
        "He drops the bomb straight down on frame 13 with a mischievous grin (draw the bomb leaving his hands and falling out of the cell bottom, no explosion); the balloon jumps up lighter.",
        "The balloon rises a little and wobbles, the basket swings, the worm looks down over the edge.",
        "The balloon settles back to its floating height, the worm straightens, the basket stops swinging and the pose matches the idle."],
    "p5_laser_blade_worm": [
        "The body coils back low, the laser sword is pulled behind the body with its glow brightening, the visor glints.",
        "The worm tenses and starts to push forward, the sword reaches its farthest back position, a faint cyan trail gathers behind the blade.",
        "The body lunges forward and the sword sweeps in a bright cyan arc from above-behind to the front on frame 13, leaving a clean cyan afterimage trail.",
        "The arc fades into a short trail, the body is stretched forward at the end of the lunge, the glow flickers.",
        "The body pulls back and the sword returns to the ready position, the hum calms and the pose matches the idle."],
    "p5_mecha_worm": [
        "The mech plants its legs wide and sinks slightly; the arm cannon lifts and starts to glow cyan, the pilot leans forward in the dome.",
        "The cannon charges: the cyan glow grows and the joints flash brighter, the body shakes slightly.",
        "A bright cyan muzzle flash on frame 13 (no shot in flight) and a strong recoil that pushes the mech's upper body backward.",
        "The mech skids slightly backward, small cyan sparks and a puff of smoke at the muzzle, the dome flashes.",
        "The arm lowers, the legs steady, the joints dim to their normal pulse and the pose matches the idle."],
    "p5_time_medic_worm": [
        "The drone tilts slightly back, the medic breathes in and starts to raise both arms; the healing orb begins to glow brighter.",
        "Both arms are raised above the head, the orb grows bigger and brighter, the backpack gear symbol glows.",
        "A ring of golden-teal light bursts out of the orb on frame 13 and expands outward around the drone (the ring may extend far beyond the body), with tiny sparkles along it.",
        "The ring keeps expanding and fades, soft sparkles fall around the drone, the medic smiles kindly.",
        "The arms lower, the orb shrinks back to its soft pulse and the pose matches the idle."],
    "e1_ant_clubber": [
        "The ant rears up on its hind legs and leans back, the stone club lifts off the shoulder with both front legs gripping it.",
        "The club reaches its highest point over the head, the body leans far back, the mandibles open in a snarl.",
        "The club swings down and forward in a heavy arc on frame 13, smashing the ground in front of the ant with a dust puff.",
        "The ant is bent forward with the club low on the ground, the antennae whip forward.",
        "The club is hauled back to the shoulder, the ant drops back onto all its legs and the pose matches the idle."],
    "e1_ant_spitter": [
        "The ant rears up on its hind legs and the blowpipe lifts toward its mouth; the green drop at the tip grows.",
        "The cheeks puff up like balloons, the body leans back, the antennae stand up.",
        "The cheeks deflate in one blast on frame 13 and the green acid glob is spat out of the blowpipe (draw only the burst at the tip, no glob in flight); the ant recoils backward.",
        "The ant's body bends from the recoil, the blowpipe shakes, a thin green drip hangs at its tip.",
        "The blowpipe lowers to the side, the cheeks return to normal, the ant drops back onto all its legs and the pose matches the idle."],
    "e1_stone_beetle": [
        "The beetle shifts its weight backward on its heavy legs and starts to lower its head; moss patches on the shell tilt.",
        "A long, slow wind-up: it rears back with the front legs off the ground, the horn lowered and pointing forward, the shell creaking.",
        "It drops and rams forward on frame 13: the horn hits low and forward with a heavy thud and a dust puff, the shell slabs rattle.",
        "The momentum drags the beetle forward a little with the horn still low, small pebbles bounce off the shell.",
        "It slowly pulls back, lifts its head and settles onto its standing line; the pose matches the idle."],
    "e2_scarab_soldier": [
        "The scarab raises its bronze blade backward over the shoulder, the helmet tilts back and the shell lifts slightly.",
        "The body leans far back, the blade is held high at its maximum, the legs brace.",
        "A diagonal slash comes down and forward on frame 13 with a clean bright swoosh arc; the shell shines as it passes.",
        "The blade finishes low and forward, the body leans into the cut, the sash flutters.",
        "The blade is raised back to the guard position, the body straightens and the pose matches the idle."],
    "e2_locust_archer": [
        "The locust rears up slightly on its back legs, raises the bow and nocks an arrow; its sly smirk widens.",
        "The string is drawn back slowly to the cheek, the antennae lean back, the long back legs flex ready to spring.",
        "The string is released on frame 13: the bow springs forward and the string vibrates (no arrow in flight).",
        "The body recoils and crouches, the long back legs bend deeply for the hop.",
        "A small hop backward (during these frames): the legs extend, the body lifts a little off the standing line and lands again in the idle pose on frame 25, staying inside the cell."],
    "e2_mummy_moth": [
        "The moth rises slightly with slow wing beats and holds the bandage roll with its leg; a loose end of the bandage unfurls.",
        "The bandage unrolls and swirls in a slow circle around the moth (draw the cloth trail), the wings spread wider.",
        "A soft golden glow ring expands outward from the swirling bandage on frame 13, with tiny sparkles along the ring (it may extend beyond the body).",
        "The ring keeps expanding and fades, golden sparkles fall, the bandage flutters loosely.",
        "The bandage rolls back up into a neat roll, the wings return to their slow beat and the pose matches the idle."],
    "e3_beetle_knight": [
        "The beetle pulls the long lance back along its side, the shield rises in front and the plume tilts back.",
        "The body leans back and the legs brace, the lance tip is held high behind, a stern look.",
        "The whole body lunges forward and the lance thrusts straight ahead on frame 13, the shield tucked in, the plume streaming back.",
        "The lance stays extended at the end of the thrust, the body leans far forward, the cape-like plume whips.",
        "The lance pulls back along the side, the shield lowers, the body straightens and the pose matches the idle."],
    "e3_dung_catapult": [
        "The beetle stops pushing and plants its legs; it reaches for the lever with the catapult arm lowered and the ball in the cup.",
        "The beetle pulls the lever back, the catapult arm tilts backward under tension, the wheels creak and the ropes tighten.",
        "The lever is released on frame 13: the catapult arm swings forward and flings the ball (the cup is empty after the throw, no ball drawn in flight); the whole catapult shakes.",
        "The arm swings past and bounces, the banner flaps, the beetle's cap flies up a little.",
        "The arm is cranked back down and a new ball is loaded; the beetle straightens its cap and the pose matches the idle."],
    "e3_hornet_scout": [
        "The hornet pulls its body back and rises slightly, the spear pulled in close and the wings buzzing in blur.",
        "It tilts into a dive angle, the stinger end pointing toward the target, the scarf streams back.",
        "The hornet dives forward on frame 13 and thrusts the spear straight ahead at the end of the dive; the wings stretch back.",
        "It swings upward past the target in an arc, the scarf whipping.",
        "It returns to its hover height, the spear comes back to point forward and the pose matches the hover idle."],
    "e4_cog_roach": [
        "The roach rears back on its hind legs and lifts the iron wrench off the shoulder; gears on its back spin faster.",
        "The wrench rises behind the head, the body coils like a spring, a cheeky grin.",
        "The wrench swings down and forward in a quick snappy arc on frame 13 with a small spark at the contact.",
        "The wrench rests low in front, the body bends forward, a gear pops slightly loose.",
        "The roach hauls the wrench back to the shoulder, drops onto all its legs and the pose matches the idle."],
    "e4_spark_fly": [
        "The firefly curls its body back, the propellers slow down and the lantern abdomen begins to glow brighter.",
        "The lantern reaches its brightest white-blue, tiny sparks crackle around it, the body curls tight.",
        "A short zig-zag bolt of blue-white electricity zaps forward from the lantern on frame 13 (about one body length only), the body snaps forward.",
        "The bolt flickers out, sparks drift down, the lantern dims and the body floats back up.",
        "The propellers speed back up, the body returns to its hover height and the pose matches the hover idle."],
    "e4_clank_crab": [
        "The crab rears up on its back legs and lifts both big claws high, steam hissing from the pipes.",
        "Both claws reach their highest point, the body leans back, the eye stalks tilt up.",
        "Both claws slam down and forward together on frame 13 with a loud clank, a flash of sparks and a puff of steam at the impact.",
        "The claws stay pressed down for a moment, the body bends forward, the shell plates rattle.",
        "The claws lift and pull back to the guard position in front, the crab lowers onto its legs and the pose matches the idle."],
    "e5_laser_bug": [
        "The bug lowers its body slightly and the cannon on its back swivels forward; the red visor brightens.",
        "The cannon charges with a growing red glow at the muzzle, tiny red particles gather, the legs brace.",
        "The cannon fires on frame 13: a bright red muzzle flash and a strong recoil kick (no beam drawn), the whole body skids back a little.",
        "Smoke curls from the muzzle, the visor flickers and the barrel is hot red.",
        "The cannon cools to dark gray and swivels back to rest, the visor returns to its steady glow and the pose matches the idle."],
    "e5_drone_fly": [
        "The drone pulls back and up, the wings blur faster, the red light blinks quickly and the claws open.",
        "It tilts into a dive angle with the claws spread forward, the body shakes slightly as it charges.",
        "It dives forward on frame 13 with the claws extended to grab and swipe, wings stretched back.",
        "It sweeps past in an arc, the claws closing on empty air, the red light flashes.",
        "The drone climbs back to its hover height, the claws tuck in and the pose matches the hover idle."],
    "e5_mecha_beetle": [
        "The robot beetle plants its thick legs wide and lowers its body, the horn tilts down toward the target; the red joints light up brighter.",
        "The horn glows deep red and charges, small red sparks run along its length, the whole body vibrates.",
        "A charged red blast fires from the horn tip on frame 13 (draw only the muzzle flash, no shot in flight) and a strong recoil pushes the body backward, the legs skid.",
        "Smoke curls from the horn, the red joints flicker, the body is rocked back.",
        "The horn cools and lifts back to its resting angle, the legs steady and the pose matches the idle."],
    "b1_rexy": [
        "Rexy lifts his head and takes a big breath, the chest swelling; one heavy foot lifts off the ground and the tiny arms curl in.",
        "The head rears far back and up, the mouth closes tight and the body coils backward, the tail swings the other way for balance.",
        "The foot stomps hard and the whole body lunges forward as the head snaps down and the jaws chomp with a loud roar on frame 13; a ring of dust bursts around the foot.",
        "The head stays low and forward with the jaws open mid-roar, the tail swings back and the necklace bounces.",
        "He straightens slowly, closes the mouth into the goofy grin and the pose matches the idle."],
    "b2_pharaoh_scarab": [
        "The Pharaoh raises the golden flail high over his head with one arm, the headdress tilts back and the cape lifts; the crook is held up in the other arm.",
        "The flail is spun once overhead in a full circle (draw the chain in 3 or 4 positions), the body leans back and the shell gleams.",
        "The flail is slammed down and forward on frame 13, hitting the ground with a burst of golden dust that sprays outward.",
        "The flail stays on the ground, the golden dust drifts upward, the cape swings forward and the headdress tips.",
        "The flail is lifted back to the guard position, the crook lowers, the body straightens and the pose matches the idle."],
    "b3_sir_sizzle": [
        "Sir Sizzle takes a deep breath: the belly begins to swell, the wings lift and the helmet wobbles on his head.",
        "The belly is at its biggest, the head rears far back, the smoke curls thicken, the cheeks puff.",
        "He thrusts the head forward and breathes a big cartoon fireball on frame 13, the helmet flying up off his head; the flame stretches far in front of him.",
        "The fire keeps pouring forward in a streak as the belly shrinks, the banner on the tail whips, the helmet spins in the air.",
        "The flame fades into a wisp of smoke, the helmet drops back onto his head crooked, the belly settles and the pose matches the idle."],
    "b4_clockwork_queen": [
        "The Queen raises her two front legs high and the glass dome starts to glow; the gears spin faster and the steam inside swirls.",
        "The dome glows bright white-orange, the body squats on the rear legs, the crown tilts back and the red eyes flare.",
        "The front legs stab down hard on frame 13 and a burst of hot steam jets forward out of the dome in a thick white cloud.",
        "The steam keeps pouring forward and spreads, the front legs stay planted, the sash flutters wildly.",
        "The steam thins out, the front legs lift and return, the dome calms to its slow swirl and the pose matches the idle."],
    "b5_count_magpie_3000": [
        "The Count lifts his chest and the blade wings start to spread; the claw with the Chrono Core shard rises and the shard glows brighter.",
        "The wings are fully spread wide, the cape billows, the cyan eyes flare and the shard in the claw pulses strongly.",
        "The claw swings forward and releases a golden-cyan time wave on frame 13: a bright expanding arc of light around the claw, strong enough to push the cape back.",
        "The time wave expands further and fades, the wings stay open, small gold sparks drift down, the monocle flashes.",
        "The wings fold back in one smooth motion, the claw lowers with the shard glowing softly and the pose matches the idle."],
}


VERBS = {"ends", "droops", "slides", "swings", "returns", "pulls", "dives", "recovers", "flares", "settles", "winds", "drops",
         "lowers", "rams", "springs", "lands", "charges", "fires", "cools", "takes", "lunges", "topples", "flops", "fades", "steadies"}
PARTICIPLES = {"slammed", "swirled", "pointed", "released", "spun"}


def subject_of(c):
    if c["kind"] in ("hero", "skin"):
        return "Squirmy"
    n = c["name"].split(" (")[0]
    if c["kind"] == "boss":
        if n.startswith("Pharaoh"):
            return "The Pharaoh Scarab"
        return n.split(" the ")[0] if not n.startswith("The ") else n
    return "The " + n


def seq_beats(c, anim, txt):
    cl = [fix_frame_refs(x) for x in clauses(txt)]
    subj = subject_of(c)

    def J(g):
        g = list(g)
        w = re.sub(r"^(then|and) ", "", g[0]).split()[0]
        if w in VERBS:
            g[0] = subj + " " + re.sub(r"^(then|and) ", "", g[0])
        elif w in PARTICIPLES:
            g[0] = "it is " + re.sub(r"^(then|and) ", "", g[0])
        return cap(", ".join(g)) + "."

    det = ", ".join(cl)
    if anim == "idle":
        t = IDLE_T["float" if (c["flying"] or c["id"] in ("p4_boiler_tank_worm", "p5_mecha_worm")) else "ground"]
        res = [(a, b, s) for (a, b), s in zip(ranges(4), t)]
        res.append((1, 25, "Character details to keep throughout the loop (one blink of about 2 frames around frames 21-22): %s." % det))
        return res
    if anim == "walk":
        t = WALK_T[WALK_TYPE[c["id"]]]
        res = [(a, b, s) for (a, b), s in zip(ranges(4), t)]
        res.append((1, 25, "Character details to keep throughout the loop: %s." % det))
        return res
    if anim in ("cast_slam", "cast_power", "celebrate"):
        gs = group_even(cl, 5)
        return [(a, b, J(g)) for (a, b), g in zip(ranges(len(gs)), gs)]
    if anim == "attack" and c["id"] in ATTACK:
        return [(a, b, cap(t)) for (a, b), t in zip(ATTACK_RANGES, ATTACK[c["id"]])]
    if anim == "attack":
        if len(cl) < 3:
            wind, strike, rec = ["the body prepares for the strike, coiling and leaning back"], cl[0], cl[-1]
        else:
            wind, strike, rec = cl[:-2], cl[-2], cl[-1]
        groups = group_even(wind, 2)
        res = [(a, b, J(g)) for (a, b), g in zip(split_range(1, 11, len(groups)), groups)]
        res.append((12, 19, J([strike]) + " The key moment (impact or release) is on frame 13."))
        res.append((20, 25, J([rec]) + " Frame 25 is back in the starting pose."))
        return res
    if anim == "hurt":
        front, last = cl[:-1] or ["the body reacts"], cl[-1]
        res = []
        if len(front) >= 3:
            res.append((1, 5, "The hit lands: " + J(front[:1])[0].lower() + J(front[:1])[1:]))
            res.append((6, 18, J(front[1:])))
        else:
            res.append((1, 18, "The hit lands: " + J(front)[0].lower() + J(front)[1:]))
        res.append((19, 25, J([last])))
        return res
    # defeat
    front, last = cl[:-1] or ["the body wobbles and droops"], cl[-1]
    res = []
    if len(front) >= 3:
        res.append((1, 8, J(front[:1])))
        res.append((9, 20, J(front[1:])))
    else:
        res.append((1, 20, J(front)))
    res.append((21, 25, J([last]) + " Hold this final pose still until frame 25."))
    return res


SKIN_WORD = {"pirate": "tricorn hat", "knight": "helmet", "astronaut": "helmet"}
SKIN_SUBS = {
    "pirate": [("the cap brim", "the hat brim"), ("a tiny tip of the cap", "a tiny tip of the hat")],
    "knight": [("the cap brim", "the plume"), ("tips down over one eye", "wobbles on his head"), ("a tiny tip of the cap", "a small proud nod")],
    "astronaut": [("the cap brim", "the backpack antenna"), ("tips down over one eye", "wobbles on his head"), ("a tiny tip of the cap", "a small wave")],
}


def skin_info(c, anim, orig):
    skin = c["id"].split("_")[-1]
    summ, key, beats = HERO[anim]

    def sub(t):
        for a, b in SKIN_SUBS[skin]:
            t = t.replace(a, b)
        return re.sub(r"\bcap\b", SKIN_WORD[skin], t)
    beats = [(a, b, sub(t)) for a, b, t in beats]
    label, txt = orig[c["orig"]]["rows"][HERO_ANIMS.index(anim)]
    beats.append((1, 25, "Skin-specific details to keep (they replace the cap of the base design): %s." % fix_frame_refs(", ".join(clauses(txt)))))
    return sub(summ).replace("Squirmy", "Squirmy in his %s outfit" % skin, 1), key, beats


def anim_info(c, anim, orig):
    """-> (resumen, key_moment, beats[(a,b,txt)])"""
    if c["id"] == "squirmy":
        return HERO[anim]
    if c["kind"] == "skin":
        return skin_info(c, anim, orig)
    d = orig[c["orig"]]
    idx = (HERO_ANIMS if c["kind"] in ("hero", "skin") else STD_ANIMS).index(anim)
    label, txt = d["rows"][idx]
    beats = seq_beats(c, anim, txt)
    summ = {
        "idle": "A calm looping idle: subtle breathing motion, the character stays in place.",
        "walk": "A looping move cycle (%s): it stays in place inside the cell (no travel across the cell, the game moves the sprite)." % label.split(",")[0].replace(" loop", ""),
        "attack": "A single attack with anticipation, strike and recovery back to the starting pose. Key moment (damage or release) on frame 13.",
        "hurt": "A short flinch from a hit and a recovery to the idle pose; the character stays in place.",
        "defeat": "A defeat that ends lying still: the final pose is held, almost unchanged, from frame 21 to frame 25.",
        "cast_slam": "Casting Squirm Slam: coil, rise and slam the front half into the ground. Key moment (impact) on frame 18.",
        "cast_power": "Casting a generic power: arms to the sky and a swirl of golden and teal light. Key moment on frame 17.",
        "celebrate": "Celebrating with a happy jump.",
    }[anim]
    if anim == "attack" and c["id"] in ("p5_time_medic_worm", "e2_mummy_moth"):
        summ = "A single HEAL cast with anticipation, release and recovery back to the starting pose. Key moment (the ring of light expands) on frame 13."
    if c["kind"] in ("hero", "skin") and anim == "cast_slam":
        summ += " (Golden sparks at the impact.)"
    key = 13 if anim == "attack" else (18 if anim == "cast_slam" else (17 if anim == "cast_power" else None))
    return summ, key, beats


def loop_note(anim):
    if anim in ("idle", "walk"):
        return ("This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), "
                "so the cycle repeats with no jump or pause.")
    if anim == "defeat":
        return "Not a loop: it starts from the neutral standing pose of frame 1 and ends still."
    return ("Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.")


def anim_prompt(c, anim, orig, x2):
    d = orig[c["orig"]]
    summ, key, beats = anim_info(c, anim, orig)
    face = facing_of(c)
    flying = c["flying"]
    kcol = "#FF00FF"
    ground = "the same height line (hover height)" if flying else "the same standing line"
    roomy = ""
    if x2:
        roomy = (" The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central "
                 "half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.")
    if c["id"] == "squirmy" or c["kind"] in ("hero", "skin"):
        who = "the hero Squirmy"
    else:
        who = c["name"].split(" (")[0]
    lines = []
    lines.append(f"Using the attached reference image ({c['id']}_ref.png) as the exact design of the character, draw an animation sprite sheet of {who} performing the '{anim}' animation.")
    lines.append(f"Character identity, to stay consistent: {c['identity']}")
    lines.append(f"Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.")
    lines.append(
        "Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). "
        f"Each cell holds exactly one full-body copy of the same character, side view facing {face}, with identical size, identical proportions and {ground} in every cell, "
        "centered in its cell with an empty margin so nothing touches the cell edges." + roomy)
    lines.append(
        f"Background: one perfectly flat solid magenta ({kcol}) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. "
        "Do not use magenta or pink anywhere on the character. Square 1:1 image.")
    lines.append(f"Animation: {summ} It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.")
    lines.append(loop_note(anim))
    if c["atk"] and anim == "attack":
        lines.append("Specific to this character: " + c["atk"])
    lines.append("Motion by frames:")
    for a, b, t in beats:
        lines.append(f"- {t}" if (a, b) == (1, 25) else f"- Frames {a}-{b}: {t}")
    return "\n".join(lines)


# ---------------------------------------------------------------------------------------------
# 7. Catalogo de imagenes / sprites estaticos
# ---------------------------------------------------------------------------------------------
SIZE_TXT = {
    "base": "1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja 512 px de ancho)",
    "icon": "1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)",
    "char": "1:1 cuadrada, generar a 1024x1024 px (el pipeline recorta y deja unos 384 px de alto)",
    "bg": "9:16 vertical, 1080x1920 px (si Gemini devuelve otra proporción, recortar a 9:16)",
    "story": "16:9 horizontal, 1920x1080 px",
    "logo": "1:1 cuadrada, generar a 1024x1024 px (se recorta al logo; ancho final ≈ 900 px)",
    "appicon": "1:1 cuadrada, 1024x1024 px (se exporta a 512x512 para Google Play)",
    "feature": "2:1 apaisada; si Gemini no da 2:1, generar 16:9 y recortar a 1024x500 px finales",
    "tex": "1:1 cuadrada, 1024x1024 px, que se pueda repetir en mosaico",
}
ICON_TAIL = ("Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, "
             "cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly "
             "flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. "
             "Do not use magenta or pink anywhere on the icon. Square 1:1 image.")
PROJ_TAIL = ("Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, "
             "cute rounded shapes and friendly saturated colors. One single small object, side view pointing right, centered with a wide empty margin, "
             "drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. "
             "Do not use magenta or pink anywhere on the subject. Square 1:1 image.")
STORY_TAIL = ("Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, "
              "cute rounded shapes and friendly saturated colors. Wide 16:9 landscape image, comic-book panel composition with no text, no logos and no UI.")
SQ = ("Squirmy, a bright-green worm with a lighter yellow-green belly, big brown eyes, small hands and a black baseball cap with a letter A")
WO = ("Wormina, a soft-pink worm with long wavy pink hair, round glasses, braces and a white daisy in her hair")

STATICS = {}

DESC_ES = {
    "bg_era1": "Valle prehistórico soleado con helechos gigantes, volcán lejano y camino de tierra horizontal al 55-62% de la altura; luz de mañana.",
    "base_p1": "Madriguera prehistórica: montículo de tierra con entrada redonda, techo de hojas, valla de huesos, fogata, helechos y bandera azul.",
    "base_e1": "Hormiguero fortaleza marrón con túnel oscuro, pinchos de madera y hueso, marcas tribales y bandera roja; mira a la izquierda.",
    "icon_coin": "Moneda dorada brillante con una carita de gusano sonriente grabada.",
    "icon_food": "Manzana roja jugosa con hoja verde y un pequeño mordisco.",
    "fx_impact": "Estallido de impacto estilo cómic con centro amarillo, anillo naranja y chispas blancas.",
    "proj_stone": "Piedra gris redonda con grietas y una pequeña estela de movimiento.",
    "power_squirm_slam": "Cabeza naranja de gusano estrellándose contra el suelo con onda expansiva, grietas y tierra volando.",
    "power_apple_rain": "Tres manzanas rojas con hojas cayendo en diagonal con líneas de movimiento.",
    "proj_acid": "Gota verde de ácido brillante con dos goteos detrás; apunta a la izquierda.",
    "logo": "Logo con el nombre del juego en letras naranjas redondeadas con borde turquesa, el gusano Squirmy asomando y un cartel dorado con forma de engranaje 'Lost in Time'.",
    "bg_home": "Jardín en hora dorada con flores, madriguera en la esquina inferior izquierda y un portal del tiempo dorado y turquesa en el cielo; centro superior libre para el logo.",
    "paper_texture": "Textura de papel crema cálido con manchas de acuarela y fibras, sin objetos, repetible.",
    "icon_gem": "Gema azul turquesa facetada en forma de diamante redondeado con brillos y dos chispas.",
    "icon_capsule": "Cápsula del tiempo en forma de huevo, mitad dorada y mitad turquesa, con reloj central y engranajes.",
    "icon_chrono_dust": "Montículo brillante de polvo dorado y turquesa con engranajes pequeños y estrellitas.",
    "world_map": "Mapa del tesoro acuarelado sobre papel envejecido con camino punteado que cruza las cinco eras de abajo hacia arriba y una brújula de relojería.",
    "era_1": "Medalla de piedra con una huella de dinosaurio tallada y una hoja de helecho.",
    "power_time_freeze": "Reloj de bolsillo dorado congelado dentro de cristales de hielo con carámbanos y copos.",
    "wormina": "Wormina: gusana rosa con pelo rizado rosa chicle, margarita, gafas redondas y brackets, en pose neutra mirando al frente.",
    "chrono_core": "El Núcleo Crono: esfera de relojería dorada y turquesa del tamaño de una manzana con cinco engarces para gemas y grietas que dejan escapar luz.",
    "story_intro_1": "Picnic romántico de tierra de Squirmy y Wormina en el jardín.",
    "story_intro_2": "Squirmy y Wormina descubren la esfera dorada brillante en la hierba.",
    "story_intro_3": "Destello: Wormina es absorbida por la esfera, que se rompe en cinco fragmentos, y Squirmy extiende la mano.",
    "count_magpie": "Count Magpie: urraca gordita y elegante con sombrero de copa índigo, monóculo dorado y capa corta, con un engranaje dorado en la garra.",
    "app_icon": "Primer plano de Squirmy valiente frente a un engranaje dorado y remolino de luz turquesa que llena todo el fondo.",
    "bg_era2": "Desierto egipcio al mediodía con dunas, tres pirámides, río con papiros y palmeras; camino de arena horizontal.",
    "base_p2": "Madriguera en forma de pirámide de arenisca con puerta en arco, jeroglíficos, gema turquesa y bandera azul.",
    "base_e2": "Templo dorado del escarabajo con columnas, una gran estatua de escarabajo en el techo y banderas rojas.",
    "proj_arrow": "Flecha de madera con punta de piedra y plumas blancas, apuntando a la derecha.",
    "era_2": "Medalla dorada con un escarabajo turquesa en el centro.",
    "power_rewind": "Esfera de reloj dorada con una gran flecha turquesa curva girando en sentido contrario a las agujas.",
    "bg_era3": "Reino medieval verde con colinas, castillo lejano, molinos, estandartes y camino de piedra horizontal.",
    "base_p3": "Torre de castillo acogedora de piedra con almenas, puerta de madera, hiedra, ventana con luz y bandera azul y blanca.",
    "base_e3": "Castillo gris oscuro de torres puntiagudas, puerta de hierro, antorchas y estandartes rojos con escarabajo.",
    "proj_magic_star": "Estrella dorada de cinco puntas brillante con dos chispas, volando a la derecha.",
    "proj_dung_ball": "Bola marrón irregular de estiércol con pajitas y estela de polvo; apunta a la izquierda.",
    "era_3": "Medalla de plata con una torre de castillo y estandarte azul y blanco.",
    "power_dirt_shield": "Escudo redondo de tierra compactada con piedrecitas, un brote verde y borde dorado.",
    "bg_era4": "Ciudad industrial de vapor al anochecer con torres de latón, tuberías, engranajes en el cielo y globos; camino de adoquín de hierro.",
    "base_p4": "Fortaleza de vapor de latón y cobre con dos torres remachadas, chimeneas, engranajes y puerta de horno brillante.",
    "base_e4": "Fortaleza-fábrica de hierro sucia con chimeneas humeantes, engranajes gigantes, luces rojas y bandera roja.",
    "proj_cannonball": "Bola de cañón de hierro con banda de latón y remaches y una nube de vapor.",
    "proj_bomb": "Bomba negra redonda con mecha encendida, chispas y banda de latón.",
    "era_4": "Medalla de cobre con dos engranajes de latón entrelazados y una nube de vapor.",
    "power_fast_forward": "Dos chevrones dorados hacia la derecha delante de un reloj con líneas de velocidad.",
    "bg_era5": "Plataforma futurista flotante en el espacio con planeta con anillos, estrellas, nebulosa violeta, líneas de neón cian y camino de metal brillante.",
    "base_p5": "Base de cúpula de cristal blanca y turquesa con anillo cian, antena, pista de aterrizaje y puerta redonda.",
    "base_e5": "Aguja de cristal negra y gris sobre una roca flotante con grietas rojas y luces de aviso.",
    "proj_laser": "Rayo láser cian corto con forma de cápsula y núcleo blanco, apuntando a la derecha.",
    "proj_laser_red": "Rayo láser rojo corto con forma de cápsula y núcleo blanco, apuntando a la izquierda.",
    "era_5": "Medalla índigo con un planeta con anillos cian y estrellitas.",
    "icon_capsule_open": "La cápsula del tiempo abierta por la mitad con un estallido de luz dorada, engranajes y estrellas.",
    "icon_rarity_common": "Medalla verde hoja sencilla (rareza común).",
    "icon_rarity_rare": "Medalla azul turquesa con borde facetado plateado (rareza rara).",
    "icon_rarity_epic": "Medalla índigo con borde dorado grueso y estrella dorada (rareza épica).",
    "icon_shop_gems_80": "Montoncito de tres gemas turquesa.", "icon_shop_gems_450": "Bolsa de cuero que derrama gemas turquesa.",
    "icon_shop_gems_1000": "Cofre de madera abierto lleno de gemas.", "icon_shop_gems_2200": "Gran cofre dorado con una montaña de gemas.",
    "icon_shop_starter_pack": "Caja de regalo turquesa con lazo dorado, una gorrita con A y una cápsula asomando.",
    "icon_shop_golden_pass": "Boleto dorado con un engranaje en el centro y chispas.",
    "story_era1_open_1": "Squirmy aterriza en el Valle Dino ante hormigas gruñonas.",
    "story_era1_close_1": "Rexy derrotado y aturdido; Squirmy sostiene el primer fragmento y cae un pétalo de margarita.",
    "story_era2_open_1": "Squirmy cubierto de arena ve marchar una legión de escarabajos por las dunas.",
    "story_era2_close_1": "El Faraón Escarabajo entrega el fragmento y una nota de Wormina vuela entre ellos.",
    "story_era3_open_1": "Squirmy con hambre mira el Reino de las Migajas con caballeros escarabajo y molinos.",
    "story_era3_close_1": "Sir Sizzle sorbe la nariz y entrega el fragmento; hay un malvavisco tostado cerca.",
    "story_era4_open_1": "Squirmy saluda con educación a una cucaracha mecánica en Ciudad Vapor.",
    "story_era4_close_1": "La Reina Mecánica apagada; en sus engranes suena una grabación de Wormina; Squirmy emocionado.",
    "story_era5_open_1": "Órbita Neón: Count Magpie sobre un montón de cosas brillantes con un fragmento; Squirmy lo mira desde abajo.",
    "story_era5_close_1": "Count Magpie 3000 estrellado entre sus tesoros; Squirmy toma el último fragmento.",
    "story_end_1": "Squirmy encaja el último fragmento en el Núcleo, que abre un portal.",
    "story_end_2": "Wormina sale del portal con los brazos abiertos y Squirmy corre hacia ella.",
    "story_end_3": "Squirmy y Wormina abrazados en el jardín al atardecer con el Núcleo reparado y una pluma cayendo.",
    "story_end_4": "El Núcleo en la hierba con un sexto engarce que brilla; los dos lo miran sorprendidos.",
    "story_03_portal": "Squirmy de espaldas ante un enorme portal del tiempo con vistazos de las cinco eras (opcional).",
    "feature_graphic": "Banner con Squirmy liderando gusanos soldado de distintas eras hacia un portal del tiempo; tercio izquierdo libre para el título.",
}
RELIC_ES = {"sticky_seed": "Semilla pegajosa con brote cubierta de almíbar dorado.", "lucky_clover": "Trébol de cuatro hojas con una moneda dorada.",
            "tough_pebble": "Guijarro gris redondo con carita decidida.", "sharp_thorn": "Espina curva y brillante.",
            "quick_sprout": "Brote joven saliendo de la tierra con líneas de velocidad.", "cozy_mushroom": "Seta roja con puntos crema y brillo cálido.",
            "golden_dewdrop": "Gota de rocío dorada colgando de una hoja.", "echo_seashell": "Concha en espiral con ondas de sonido.",
            "mini_hourglass": "Reloj de arena dorado con arena turquesa brillante.", "wormina_daisy": "Margarita blanca con centro amarillo y hoja.",
            "chrono_gear": "Engranaje dorado pulido con centro turquesa brillante.", "time_crown": "Corona dorada cuyas puntas son engranajes, con gema turquesa."}


def S(key, phase, title, file, kind, size, used, ref, body, orig=None, key_color="#FF00FF", extra=False):
    STATICS[key] = dict(key=key, phase=phase, title=title, file=file, kind=kind, size=size, used=used, ref=ref,
                        body=body, orig=orig, key_color=key_color, extra=extra)


def ob(oid, orig):
    return orig[oid]["body"]


def build_statics(orig):
    S("bg_era1", "A", "Fondo de batalla, Era 1 (Edad de Piedra)", "bg_era1.png", "image", "bg",
      "Fondo de la pantalla de batalla (`BattleBackground`, src/battle/battle_background.gd) en las etapas de la Era 1 y el jefe Rexy; sustituye las capas de color. El carril de combate cae a ~58% de la altura (lane_y 557 de 960).",
      "ninguna", ob("H01", orig), "H01")
    S("base_p1", "A", "Base del jugador, Era 1 (madriguera)", "base_p1.png", "sprite", "base",
      "Base del jugador al extremo izquierdo del carril de batalla (`BaseView`, barra de vida encima) y madriguera de la pantalla Home (home_screen.gd, hoy un rectángulo 210x170).",
      "ninguna", ob("E01", orig), "E01")
    S("base_e1", "A", "Base enemiga, Era 1 (hormiguero)", "base_e1.png", "sprite", "base",
      "Base enemiga al extremo derecho del carril de batalla (`BaseView`), mirando a la izquierda.",
      "ninguna", ob("E06", orig), "E06")
    S("icon_coin", "A", "Icono de moneda", "icon_coin.png", "sprite", "icon",
      "Chip de monedas de la barra superior (todas las pantallas), recompensa de la pantalla de Victoria y precios de Upgrades.",
      "ninguna", ob("G01", orig), "G01")
    S("icon_food", "A", "Icono de comida (manzana)", "icon_food.png", "sprite", "icon",
      "HUD de batalla: contador de comida y coste de cada tarjeta de unidad.",
      "ninguna", ob("G02", orig), "G02")
    S("fx_impact", "A", "Efecto de impacto", "fx_impact.png", "sprite", "icon",
      "Efecto que aparece donde un golpe o proyectil impacta (src/battle/battle_effects.gd).",
      "ninguna", ob("F06", orig), "F06")
    S("proj_stone", "A", "Proyectil: piedra", "proj_stone.png", "sprite", "icon",
      "Proyectil del Slinger Worm (Era 1) en el carril de batalla.",
      "ninguna", ob("F01", orig), "F01")
    S("power_squirm_slam", "A", "Icono de poder: Squirm Slam", "power_squirm_slam.png", "sprite", "icon",
      "Botón de poder del HUD de batalla y selector de poderes en Pre-batalla/Upgrades (poder inicial, ya desbloqueado).",
      "ninguna", ob("G06", orig), "G06")
    S("power_apple_rain", "A", "Icono de poder: Apple Rain", "power_apple_rain.png", "sprite", "icon",
      "Botón de poder del HUD de batalla y selector de Pre-batalla/Upgrades (poder inicial, ya desbloqueado).",
      "ninguna", ob("G07", orig), "G07")
    S("proj_acid", "A", "Proyectil: gota de ácido", "proj_acid.png", "sprite", "icon",
      "Proyectil del Ant Spitter (Era 1). NUEVO: el original no lo traía; se añade porque el ataque del Ant Spitter lanza una gota que no se dibuja en su hoja.",
      "ninguna", "A single glowing green acid glob shaped like a rounded teardrop with a shiny white highlight and two tiny drips trailing behind it, pointing left. " + PROJ_TAIL.replace("pointing right", "pointing left"),
      None, extra=True)

    # ---- B
    S("logo", "B", "Logo del juego", "logo.png", "sprite", "logo",
      "Pantalla de título (title_screen.gd, hoy un rectángulo 'LOGO' de 150 px de alto) y Créditos (credits_screen.gd).",
      "`squirmy_ref.png` (para que el gusano sea idéntico al héroe)",
      ob("H08", orig).replace('with the words "Worm Warriors" spelled exactly,',
                              'with the words "Love \'n Wormholes" spelled exactly, on two lines ("Love \'n" smaller above and "Wormholes" larger below),'),
      "H08")
    S("bg_home", "B", "Fondo de título y Home", "bg_home.png", "image", "bg",
      "Fondo de la pantalla de título (title_screen.gd) y de Home (home_screen.gd), detrás del botón Play, Squirmy y la madriguera.",
      "ninguna", ob("H06", orig), "H06")
    S("paper_texture", "B", "Textura de papel para paneles", "paper_texture.png", "image", "tex",
      "Fondo repetido de los paneles y diálogos de menú (src/ui/ui.gd, cajas de Home, Squad, Upgrades, Shop, Capsules, Ajustes).",
      "ninguna", ob("H15", orig), "H15")
    S("icon_gem", "B", "Icono de gema", "icon_gem.png", "sprite", "icon",
      "Chip de gemas de la barra superior (todas las pantallas), precios de cápsulas y Tienda, recompensa diaria.",
      "ninguna", ob("G03", orig), "G03")
    S("icon_capsule", "B", "Icono de cápsula del tiempo", "icon_capsule.png", "sprite", "icon",
      "Chip de cápsulas de la barra superior, botón Capsules de Home y arte principal de la pantalla de cápsulas (capsule_screen.gd, hoy un placeholder 120x120).",
      "ninguna", ob("G05", orig), "G05")
    S("icon_chrono_dust", "B", "Icono de Chrono Dust", "icon_chrono_dust.png", "sprite", "icon",
      "Chip de polvo en la pantalla de cápsulas y reliquias (compra de reliquias con Dust, duplicados).",
      "ninguna", ob("G04", orig), "G04")
    S("world_map", "B", "Mapa del mundo (selección de etapa)", "world_map.png", "image", "bg",
      "Pantalla de selección de etapa/mapa (level_select_screen.gd): fondo del mapa con los nodos de etapa y el botón del jefe encima.",
      "ninguna", ob("H07", orig), "H07")
    S("era_1", "B", "Insignia de era: Edad de Piedra", "era_1.png", "sprite", "icon",
      "Cabecera del mapa y de Home ('Era 1 · Dino Valley'), selector de era en Squad/Upgrades.",
      "ninguna", ob("G12", orig), "G12")
    S("power_time_freeze", "B", "Icono de poder: Time Freeze", "power_time_freeze.png", "sprite", "icon",
      "Botón de poder del HUD y selector de poderes; se desbloquea tras el jefe de la Era 1, así que se necesita justo al terminar la Fase A.",
      "ninguna", ob("G08", orig), "G08")
    S("wormina", "B", "Wormina", "wormina.png", "sprite", "char",
      "Sprite estático de Wormina en la historia y eco de Wormina en el mapa (etapas que 'ocultan un eco'); también sirve de referencia para los paneles de historia.",
      "hoja oficial de personaje de Wormina de Alfredo (adjuntar si la tienes). Este sprite ES la referencia de Wormina: no hay `_ref.png` aparte.",
      ob("A03", orig), "A03", key_color="#0000FF")
    S("chrono_core", "B", "El Núcleo Crono", "chrono_core.png", "sprite", "char",
      "Sprite estático del Núcleo en Home (indicador de fragmentos 'Shards 0 / 5'), historia y créditos.",
      "ninguna (este sprite es su propia referencia)", ob("A05", orig), "A05")
    S("story_intro_1", "B", "Historia, intro 1: picnic en el jardín", "story_intro_1.png", "image", "story",
      "Panel 1 de la secuencia 'intro' (story_screen.gd): 'Squirmy y Wormina tenían el picnic más romántico del mundo'. Aparece en la primera partida.",
      "`squirmy_ref.png` y `wormina.png`",
      f"A romantic dirt picnic in a sunny garden: {SQ}, and {WO}, sitting close together on a tiny checkered cloth spread on the soil, sharing two small leaf plates with crumbs, a dewdrop in a tiny acorn cup and a ladybug watching from a flower stem, warm golden light. {STORY_TAIL}",
      None, extra=True)
    S("story_intro_2", "B", "Historia, intro 2: la esfera dorada", "story_intro_2.png", "image", "story",
      "Panel 2 de la secuencia 'intro': 'Entonces encontraron una esfera dorada que brillaba'. (Original H09 'el descubrimiento'.)",
      "`squirmy_ref.png`, `wormina.png` y `chrono_core.png`", ob("H09", orig), "H09")
    S("story_intro_3", "B", "Historia, intro 3: flash y portal", "story_intro_3.png", "image", "story",
      "Panel 3 de la secuencia 'intro': 'FLASH! Wormina desapareció y la esfera se rompió en cinco fragmentos'. (Original H10 'Wormina desaparece'.)",
      "`squirmy_ref.png` y `wormina.png`",
      ob("H10", orig).replace("while Squirmy,", "with five golden shards of the orb flying outward, while Squirmy,"), "H10")
    S("count_magpie", "B", "Count Magpie (villano de la historia)", "count_magpie.png", "sprite", "char",
      "Sprite estático del villano en los paneles/escenas de historia y créditos (la Era 5 usa a Count Magpie 3000 en su lugar).",
      "ninguna (este sprite es su propia referencia)", ob("A04", orig), "A04")
    S("app_icon", "B", "Icono de la app", "app_icon.png", "image", "appicon",
      "Icono del lanzador de Android (project.godot / export_presets.cfg) y ficha de Google Play.",
      "`squirmy_ref.png`", ob("H13", orig), "H13")

    # ---- C (Era 2)
    S("bg_era2", "C", "Fondo de batalla, Era 2 (Egipto)", "bg_era2.png", "image", "bg",
      "Fondo de la batalla en las etapas de la Era 2 y el jefe Pharaoh Scarab.", "ninguna", ob("H02", orig), "H02")
    S("base_p2", "C", "Base del jugador, Era 2", "base_p2.png", "sprite", "base",
      "Base del jugador (izquierda del carril) en la Era 2.", "ninguna", ob("E02", orig), "E02")
    S("base_e2", "C", "Base enemiga, Era 2", "base_e2.png", "sprite", "base",
      "Base enemiga (derecha del carril, mirando a la izquierda) en la Era 2.", "ninguna", ob("E07", orig), "E07")
    S("proj_arrow", "C", "Proyectil: flecha", "proj_arrow.png", "sprite", "icon",
      "Proyectil del Bow Worm y el Locust Archer (Era 2); también de la Crossbow Worm (Era 3) a falta de saeta propia.", "ninguna", ob("F02", orig), "F02")
    S("era_2", "C", "Insignia de era: Antiguo Egipto", "era_2.png", "sprite", "icon",
      "Cabecera del mapa y Home en la Era 2, selector de era.", "ninguna", ob("G13", orig), "G13")
    S("power_rewind", "C", "Icono de poder: Rewind", "power_rewind.png", "sprite", "icon",
      "Botón de poder del HUD y selector de poderes; se desbloquea tras el jefe de la Era 2.", "ninguna", ob("G09", orig), "G09")

    # ---- E (Era 3)
    S("bg_era3", "E", "Fondo de batalla, Era 3 (Medieval)", "bg_era3.png", "image", "bg",
      "Fondo de la batalla en las etapas de la Era 3 y el jefe Sir Sizzle.", "ninguna", ob("H03", orig), "H03")
    S("base_p3", "E", "Base del jugador, Era 3", "base_p3.png", "sprite", "base",
      "Base del jugador (izquierda del carril) en la Era 3.", "ninguna", ob("E03", orig), "E03")
    S("base_e3", "E", "Base enemiga, Era 3", "base_e3.png", "sprite", "base",
      "Base enemiga (derecha del carril, mirando a la izquierda) en la Era 3.", "ninguna", ob("E08", orig), "E08")
    S("proj_magic_star", "E", "Proyectil: estrella mágica", "proj_magic_star.png", "sprite", "icon",
      "Proyectil de la Wizard Worm (Era 3).", "ninguna", ob("F05", orig), "F05")
    S("proj_dung_ball", "E", "Proyectil: bola de estiércol", "proj_dung_ball.png", "sprite", "icon",
      "Proyectil de la Dung Catapult (Era 3). NUEVO: el original no lo traía.", "ninguna",
      "A single round lumpy brown dung ball with a few small straw bits stuck to it, a faint dusty motion swoosh behind it, pointing left. " + PROJ_TAIL.replace("pointing right", "pointing left"),
      None, extra=True)
    S("era_3", "E", "Insignia de era: Medieval", "era_3.png", "sprite", "icon",
      "Cabecera del mapa y Home en la Era 3, selector de era.", "ninguna", ob("G14", orig), "G14")
    S("power_dirt_shield", "E", "Icono de poder: Dirt Shield", "power_dirt_shield.png", "sprite", "icon",
      "Botón de poder del HUD y selector de poderes; se desbloquea tras el jefe de la Era 3.", "ninguna", ob("G10", orig), "G10")

    # ---- F (Era 4)
    S("bg_era4", "F", "Fondo de batalla, Era 4 (Industrial)", "bg_era4.png", "image", "bg",
      "Fondo de la batalla en las etapas de la Era 4 y la jefa Clockwork Queen.", "ninguna", ob("H04", orig), "H04")
    S("base_p4", "F", "Base del jugador, Era 4", "base_p4.png", "sprite", "base",
      "Base del jugador (izquierda del carril) en la Era 4.", "ninguna", ob("E04", orig), "E04")
    S("base_e4", "F", "Base enemiga, Era 4", "base_e4.png", "sprite", "base",
      "Base enemiga (derecha del carril, mirando a la izquierda) en la Era 4.", "ninguna", ob("E09", orig), "E09")
    S("proj_cannonball", "F", "Proyectil: bola de cañón de vapor", "proj_cannonball.png", "sprite", "icon",
      "Proyectil de la Boiler Tank Worm (Era 4) y, reducido, de la Gear Gunner Worm.", "ninguna", ob("F03", orig), "F03")
    S("proj_bomb", "F", "Proyectil: bomba", "proj_bomb.png", "sprite", "icon",
      "Bomba que suelta la Balloon Bomber Worm (Era 4). NUEVO: el original no lo traía.", "ninguna",
      "A single round black bomb with a short lit fuse throwing tiny orange sparks, a small white highlight and a thin brass band. " + PROJ_TAIL.replace("side view pointing right", "front view"),
      None, extra=True)
    S("era_4", "F", "Insignia de era: Industrial", "era_4.png", "sprite", "icon",
      "Cabecera del mapa y Home en la Era 4, selector de era.", "ninguna", ob("G15", orig), "G15")
    S("power_fast_forward", "F", "Icono de poder: Fast-Forward", "power_fast_forward.png", "sprite", "icon",
      "Botón de poder del HUD y selector de poderes; se desbloquea tras el jefe de la Era 4.", "ninguna", ob("G11", orig), "G11")

    # ---- G (Era 5)
    S("bg_era5", "G", "Fondo de batalla, Era 5 (Futuro lejano)", "bg_era5.png", "image", "bg",
      "Fondo de la batalla en las etapas de la Era 5 y el jefe final Count Magpie 3000.", "ninguna", ob("H05", orig), "H05")
    S("base_p5", "G", "Base del jugador, Era 5", "base_p5.png", "sprite", "base",
      "Base del jugador (izquierda del carril) en la Era 5.", "ninguna", ob("E05", orig), "E05")
    S("base_e5", "G", "Base enemiga, Era 5", "base_e5.png", "sprite", "base",
      "Base enemiga (derecha del carril, mirando a la izquierda) en la Era 5.", "ninguna", ob("E10", orig), "E10")
    S("proj_laser", "G", "Proyectil: rayo láser", "proj_laser.png", "sprite", "icon",
      "Proyectil de la Mecha Worm (Era 5).", "ninguna", ob("F04", orig), "F04")
    S("proj_laser_red", "G", "Proyectil: rayo láser rojo", "proj_laser_red.png", "sprite", "icon",
      "Proyectil del Laser Bug y del Mecha Beetle (Era 5, enemigos). NUEVO: el original solo trae el láser cian.", "ninguna",
      "A single short glowing red laser bolt shaped like a rounded capsule with a bright white-hot core and a soft red glow, pointing left. " + PROJ_TAIL.replace("pointing right", "pointing left"),
      None, extra=True)
    S("era_5", "G", "Insignia de era: Futuro lejano", "era_5.png", "sprite", "icon",
      "Cabecera del mapa y Home en la Era 5, selector de era.", "ninguna", ob("G16", orig), "G16")

    # ---- D (tienda, capsulas, reliquias)
    S("icon_capsule_open", "D", "Cápsula abierta (resultado de apertura)", "icon_capsule_open.png", "sprite", "icon",
      "Animación/pantalla de apertura de cápsula (capsule_screen.gd) tras tocar 'Open'. NUEVO: el original no lo traía.", "ninguna",
      "The glossy egg-shaped time capsule with a golden half and a teal half, cracked open along its seam with a burst of warm golden light, tiny gears, small stars and sparkles flying out of it. " + ICON_TAIL,
      None, extra=True)
    rar = {
        "common": "a round leaf-green medallion with a plain smooth rim and a single small white sparkle",
        "rare": "a round turquoise-blue medallion with a faceted silver rim and two bright white sparkles",
        "epic": "a round deep-indigo medallion with a thick gold rim, a bright golden star in the center and several glowing sparkles",
    }
    for r, d in rar.items():
        S("icon_rarity_" + r, "D", "Insignia de rareza: " + {"common": "común", "rare": "rara", "epic": "épica"}[r], "icon_rarity_%s.png" % r, "sprite", "icon",
          "Insignia de rareza en la lista de reliquias (relics_screen.gd, hoy un cuadro de color 64x64) y en las filas de resultado de cápsula (capsule_screen.gd, 72x56). NUEVO: el original no lo traía.",
          "ninguna", f"A rarity badge for a game collection: {d}, no letters and no symbols other than described. " + ICON_TAIL, None, extra=True)
    relics = [
        ("sticky_seed", "Sticky Seed (común, comida)", "a plump brown seed with a tiny green sprout on top, coated in a drip of golden sticky syrup"),
        ("lucky_clover", "Lucky Clover (común, monedas)", "a bright green four-leaf clover with a tiny golden coin glinting in the middle"),
        ("tough_pebble", "Tough Pebble (común, vida de base)", "a smooth round gray pebble with a darker stripe and a tiny determined face of two dots and a small line"),
        ("sharp_thorn", "Sharp Thorn (común, daño)", "a single curved rose thorn, pointy and glossy dark green with a bright white highlight"),
        ("quick_sprout", "Quick Sprout (común, reducción de espera)", "a young green sprout with two leaves bursting out of the soil with small speed lines"),
        ("cozy_mushroom", "Cozy Mushroom (común, vida de unidades)", "a red mushroom cap with cream dots on a short cream stalk, with a warm cozy glow"),
        ("golden_dewdrop", "Golden Dewdrop (rara, monedas)", "a perfect golden dewdrop hanging from a small green leaf tip with a bright white highlight"),
        ("echo_seashell", "Echo Seashell (rara, comida)", "a spiral cream-and-turquoise seashell with three soft curved sound waves coming from its opening"),
        ("mini_hourglass", "Mini Hourglass (rara, espera de poderes)", "a tiny hourglass with a golden frame and glowing teal sand, a few sparkles around it"),
        ("wormina_daisy", "Wormina's Daisy (rara, vida de unidades)", "a white daisy with a yellow center and a tiny green stem with one leaf, a soft warm glow around it"),
        ("chrono_gear", "Chrono Gear (épica, comida)", "a polished golden clockwork gear with a glowing teal center and tiny sparks of light"),
        ("time_crown", "Time Crown (épica, daño)", "a small golden crown whose points are tiny gears, with a glowing teal gem in the front and sparkles"),
    ]
    for rid, title, desc in relics:
        S("icon_relic_" + rid, "D", "Reliquia: " + title, "icon_relic_%s.png" % rid, "sprite", "icon",
          "Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `%s` en data/relics.json. NUEVO: el original no traía iconos de reliquia." % rid,
          "ninguna", f"A collectible relic icon: {desc}. " + ICON_TAIL, None, extra=True)
    shop = [
        ("gems_80", "Pack de 80 gemas", "a tiny pile of three faceted teal-blue gems with white highlights and one sparkle"),
        ("gems_450", "Pack de 450 gemas", "a small brown leather pouch tied with a string, spilling several faceted teal-blue gems with white highlights"),
        ("gems_1000", "Pack de 1000 gemas", "a wooden treasure chest, open and overflowing with faceted teal-blue gems and sparkles"),
        ("gems_2200", "Pack de 2200 gemas", "a big golden treasure chest with a mountain of faceted teal-blue gems pouring out and many sparkles"),
        ("starter_pack", "Pack inicial", "a small teal gift box tied with a golden ribbon, with a tiny black baseball cap with a letter A and a golden time capsule peeking out of the top"),
        ("golden_pass", "Golden Pass", "a shiny golden ticket with a clock-gear emblem in the center, a scalloped edge and sparkles"),
    ]
    for pid, title, desc in shop:
        S("icon_shop_" + pid, "D", "Tienda: " + title, "icon_shop_%s.png" % pid, "sprite", "icon",
          "Tarjeta del producto `%s` en la Tienda (shop_screen.gd, data/shop.json). NUEVO: el original no lo traía." % pid,
          "ninguna", f"A shop product icon: {desc}. " + ICON_TAIL, None, extra=True)

    # ---- H (historia y Play)
    panels = [
        ("story_era1_open_1", "Era 1 apertura: Valle Dino", "era1.open.1", "Dino Valley: Squirmy lands",
         "`squirmy_ref.png`",
         f"Dino Valley: {SQ}, has just tumbled out of a small swirling portal onto the grass of a prehistoric valley with giant ferns, a smoking volcano in the distance and a few grumpy black ants with red head bands peeking out from behind a rock. Warm morning light."),
        ("story_era1_close_1", "Era 1 cierre: Rexy cae", "era1.close.1", "Rexy down, shard + daisy petal",
         "`squirmy_ref.png` y `b1_rexy_ref.png`",
         f"Rexy, a big chubby green T-Rex with a red bandana and tiny arms, sits dazed on the ground with little stars around his head, while {SQ}, holds up a glowing golden shard of a clockwork orb in wonder, and a single white daisy petal floats down through the air between them."),
        ("story_era2_open_1", "Era 2 apertura: Arenas Escarabajo", "era2.open.1", "Scarab Sands",
         "`squirmy_ref.png`",
         f"Scarab Sands: {SQ}, stands on a golden dune with a small pile of sand on his cap and sand in his eyes, squinting under a hot noon sun, while a legion of golden scarab beetle soldiers marches over the dunes toward him and three pyramids shine in the distance."),
        ("story_era2_close_1", "Era 2 cierre: Faraón y nota", "era2.close.1", "Pharaoh Scarab + Wormina's note",
         "`squirmy_ref.png` y `b2_pharaoh_scarab_ref.png`",
         f"The Pharaoh Scarab, a giant golden scarab with a striped pharaoh headdress, gently hands a glowing golden shard to {SQ}, while a small rolled papyrus note with a tiny doodle of a daisy flutters between them (no readable text); a sphinx statue sits in the background."),
        ("story_era3_open_1", "Era 3 apertura: Reino de las Migajas", "era3.open.1", "Kingdom of Crumbs",
         "`squirmy_ref.png`",
         f"The Kingdom of Crumbs: {SQ}, looks hungrily and determinedly up at a medieval village where the towers and walls look like giant loaves of bread and cheese crumbs, with beetle knights on patrol, colorful banners and two windmills, soft afternoon light."),
        ("story_era3_close_1", "Era 3 cierre: Sir Sizzle llora", "era3.close.1", "Sir Sizzle sniffles, shard",
         "`squirmy_ref.png` y `b3_sir_sizzle_ref.png`",
         f"Sir Sizzle, a chubby red-orange dragon in a dented tin helmet, sniffles with a big tear and a runny nose while holding out a glowing golden shard in one claw; a stick with a toasted marshmallow lies on the ground by a tiny campfire, and {SQ}, looks up at him kindly."),
        ("story_era4_open_1", "Era 4 apertura: Ciudad Vapor", "era4.open.1", "Steam City",
         "`squirmy_ref.png`",
         f"Steam City: {SQ}, politely tips his cap toward a scowling clockwork cockroach with a wrench, between tall brass towers, screaming pipes, big gears and clouds of white steam, dusk light with warm orange windows."),
        ("story_era4_close_1", "Era 4 cierre: la Reina Mecánica se apaga", "era4.close.1", "Clockwork Queen + Wormina's voice",
         "`squirmy_ref.png` y `b4_clockwork_queen_ref.png`",
         f"The Clockwork Queen, a large brass mechanical spider with a small golden crown, sits powered down with her glass dome open; inside the gears a tiny glowing recorder plays sound waves shaped like little hearts and a daisy, and {SQ}, holds his cap in his hands with watery eyes while a little steam drifts by."),
        ("story_era5_open_1", "Era 5 apertura: Órbita Neón + Count Magpie", "era5.open.1", "Neon Orbit + Count Magpie",
         "`squirmy_ref.png` y `count_magpie.png`",
         f"Neon Orbit: on a floating futuristic platform with a huge ringed planet and stars behind, Count Magpie, a plump dapper black-and-white magpie with an indigo top hat, a gold monocle and a short dark-blue cape, perches smugly on a heap of shiny gadgets holding a golden shard, while {SQ}, looks up at him."),
        ("story_era5_close_1", "Era 5 cierre: cae Count Magpie 3000", "era5.close.1", "Count Magpie 3000 falls",
         "`squirmy_ref.png` y `b5_count_magpie_3000_ref.png`",
         f"Count Magpie 3000, a giant chrome-and-indigo mechanical magpie, has crashed into a big pile of his own shiny trinkets, sparks flying and one tiny tear on his cheek, while {SQ}, grabs the last glowing golden shard from the heap."),
        ("story_end_1", "Final 1: el Núcleo se reensambla", "end.1", "Core reassembled",
         "`squirmy_ref.png` y `chrono_core.png`",
         f"{SQ}, clicks the last of five glowing golden shards into the five round gem sockets of the apple-sized golden-and-teal clockwork orb, the orb humming with bright light and a swirling golden-and-teal portal beginning to open above it."),
        ("story_end_2", "Final 2: Wormina vuelve", "end.2", "Wormina returns",
         "`squirmy_ref.png` y `wormina.png`",
         f"{WO}, steps out of a swirling golden-and-teal portal with her arms open and a huge happy smile, while {SQ}, runs toward her with sand falling out of his cap, golden light all around."),
        ("story_end_4", "Final 4: un sexto engarce brilla", "end.4", "A sixth socket glows",
         "`squirmy_ref.png`, `wormina.png` y `chrono_core.png`",
         f"The golden-and-teal clockwork orb rests in the garden grass at dusk, a sixth gem socket now glowing in a new mysterious color, while {SQ}, and {WO}, lean in with surprised wide eyes."),
    ]
    for art, title, tkey, cap, ref, desc in panels:
        S(art, "H", "Historia: " + title, art + ".png", "image", "story",
          "Panel de historia `%s` (story_screen.gd, secuencia de data/story.json, texto `story.%s`: «%s»). NUEVO: el original solo traía 4 paneles con otros nombres." % (art, tkey, cap),
          ref, desc + " " + STORY_TAIL, None, extra=True)
    S("story_end_3", "H", "Historia: Final 3, de vuelta en el jardín", "story_end_3.png", "image", "story",
      "Panel final `story_end_3` (story_screen.gd, texto `story.end.3`: 'De vuelta en el jardín...'). (Original H12 'el reencuentro'.)",
      "`squirmy_ref.png` y `wormina.png`", ob("H12", orig), "H12")
    S("story_03_portal", "H", "Portal con vistazos de las eras (opcional)", "story_03_portal.png", "image", "story",
      "OPCIONAL: el original H11 no coincide con ningún panel del juego; sirve como pantalla de carga o imagen de marketing.",
      "`squirmy_ref.png`", ob("H11", orig), "H11")
    S("feature_graphic", "H", "Gráfico de funciones de Google Play", "feature_graphic.png", "image", "feature",
      "Ficha de Google Play (banner superior). Se añade el título encima con el editor de la tienda, no se dibuja.",
      "`squirmy_ref.png`", ob("H14", orig), "H14")


# ---------------------------------------------------------------------------------------------
# 8. Fases y orden
# ---------------------------------------------------------------------------------------------
PHASES = [
    ("A", "fase-a-era1.md", "Era 1 jugable",
     "Primer combate completo de la Era 1 (Squirmy, unidades y enemigos de la Era 1, Rexy, bases, proyectiles, iconos esenciales y fondo). Sin esto no hay nada que probar con arte real."),
    ("B", "fase-b-menus.md", "Menús y Home",
     "Lo que ve el jugador al abrir el juego: logo, Home, mapa, textura de papel, iconos de la barra superior, Wormina, Núcleo Crono, intro de historia y Count Magpie. Se mueve aquí la intro de 3 paneles (se muestra en la primera partida) y el icono de la app."),
    ("C", "fase-c-era2.md", "Era 2 (Egipto)", "Todo lo de la Era 2: 3 unidades, 3 enemigos, Pharaoh Scarab, bases, flecha, insignia, icono de Rewind y fondo."),
    ("D", "fase-d-tienda.md", "Tienda, cápsulas y reliquias",
     "Arte de cápsulas y reliquias (12 iconos, 3 insignias de rareza, cápsula abierta), tarjetas de la Tienda y las 3 skins del héroe (cada skin = referencia + 5 animaciones). Va antes que las eras avanzadas porque la economía y la tienda se juegan desde la Era 1."),
    ("E", "fase-e-era3.md", "Era 3 (Medieval)", "Todo lo de la Era 3, incluyendo Sir Sizzle, proyectiles de estrella mágica y bola de estiércol y el icono de Dirt Shield."),
    ("F", "fase-f-era4.md", "Era 4 (Industrial)", "Todo lo de la Era 4, incluyendo la Clockwork Queen, bola de cañón y bomba, e icono de Fast-Forward."),
    ("G", "fase-g-era5.md", "Era 5 (Futuro lejano)", "Todo lo de la Era 5, incluyendo a Count Magpie 3000 (jefe final) y los láseres."),
    ("H", "fase-h-historia-tienda-play.md", "Historia y tienda de Play",
     "14 paneles de historia (aperturas y cierres de era y final), gráfico de funciones y el portal opcional. Las capturas de pantalla de Play NO son prompts: se sacan del juego con tools/screenshots.gd cuando el arte real esté integrado."),
]

ORDER = {
    "A": ["c:squirmy", "c:p1_club_worm", "c:e1_ant_clubber", "s:bg_era1", "s:base_p1", "s:base_e1", "s:icon_coin", "s:icon_food",
          "s:fx_impact", "s:proj_stone", "s:power_squirm_slam", "s:power_apple_rain", "c:p1_slinger_worm", "c:e1_ant_spitter",
          "s:proj_acid", "c:p1_dino_rider_worm", "c:e1_stone_beetle", "c:b1_rexy"],
    "B": ["s:logo", "s:bg_home", "s:paper_texture", "s:icon_gem", "s:icon_capsule", "s:icon_chrono_dust", "s:world_map", "s:era_1",
          "s:power_time_freeze", "s:wormina", "s:chrono_core", "s:story_intro_1", "s:story_intro_2", "s:story_intro_3",
          "s:count_magpie", "s:app_icon"],
    "C": ["s:bg_era2", "s:base_p2", "s:base_e2", "c:p2_shield_bearer_worm", "c:e2_scarab_soldier", "c:p2_bow_worm", "s:proj_arrow",
          "c:e2_locust_archer", "c:p2_cobra_charmer_worm", "c:e2_mummy_moth", "c:b2_pharaoh_scarab", "s:era_2", "s:power_rewind"],
    "D": ["s:icon_capsule_open", "s:icon_rarity_common", "s:icon_rarity_rare", "s:icon_rarity_epic"]
         + ["s:icon_relic_" + r for r in ("sticky_seed", "lucky_clover", "tough_pebble", "sharp_thorn", "quick_sprout", "cozy_mushroom",
                                          "golden_dewdrop", "echo_seashell", "mini_hourglass", "wormina_daisy", "chrono_gear", "time_crown")]
         + ["s:icon_shop_" + r for r in ("gems_80", "gems_450", "gems_1000", "gems_2200", "starter_pack", "golden_pass")]
         + ["c:squirmy_skin_pirate", "c:squirmy_skin_knight", "c:squirmy_skin_astronaut"],
    "E": ["s:bg_era3", "s:base_p3", "s:base_e3", "c:p3_knight_worm", "c:e3_beetle_knight", "c:p3_crossbow_worm", "c:e3_dung_catapult",
          "s:proj_dung_ball", "c:p3_wizard_worm", "s:proj_magic_star", "c:e3_hornet_scout", "c:b3_sir_sizzle", "s:era_3", "s:power_dirt_shield"],
    "F": ["s:bg_era4", "s:base_p4", "s:base_e4", "c:p4_gear_gunner_worm", "c:e4_cog_roach", "c:p4_boiler_tank_worm", "s:proj_cannonball",
          "c:e4_clank_crab", "c:p4_balloon_bomber_worm", "s:proj_bomb", "c:e4_spark_fly", "c:b4_clockwork_queen", "s:era_4", "s:power_fast_forward"],
    "G": ["s:bg_era5", "s:base_p5", "s:base_e5", "c:p5_laser_blade_worm", "c:e5_laser_bug", "s:proj_laser", "s:proj_laser_red",
          "c:p5_mecha_worm", "c:e5_mecha_beetle", "c:p5_time_medic_worm", "c:e5_drone_fly", "c:b5_count_magpie_3000", "s:era_5"],
    "H": ["s:story_era1_open_1", "s:story_era1_close_1", "s:story_era2_open_1", "s:story_era2_close_1", "s:story_era3_open_1",
          "s:story_era3_close_1", "s:story_era4_open_1", "s:story_era4_close_1", "s:story_era5_open_1", "s:story_era5_close_1",
          "s:story_end_1", "s:story_end_2", "s:story_end_3", "s:story_end_4", "s:feature_graphic", "s:story_03_portal"],
}


# ---------------------------------------------------------------------------------------------
# 9. Render de secciones Markdown
# ---------------------------------------------------------------------------------------------
def block(text):
    return "```text\n" + text + "\n```"


def sheet_name(cid, anim, x2):
    return "%s_%s%s_sheet.png" % (cid, anim, "_x2" if x2 else "")


def render_ref(pid, c, orig):
    key = "ninguna"
    if c["kind"] in ("hero", "skin"):
        key = "hoja oficial de personaje de Squirmy hecha por Alfredo (adjuntarla si la tienes; la gorra con la A y los colores deben salir idénticos)"
    face = "derecha" if facing_of(c) == "right" else "izquierda"
    used = {
        "hero": "Solo como referencia para sus 5 animaciones, paneles de historia, logo, icono de app y banner. No entra al juego.",
        "skin": "Solo como referencia para las 5 animaciones de la skin; puede servir de imagen del producto en la Tienda (shop_screen.gd). No entra al juego como sprite.",
    }.get(c["kind"], "Solo como referencia de diseño para las 5 animaciones de este personaje (se adjunta en cada una). No entra al juego.")
    lines = [
        f"### {pid} · {c['name']}: referencia de personaje",
        "- **Tipo:** Referencia de personaje (sprite individual, pose estática única)",
        f"- **Aplica a:** `{c['id']}`, {c['name']}. {c['role']}.",
        f"- **Referencia a adjuntar:** {key}",
        f"- **Archivo de salida:** `{c['id']}_ref.png`",
        "- **Tamaño:** 1:1 cuadrada, 1024x1024 px",
        f"- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la {face}; cuerpo completo y objetos visibles; margen vacío alrededor",
        f"- **Dónde se usa:** {used}",
        f"- **Origen:** {c['orig']} (descripción de diseño)",
        "",
        block(ref_prompt(c, orig)),
    ]
    return "\n".join(lines)


def render_anim(pid, c, anim, orig, idx):
    over, why = overflow(c, anim)
    cell, sheet, cell2, sheet2 = SIZES[c["kind"]]
    n_norm = sheet_name(c["id"], anim, False)
    n_x2 = sheet_name(c["id"], anim, True)
    face = "derecha" if facing_of(c) == "right" else "izquierda"
    key = "#FF00FF"
    label = ANIM_ES[anim]
    if anim == "attack" and c["id"] in ("p5_time_medic_worm", "e2_mummy_moth"):
        label = "attack = heal (curar)"
    if over:
        out, alt = n_x2, n_norm
        ov = (f"sí — {why}. Recomendado lienzo doble: celda {cell2} px, hoja {sheet2}x{sheet2} px "
              f"(el personaje ocupa solo la mitad central de cada celda).")
        sz = f"celda {cell2} px / hoja {sheet2}x{sheet2} px (lienzo doble recomendado)"
        alt_line = f"- **Archivo con lienzo normal (alternativo):** `{alt}` (celda {cell} px / hoja {sheet}x{sheet} px)"
    else:
        out, alt = n_norm, n_x2
        ov = f"no — {why}. Lienzo normal."
        sz = f"celda {cell} px / hoja {sheet}x{sheet} px"
        alt_line = f"- **Archivo con lienzo doble (solo si te sale cortado):** `{alt}` (celda {cell2} px / hoja {sheet2}x{sheet2} px)"
    origrow = (f"{c['orig']}, fila {idx + 1} ({orig[c['orig']]['rows'][idx][0]})")
    extra = "" if c["id"] != "squirmy" else " (movimiento reescrito a mano)"
    lines = [
        f"### {pid} · {c['name']}: {label}",
        "- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)",
        f"- **Aplica a:** `{c['id']}`, {c['name']}. {c['role']}.",
        f"- **Referencia a adjuntar:** `{c['id']}_ref.png`",
        f"- **Archivo de salida:** `{out}`",
        alt_line,
        f"- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano {key}, mirada a la {face}, {sz}; imagen 1:1",
        f"- **¿Puede sobresalir de la celda?:** {ov}",
        f"- **Origen:** {origrow}{extra}",
        "",
        block(anim_prompt(c, anim, orig, over)),
    ]
    return "\n".join(lines)


def render_static(pid, s):
    s = dict(s)
    s["desc"] = DESC_ES.get(s["key"]) or RELIC_ES.get(s["key"].replace("icon_relic_", "")) or s["title"] + "."
    kind = {"sprite": "Sprite estático (recortado sobre fondo de color)", "image": "Imagen final (se usa tal cual)"}[s["kind"]]
    if s["kind"] == "sprite":
        col = "azul plano #0000FF (Wormina es rosa)" if s["key_color"] == "#0000FF" else "magenta plano #FF00FF"
        tech = f"fondo {col}; sin sombras ni suelo; bordes limpios"
    else:
        tech = "imagen completa sin fondo recortable; sin texto, logos ni interfaz"
    lines = [
        f"### {pid} · {s['title']}",
        f"- **Tipo:** {kind}",
        f"- **Descripción de la imagen:** {s['desc']}" + (" (Pieza nueva, añadida respecto al original.)" if s["extra"] else ""),
        f"- **Tamaño / proporción:** {SIZE_TXT[s['size']]}",
        f"- **Datos técnicos:** {tech}",
        f"- **Dónde se usa:** {s['used']}",
        f"- **Referencia a adjuntar:** {s['ref']}",
        f"- **Archivo de salida:** `{s['file']}`",
        f"- **Origen:** {s['orig'] if s['orig'] else 'nuevo (no estaba en el original)'}",
        "",
        block(s["body"]),
    ]
    return "\n".join(lines)


def build_all(orig):
    """-> dict fase -> lista de (id, markdown, meta)"""
    build_statics(orig)
    result = {}
    for ph, _, _, _ in PHASES:
        items, n = [], 0
        for tok in ORDER[ph]:
            typ, key = tok.split(":", 1)
            if typ == "s":
                n += 1
                pid = "%s-%03d" % (ph, n)
                s = STATICS[key]
                items.append((pid, render_static(pid, s), {"kind": "static", "file": s["file"], "alt": None}))
            else:
                c = CH[key]
                n += 1
                pid = "%s-%03d" % (ph, n)
                items.append((pid, render_ref(pid, c, orig), {"kind": "ref", "file": c["id"] + "_ref.png", "alt": None}))
                anims = HERO_ANIMS if c["kind"] in ("hero", "skin") else STD_ANIMS
                for i, a in enumerate(anims):
                    n += 1
                    pid = "%s-%03d" % (ph, n)
                    over, _ = overflow(c, a)
                    out = sheet_name(c["id"], a, over)
                    alt = sheet_name(c["id"], a, not over)
                    items.append((pid, render_anim(pid, c, a, orig, i), {"kind": "sheet", "file": out, "alt": alt}))
        result[ph] = items
    return result


def count_kinds(items):
    k = {"static": 0, "ref": 0, "sheet": 0}
    for _, _, m in items:
        k[m["kind"]] += 1
    return k


def write_phase(ph, fname, title, desc, items):
    k = count_kinds(items)
    head = [f"# Fase {ph}: {title}", "",
            desc, "",
            f"**{len(items)} prompts** ({k['ref']} referencias de personaje, {k['sheet']} hojas de animación, {k['static']} imágenes o sprites estáticos). "
            "Antes de empezar lee `README.md` (convenciones, tamaños, qué hacer si la cuadrícula sale mal). "
            "Genera cada referencia primero y luego sus animaciones en el mismo chat de Gemini, adjuntando `<id>_ref.png`.", "",
            "---", ""]
    body = "\n\n".join(md for _, md, _ in items)
    open(os.path.join(OUT, fname), "w", encoding="utf-8").write("\n".join(head) + body + "\n")


def write_readme(res, orig):
    tot = {"static": 0, "ref": 0, "sheet": 0}
    rows = []
    for ph, fname, title, desc in PHASES:
        k = count_kinds(res[ph])
        for a in tot:
            tot[a] += k[a]
        rows.append(f"| {ph} | [{title}]({fname}) | {ph}-001 a {ph}-%03d | {k['ref']} | {k['sheet']} | {k['static']} | **{len(res[ph])}** |" % len(res[ph]))
    total = sum(tot.values())
    why = "\n".join(f"- **Fase {ph}, {title}:** {desc}" for ph, fname, title, desc in PHASES)
    n_chars = len(CHARS)
    n_x2 = 0
    for ph in res:
        for _, _, m in res[ph]:
            if m["kind"] == "sheet" and "_x2_" in m["file"]:
                n_x2 += 1
    txt = f"""# Prompts de arte para Gemini (formato nuevo)

Sustituye a `docs/ART_PROMPTS_ORIGINAL.md` (los 89 prompts originales, que se conservan sin tocar). Generado por
`python3 tools/gen_art_prompts.py`, que lee el original para los textos de diseño y las filas de animación.
El estado de cada pieza (pendiente, en inbox, integrado) lo genera `python3 tools/art_status.py` en `docs/ART_STATUS.md`.

**Total: {total} prompts** ({tot['ref']} referencias de personaje, {tot['sheet']} hojas de animación, {tot['static']} imágenes y sprites estáticos),
repartidos en 8 fases. Los prompts de Gemini están en inglés; todo lo demás, en español.

## Qué cambia respecto al original

1. **Una hoja = una animación.** Antes cada hoja 5x5 juntaba 5 animaciones (una por fila). Ahora cada animación
   (idle, walk, attack, hurt, defeat; el héroe: idle, cast_slam, cast_power, hurt, celebrate) es un prompt aparte con
   25 fotogramas de la misma animación (orden izquierda→derecha, arriba→abajo), mucho más fluida. Las animaciones en
   bucle (idle, walk) deben enlazar el último fotograma con el primero.
2. **Una referencia por personaje.** Cada personaje tiene un prompt de pose estática (`<id>_ref.png`, 1024 px) con toda
   su descripción de diseño. Esa imagen se adjunta en Gemini en cada una de sus animaciones, así el prompt de
   animación solo habla del movimiento (más una línea de identidad: color y rasgo clave).
3. **Cada imagen estática dice dónde se usa** en el juego (pantalla o elemento), su tamaño y qué referencia adjuntar.
4. **Sin referencias cruzadas:** cada prompt se entiende solo. Los nombres de archivo son los que espera el pipeline.

## Cómo usar

1. Abre la fase en curso (empieza por la A) y trabaja **en el orden de los identificadores**: dentro de cada fase lo
   imprescindible va primero.
2. Para un personaje: genera su `referencia` y elige el mejor resultado; guárdalo como `<id>_ref.png`. Después abre un
   chat de Gemini (uno por era, para que el estilo sea consistente), **adjunta `<id>_ref.png`**, pega el prompt de una
   animación y genera. Repite con las otras 4 animaciones en el mismo chat.
3. Copia el bloque de código completo (el cuerpo en inglés) y pégalo. El resto de campos (lista con viñetas) son para ti.
4. Guarda el resultado con el **nombre de archivo exacto** del campo *Archivo de salida* en `art-inbox/` (ver
   `docs/ART_PIPELINE.md`) y ejecuta `python3 tools/art_status.py` para ver el avance.
5. Si una hoja sale mal (fotogramas con tamaño distinto, un miembro cortado, magenta en el cuerpo, la cuadrícula no es
   5x5 exacta): regenera la hoja completa en el mismo chat, o pide a Gemini que redibuje solo las filas con problema.
   Una hoja 5x5 = 25 celdas iguales: si Gemini devuelve 4x4 o 6x6, regenera.

## Convención de nombres

| Qué | Nombre | Ejemplo |
|---|---|---|
| Referencia de personaje | `<id>_ref.png` | `p1_club_worm_ref.png` |
| Hoja de animación (lienzo normal) | `<id>_<anim>_sheet.png` | `p1_club_worm_attack_sheet.png` |
| Hoja de animación (lienzo doble) | `<id>_<anim>_x2_sheet.png` | `p1_club_worm_attack_x2_sheet.png` |
| Imagen o sprite estático | el nombre de siempre | `base_p1.png`, `proj_stone.png`, `icon_coin.png`, `bg_era1.png` |

- `<id>`: `squirmy`, `squirmy_skin_<pirate|knight|astronaut>`, unidades `p<era>_<nombre>_worm`, enemigos `e<era>_<nombre>`,
  jefes `b<era>_<nombre>`.
- `<anim>` de unidades, enemigos y jefes: `idle`, `walk`, `attack`, `hurt`, `defeat`. Del héroe y sus skins: `idle`,
  `cast_slam`, `cast_power`, `hurt`, `celebrate`.
- Los voladores usan `walk` para el vuelo; los de apoyo (Time Medic Worm, Mummy Moth) usan `attack` para la curación.
- Wormina, Count Magpie y el Núcleo Crono son estáticos: su sprite (`wormina.png`, `count_magpie.png`, `chrono_core.png`)
  es a la vez su referencia; no tienen `_ref.png` ni animaciones.

## Tamaños

| Tipo | Lienzo normal | Lienzo doble (`_x2`) |
|---|---|---|
| Unidades y enemigos | celda 256 px, hoja 1280x1280 | celda 512, hoja 2560x2560 |
| Jefes | celda 512 px, hoja 2560x2560 | celda 1024, hoja 5120x5120 |
| Héroe, skins | celda 384 px, hoja 1920x1920 | celda 768, hoja 3840x3840 |
| Referencia de personaje | 1024x1024 | |
| Bases, proyectiles, iconos | 1024x1024 de origen (final: base 512 px de ancho, iconos máx. 128 px) | |
| Fondos de batalla, Home, mapa | 9:16, 1080x1920 | |
| Paneles de historia | 16:9, 1920x1080 | |
| Icono de app | 1024x1024 (se exporta a 512) | |
| Feature graphic | 2:1, 1024x500 finales | |

Gemini rara vez devuelve exactamente esos píxeles; son tamaños objetivo (pide la proporción y reescala después, o usa
el tamaño más grande que te dé). Todas las hojas son 1:1 con cuadrícula 5x5; fondo magenta `#FF00FF`
(Wormina: azul `#0000FF`). Mirada a la **derecha** en el héroe y las unidades propias; a la **izquierda** en enemigos y jefes.

### Lienzo doble (`_x2`)

Cada prompt de animación tiene la línea **¿Puede sobresalir de la celda?**. Si dice **sí**, genera con el lienzo doble:
el personaje se dibuja a la misma escala pero ocupando solo la mitad central de cada celda, así los golpes largos, saltos,
poderes, explosiones, caídas o proyectiles no se cortan ni invaden la celda vecina. El archivo lleva el sufijo `_x2` antes de
`_sheet` y el pipeline lo reduce a la escala normal. Si dice **no**, usa el lienzo normal. Hoy hay **{n_x2}** hojas marcadas
como lienzo doble. El prompt ya incluye la instrucción de margen cuando corresponde.

## Fases

| Fase | Contenido | IDs | Refs | Animaciones | Estáticos | Total |
|---|---|---|---|---|---|---|
{chr(10).join(rows)}
| | **Total** | | **{tot['ref']}** | **{tot['sheet']}** | **{tot['static']}** | **{total}** |

Por qué este orden:

{why}

El criterio general: primero lo que hace falta para jugar un combate de la Era 1 con arte real (A), luego lo que se ve al
abrir el juego (B), luego una era completa de ejemplo (C), luego la economía y la tienda, que están activas desde la
primera partida (D), luego las eras 3 a 5 (E, F, G) y por último la historia y la ficha de la tienda de Play (H).
Los iconos de poder se piden en la fase de la era cuyo jefe los desbloquea (Time Freeze en B, justo al acabar A).

{n_chars} personajes con animación: 1 héroe + 3 skins, 15 unidades, 15 enemigos y 5 jefes. Cada uno son 6 prompts (referencia + 5 animaciones).

## Mapa original → nuevo

Los identificadores del original (`A01`, `B01`...) se conservan en el campo **Origen** de cada prompt. Cambios:

- `A01` Squirmy, `A06` a `A08` skins, `B01` a `B15` unidades, `C01` a `C15` enemigos y `D01` a `D05` jefes: cada hoja de 5 filas
  pasa a 1 referencia + 5 hojas de animación (6 prompts). Los movimientos salen de las filas originales ampliadas a 25 fotogramas.
  El movimiento de Squirmy (héroe base) está reescrito a mano; las skins parten de sus filas originales.
- `A03`, `A04`, `A05` (Wormina, Count Magpie, Núcleo) y `E`/`F`/`G`/`H` (bases, proyectiles, iconos, fondos, logo, textura, icono de app, feature graphic) se
  mantienen como estáticos con el mismo nombre de archivo.
- `H08` logo: el texto pasa de "Worm Warriors" a "Love 'n Wormholes" (nombre del juego desde el 2026-11-21; ver ambigüedades).
- `H09` a `H12` (4 paneles de historia): el juego usa 17 paneles (`data/story.json`) con otros nombres, así que `H09` pasa a
  `story_intro_2`, `H10` a `story_intro_3` y `H12` a `story_end_3`; `H11` (el portal con las eras) queda como pieza **opcional**
  `story_03_portal.png`. Se añaden 13 paneles nuevos.
- Piezas **nuevas** que el juego necesita y el original no tenía: proyectiles `proj_acid`, `proj_dung_ball`, `proj_bomb`, `proj_laser_red`;
  `icon_capsule_open`; 3 insignias de rareza; 12 iconos de reliquia; 6 iconos de la Tienda. Marcadas como "nuevo" en el campo Origen.

## Ambigüedades y decisiones a confirmar

1. **Nombre en el logo:** el original dice "Worm Warriors / Lost in Time"; el juego se llama "Love 'n Wormholes" (decisión del 2026-11-21).
   El prompt del logo (B) usa el nombre nuevo. Cámbialo si prefieres otro.
2. **Referencias de personajes estáticos:** Wormina, Count Magpie y Núcleo Crono no llevan `_ref.png`; su sprite estático hace de referencia.
   El pipeline de sprites trata `wormina.png`, `chrono_core.png` y `count_magpie.png` como "personajes" estáticos.
3. **Dónde se guardan las referencias `_ref.png`:** no entran al juego. El estado las cuenta como "en inbox" si están en `art-inbox/` o "integrado" si están en `art-refs/`.
4. **Lienzo doble:** los marcados `_x2` son recomendación; si Gemini no entrega esa resolución se puede generar en lienzo normal
   (el nombre alternativo está en cada prompt) y aceptar un recorte mayor. Las hojas de jefe en lienzo doble (5120 px) probablemente superen lo que Gemini entrega: generar al máximo posible y reescalar.
5. **Fotograma del golpe:** en cada ataque el momento clave (daño o disparo) está en el fotograma 13 (poderes del héroe: 18 y 17).
   En el pipeline actual `hit_frame` es el 3.º de la fila (índice 2); la implementación nueva debe usar el 13.
6. **Proyectiles en hojas de ataque:** los prompts piden NO dibujar el proyectil en vuelo; el juego usa los sprites `proj_*`.
7. **Pipeline actual:** `tools/process_sprites.py` clasifica `era_N.png`, `power_*.png` y `fx_impact.png` como "personaje" (384 px de alto)
   porque no empiezan por `icon_`/`proj_`; pendiente de ajustar por el agente que implementa el pipeline (los iconos deberían quedar en 128 px).
8. **Panel de la Era 1 con Rexy y las hojas de Count Magpie 3000:** los paneles de historia adjuntan las referencias de los jefes; genera esas referencias antes (fases A y G).
9. **Capturas de Play:** no son prompts; se sacan con `tools/screenshots.gd` cuando haya arte real.
10. **Cosméticos `starter_cap` y `golden_cap`** (contenido de packs de la tienda): no hay arte definido; no se han incluido prompts.
11. **Mapa del mundo:** el original lo trae como un solo 9:16; si `level_select_screen.gd` acaba haciendo scroll vertical por era, habría que pedir una imagen más alta por era.
12. **Unidades y retratos:** las tarjetas de Squad/Upgrades/HUD usan hoy placeholders; no se piden retratos aparte, se supone un fotograma del `idle`.

## Regenerar

```
python3 tools/gen_art_prompts.py   # reescribe docs/art-prompts/*
python3 tools/art_status.py        # reescribe docs/ART_STATUS.md
```
"""
    open(os.path.join(OUT, "README.md"), "w", encoding="utf-8").write(txt)


def main():
    orig = parse_original()
    os.makedirs(OUT, exist_ok=True)
    res = build_all(orig)
    # estaticos del original que ninguna fase uso (control)
    used = {m["orig"] for m in STATICS.values() if m["orig"]} | {c["orig"] for c in CHARS}
    missing = sorted(set(orig) - used)
    for ph, fname, title, desc in PHASES:
        write_phase(ph, fname, title, desc, res[ph])
    write_readme(res, orig)
    total = 0
    for ph, fname, title, desc in PHASES:
        print("Fase %s: %d prompts (%s)" % (ph, len(res[ph]), fname))
        total += len(res[ph])
    print("Total: %d prompts" % total)
    if missing:
        print("AVISO: ids del original sin usar:", ", ".join(missing))


if __name__ == "__main__":
    main()
