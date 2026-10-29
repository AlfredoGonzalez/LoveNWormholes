# Eras 2-4: Antiguo Egipto, Edad Media, Lejano Oeste

Usa la plantilla base y la biblia de estilo (`00-style-bible.md`). Mismos tamaños y convención de archivos que en `01-characters.md`:
`public/assets/characters/<id>/idle_01.png` (mínimo viable: 1 imagen por personaje; luego walk/attack/die).
Paletas por era en la biblia de estilo. **Los ids de abajo son EXACTAMENTE los nombres de carpeta que el juego busca.**

## Héroe con atuendo de cada era
El juego usa `hero_<era>` si existe; si no, cae a `hero`. Mantén a Gusanito reconocible (rosa-salmón, mismos ojos) y cambia solo el atuendo. Usa tu hoja de referencia de Gusanito como imagen de referencia.
| id | Sujeto |
|---|---|
| `hero_prehistoria` | Gusanito con taparrabos de leopardo y diadema de hueso (ya definido) |
| `hero_egipto` | Gusanito con tocado nemes azul/dorado, collar ancho dorado y lápiz de ojos egipcio |
| `hero_medieval` | Gusanito con casco de caballero pequeño con pluma, capa roja, espada de juguete |
| `hero_oeste` | Gusanito con sombrero vaquero, pañuelo rojo, estrellita de sheriff |

## Antiguo Egipto (`egipto`)
**Aliados**
| id | Sujeto |
|---|---|
| `spear` | `small golden-tan worm warrior with a long spear, linen kilt, kohl eyes, brave face` |
| `archer` | `teal worm archer with a bow and papyrus quiver, eye-of-Horus necklace, focused look` |
| `sarcophagus` | `sturdy worm inside a half-open golden sarcophagus used as armor, only eyes and arms visible, grumpy cute` |
| `pharaoh` | `blue worm pharaoh with tall double crown, golden crook and flail, regal and slightly pompous` |
**Enemigos**
| id | Sujeto |
|---|---|
| `scarab` | `angry dark-blue scarab beetle with tiny gold wings, little mandibles, cute but fierce` |
| `mummy` | `bandaged mummy with one eye peeking, arms stretched forward, funny trailing bandage` |
| `scarabking` (jefe, 1024 px) | `giant golden scarab king boss, jeweled shell, tiny crown, glowing eyes, imposing yet comical` |
**Fondo**: `far` cielo dorado con sol grande y pirámides lejanas; `mid` palmeras, obeliscos, dunas; `near` arena y piedras con jeroglíficos. Base aliada: `a cozy worm house made of a papyrus reed hut with heart flag`; base enemiga: `small pyramid with a glowing red eye at the top`.

## Edad Media (`medieval`)
**Aliados**
| id | Sujeto |
|---|---|
| `sword` | `grey worm squire with a small sword and wooden shield, tiny chainmail cap` |
| `crossbow` | `green worm crossbowman in a hood, big crossbow, cheeky smile` |
| `knight` | `big sturdy worm in full plate armor with a tower shield, visor slit showing eyes` |
| `king` | `red-robed worm king with a golden crown and ermine cape, holding a scepter, proud` |
**Enemigos**
| id | Sujeto |
|---|---|
| `goblin` | `sneaky green goblin with a dagger and a stolen coin bag, big ears, mischievous grin` |
| `skeleton` | `dancing skeleton with a rusty sword, floppy pose, funny not scary` |
| `dragon` (jefe, 1024 px) | `big sleepy dragon boss, brown-orange scales, half-closed eyes, small wings, tiny smoke puffs, cute and imposing` |
**Fondo**: `far` cielo azul grisáceo con castillo y colinas; `mid` árboles y muralla; `near` hierba, flores y piedras. Base aliada: `small stone cottage with a banner and heart`; enemiga: `dark tower with a purple flag and glowing windows`.

## Lejano Oeste (`oeste`)
**Aliados**
| id | Sujeto |
|---|---|
| `cowboy` | `brown worm cowboy with a lasso and hat, bandana, determined` |
| `sharp` | `dark-teal worm gunslinger with a revolver, poncho, squinting eyes` |
| `barrel` | `sturdy worm wearing a wooden barrel as armor, only eyes and feet visible, grumpy cute` |
| `sheriff` | `golden worm sheriff with a big star badge, long mustache, cowboy hat` |
**Enemigos**
| id | Sujeto |
|---|---|
| `coyote` | `bandit coyote with a mask and bandana, sneaky grin, small pistol` |
| `outlaw` | `outlaw cactus with a tiny hat and angry face, spiky arms` |
| `scorpion` (jefe, 1024 px) | `giant scorpion boss wearing a sheriff hat and star badge, big claws, purple-maroon shell, comical menace` |
**Fondo**: `far` atardecer naranja con mesetas; `mid` cactus, vagones, torre de agua; `near` arena, piedras y arbustos rodantes. Base aliada: `wooden saloon-style house with heart sign`; enemiga: `rickety jail/outlaw hideout with wanted posters`.

## Aliado fantasma (anomalía de la Edad Media)
Un caballero del futuro que aparece por 12 s. Se usa uno por era (`ghost_prehistoria`, `ghost_egipto`, `ghost_medieval`, `ghost_oeste`); con una sola imagen en `ghost_medieval` basta por ahora.
`translucent ghost-knight worm, glowing cyan-white, futuristic armor with visor and small energy sword, wispy tail, friendly`. El juego ya lo dibuja semitransparente.

## Efectos de las anomalías (PNG con transparencia, opcionales por ahora)
| Archivo | Sujeto |
|---|---|
| `assets/fx/meteor.png` | `flaming meteor falling diagonally with fire trail, cartoon, 256×256` + `assets/fx/explosion.png` `cartoon impact explosion` 256×256 |
| `assets/fx/sandstorm.png` | `swirling sand gusts overlay, semi-transparent, vertical, 1080×1920` |
| `assets/fx/tumbleweed.png` | `rolling tumbleweed, cute, 128×128` |
| `assets/fx/ghost_portal.png` | `small purple-cyan wormhole opening, sparkles, 256×256` |

## Mapa de eras (opcional)
Iconos de era 256×256 para el selector: `egipto` (pirámide), `medieval` (castillo), `oeste` (sombrero vaquero), `prehistoria` (huevo de dinosaurio) con candado sobreimpreso aparte (`assets/ui/lock.png`).

## Resumen de archivos nuevos que el juego ya busca
`characters/{hero_prehistoria,hero_egipto,hero_medieval,hero_oeste}`, `characters/{spear,archer,sarcophagus,pharaoh,scarab,mummy,scarabking}`, `characters/{sword,crossbow,knight,king,goblin,skeleton,dragon}`, `characters/{cowboy,sharp,barrel,sheriff,coyote,outlaw,scorpion}`, `characters/ghost_<era>`, `backgrounds/{egipto,medieval,oeste}/far.png` — todos como `idle_01.png` dentro de su carpeta (salvo los fondos).
