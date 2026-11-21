# Love 'n Wormholes: Lost in Time — Game Design & Build Spec

> Copia de trabajo del documento de Alfredo (fuente: artifact de Claude Docs). Texto plano extraído; las tablas aparecen con celdas separadas por `|`. Los prompts de arte de la sección 10 a partir de E08 no están copiados (no se necesitan para el código). El nombre del juego en pantalla es **Love 'n Wormholes** (decisión del 2026-11-21); el paquete es com.am23studios.wormwarriors.

Worm Warriors: Lost in Time — Game Design & Build Spec (for Claude Code)
 · 
1. Vision and scope
Worm Warriors: Lost in Time is a cute, offline-first lane-battle strategy game where a worm named Squirmy fights through five eras to rescue his girlfriend Wormina. Phase 1 ships on Android, phase 2 on iOS.
Pitch. Squirmy and Wormina find a glowing clockwork artifact (the Chrono Core) in the garden. Wormina touches it, the Core absorbs her and shatters into five shards that scatter across history. Squirmy dives through the time portal and must defeat each era's enemies to recover her.
Genre. Casual real-time lane strategy with era evolution. The reference is We Are Warriors (Lessmore), improved where its players complain (section 2).
Session shape. Portrait, one lane, 2 to 4 minute battles, offline campaign, no account required.
Working titles. EN: Love 'n Wormholes: Lost in Time. ES: Love 'n Wormholes: Perdidos en el Tiempo. Hero: Squirmy. Girlfriend: Wormina. Villain: Count Magpie.
Decisions
Topic
 | Decision
 | Status
 | 
Platforms
 | Android first (Google Play), iOS later
 | Confirmed
 | 
In-game languages
 | Spanish and English, auto-detected from device, switchable in Settings
 | Confirmed
 | 
Art style
 | Storybook watercolor, warm ink outlines, cute rounded shapes
 | Confirmed
 | 
Tone
 | Comic and tender: silly villains, sweet hero, light jokes
 | Confirmed
 | 
Ads
 | AdMob, rewarded video only, always started by the player
 | Confirmed
 | 
In-app purchases
 | Yes (section 7)
 | Confirmed
 | 
Random rewards
 | Time Capsules with published odds and guaranteed pity
 | Confirmed
 | 
Engine
 | Godot 4.x with GDScript
 | Recommended, confirm before build
 | 
Orientation
 | Portrait
 |  | 
Launch content
 | 5 eras, 50 stages, 15 player units, 5 bosses
 | Recommended
 | 
How Claude Code should use this document
Read sections 1 to 9 fully before writing code. Section 10 is the art pipeline and the asset manifest.

This document owns the rules (numbers, flows, data). The separate UI mockup owns layout and look of each screen.

Everything tunable (stats, costs, drop odds, ad rewards, scaling) lives in data files, never hardcoded.

Wrap every platform service (ads, billing, analytics, save) behind an interface so the iOS port only adds implementations.

Work in the phases of section 11 and stop at each acceptance gate.

2. Reference analysis and review-driven improvements
We Are Warriors has 10M+ installs and about 4.5 stars, so its core loop works; its weak points are grind, ad pressure and thin strategy, and each one maps to a concrete fix below.
What the reference does
Real-time lane defense: spend Food to spawn units that push toward the enemy base (Google Play listing).

Era evolution from Stone Age to Modern Age, three warrior types per era, an Evolution fee as the prestige step (AppiReview).

Gems gamble for permanent unit boosts; Manager Cards merge to improve production.

Rewarded ads are optional (double food, extra gems); no pop-up ads, which players praise (Marlvel).

Single-player offline campaign; no PvP.

Keep: low-pressure feel, no interruptions mid-battle, cute readable art, short sessions, offline play, era fantasy.
Player complaints and our response
Sources: Google Play reviews on the listing plus AppiReview, Marlvel and GameBrain summaries. Review text is paraphrased.
#
 | Complaint
 | Our design response
 | Spec
 | 
R1
 | Only one unit type is useful per era; players want units from all unlocked eras together
 | Time Squad: a 5-slot deck picked from every unit unlocked in any era, with era-based counters
 | 4.3
 | 
R2
 | Feels pay-to-win; free players must lose many battles to afford progress
 | Mercy rules: losing still pays 40% rewards, and the Underdog Bonus eases a stage after repeated losses; no IAP-only stats
 | 6.4, 7.3
 | 
R3
 | Ads feel mandatory to progress
 | Every ad reward has a free equivalent (daily claim or time); campaign is fully beatable with zero ads at the intended pace
 | 7.1
 | 
R4
 | Enemy stats climb exponentially, later stages feel mathematically impossible
 | Published, capped scaling curve plus telemetry on stuck stages; target first-try win rate 60 to 75%
 | 6.3
 | 
R5
 | Little strategic depth
 | Counter triangle, hero powers with cooldowns, era mechanics, enemy behaviors that demand a response
 | 4, 5
 | 
R6
 | Gambling gems for cards stalls progress when luck is bad
 | Time Capsules with visible odds, hard pity, and Chrono Dust to buy a chosen relic; capsules also earned free
 | 7.4
 | 
R7
 | Late game needs days of resource gathering
 | Offline Worm Farm income, stage rewards that scale with difficulty, no hard progress walls
 | 6.5
 | 
R8
 | Endgame is repetitive after the last era
 | Each era adds a new battlefield rule; Endless Time Rift and Daily Challenge after launch
 | 4.6, 11
 | 
R9
 | Bugs and broken ad rewards
 | Rewards are granted only on the SDK reward callback and persisted before the UI updates; crash-free sessions target 99.5%
 | 8.8
 | 
R10
 | Heavy data sharing, unencrypted data (store listing)
 | Minimal collection, consent flow, tamper-resistant local save, honest Data safety form
 | 8.7
 | 
R11
 | In similar games, paying to remove ads does not fully remove them
 | There are no forced ads to remove; the Golden Pass makes all rewarded bonuses automatic
 | 7.3
 | 
Design rule that comes out of this
If a feature needs the player to watch an ad or pay to avoid frustration, redesign the feature instead.
3. Story and the five eras
The story is a rescue told in short, funny cutscenes: one comic panel before each era and one after each boss, never longer than 15 seconds and always skippable.
Cast
Character
 | Role
 | Look and personality
 | 
Squirmy
 | Hero, player avatar
 | Bright-green worm with a lighter yellow-green belly, big brown eyes, peach-pink cheeks, small hands and a black baseball cap with a letter A. Confident, goofy, brave. Official character sheet supplied by Alfredo (front, side, back, angry, surprised, happy)
 | 
Wormina
 | Girlfriend, rescued at the end
 | Soft-pink worm with long wavy pink hair, round glasses, braces, rosy cheeks and a white daisy in her hair. Sweet, curious, a little mischievous. Official character sheet supplied by Alfredo (front, side, back, happy, sad, surprised, angry, sleeping); leaves "echoes" (clues, notes) in each era
 | 
Count Magpie
 | Final villain
 | Dapper magpie with indigo top hat and gold monocle; collects shiny things across time and found the Chrono Core first
 | 
The Chrono Core
 | Artifact
 | Golden-and-teal clockwork orb with five gem sockets, one per era shard
 | 
Story beats
Prologue. Squirmy and Wormina find the glowing Core in the garden. Wormina pokes it, the Core flashes, she is gone, and the Core cracks into five shards that pull Squirmy into a time portal.

Each era. Squirmy lands, meets the local enemy faction, fights 10 stages, beats the boss, recovers a shard and a Wormina echo (a daisy petal, a scribbled note, her voice).

Finale. Count Magpie has been stealing the shards to power his collection. After the last boss Squirmy reassembles the Core and brings Wormina home.

Epilogue. Wormina keeps the daisy and asks to touch one more shiny thing; Squirmy says no. Sequel hook: an unlocked sixth era.

Eras
#
 | Era
 | Setting
 | Enemy faction (red accents)
 | Boss
 | Battlefield rule (see 4.6)
 | 
1
 | Stone Age: Dino Valley
 | Jungle valley, volcano, giant ferns
 | Ant tribe
 | Rexy, the tiny-armed T-Rex
 | None (tutorial era)
 | 
2
 | Ancient Egypt: Scarab Sands
 | Desert, pyramids, Nile bank
 | Scarab legion and locusts
 | Pharaoh Scarab
 | Sand patches slow all units
 | 
3
 | Medieval: Kingdom of Crumbs
 | Castle fields, banners, windmills
 | Beetle knights
 | Sir Sizzle, the dragon
 | Walls: first hit on each base is reduced
 | 
4
 | Industrial: Steam City
 | Brass towers, pipes, smog
 | Clockwork roaches
 | The Clockwork Queen
 | Steam vents boost units that stand on them
 | 
5
 | Far Future: Neon Orbit
 | Floating platforms, neon, stars
 | Robot beetles and drones
 | Count Magpie 3000
 | Gravity wells pull projectiles off course
 | 
Every era has 10 stages; stage 5 gives a Wormina echo and stage 10 is the boss.
4. Core gameplay
A battle is a side-view lane fight: the player spends Food to spawn worms from the left burrow, worms march right, and the first base to reach 0 HP loses.
4.1 Battle rules
One lane, two bases. Player base on the left, enemy base on the right. Units walk toward the nearest enemy, stop when something is in range, attack, and resume when it dies.

Win: enemy base reaches 0 HP. Lose: player base reaches 0 HP. No timer, but enemies get an "overtime" 20% attack boost after 4 minutes so stalls end.

Population cap: 40 units per side on screen. Projectiles and effects are pooled.

Free x2 battle speed toggle on the HUD, remembered between battles.

Pause always available; leaving a battle counts as a loss with no penalty beyond the lost attempt.

4.2 Food and spawning
Food is earned in battle only and resets each battle. Start with 100. Base income is 8 Food per second at Food Burrow level 1, cap 500.

Tapping a unit card spends its Food cost and spawns the unit after its spawn cooldown. Cards show the cost, a cooldown sweep and a greyed state when unaffordable.

Killing an enemy gives Food equal to 25% of its cost, so winning fights snowballs slightly without runaway.

Food Burrow can be upgraded between battles with Coins (section 6).

4.3 Time Squad (answers review R1)
Before a battle the player picks a Time Squad of up to 5 units from every unit unlocked in any era. Evolving never removes old units.
Unit costs and stats are tied to their era, so a Stone Age unit stays cheap and weaker, but it is still a valid pick for synergy and counters.

Upgrades are per unit and persist.

Squad slots: 4 at start, the 5th unlocks after the Era 2 boss.

The squad is saved as presets (2 presets at launch, a 3rd later via a free reward).

4.4 Roles and counters
Every unit has a role. Damage dealt is multiplied by 1.5 when the attacker counters the target and by 0.75 when it is countered.
Role
 | Strong against
 | Weak against
 | Notes
 | 
Fighter (melee)
 | Shooter
 | Heavy
 | Cheap, fast to spawn
 | 
Shooter (ranged)
 | Heavy
 | Fighter
 | Fragile, high damage at range
 | 
Heavy (tank or mount)
 | Fighter
 | Shooter
 | Slow, high HP
 | 
Air
 | none
 | Shooter only
 | Only Shooters and some hero powers can hit it
 | 
Support
 | none
 | any
 | Heals or slows nearby allies, low HP
 | 
Enemy units follow the same table. The enemy director (section 6.3) mixes roles so a single-role squad loses.
4.5 Hero powers
Squirmy stands beside the base and casts powers. Each power has a cooldown, a Coin upgrade path (5 levels) and starts ready at the beginning of each battle. Launch ships with six powers; the player equips 2 slots, and a third slot unlocks after the Era 3 boss.
Power
 | Effect at level 1
 | Cooldown
 | Unlock
 | 
Squirm Slam
 | Ground slam at the front line: 60 damage in radius 3 and a 1.5 s stun
 | 18 s
 | Start
 | 
Apple Rain
 | Apples fall and add 150 Food over 5 s
 | 40 s
 | Start
 | 
Time Freeze
 | Enemies freeze for 3 s (bosses 1.5 s)
 | 45 s
 | Era 1 boss
 | 
Rewind
 | Allies that died in the last 6 s return with 50% HP at no cost
 | 60 s
 | Era 2 boss
 | 
Dirt Shield
 | Base shield absorbs damage equal to 25% of max base HP for 8 s
 | 50 s
 | Era 3 boss
 | 
Fast-Forward
 | Allies get +30% move and attack speed for 8 s
 | 40 s
 | Era 4 boss
 | 
Candidates for post-launch (pick later): Wormhole Pull (drags enemies toward the center), Glow Burst (heals allies in an area), Chrono Bomb (big delayed damage). Each is a data entry in powers.json plus one effect script.
4.6 Era battlefield rules (answers review R5 and R8)
Each era adds one rule to the battlefield from stage 3 onward, defined per stage in stages.json:
Era 1: none, so new players learn the basics.

Era 2: sand patches slow any unit by 30% while on them.

Era 3: walls reduce the first 20% of each base's HP damage by half.

Era 4: steam vents give +25% attack speed to units standing on them.

Era 5: gravity wells bend projectiles, so shooters should be placed carefully.

4.7 Enemy behaviors that demand a response
Boss stages: the boss walks with escorts and casts one telegraphed attack every 10 s (a 1.5 s warning icon on the lane). Time Freeze, Dirt Shield and spawning Heavies are valid answers.

Air units appear from Era 3 and force at least one Shooter in the squad.

Support enemies heal; killing them first matters, so unit targeting prefers Support and Shooters inside range over Heavies.

5. Units, enemies and bosses
Launch has 15 player units (3 per era), 15 regular enemies and 5 bosses; every player worm wears a blue cloth as team color and every enemy carries red accents so sides read instantly.
5.1 Player units
ID
 | Era
 | Unit
 | Role
 | Signature
 | 
P1-1
 | 1
 | Club Worm
 | Fighter
 | Cheap swarm unit, fur tunic and wooden club
 | 
P1-2
 | 1
 | Slinger Worm
 | Shooter
 | Throws stones at range 5
 | 
P1-3
 | 1
 | Dino Rider Worm
 | Heavy
 | Rides a baby triceratops, slow and tough
 | 
P2-1
 | 2
 | Shield Bearer Worm
 | Heavy
 | Scarab shield blocks 20% of ranged damage
 | 
P2-2
 | 2
 | Bow Worm
 | Shooter
 | Fast arrows, fragile
 | 
P2-3
 | 2
 | Cobra Charmer Worm
 | Support
 | Flute and cobra slow enemies in range by 20%
 | 
P3-1
 | 3
 | Knight Worm
 | Fighter
 | Charges: first hit deals +50%
 | 
P3-2
 | 3
 | Crossbow Worm
 | Shooter
 | Slow shot, high damage, can hit air
 | 
P3-3
 | 3
 | Wizard Worm
 | Support
 | Star wand gives nearby allies +15% damage
 | 
P4-1
 | 4
 | Gear Gunner Worm
 | Shooter
 | Rapid steam rifle, can hit air
 | 
P4-2
 | 4
 | Boiler Tank Worm
 | Heavy
 | Steam tank, splash damage on hit
 | 
P4-3
 | 4
 | Balloon Bomber Worm
 | Air
 | Drops bombs on ground units, only Shooters can hit it
 | 
P5-1
 | 5
 | Laser Blade Worm
 | Fighter
 | Fast dash and laser sword
 | 
P5-2
 | 5
 | Mecha Worm
 | Heavy
 | Piloted mech walker, highest HP
 | 
P5-3
 | 5
 | Time Medic Worm
 | Support
 | Hover drone heals nearby allies 5% max HP per second
 | 
5.2 Enemy units
ID
 | Era
 | Enemy
 | Role
 | Behavior
 | 
E1-1
 | 1
 | Ant Clubber
 | Fighter
 | Rushes the nearest unit
 | 
E1-2
 | 1
 | Ant Spitter
 | Shooter
 | Spits acid from range 5
 | 
E1-3
 | 1
 | Stone Beetle
 | Heavy
 | Rock shell, slow
 | 
E2-1
 | 2
 | Scarab Soldier
 | Fighter
 | Gold armor, curved blade
 | 
E2-2
 | 2
 | Locust Archer
 | Shooter
 | Jumps back after shooting
 | 
E2-3
 | 2
 | Mummy Moth
 | Support
 | Heals allies with bandage wraps
 | 
E3-1
 | 3
 | Beetle Knight
 | Fighter
 | Lance charge
 | 
E3-2
 | 3
 | Dung Catapult
 | Shooter
 | Long range, targets the highest-HP unit
 | 
E3-3
 | 3
 | Hornet Scout
 | Air
 | Flies over fighters
 | 
E4-1
 | 4
 | Cog Roach
 | Fighter
 | Fast clockwork rusher
 | 
E4-2
 | 4
 | Spark Fly
 | Air
 | Shock hits chain to 2 nearby units
 | 
E4-3
 | 4
 | Clank Crab
 | Heavy
 | Steam shell, frontal armor
 | 
E5-1
 | 5
 | Laser Bug
 | Shooter
 | Piercing beam
 | 
E5-2
 | 5
 | Drone Fly
 | Air
 | Fast, low HP, targets Support units
 | 
E5-3
 | 5
 | Mecha Beetle
 | Heavy
 | Highest enemy HP
 | 
5.3 Bosses (stage 10 of each era)
ID
 | Boss
 | Era
 | Telegraphed attack (every 10 s)
 | Phase 2 at 50% HP
 | 
B1
 | Rexy the T-Rex
 | 1
 | Stomp: stuns allies in front for 1 s
 | Roars, enemy units gain +20% speed
 | 
B2
 | Pharaoh Scarab
 | 2
 | Summons 3 Scarab Soldiers
 | Sandstorm slows the whole lane
 | 
B3
 | Sir Sizzle the Dragon
 | 3
 | Fire breath over a lane segment, damage over time
 | Flies, becomes an Air target
 | 
B4
 | The Clockwork Queen
 | 4
 | Steam burst slows and damages
 | Spawns Cog Roaches every 8 s
 | 
B5
 | Count Magpie 3000
 | 5
 | Steals one equipped hero power for 8 s
 | Teleports short hops, drops shiny bombs
 | 
5.4 Base stats by role (Era 1 reference)
All numbers are starting values for units.json; balance with the formulas in section 6.
Role
 | Food cost
 | HP
 | Damage
 | Attack interval (s)
 | Range
 | Move speed
 | Spawn cooldown (s)
 | 
Fighter
 | 50
 | 100
 | 12
 | 0.8
 | 1
 | 60
 | 2
 | 
Shooter
 | 75
 | 60
 | 14
 | 1.0
 | 5
 | 55
 | 3
 | 
Heavy
 | 150
 | 300
 | 25
 | 1.2
 | 1
 | 50
 | 6
 | 
Support
 | 100
 | 70
 | utility only
 | 1.0
 | 4
 | 55
 | 5
 | 
Air
 | 120
 | 80
 | 20 (area on ground)
 | 1.4
 | 1
 | 70
 | 5
 | 
Player base HP is 1000 in Era 1; enemy base HP is 1000 in stage 1 and rises per stage (section 6.3). Era scaling: HP and Damage x1.6 per era, Food cost x1.5 per era.
6. Progression, economy and balance
Progress comes from clearing stages and spending Coins on upgrades; every number below is a starting value stored in data files and checked by a balance simulator before release.
6.1 Currencies
Currency
 | Earned by
 | Spent on
 | Notes
 | 
Food
 | Passive income and kills, in battle only
 | Spawning units
 | Resets every battle
 | 
Coins
 | Battles, daily quests, offline Worm Farm
 | Unit, Food Burrow, base and power upgrades
 | Soft currency
 | 
Gems
 | First clears, boss clears, daily quests, IAP
 | Time Capsules, cosmetics, squad preset slot
 | Earned free through play and also sold in the shop
 | 
Chrono Dust
 | Duplicate relics, capsule pity
 | Buying a chosen relic
 | Prevents bad luck from blocking progress
 | 
Time Capsule
 | Daily login, stage rewards, gems
 | Opened for a random relic (section 7.4)
 | Optional power layer, capped
 | 
6.2 Upgrades (between battles, paid in Coins)
Unit level 1 to 20: stat multiplier 1 + 0.10 x (level - 1). Cost to reach level L: round(60 x 1.18^(L-2)).

Food Burrow level 1 to 10: income +1.2 Food per second and cap +60 per level. Cost starts at 80 and rises x1.45 per level.

Base level 1 to 10: +10% base HP per level. Cost starts at 100 and rises x1.45 per level.

Hero power level 1 to 5: effect +12% and cooldown -4% per level. Cost starts at 150 and rises x1.6 per level.

6.3 Stage scaling and the enemy director (answers review R4)
Stages are numbered n = 1 to 50 (era e = 1 to 5, stage s = 1 to 10).
Enemy stat multiplier: 1.6^(e-1) x (1 + 0.05 x (s - 1)). The curve is linear inside an era and steps up at each era, never exponential per stage.

Player unit multiplier: 1.6^(unit era - 1) x (1 + 0.40 x (current era - unit era)) x (1 + 0.10 x (level - 1)). The middle term is Time Sync: older units get stronger as the player advances, so they stay useful (review R1).

Enemy base HP: 1000 x (1 + 0.15 x (n - 1)).

Enemy director: each stage defines a Food budget and a wave script in stages.json; the director spends the budget with a role mix that includes at least one counter to the most-used player role.

Target pacing: a player who upgrades normally has an average squad level near 1 + 0.25 x (n - 1) and should win each stage on the first try 60 to 75% of the time, within 2 tries 90% of the time.

Tool to build: tools/balance_sim.py runs the battle rules headless against units.json and stages.json and prints win rate by stage for three player profiles (casual, normal, optimized). Release gate: no stage under 45% for the normal profile.

6.4 Rewards and mercy rules (answers review R2)
Win reward in Coins: round(30 x 1.06^(n-1)). First clear gives x2 Coins and 5 Gems; a boss first clear gives 20 Gems and 1 Time Capsule.

A loss still pays 40% of the Coin reward.

Underdog Bonus: after 2 losses in a row on the same stage, each further loss adds +10% starting Food and +10% player base HP, up to 3 stacks. It shows as a visible badge and resets on a win.

The pre-battle screen always shows the enemy role mix (scout report) for free, so players can pick counters.

6.5 Offline Worm Farm (answers review R7)
Coins per minute while away: 2 + 0.4 x (highest stage cleared). Base cap 3 hours; each boss cleared adds +1 hour (max 8 hours); an optional IAP adds more (section 7.3).

Claimed on app open. An optional rewarded ad doubles one claim.

6.6 Daily loop
Daily login: 1 Time Capsule, 10 Gems, streak bonus on day 7.

Three daily quests (for example win 3 battles, use a hero power 5 times, spawn 30 units): Coins and Gems.

Every ad reward has a free path: the capsule and Coins above are free; the ad only doubles or boosts them.

7. Monetization
Revenue comes from rewarded ads the player chooses to watch and from fair in-app purchases; nothing interrupts a battle and nothing is required to finish the campaign.
7.1 AdMob: opt-in rewarded ads only (answers review R3)
Placement
 | Where it appears
 | Reward
 | Free path to the same progress
 | 
Double Coins
 | Victory screen button
 | x2 Coins from that battle
 | Normal Coin reward
 | 
Food Boost
 | Pre-battle toggle
 | Start the battle with +30% Food
 | Normal start
 | 
Second Wind
 | Defeat screen button, once per battle
 | Retry from where you lost with base HP restored to 25%
 | Retry from the start, with Underdog Bonus
 | 
Bonus Capsule
 | Shop and Home, max 1 per day
 | 1 extra Time Capsule
 | Daily login capsule
 | 
Double Farm
 | Offline claim popup
 | x2 on that claim
 | Normal claim
 | 
Rules for Claude Code:
Rewarded video only at launch. No interstitials, no banners, no app-open ads, no ads in the first session before the player has completed stage 3.

Every ad button states the reward before it is tapped and shows a video icon. If no ad is loaded the button is hidden or shows "Not available right now"; the player is never blocked or penalized.

Grant the reward only in the SDK's user-earned-reward callback, write it to the save first, then update the UI. Preload the next ad right after one finishes or fails; retry with backoff.

A remote-config style flag file (config/ads.json) can disable any placement without a new build.

Use Google's published test app and ad unit IDs in debug builds; production IDs live in an untracked config/ads.prod.json. Verify the current test IDs in the AdMob documentation at build time.

Add the UMP consent flow before the first ad request, and a "Privacy options" entry in Settings. Initialize the SDK only after consent state is known.

Wrap the SDK behind an AdService interface with Android and iOS implementations plus a MockAdService for the editor.

7.2 Ad etiquette checks
No ad is ever shown without a tap on an ad button.

Sound respects the in-game mute switch before and after an ad.

The game must be fully completable with zero ads watched.

7.3 In-app purchases
Prices are USD reference tiers; use Play Console local pricing for Latin America and other regions.
Product ID
 | Type
 | Price
 | Contents
 | 
gems_80
 | Consumable
 | 0.99
 | 80 Gems
 | 
gems_450
 | Consumable
 | 4.99
 | 450 Gems
 | 
gems_1000
 | Consumable
 | 9.99
 | 1000 Gems
 | 
gems_2200
 | Consumable
 | 19.99
 | 2200 Gems
 | 
starter_pack
 | One-time, non-consumable
 | 1.99
 | 300 Gems, 3 Time Capsules, cosmetic cap
 | 
golden_pass
 | Non-consumable
 | 4.99
 | All rewarded-ad bonuses apply automatically without watching; ad buttons disappear; +2 hours offline cap; golden cap cosmetic
 | 
skin_pirate, skin_knight, skin_astronaut
 | Non-consumable
 | 1.99 each
 | Cosmetic hero skins, no stats
 | 
Fairness rules:
No stat or content is sold that cannot also be earned for free. The only paid-only items are cosmetics.

Gems buy Time Capsules (60 Gems each, 10 for 540), cosmetics and extra squad preset slots. Gems never buy Coins or direct stat upgrades.

Handle pending purchases, acknowledge within 3 days, restore purchases on startup and from Settings, and keep the Billing code behind a BillingService interface.

7.4 Time Capsules and relics (answers review R6)
A capsule opens into a relic, a small permanent passive. Relics add depth but are capped so paying cannot break the campaign.
Rarity
 | Drop chance
 | Max level
 | Relics
 | 
Common
 | 70%
 | 5
 | Sticky Seed (+5% Food income), Lucky Clover (+5% Coins), Tough Pebble (+5% base HP), Sharp Thorn (+3% unit damage), Quick Sprout (-5% spawn cooldown), Cozy Mushroom (+3% unit HP)
 | 
Rare
 | 25%
 | 4
 | Golden Dewdrop (+8% Coins), Echo Seashell (+8% Food income), Mini Hourglass (-6% power cooldowns), Wormina's Daisy (+6% unit HP)
 | 
Epic
 | 5%
 | 3
 | Chrono Gear (+10% Food income), Time Crown (+8% unit damage)
 | 
Each relic level adds its listed bonus again. Total relic bonus per stat is capped at +25%.

Pity: a Rare or better is guaranteed every 5 capsules and an Epic every 20 capsules. The counters are visible on the capsule screen.

A duplicate at max level converts to Chrono Dust (Common 5, Rare 15, Epic 50). Dust buys a chosen relic (Common 30, Rare 90, Epic 250).

The capsule screen shows all odds, the pity counters and the dust conversion in plain text, as Google Play requires for random items. Put the same odds in the Play Store listing description.

All capsule rolls use a seeded local random with the pity state saved, so closing the app never resets pity.

8. Technical specification
Build with Godot 4.x and GDScript, data-driven, with every platform service behind an interface so Android ships first and iOS only adds implementations.
8.1 Stack and targets
Engine: latest stable Godot 4.x, GDScript, 2D renderer (Mobile or Compatibility, whichever holds 60 fps on the low-end target). Why Godot: scenes and resources are text files, which suits agent-driven development, and exports to Android and iOS from one project.

Fallback if a required SDK plugin is unmaintained for the chosen Godot version: keep the game logic as is and write a thin Kotlin Android plugin that exposes the SDK as Godot signals.

Android: AAB build, minimum Android version the Godot export supports (target Android 8 or newer), target SDK per the current Google Play requirement at submission time.

Package name format: com.am23studios.wormwarriors, each segment starting with a letter (a segment cannot start with a digit). The studio segment is am23studios (confirmed). Audience 13+, distribution Latin America only.

Performance targets: 60 fps on a 3 GB RAM mid-range phone with 80 units and effects on screen, cold start under 4 s, AAB under 150 MB, battery-friendly (cap FPS to 60, pause simulation when backgrounded).

8.2 Project layout
worm-warriors/
  project.godot
  config/            ads.json, ads.prod.json (untracked), feature_flags.json
  data/              units.json, enemies.json, bosses.json, stages.json,
                     powers.json, relics.json, shop.json, quests.json
  i18n/              strings.csv (key, en, es)
  assets/
    sprites/         hero/ units/ enemies/ bosses/ bases/ fx/ icons/
    images/          backgrounds/ story/ ui/ store/
    audio/           music/ sfx/
  src/
    autoload/        Game.gd, SaveService.gd, Economy.gd, Localization.gd,
                     AdService.gd, BillingService.gd, Analytics.gd, Audio.gd
    battle/          BattleScene.tscn, Unit.gd, Projectile.gd, Base.gd,
                     Director.gd, PowerController.gd, Hud.tscn
    meta/            Home.tscn, WorldMap.tscn, Squad.tscn, Upgrades.tscn,
                     Shop.tscn, Capsules.tscn, Settings.tscn, Story.tscn
    platform/        android/ ios/ mock/   (implementations of the services)
  tools/             process_sprites.py, balance_sim.py, check_i18n.py
  tests/             combat, economy, save migration, capsule pity
8.3 Services (autoloads)
Service
 | Responsibility
 | Interface notes
 | 
SaveService
 | Load and save the player profile atomically
 | Versioned schema with migrations, backup copy, write on every reward
 | 
Economy
 | Currencies, upgrade costs, rewards
 | Single source of truth, emits signals, never touches UI
 | 
AdService
 | Rewarded ads
 | is_ready(placement), show(placement), signals rewarded, closed, failed
 | 
BillingService
 | Purchases and restore
 | purchase(product_id), restore(), signals purchased, failed
 | 
Analytics
 | Event log
 | Events in 8.6; no-op in editor
 | 
Localization
 | ES and EN
 | Loads strings.csv, falls back to EN, never shows raw keys
 | 
Audio
 | Music and SFX buses
 | Volume settings, mute follows ads rules
 | 
8.4 Battle implementation notes
Fixed-timestep simulation (30 ticks per second) separate from rendering, so x2 speed just doubles ticks and the balance simulator can run headless.

Units are data-driven (units.json), use a small state machine (Walk, Attack, Hit, Die), and are pooled. Cap 40 per side.

Characters animate from 5x5 sprite sheets (rows: idle, walk, attack, hurt, defeat; hero: idle, two casts, hurt, celebrate). tools/process_sprites.py slices each sheet into 25 frames and writes a manifest; the game builds SpriteFrames from that manifest in code. Frame rates: idle 6, walk 10, attack 12, hurt 10, defeat 8 fps. Attack hits and projectile spawns fire on the manifest's hit_frame (frame 3 of the attack row by default). No procedural squash and stretch is needed.

Projectiles are pooled sprites with a straight or arc path; gravity wells (Era 5) add a curve.

Hero powers are scripts selected by id in powers.json.

Era battlefield rules are components attached to the stage (SandPatch, Walls, SteamVent, GravityWell).

Parallax background in 3 layers (far, mid, ground) from one tall 9:16 background image plus optional foreground props. The lane sits at about 58% of the screen height; the HUD is on top and unit cards and powers are in the bottom 30%.

8.5 Data files
All IDs are lowercase snake_case and match asset file names. units.json entry fields: id, era, role, cost, hp, damage, interval, range, speed, spawn_cooldown, sprite, flags (air, splash, slow, heal, buff). stages.json entry fields: id, era, index, enemy_base_hp, food_budget, waves[], rule, rewards. Strings are keyed, never hardcoded.
8.6 Analytics events
session_start, tutorial_step, stage_start, stage_end (result, duration, squad, tries), unit_upgrade, power_used, ad_offered, ad_started, ad_rewarded, ad_failed, iap_view, iap_purchase, capsule_open (rarity, pity), era_unlocked. Use them to track win rate and "stuck" stages (more than 4 tries) so balance can be tuned after launch.
8.7 Save, privacy and security (answers review R10)
Local save in user://, JSON with a schema version, written to a temp file and renamed, with a checksum and a rolling backup. A tampered checksum falls back to the backup.

No account, no server at launch. Optional cloud save through Google Play Games Services is post-launch.

Collect only what ads, analytics and billing need. Declare it accurately in the Play Data safety form. Link a privacy policy page for this game in the store listing and in Settings.

Show the consent dialog (UMP) before ads; Settings has "Privacy options" and "Delete my local data".

8.8 Quality gates (answers review R9)
Automated tests: combat rules, economy formulas, save migrations, capsule pity and odds, ad reward grant and restore flow with mock services.

Headless simulator: tools/balance_sim.py per section 6.3 in CI.

Manual device matrix: a low-end 3 GB phone, a mid-range phone, a tablet, small and tall aspect ratios (notch safe areas).

Crash-free sessions target 99.5% in the first 2 weeks; no reward-loss bugs; cold-offline start works.

8.9 iOS phase (later)
Add platform/ios/ implementations: AdMob iOS, StoreKit purchases and restore, App Tracking Transparency prompt, SKAdNetwork identifiers, privacy manifest and nutrition labels.

Re-check safe areas, haptics, and audio session behavior. No game-logic changes expected.

8.10 Build and release
Debug builds use test ad IDs and mock billing. Release builds use config/ads.prod.json and Play Billing.

Sign the AAB with an upload key kept outside the repo. Use Play Console internal testing, then closed testing, before production.

Host app-ads.txt on the developer website that is listed in the Play listing.

8.11 Code-only workflow (no editor clicking)
Alfredo wants the whole game built by code, with no Godot editor interaction. Claude Code therefore does this:
Write every scene as a text .tscn file or, better, build the scene tree in GDScript at runtime from the JSON data files; keep project.godot and export_presets.cfg as hand-written text.

Import assets and run checks headless: godot --headless --import, godot --headless --script res://tools/run_tests.gd, and godot --headless --export-release "Android" build/wormwarriors.aab.

Build SpriteFrames, atlases and the sprite manifest with tools/process_sprites.py; never ask the user to drag assets into the editor.

Drive screens from code (a small UI builder that creates Controls, themes and layouts from JSON) so no scene needs visual editing.

Video: play studio_intro.ogv with a VideoStreamPlayer created in code (Godot plays Ogg Theora only, so convert the video once with ffmpeg: ffmpeg -i studio_intro.mp4 -c:v libtheora -q:v 7 -c:a libvorbis assets/video/studio_intro.ogv).

Verify with the headless balance simulator and a smoke-test script that boots every screen and exits non-zero on any error.

9. UX, screens, localization and audio
The game has 15 screens; the UI mockup delivered with this document shows 13 of them, plus the offline-claim popup on Home and is the visual reference for layout, spacing and hierarchy.
9.1 Screen list
#
 | Screen
 | Purpose and key elements
 | 
1
 | Title
 | Logo, Play button, language and settings icons, version
 | 
2
 | Consent
 | UMP consent dialog before ads, shown once per region rules
 | 
3
 | Home
 | Squirmy on the burrow, Play (next stage), currency bar, bottom navigation: Squad, Upgrades, Capsules, Shop; daily reward badge; offline claim popup
 | 
4
 | World Map
 | Era tabs with 10 stage nodes each, stars, boss node, locked eras, Wormina echo markers
 | 
5
 | Pre-battle
 | Scout report (enemy roles), Time Squad selector (5 slots), equipped hero powers, optional Food Boost ad button, Start
 | 
6
 | Battle HUD
 | Player and enemy base HP bars, Food bar and income, 5 unit cards with cost and cooldown, 2 power buttons, speed x2, pause
 | 
7
 | Pause
 | Resume, restart, quit, sound toggles
 | 
8
 | Victory
 | Coins, gems, first-clear bonuses, optional Double Coins ad, next stage
 | 
9
 | Defeat
 | Mercy rewards, Underdog badge, optional Second Wind ad, retry, change squad
 | 
10
 | Upgrades
 | Tabs: Units, Food Burrow, Base, Powers; level, cost, stat preview
 | 
11
 | Squad and Collection
 | All unlocked units across eras, presets, counters chart
 | 
12
 | Shop
 | Gem packs, Starter pack, Golden Pass, skins, free daily items, Restore purchases
 | 
13
 | Time Capsules
 | Open capsule, odds table, pity counters, Chrono Dust and relic shop, relic collection
 | 
14
 | Settings
 | Language, music, SFX, vibration, privacy options, restore purchases, credits, delete local data
 | 
15
 | Story
 | Era intro and boss outro comic panels, skip button
 | 
16
 | Studio intro
 | Full-screen am23studios presentation video (provided by Alfredo, bundled as assets/video/studio_intro.ogv), plays at every cold start before the Title, tap to skip after 1 second, silent if the device is muted
 | 
The mockup omits Story and Consent (system dialogs); everything else appears. Boot order: Studio intro (16), then Consent if needed, then Title.
9.2 First-time experience
Prologue comic (3 panels, skippable), then a guided first battle of about 60 seconds: spawn a Club Worm, use Squirm Slam, destroy the base.

Unlocks appear one at a time: Upgrades after stage 2, Squad after stage 3, Capsules after stage 5, Shop after stage 4. No ad prompts before stage 3.

9.3 UX rules
One-handed portrait play: unit cards and power buttons sit in the lower corners within thumb reach.

Team readability: blue cloth for the player and red accents for enemies, plus a small blue or red marker under each unit so color-blind players can tell sides apart.

Touch targets at least 48 dp, safe areas respected, text readable at small sizes with a text size option.

Every currency in the top bar can be tapped to open the matching shop section.

No dark patterns: no fake timers, no countdown pressure on purchases, no guilt text on declining.

9.4 Localization (Spanish and English)
All text lives in i18n/strings.csv with columns key,en,es. The game starts in the device language if supported, otherwise English.

Layouts must tolerate Spanish text up to 30% longer than English.

Glossary: Worm = Gusano, Food = Comida, Coins = Monedas, Gems = Gemas, Time Capsule = Cápsula del Tiempo, Chrono Dust = Polvo Crono, Relic = Reliquia, Squad = Escuadrón, Power = Poder, Boss = Jefe, Era = Era, Victory = ¡Victoria!, Defeat = Derrota. Character names stay as written.

tools/check_i18n.py fails the build if a key is missing in either language.

9.5 Audio
Music: one loop per era (5), one menu loop, one victory and one defeat stinger. Style follows each era (drums and flutes, desert strings, medieval lute, brass and gears, synth).

SFX: spawn, hit, death, base hit, power casts (6), UI tap, coin, gem, capsule open per rarity, ad reward.

Use only CC0 or properly licensed open sources, and keep a CREDITS list of every file with its license, shown in Settings.

Audio sourcing plan (CC0 only, so no credit is legally required, but we still list everything).
Sound effects: start with Kenney (kenney.nl) audio packs such as Interface Sounds, Impact Sounds and Digital Audio, all CC0. Fill gaps from Freesound using only files filtered to the CC0 license, and OpenGameArt using only CC0 entries.

Music: six loops (five eras plus menu) and two stingers. Search OpenGameArt and itch.io free-assets for CC0 tracks, matching each era: drums and flutes (Era 1), desert strings (Era 2), lute (Era 3), brass and gears (Era 4), soft synth (Era 5), and a gentle playful theme for the menu.

Alternative if CC0 music does not fit the tone: commission or buy a small royalty-free pack with a commercial license in writing, and keep the receipt in docs/licenses/.

Rules for Claude Code: store files in assets/audio/ with a CREDITS.md row for each (file, author, source URL, license, date downloaded); never add a file whose license is unclear; loop points must be seamless; normalize to about -14 LUFS for music and -10 LUFS for SFX; export OGG Vorbis at 96 to 128 kbps.

Placeholder: until real files arrive, generate short beeps in code so every sound event is wired and testable.

Alfredo review: pick the final music tracks by listening; Claude Code only proposes candidates with links.

10. Art bible and Gemini prompts
All art is generated in Gemini from the 90 prompts below; every prompt is complete on its own, so copy one box, paste it into Gemini and generate.
10.1 How to use the prompts
IMAGE means a finished picture used as it is (backgrounds, story panels, logo, icon, store art). SPRITE means a single object on a flat magenta (#FF00FF) background that gets cut out and becomes a transparent PNG.

Copy a prompt, generate, pick the best result and save it with the file name shown above the prompt.

Gemini may not return exact pixel sizes or a perfect grid. Ask for 1:1 for sprites and sheets, 9:16 for portrait backgrounds and 16:9 for wide images as the prompts do. For sheets: if a frame drifts (different size, a cropped limb, magenta on the body), regenerate the whole sheet or ask Gemini to redraw only that row, then paste it in. If a character looks different between rows, regenerate with the same prompt in the same chat. Keep the 5x5 sheet as the source of truth; tools/process_sprites.py trims, removes the magenta, resizes and builds atlases.

Work one era per Gemini chat so the style stays consistent. If a result has magenta on the subject, text, extra objects, a cropped subject or a different color scheme, regenerate with the same prompt.

Player units face right, enemies face left. Animated characters (hero, units, enemies, bosses) are SPRITE SHEETS 5x5: one image, 5 columns by 5 rows, 25 frames, one animation per row (idle, walk, attack, hurt, defeat; the hero has idle, two casts, hurt, celebrate). Each prompt already describes what moves in every row. Static pieces (Wormina, Count Magpie, Chrono Core, bases, projectiles, icons) are single-pose SPRITES. The game is portrait, so backgrounds are 9:16.

Asset type
 | Source from Gemini
 | Final in game
 | 
Unit and enemy sprite sheets
 | 1:1 sheet, 5x5 grid, one frame per cell
 | Slice into 25 frames, 256 px tall each
 | 
Boss sprite sheets
 | 1:1
 | Slice into 25 frames, 512 px tall each
 | 
Base sprites
 | 1:1
 | Trim, 512 px wide
 | 
Hero and character sprites
 | 1:1
 | Hero sheets: 25 frames, 384 px tall each; static characters: trim, 256 to 384 px tall
 | 
Projectiles and icons
 | 1:1
 | 96 to 128 px
 | 
Battle backgrounds
 | 16:9
 | Portrait 9:16, crop to 1080 x 1920 (use 9:16 source)
 | 
Story panels
 | 16:9
 | 1920 x 1080
 | 
App icon
 | 1:1
 | 1024, export 512 for Play
 | 
Play feature graphic
 | wide
 | Crop to 1024 x 500
 | 
10.2 Era color moods
Era
 | Dominant colors
 | Light
 | 
1 Stone Age
 | Leaf green, ochre, volcanic orange
 | Warm morning
 | 
2 Egypt
 | Sand gold, turquoise, terracotta
 | Hot noon
 | 
3 Medieval
 | Slate blue, grass green, banner crimson
 | Soft afternoon
 | 
4 Industrial
 | Copper, brass, teal smog
 | Dusk with steam glow
 | 
5 Far Future
 | Deep indigo, neon cyan, soft violet-white
 | Starlight
 | 
10.3 Characters and cosmetics (SPRITE)
Characters with animation are generated as SPRITE SHEET 5x5: one image with 25 frames (5 rows, one animation per row, 5 frames per row). Static characters (Wormina, Count Magpie, Chrono Core) stay single-pose SPRITES. Squirmy and Wormina have official character sheets made by Alfredo: attach the matching sheet as a reference image in every Gemini chat that draws them (hero sheets, skins, Wormina, story panels, app icon, banner) so the faces, colors and the cap with the letter A stay identical. Squirmy is bright green and Wormina is soft pink, so Wormina's sprite uses a blue key background instead of magenta.
A01 · SPRITE SHEET 5x5 · Squirmy (hero). Save as assets/sprites/hero/squirmy_sheet.png. Rows: idle, cast Squirm Slam, cast generic power, hurt, celebrate.
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks, two small simple hands, a black baseball cap worn slightly tilted with a small stylized letter A on the front, and a friendly confident smile. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body stands upright like a friendly question mark and slowly rises and sinks as if breathing, one little hand gives a tiny wave, the cap brim bobs slightly, and the eyes blink on frame 4. Row 2, casting Squirm Slam: the head leans back, both hands rise, the body coils like a spring, then the whole front half rises high and slams down toward the ground with the cap tipping forward, with small golden sparks around the impact in the last two frames. Row 3, casting a generic power: the head tilts up, both little hands stretch toward the sky with a determined open-mouth battle cry while a swirl of golden and teal light with tiny gears grows around him and then fades. Row 4, getting hurt: the body flinches backward, the eyes squeeze shut, the cap tips down over one eye, the body wobbles, and then he recovers to a standing pose. Row 5, celebrating: the body bounces up in a happy jump with one fist pumped in the air, the cap stays on, a small spin, and a cheerful landing with a tiny tip of the cap.
A03 · SPRITE · Wormina. Save as assets/sprites/hero/wormina.png
Wormina, a small cheerful soft-pink earthworm girl with a lighter pink segmented belly, long wavy bubblegum-pink hair with a pretty curl on top, a white daisy with a yellow center tucked into the hair, round thin-framed glasses over big sparkling eyes with long lashes, rosy cheeks, a happy smile with tiny braces and two small simple hands, standing upright in a neutral pose with her body gently curved, looking forward with wonder. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin dark-rose ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, side view facing right, centered with a wide empty margin, drawn on a perfectly flat solid pure blue background (#0000FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use blue anywhere on the subject. Square 1:1 image.
Wormina is pink, so this one sprite uses a flat blue background (#0000FF) instead of magenta. tools/process_sprites.py must read the key color per asset from assets/manifest.json (key_color, default #FF00FF; Wormina: #0000FF).
A04 · SPRITE · Count Magpie (story villain). Save as assets/sprites/hero/count_magpie.png
Count Magpie, a plump dapper magpie with glossy black-and-white feathers, iridescent blue-green wing tips, a deep indigo top hat, a gold monocle and a short dark-blue cape, wearing a smug grin and holding a tiny glowing golden gear in one claw, standing proudly with his chest puffed out. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, side view facing left, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
A05 · SPRITE · The Chrono Core. Save as assets/sprites/hero/chrono_core.png
The Chrono Core, a glowing apple-sized clockwork orb made of polished gold and teal metal with tiny visible gears, five small round gem sockets around its middle and hairline cracks letting warm golden light leak out, floating slightly with a few sparkles around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single object, front view, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
A06 · SPRITE SHEET 5x5 · Squirmy skin: Pirate. Save as assets/sprites/hero/squirmy_skin_pirate_sheet.png. Same five rows as A01.
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks and two small simple hands, dressed as a pirate with a small black tricorn hat with a gold star instead of his cap and a tiny black eyepatch. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body stands upright and slowly rises and sinks as if breathing, one little hand gives a tiny wave, the hat bobs, and the visible eye blinks on frame 4. Row 2, casting Squirm Slam: the head leans back with the hat tilting, the body coils like a spring, then the front half rises high and slams down toward the ground, with golden sparks at the impact in the last two frames. Row 3, casting a generic power: the head tilts up with a pirate battle cry, both little hands stretch toward the sky while a swirl of golden and teal light with tiny gears grows around him and fades. Row 4, getting hurt: the body flinches backward, the hat tips over one eye, the body wobbles, and then he recovers. Row 5, celebrating: the body bounces up in a happy jump with one fist pumped, a small spin in the air, the hat stays on, and a cheerful landing with a tiny bow.
A07 · SPRITE SHEET 5x5 · Squirmy skin: Knight. Save as assets/sprites/hero/squirmy_skin_knight_sheet.png. Same five rows as A01.
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks and two small simple hands, dressed as a knight with a tiny shiny silver helmet with a blue plume instead of his cap and a small round silver shield strapped to his body. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body stands upright and slowly rises and sinks as if breathing, the helmet plume sways, and the eyes blink on frame 4. Row 2, casting Squirm Slam: the head leans back, the body coils like a spring, then the front half rises and slams down with the shield forward, with golden sparks at the impact in the last two frames. Row 3, casting a generic power: the head tilts up with a brave battle cry, both little hands stretch toward the sky while a swirl of golden and teal light with tiny gears grows around him and fades. Row 4, getting hurt: the body flinches backward, the plume bends, the shield lifts to block, the body wobbles, and then he recovers. Row 5, celebrating: the body bounces up in a happy jump with the shield raised high, a small spin, and a proud landing.
A08 · SPRITE SHEET 5x5 · Squirmy skin: Astronaut. Save as assets/sprites/hero/squirmy_skin_astronaut_sheet.png. Same five rows as A01.
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks and two small simple hands, dressed as an astronaut with a round clear glass space helmet instead of his cap and a small white backpack with a tiny antenna. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body stands upright and slowly rises and sinks as if breathing, the antenna on the backpack wobbles, and the eyes blink on frame 4. Row 2, casting Squirm Slam: the head leans back, the body coils like a spring, then the front half rises and slams down, with golden sparks at the impact in the last two frames. Row 3, casting a generic power: the head tilts up with an excited shout, both little hands stretch toward the sky while a swirl of golden and teal light with tiny gears grows around him and fades. Row 4, getting hurt: the body flinches backward, the helmet glass shows a tiny crack of light, the antenna bends, the body wobbles, and then he recovers. Row 5, celebrating: the body floats up in a slow happy bounce as if in low gravity, a gentle spin, and a soft landing with a small wave.
10.4 Player units (SPRITE, facing right, blue cloth team color)
Every unit is a SPRITE SHEET 5x5 with the same five rows: 1 idle, 2 walk, 3 attack, 4 hurt, 5 defeat. Ids B01 to B15.
B01 · SPRITE SHEET 5x5 · Club Worm (Era 1). Save as assets/sprites/units/p1_club_worm_sheet.png.
A small golden-yellow earthworm soldier with a cream-colored segmented belly, big round dark eyes, a small blue cloth headband as team color, wearing a tiny brown animal-fur tunic and gripping a thick wooden club. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the club rests on the shoulder, the headband tails sway, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm, the body arches up in the middle and stretches forward again, the club bobs on the shoulder. Row 3, attack: the club is raised high behind the head, the body coils back, then swings the club down and forward with a determined grin, and recovers. Row 4, hurt: the body flinches backward, the eyes squeeze shut, the club drops low, the headband flies forward, and the worm recovers. Row 5, defeat: the body wobbles, droops, slides down flat to the ground with the club falling beside him, and ends lying still with tiny stars above his head.
B02 · SPRITE SHEET 5x5 · Slinger Worm (Era 1). Save as assets/sprites/units/p1_slinger_worm_sheet.png.
A small golden-yellow earthworm soldier with a cream-colored segmented belly, big round dark eyes, a small blue cloth headband as team color, wearing a tiny brown animal-fur tunic and holding a leather sling with a round gray stone. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the sling swings a little in the hand, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm, arching up in the middle and stretching forward, the sling bouncing at his side. Row 3, attack: one eye squints, the sling spins in a circle above the head over three frames, then the arm snaps forward and releases the stone, and the body relaxes. Row 4, hurt: the body flinches backward, the eyes squeeze shut, the sling tangles around the hand, and the worm recovers. Row 5, defeat: the body wobbles, droops, slides down flat to the ground with the sling falling beside him, and ends lying still with tiny stars above his head.
B03 · SPRITE SHEET 5x5 · Dino Rider Worm (Era 1). Save as assets/sprites/units/p1_dino_rider_worm_sheet.png.
A small golden-yellow earthworm rider with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, riding on the back of a chubby friendly baby triceratops with a green body, three small horns and a tan frill, holding a short bone lance. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character group, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the dinosaur breathes with its sides rising and falling and its tail swaying, the rider rocks slightly and blinks on frame 4. Row 2, walk loop: the dinosaur stomps with alternating legs, the body bobbing up and down, the rider bouncing on its back and the lance tip bobbing. Row 3, attack: the dinosaur lowers its head and horns and lunges forward, the rider levels the lance and thrusts it ahead, then both settle back. Row 4, hurt: the dinosaur rears back with a surprised face, the rider tilts backward and the lance wobbles, then both recover. Row 5, defeat: the dinosaur sits down with its legs folding, the rider slides off its back, and both end lying still with tiny stars above their heads.
B04 · SPRITE SHEET 5x5 · Shield Bearer Worm (Era 2). Save as assets/sprites/units/p2_shield_bearer_worm_sheet.png.
A small golden-yellow earthworm soldier with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a gold-and-turquoise striped Egyptian headdress, carrying a big round gold shield with a turquoise scarab beetle emblem in front of him and a short bronze spear. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks behind the shield, the headdress tails sway, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the shield held steady in front, the body arching and stretching forward. Row 3, attack: the shield pushes forward in a bash, the spear jabs out over the top edge, then both pull back. Row 4, hurt: the shield takes a hit and shakes, the body is pushed back and the eyes squeeze shut, then the worm braces again. Row 5, defeat: the shield tips forward and falls flat, the worm slides down behind it, and ends lying still with tiny stars above his head.
B05 · SPRITE SHEET 5x5 · Bow Worm (Era 2). Save as assets/sprites/units/p2_bow_worm_sheet.png.
A small golden-yellow earthworm archer with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a white linen Egyptian headcloth with a thin gold band, holding a small curved wooden bow with an arrow. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the bow swings slightly in the hand, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm, arching up and stretching forward, the bow held at his side. Row 3, attack: the arrow is nocked, the string is pulled back with one eye closed over three frames, then the string is released and the bow springs forward, and the body relaxes. Row 4, hurt: the body flinches backward, the bow drops, the eyes squeeze shut, then the worm grabs the bow again. Row 5, defeat: the body wobbles, droops, slides down flat to the ground with the bow falling beside him, and ends lying still with tiny stars above his head.
B06 · SPRITE SHEET 5x5 · Cobra Charmer Worm (Era 2). Save as assets/sprites/units/p2_cobra_charmer_worm_sheet.png.
A small golden-yellow earthworm musician with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a turquoise turban with a small gold jewel and playing a little wooden flute, while a friendly sand-yellow cobra with a gentle smile rises from a woven basket beside him. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character group, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the worm sways side to side while playing, the cobra sways the opposite way in the basket, little musical notes float up, and both blink on frame 4. Row 2, walk loop: the worm moves like an inchworm while carrying the basket with the cobra peeking out and bobbing. Row 3, attack: the flute is blown harder, the cobra rises tall, flares its hood and strikes forward with its mouth open, then returns to the basket. Row 4, hurt: the worm flinches backward and the flute squeaks, the cobra ducks into the basket and peeks out, then both recover. Row 5, defeat: the flute drops, the worm droops and slides down flat, the cobra slumps over the basket rim, and both end still with tiny stars above their heads.
B07 · SPRITE SHEET 5x5 · Knight Worm (Era 3). Save as assets/sprites/units/p3_knight_worm_sheet.png.
A small golden-yellow earthworm knight with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a tiny shiny steel helmet with a blue plume, holding a short sword and a blue-and-white kite shield. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the helmet plume sways, the sword tip bobs, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the shield forward and the sword at his side, the plume bouncing. Row 3, attack: the sword is lifted back, the body coils, then a big diagonal slash comes down and forward with the shield tucked in, and the body recovers. Row 4, hurt: the body flinches backward, the plume bends, the shield lifts and the eyes squeeze shut, then the worm recovers. Row 5, defeat: the helmet slides over the eyes, the worm droops and slides down flat, the sword and shield fall beside him, and he ends lying still with tiny stars above his head.
B08 · SPRITE SHEET 5x5 · Crossbow Worm (Era 3). Save as assets/sprites/units/p3_crossbow_worm_sheet.png.
A small golden-yellow earthworm archer with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a brown hood and holding a wooden crossbow with a bolt loaded. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the hood tip sways, the crossbow rests in the arms, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the crossbow held up in front, the hood bobbing. Row 3, attack: the crossbow rises to eye level, one eye closes to aim, the trigger is squeezed, the crossbow kicks back as the bolt flies off, and the body relaxes. Row 4, hurt: the body flinches backward, the hood is pushed down over the eyes, the crossbow wobbles, then the worm recovers. Row 5, defeat: the worm droops and slides down flat to the ground with the crossbow falling beside him, and ends lying still with tiny stars above his head.
B09 · SPRITE SHEET 5x5 · Wizard Worm (Era 3). Save as assets/sprites/units/p3_wizard_worm_sheet.png.
A small golden-yellow earthworm wizard with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing a tall pointy deep-blue wizard hat with gold stars and holding a wand topped with a glowing golden star, sparkles floating around, with a wise and slightly dizzy smile. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the hat tip flops side to side, the wand star pulses and sparkles twinkle, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the wand held up, the hat bobbing and a few sparkles trailing behind. Row 3, attack: the wand is lifted high, swirled in a circle, then pointed forward and a golden star bolt bursts from the tip, and the body recoils slightly. Row 4, hurt: the body flinches backward, the hat flops over the eyes, sparkles scatter, then the worm straightens the hat. Row 5, defeat: the wand star flickers out, the worm droops and slides down flat with the hat covering his face, and ends lying still with tiny stars above his head.
B10 · SPRITE SHEET 5x5 · Gear Gunner Worm (Era 4). Save as assets/sprites/units/p4_gear_gunner_worm_sheet.png.
A small golden-yellow earthworm gunner with a cream-colored segmented belly, big round dark eyes and a small blue cloth headband as team color, wearing brass goggles on his forehead and a small leather vest, holding a copper steam rifle. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, small puffs of white steam rise from the rifle, the goggles glint, and the eyes blink on frame 4. Row 2, walk loop: the worm moves like an inchworm with the rifle on his shoulder, the goggles bouncing. Row 3, attack: the rifle is raised and aimed with a cocky grin, a puff of white steam shoots out with a recoil kick, then the rifle is lowered. Row 4, hurt: the body flinches backward, the goggles slip down over the eyes, the rifle sputters steam, then the worm recovers. Row 5, defeat: the rifle drops, the worm droops and slides down flat, steam fizzles out, and he ends lying still with tiny stars above his head.
B11 · SPRITE SHEET 5x5 · Boiler Tank Worm (Era 4). Save as assets/sprites/units/p4_boiler_tank_worm_sheet.png.
A small golden-yellow earthworm driver with big round dark eyes and a small blue cloth headband as team color, peeking out of the hatch of a chunky round copper-and-brass steam tank with rivets, a tall chimney puffing white steam, small treads and a stubby cannon. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same vehicle with its driver, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the tank body shudders gently, steam puffs rise from the chimney, and the driver blinks on frame 4. Row 2, drive loop: the treads roll, the tank bounces up and down as it moves, the chimney puffs faster, the driver holds on. Row 3, attack: the cannon barrel slides back, a flash and a puff of smoke shoot out of the muzzle, the whole tank rocks backward, then settles. Row 4, hurt: the tank rocks back, the driver ducks into the hatch and peeks out, a few rivets pop and sparks fly, then it recovers. Row 5, defeat: the chimney bends, steam leaks out in puffs, the tank tilts and sinks, the driver slumps out of the hatch, and it ends still with tiny stars above.
B12 · SPRITE SHEET 5x5 · Balloon Bomber Worm (Era 4). Save as assets/sprites/units/p4_balloon_bomber_worm_sheet.png.
A small golden-yellow earthworm bomber with a cream-colored segmented belly, big round dark eyes, a small blue cloth headband as team color and brass goggles, hanging from a small wicker basket under a patched teal-and-cream hot-air balloon, holding a round black bomb with a lit sparking fuse. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same balloon and worm, side view facing right, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the balloon floats up and down gently, the basket sways below it, the bomb fuse sparkles, and the worm blinks on frame 4. Row 2, fly loop: the balloon tilts forward and drifts, the basket swings behind it, the ropes stretch and relax, the worm grins. Row 3, attack: the worm lifts the bomb over the basket edge, winds up, drops it with a mischievous grin, and the balloon bobs upward lighter. Row 4, hurt: the balloon squashes sideways, the basket swings wildly, a small patch rips and puffs of air escape, the worm holds on and recovers. Row 5, defeat: the balloon deflates and wrinkles, the basket drops down, the worm waves a tiny white flag, and everything ends still on the ground with tiny stars above.
B13 · SPRITE SHEET 5x5 · Laser Blade Worm (Era 5). Save as assets/sprites/units/p5_laser_blade_worm_sheet.png.
A small golden-yellow earthworm warrior with big round dark eyes and a small blue cloth headband as team color, wearing a sleek white-and-teal helmet with a glowing cyan visor and light armor plates on his body, wielding a glowing cyan laser sword. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body gently rises and sinks, the laser sword hums and its glow pulses, the visor glints, and the eyes blink on frame 4. Row 2, dash loop: the worm moves in quick forward arches with the sword held back, a faint cyan trail behind him. Row 3, attack: the body coils back, the sword sweeps in a bright cyan arc from above to the front, the body lunges forward, and then pulls back. Row 4, hurt: the body flinches backward, the visor flickers, the armor plates rattle, then the worm raises the sword again. Row 5, defeat: the sword light flickers out, the worm droops and slides down flat, the visor goes dark, and he ends lying still with tiny stars above his head.
B14 · SPRITE SHEET 5x5 · Mecha Worm (Era 5). Save as assets/sprites/units/p5_mecha_worm_sheet.png.
A small golden-yellow earthworm pilot with big round dark eyes and a small blue cloth headband as team color, sitting in the glass cockpit dome of a chunky white-and-blue walking mech with two stubby legs, rounded armor plates, glowing cyan joints and a small arm cannon. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same mech with its pilot, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the mech sinks and rises slightly on its legs, the cyan joints pulse, the arm cannon swings a little, and the pilot blinks on frame 4. Row 2, walk loop: the mech steps with alternating stubby legs, the body bobbing, the pilot bouncing in the dome. Row 3, attack: the arm cannon lifts and glows, a bright cyan shot fires with a recoil kick backward, and the mech steadies. Row 4, hurt: the mech staggers backward, the cockpit dome flashes, sparks fly from one joint, then it steadies. Row 5, defeat: the joint lights go out one by one, the legs fold, the mech sits down and tilts, the pilot slumps in the dome, and it ends still with tiny stars above.
B15 · SPRITE SHEET 5x5 · Time Medic Worm (Era 5). Save as assets/sprites/units/p5_time_medic_worm_sheet.png.
A small golden-yellow earthworm medic with big round dark eyes and a small blue cloth headband as team color, riding on top of a round white-and-teal hovering drone that holds a glowing golden-teal healing orb, wearing a tiny backpack marked with a gear symbol, with a calm kind smile. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same drone with its medic, side view facing right, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the drone hovers up and down, the healing orb pulses softly, the medic blinks on frame 4. Row 2, fly loop: the drone tilts forward and glides, a thin teal trail behind it, the backpack bouncing. Row 3, heal: the medic raises both arms, the orb grows bright and releases a ring of golden-teal light that expands outward, then the orb shrinks back. Row 4, hurt: the drone is knocked backward and spins slightly, the orb flickers, the medic holds on and recovers. Row 5, defeat: the orb goes dark, the drone sputters and sinks to the ground, the medic slides off, and everything ends still with tiny stars above.
10.5 Enemy units (SPRITE, facing left, red cloth accents)
Every enemy is a SPRITE SHEET 5x5 facing left with the same five rows: 1 idle, 2 walk (or fly), 3 attack, 4 hurt, 5 defeat. Ids C01 to C15.
C01 · SPRITE SHEET 5x5 · Ant Clubber (Era 1). Save as assets/sprites/enemies/e1_ant_clubber_sheet.png.
A small black ant warrior with big round eyes and a comically angry snarl, a red cloth band tied around its head as team color, wearing a rough leather loincloth and carrying a heavy stone club. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body bobs up and down, the antennae twitch, the club rests on the shoulder, and the eyes blink on frame 4. Row 2, walk loop: the six legs step in alternating pairs, the body bobs, the club bounces on the shoulder. Row 3, attack: the club is lifted back over the head, the body leans back, then the club swings down and forward with a snarl, and the ant recovers. Row 4, hurt: the body flinches backward, the eyes squeeze shut, the antennae flatten, the club slips, and the ant recovers. Row 5, defeat: the legs wobble, the ant flips onto its back with the legs curled up and the club falling beside it, and ends still with tiny stars above.
C02 · SPRITE SHEET 5x5 · Ant Spitter (Era 1). Save as assets/sprites/enemies/e1_ant_spitter_sheet.png.
A small black ant with big round eyes and puffed cheeks, a red cloth band tied around its head as team color, holding a long bone blowpipe to its mouth with a glowing drop of green acid at the tip. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body bobs up and down, the antennae twitch, the green drop wobbles at the tip of the blowpipe, and the eyes blink on frame 4. Row 2, walk loop: the six legs step in alternating pairs with the blowpipe held at the side. Row 3, attack: the cheeks puff up, the blowpipe lifts to the mouth, a green acid glob shoots out with a recoil, and the cheeks deflate. Row 4, hurt: the body flinches backward, the blowpipe jerks, the cheeks deflate with a squeak, and the ant recovers. Row 5, defeat: the legs wobble, the ant flips onto its back with the blowpipe falling beside it, and ends still with tiny stars above.
C03 · SPRITE SHEET 5x5 · Stone Beetle (Era 1). Save as assets/sprites/enemies/e1_stone_beetle_sheet.png.
A chunky brown beetle with a thick shell made of gray rock slabs with patches of green moss, small grumpy eyes, and a red cloth band tied around one horn as team color. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the heavy shell rises and sinks as it breathes, the horn tilts, and the eyes blink on frame 4. Row 2, walk loop: the short legs stomp slowly one after another and the shell rocks side to side like a walking boulder. Row 3, attack: the beetle rears back, lowers the horn, and rams forward with a head butt, then pulls back. Row 4, hurt: the shell cracks with a small dust puff, the body is knocked back, the eyes squeeze shut, and it recovers. Row 5, defeat: the legs give way, the body drops, the shell breaks into slabs, and it ends flat on the ground with tiny stars above.
C04 · SPRITE SHEET 5x5 · Scarab Soldier (Era 2). Save as assets/sprites/enemies/e2_scarab_soldier_sheet.png.
A golden scarab beetle soldier with a shiny turquoise-edged shell, big round eyes, a red cloth sash across its body as team color, wearing a small gold helmet and carrying a curved bronze blade. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body bobs, the blade tip sways, the shell glints, and the eyes blink on frame 4. Row 2, march loop: the legs step in alternating pairs with the blade held up, the body bobbing proudly. Row 3, attack: the blade is raised back, the body leans, then a diagonal slash comes down and forward, and the beetle recovers. Row 4, hurt: the body flinches backward, the helmet tilts, the blade wobbles, and it recovers. Row 5, defeat: the legs wobble, the beetle falls onto its shell with the legs in the air and the blade falling beside it, and ends still with tiny stars above.
C05 · SPRITE SHEET 5x5 · Locust Archer (Era 2). Save as assets/sprites/enemies/e2_locust_archer_sheet.png.
A slender green-and-brown locust with long bent back legs and big round eyes, a red cloth band tied around its head as team color, holding a small curved bow with an arrow, with a sly smirk. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body crouches and rises slightly, the antennae twitch, the back legs flex, and the eyes blink on frame 4. Row 2, hop loop: the locust crouches, springs forward in a small hop with the back legs extended, and lands. Row 3, attack: the arrow is nocked, the string pulled back with a smirk over three frames, then released as the bow springs forward, and the body relaxes. Row 4, hurt: the body flinches backward, the bow drops, the antennae flatten, and it grabs the bow again. Row 5, defeat: the long legs fold, the locust topples sideways with the bow beside it, and ends still with tiny stars above.
C06 · SPRITE SHEET 5x5 · Mummy Moth (Era 2). Save as assets/sprites/enemies/e2_mummy_moth_sheet.png.
A fluffy beige moth with soft dusty wings loosely wrapped in old linen bandages, big sleepy round eyes, a red cloth ribbon tied on one wing as team color, holding a fresh roll of bandage in one leg with a gentle caring expression. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the wings flutter slowly up and down, the body hovers, a loose bandage end sways, and the eyes blink on frame 4. Row 2, fly loop: the wings flap in a full cycle while the body glides forward and the bandage trails behind. Row 3, heal: the moth unrolls the bandage, swirls it in a circle, and a soft golden glow ring expands outward, then the bandage rolls back. Row 4, hurt: the wings fold in, the body is pushed backward, bandages flutter loose, and it recovers. Row 5, defeat: the wings stop, the bandages unwind, the moth drifts down and lands flat, and ends still with tiny stars above.
C07 · SPRITE SHEET 5x5 · Beetle Knight (Era 3). Save as assets/sprites/enemies/e3_beetle_knight_sheet.png.
A sturdy dark-brown beetle knight with a shiny steel helmet topped with a red plume, steel shoulder plates, big round eyes, carrying a long lance and a small shield with a red emblem. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body rises and sinks as it breathes, the plume sways, the lance tip bobs, and the eyes blink on frame 4. Row 2, march loop: the legs step in alternating pairs, the shield held forward, the plume bouncing. Row 3, attack: the lance is pulled back, the body leans, then it thrusts the lance forward with a stern look and pulls back. Row 4, hurt: the body flinches backward, the shield jerks up, the plume bends, and it recovers. Row 5, defeat: the helmet slides over the eyes, the knees give way, the beetle falls onto its side with the lance and shield beside it, and ends still with tiny stars above.
C08 · SPRITE SHEET 5x5 · Dung Catapult (Era 3). Save as assets/sprites/enemies/e3_dung_catapult_sheet.png.
A stout dung beetle with big round eyes pushing a small wooden catapult on two wheels that is loaded with a round brown ball, a red banner flag attached to the catapult as team color, wearing a tiny leather cap and a mischievous grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same beetle and catapult, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the characters. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the beetle breathes, the banner flaps, the arm of the catapult rocks slightly, and the eyes blink on frame 4. Row 2, push loop: the beetle pushes the catapult forward with its legs stepping, the wheels turning, the banner flapping. Row 3, attack: the beetle pulls a lever, the catapult arm swings forward and flings the ball, the whole catapult shakes, and it resets. Row 4, hurt: the catapult is knocked backward, a wheel wobbles, the beetle's cap flies up and it recovers. Row 5, defeat: a wheel falls off, the catapult tips over, the beetle tumbles flat beside it, and everything ends still with tiny stars above.
C09 · SPRITE SHEET 5x5 · Hornet Scout (Era 3, flying). Save as assets/sprites/enemies/e3_hornet_scout_sheet.png.
A small yellow-and-black striped hornet flying with blurry translucent wings, big round determined eyes, wearing a tiny leather helmet and a red cloth scarf as team color, holding a small spear pointed forward. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, hover loop: the wings buzz in blurry up and down positions, the body bobs slightly, the scarf flutters, and the eyes blink on frame 4. Row 2, flight loop: the body tilts forward, the wings flap fast, the scarf streams behind, the spear points ahead. Row 3, attack: the hornet pulls back, then dives forward and thrusts the spear, and swings back up. Row 4, hurt: the body is knocked backward and spins slightly, the wings stutter, the scarf whips, and it recovers. Row 5, defeat: the wings stop, the helmet falls off, the hornet spirals downward and lands flat, and ends still with tiny stars above.
C10 · SPRITE SHEET 5x5 · Cog Roach (Era 4). Save as assets/sprites/enemies/e4_cog_roach_sheet.png.
A clockwork cockroach with brass body plates, visible gears and rivets on its back, big round eyes, a red cloth band tied around its head as team color, carrying a big iron wrench over its shoulder with a cheeky grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the back gears turn slowly, the body bobs, the antennae twitch, and the eyes blink on frame 4. Row 2, run loop: the six legs run in fast alternating pairs, the body leaning forward, the wrench bouncing on the shoulder. Row 3, attack: the wrench is lifted behind the head, the body coils, then the wrench swings down and forward and the roach recovers. Row 4, hurt: the body flinches backward, a gear pops off, sparks fly, and it recovers. Row 5, defeat: the gears slow and stop, the legs fold, the roach flips onto its back with the wrench falling beside it, and ends still with tiny stars above.
C11 · SPRITE SHEET 5x5 · Spark Fly (Era 4, flying). Save as assets/sprites/enemies/e4_spark_fly_sheet.png.
A mechanical firefly with a copper body, tiny propeller wings, big round eyes and a glass-lantern abdomen crackling with blue-white electricity, a red cloth ribbon tied to one antenna as team color, with a playful grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, hover loop: the propellers spin in blurry positions, the body bobs, the lantern glow pulses, and the eyes blink on frame 4. Row 2, flight loop: the body tilts forward, the propellers spin fast, the ribbon streams behind, small sparks trail. Row 3, attack: the lantern glows brighter, the body curls back, then a bolt of blue-white electricity zaps forward from the lantern, and the glow dims. Row 4, hurt: the body is knocked backward, the lantern flickers, sparks fly, and it recovers. Row 5, defeat: the lantern goes dark, the propellers slow and stop, the firefly drops to the ground and ends still with tiny stars above.
C12 · SPRITE SHEET 5x5 · Clank Crab (Era 4). Save as assets/sprites/enemies/e4_clank_crab_sheet.png.
A heavy steam-powered crab with riveted iron shell plates, brass pipes releasing puffs of white steam, two big riveted claws, small angry round eyes on stalks and a small red flag on its back as team color. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the claws open and close slowly, the steam puffs from the pipes, the eye stalks wobble, and the eyes blink on frame 4. Row 2, scuttle loop: the legs step in quick alternating pairs, the body shakes from side to side, the steam puffs faster. Row 3, attack: both claws are lifted high, then slammed down and forward with a clank, and the crab pulls back. Row 4, hurt: the shell dents with a spark, the body is knocked backward, the eye stalks droop, and it recovers. Row 5, defeat: a pipe bursts with steam, the legs fold, the crab sinks flat and tips over, and ends still with tiny stars above.
C13 · SPRITE SHEET 5x5 · Laser Bug (Era 5). Save as assets/sprites/enemies/e5_laser_bug_sheet.png.
A round armored beetle robot in dark gunmetal gray with a glowing red visor, a small laser cannon mounted on its back, thin red stripes on its shell as team color and six small legs, with a menacing but cute look. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body hovers just above the ground rising and sinking, the red visor pulses, the cannon on the back rotates slightly, and the visor blinks on frame 4. Row 2, walk loop: the six legs step in alternating pairs, the body bobbing, the visor glowing steadily. Row 3, attack: the cannon on the back swivels forward, charges with a growing red glow, fires a red bolt with a recoil kick, and cools down. Row 4, hurt: the body is knocked backward, the visor flickers white, a leg twitches, and it recovers. Row 5, defeat: the visor goes dark, the cannon droops, the legs fold, the shell opens a little with sparks, and it ends still with tiny stars above.
C14 · SPRITE SHEET 5x5 · Drone Fly (Era 5, flying). Save as assets/sprites/enemies/e5_drone_fly_sheet.png.
A hovering robotic fly with a dark gray metal body, large glassy lens eyes, thin transparent propeller wings, tiny claws and a small blinking red light on its head as team color, with a mischievous look. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same height in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, hover loop: the propeller wings blur in different positions, the body bobs slightly, the red light blinks, and the lens eyes flash on frame 4. Row 2, flight loop: the body tilts forward, the wings spin fast, the claws tuck under the body. Row 3, attack: the drone pulls back, dives forward with the claws extended to grab and swipe, and returns up. Row 4, hurt: the body is knocked backward and spins slightly, the red light flickers, a wing stutters, and it recovers. Row 5, defeat: the wings stop, the light goes dark, the drone drops to the ground with a bounce, and ends still with tiny stars above.
C15 · SPRITE SHEET 5x5 · Mecha Beetle (Era 5). Save as assets/sprites/enemies/e5_mecha_beetle_sheet.png.
A huge armored rhinoceros-beetle robot in dark gunmetal gray with glowing red joints, thick sturdy legs, a big horn that doubles as a cannon and a small red emblem on its shell as team color, imposing but still cute. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the body rises and sinks heavily as it breathes, the red joints pulse, the horn tilts, and the eyes blink on frame 4. Row 2, stomp loop: the thick legs stomp one after another, the body rocks side to side and the horn bobs. Row 3, attack: the horn lowers and glows red, a charged shot fires from the horn with a strong recoil that pushes the body backward, and it settles. Row 4, hurt: a plate cracks with sparks, the body is knocked backward, the joints flicker, and it recovers. Row 5, defeat: the red joints go out one by one, the legs fold, the body crashes down with a dust puff, and it ends still with tiny stars above.
10.6 Bosses (SPRITE, facing left)
Every boss is a SPRITE SHEET 5x5 facing left with the same five rows: 1 idle, 2 walk, 3 attack, 4 hurt, 5 defeat. Bosses fill most of each cell.
D01 · SPRITE SHEET 5x5 · Rexy the T-Rex (Era 1 boss). Save as assets/sprites/bosses/b1_rexy_sheet.png.
Rexy, a big chubby green T-Rex with a cream belly, comically tiny arms, a huge goofy toothy grin and small round eyes, a red cloth bandana tied around his neck and a necklace of colorful stones. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the belly rises and sinks as he breathes, the tail sways, the tiny arms twitch, and the eyes blink on frame 4. Row 2, walk loop: heavy stomps with alternating legs, the body bobbing, the tail swinging and the necklace bouncing. Row 3, attack: he rears back, takes a big breath, then lunges forward and chomps with a loud roar, the tail swinging the other way. Row 4, hurt: the head jerks back, the eyes squeeze shut, the tiny arms flail, the body staggers, and he recovers. Row 5, defeat: the legs wobble, he sits down with a thud, topples onto his side with his tongue out, and ends still with tiny stars above.
D02 · SPRITE SHEET 5x5 · Pharaoh Scarab (Era 2 boss). Save as assets/sprites/bosses/b2_pharaoh_scarab_sheet.png.
The Pharaoh Scarab, a giant golden scarab beetle with a shiny turquoise-and-gold shell, a tall striped royal pharaoh headdress, big dramatic eyes, a red cloth cape draped over his back, holding a golden crook and flail, wearing a solemn proud grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the shell glints, the cape sways, the crook and flail hang still, and the eyes blink on frame 4. Row 2, walk loop: the legs step in slow alternating pairs, the cape flowing behind, the headdress bobbing. Row 3, attack: the flail is raised over the head, spun once, then slammed down and forward while golden dust bursts from the impact. Row 4, hurt: the headdress tips, the body is pushed back, the shell shows a small crack, and he straightens. Row 5, defeat: the headdress falls off, the legs fold, the scarab sinks flat with the cape covering him, and ends still with tiny stars above.
D03 · SPRITE SHEET 5x5 · Sir Sizzle the Dragon (Era 3 boss). Save as assets/sprites/bosses/b3_sir_sizzle_sheet.png.
Sir Sizzle, a chubby red-orange dragon with small leathery wings, a cream belly and big round eyes, wearing a dented tin knight helmet that is too small for his head, little curls of smoke rising from his nostrils and a red banner tied to his tail. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: smoke curls rise from the nostrils, the helmet wobbles, the wings twitch, the banner sways, and the eyes blink on frame 4. Row 2, walk loop: clumsy waddling steps with alternating legs, the wings flapping slightly and the helmet bouncing. Row 3, attack: he inhales so the belly swells, the head rears back, then he breathes a big cartoon fireball forward with the helmet flying up, and the belly shrinks. Row 4, hurt: the helmet is knocked over his eyes, the body is pushed back, the wings flare, and he straightens it. Row 5, defeat: the helmet clangs off, the legs give way, he sits then flops backward with a puff of smoke, and ends still with tiny stars above.
D04 · SPRITE SHEET 5x5 · The Clockwork Queen (Era 4 boss). Save as assets/sprites/bosses/b4_clockwork_queen_sheet.png.
The Clockwork Queen, a large mechanical spider with a brass-and-copper body, a small golden crown, visible gears and rivets, six thin jointed legs, a glass-dome abdomen full of swirling white steam, glowing red eyes and a red silk sash across her body. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the steam swirls in the dome, the gears turn, the legs shift slightly, and the red eyes blink on frame 4. Row 2, walk loop: the thin legs step in alternating groups, the body rising and sinking, the sash fluttering. Row 3, attack: the front legs rise, the dome glows and the queen releases a burst of hot steam forward while the front legs stab down. Row 4, hurt: the crown tilts, the body is pushed backward, gears spit out, sparks fly, and she recovers. Row 5, defeat: the glow in the dome fades, the legs fold one by one, the crown rolls off, the body sinks with a puff of steam, and she ends still with tiny stars above.
D05 · SPRITE SHEET 5x5 · Count Magpie 3000 (Era 5 final boss). Save as assets/sprites/bosses/b5_count_magpie_3000_sheet.png.
Count Magpie 3000, a giant mechanical magpie with chrome-and-indigo plating, glowing cyan eyes, a metal top hat, a gold monocle, wings made of shiny metal blades and a red cape, clutching a glowing golden Chrono Core shard in one claw, wearing a smug grin. Storybook watercolor sprite sheet with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. The image is a strict grid of 5 columns by 5 rows, 25 equal square cells, each holding exactly one full-body copy of the same character filling most of the cell, side view facing left, with identical size, identical proportions and the same standing line in every cell, centered in its cell with a small empty margin so nothing touches the cell edges. The whole background is one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image. Each row is one animation drawn as 5 consecutive frames from left to right. Row 1, idle loop: the chest puffs up and down, the blade wings flex, the shard in the claw glows and pulses, the cape sways, and the eyes blink on frame 4. Row 2, walk loop: proud strutting steps with alternating legs, the head bobbing, the cape flowing behind. Row 3, attack: the wings spread wide, the shard glows brighter, the claw swings forward and releases a golden-cyan time wave, and the wings fold back. Row 4, hurt: the top hat flies off, the monocle flashes, the body is pushed backward, sparks fly, and he recovers. Row 5, defeat: the cyan eyes flicker out, the wings droop, the shard falls from the claw, the body tips over with a shower of sparks, and he ends still with tiny stars above.
10.7 Bases (SPRITE)
Player bases open to the right and use blue accents. Enemy bases open to the left and use red accents.
E01 · SPRITE · Player base, Era 1. Save as assets/sprites/bases/base_p1.png
A cozy prehistoric worm burrow base: a big round dirt mound with a dark round hole as the entrance, a thatched leaf roof on top, a small bone fence, a little campfire, big green ferns at its sides and a small blue cloth flag on a wooden stick. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small patch of ground directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
E02 · SPRITE · Player base, Era 2. Save as assets/sprites/bases/base_p2.png
A small sandstone pyramid-shaped worm burrow base with a dark arched doorway, simple carved hieroglyph patterns, a turquoise gem at the peak, a blue banner hanging from the top and a little palm tree beside it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small patch of sand directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
E03 · SPRITE · Player base, Era 3. Save as assets/sprites/bases/base_p3.png
A small cozy stone castle tower with tiny battlements, a sturdy wooden gate, ivy climbing the walls, an arched window glowing with warm candlelight and a blue-and-white banner on a pole at the top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small patch of grass directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
E04 · SPRITE · Player base, Era 4. Save as assets/sprites/bases/base_p4.png
A brass-and-copper steam fortress with two round riveted towers, tall chimneys puffing white steam, big turning gears on the walls, a glowing furnace-door entrance and a blue flag on top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small iron platform directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
E05 · SPRITE · Player base, Era 5. Save as assets/sprites/bases/base_p5.png
A futuristic white-and-teal glass dome base with a glowing cyan ring around it, an antenna topped with a blue light, a small landing pad, a round sliding door entrance and a few small floating panels around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing right, centered with a wide empty margin, with only a small floating metal platform directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
E06 · SPRITE · Enemy base, Era 1. Save as assets/sprites/bases/base_e1.png
A tall brown anthill fortress with a dark tunnel entrance, sharp wooden and bone spikes around it, simple tribal paint marks on the dirt and a red cloth flag on a bone pole at the top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small patch of ground directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
E07 · SPRITE · Enemy base, Era 2. Save as assets/sprites/bases/base_e2.png
A golden scarab temple with sandstone columns, a big golden scarab beetle statue on its roof, a dark entrance with a stepped front and red banners hanging at both sides. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small patch of sand directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
E08 · SPRITE · Enemy base, Era 3. Save as assets/sprites/bases/base_e3.png
A dark slate-gray castle with tall pointed towers, a heavy iron gate, small flickering torches and red banners with a beetle emblem hanging from the walls, looking grumpy but still cute. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. One single building, side view with the entrance facing left, centered with a wide empty margin, with only a small patch of rocky ground directly under it, drawn on a perfectly flat solid magenta background (#FF00FF) with no cast shadow, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the subject. Square 1:1 image.
