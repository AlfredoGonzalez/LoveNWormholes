# Fase D: Tienda, cápsulas y reliquias

Arte de cápsulas y reliquias (12 iconos, 3 insignias de rareza, cápsula abierta), tarjetas de la Tienda y las 3 skins del héroe (cada skin = referencia + 5 animaciones). Va antes que las eras avanzadas porque la economía y la tienda se juegan desde la Era 1.

**40 prompts** (3 referencias de personaje, 15 hojas de animación, 22 imágenes o sprites estáticos). Antes de empezar lee `README.md` (convenciones, tamaños, qué hacer si la cuadrícula sale mal). Genera cada referencia primero y luego sus animaciones en el mismo chat de Gemini, adjuntando `<id>_ref.png`.

---
### D-001 · Cápsula abierta (resultado de apertura)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** La cápsula del tiempo abierta por la mitad con un estallido de luz dorada, engranajes y estrellas. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Animación/pantalla de apertura de cápsula (capsule_screen.gd) tras tocar 'Open'. NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_capsule_open.png`
- **Origen:** nuevo (no estaba en el original)

```text
The glossy egg-shaped time capsule with a golden half and a teal half, cracked open along its seam with a burst of warm golden light, tiny gears, small stars and sparkles flying out of it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-002 · Insignia de rareza: común
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Medalla verde hoja sencilla (rareza común). (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Insignia de rareza en la lista de reliquias (relics_screen.gd, hoy un cuadro de color 64x64) y en las filas de resultado de cápsula (capsule_screen.gd, 72x56). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_rarity_common.png`
- **Origen:** nuevo (no estaba en el original)

```text
A rarity badge for a game collection: a round leaf-green medallion with a plain smooth rim and a single small white sparkle, no letters and no symbols other than described. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-003 · Insignia de rareza: rara
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Medalla azul turquesa con borde facetado plateado (rareza rara). (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Insignia de rareza en la lista de reliquias (relics_screen.gd, hoy un cuadro de color 64x64) y en las filas de resultado de cápsula (capsule_screen.gd, 72x56). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_rarity_rare.png`
- **Origen:** nuevo (no estaba en el original)

```text
A rarity badge for a game collection: a round turquoise-blue medallion with a faceted silver rim and two bright white sparkles, no letters and no symbols other than described. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-004 · Insignia de rareza: épica
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Medalla índigo con borde dorado grueso y estrella dorada (rareza épica). (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Insignia de rareza en la lista de reliquias (relics_screen.gd, hoy un cuadro de color 64x64) y en las filas de resultado de cápsula (capsule_screen.gd, 72x56). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_rarity_epic.png`
- **Origen:** nuevo (no estaba en el original)

```text
A rarity badge for a game collection: a round deep-indigo medallion with a thick gold rim, a bright golden star in the center and several glowing sparkles, no letters and no symbols other than described. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-005 · Reliquia: Sticky Seed (común, comida)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Semilla pegajosa con brote cubierta de almíbar dorado. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `sticky_seed` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_sticky_seed.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a plump brown seed with a tiny green sprout on top, coated in a drip of golden sticky syrup. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-006 · Reliquia: Lucky Clover (común, monedas)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Trébol de cuatro hojas con una moneda dorada. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `lucky_clover` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_lucky_clover.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a bright green four-leaf clover with a tiny golden coin glinting in the middle. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-007 · Reliquia: Tough Pebble (común, vida de base)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Guijarro gris redondo con carita decidida. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `tough_pebble` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_tough_pebble.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a smooth round gray pebble with a darker stripe and a tiny determined face of two dots and a small line. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-008 · Reliquia: Sharp Thorn (común, daño)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Espina curva y brillante. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `sharp_thorn` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_sharp_thorn.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a single curved rose thorn, pointy and glossy dark green with a bright white highlight. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-009 · Reliquia: Quick Sprout (común, reducción de espera)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Brote joven saliendo de la tierra con líneas de velocidad. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `quick_sprout` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_quick_sprout.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a young green sprout with two leaves bursting out of the soil with small speed lines. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-010 · Reliquia: Cozy Mushroom (común, vida de unidades)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Seta roja con puntos crema y brillo cálido. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `cozy_mushroom` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_cozy_mushroom.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a red mushroom cap with cream dots on a short cream stalk, with a warm cozy glow. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-011 · Reliquia: Golden Dewdrop (rara, monedas)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Gota de rocío dorada colgando de una hoja. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `golden_dewdrop` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_golden_dewdrop.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a perfect golden dewdrop hanging from a small green leaf tip with a bright white highlight. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-012 · Reliquia: Echo Seashell (rara, comida)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Concha en espiral con ondas de sonido. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `echo_seashell` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_echo_seashell.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a spiral cream-and-turquoise seashell with three soft curved sound waves coming from its opening. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-013 · Reliquia: Mini Hourglass (rara, espera de poderes)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Reloj de arena dorado con arena turquesa brillante. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `mini_hourglass` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_mini_hourglass.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a tiny hourglass with a golden frame and glowing teal sand, a few sparkles around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-014 · Reliquia: Wormina's Daisy (rara, vida de unidades)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Margarita blanca con centro amarillo y hoja. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `wormina_daisy` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_wormina_daisy.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a white daisy with a yellow center and a tiny green stem with one leaf, a soft warm glow around it. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-015 · Reliquia: Chrono Gear (épica, comida)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Engranaje dorado pulido con centro turquesa brillante. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `chrono_gear` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_chrono_gear.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a polished golden clockwork gear with a glowing teal center and tiny sparks of light. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-016 · Reliquia: Time Crown (épica, daño)
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Corona dorada cuyas puntas son engranajes, con gema turquesa. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Lista de reliquias (relics_screen.gd) y filas de resultado de cápsula; id de datos `time_crown` en data/relics.json. NUEVO: el original no traía iconos de reliquia.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_relic_time_crown.png`
- **Origen:** nuevo (no estaba en el original)

```text
A collectible relic icon: a small golden crown whose points are tiny gears, with a glowing teal gem in the front and sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-017 · Tienda: Pack de 80 gemas
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Montoncito de tres gemas turquesa. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Tarjeta del producto `gems_80` en la Tienda (shop_screen.gd, data/shop.json). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_shop_gems_80.png`
- **Origen:** nuevo (no estaba en el original)

```text
A shop product icon: a tiny pile of three faceted teal-blue gems with white highlights and one sparkle. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-018 · Tienda: Pack de 450 gemas
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Bolsa de cuero que derrama gemas turquesa. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Tarjeta del producto `gems_450` en la Tienda (shop_screen.gd, data/shop.json). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_shop_gems_450.png`
- **Origen:** nuevo (no estaba en el original)

```text
A shop product icon: a small brown leather pouch tied with a string, spilling several faceted teal-blue gems with white highlights. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-019 · Tienda: Pack de 1000 gemas
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Cofre de madera abierto lleno de gemas. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Tarjeta del producto `gems_1000` en la Tienda (shop_screen.gd, data/shop.json). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_shop_gems_1000.png`
- **Origen:** nuevo (no estaba en el original)

```text
A shop product icon: a wooden treasure chest, open and overflowing with faceted teal-blue gems and sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-020 · Tienda: Pack de 2200 gemas
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Gran cofre dorado con una montaña de gemas. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Tarjeta del producto `gems_2200` en la Tienda (shop_screen.gd, data/shop.json). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_shop_gems_2200.png`
- **Origen:** nuevo (no estaba en el original)

```text
A shop product icon: a big golden treasure chest with a mountain of faceted teal-blue gems pouring out and many sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-021 · Tienda: Pack inicial
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Caja de regalo turquesa con lazo dorado, una gorrita con A y una cápsula asomando. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Tarjeta del producto `starter_pack` en la Tienda (shop_screen.gd, data/shop.json). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_shop_starter_pack.png`
- **Origen:** nuevo (no estaba en el original)

```text
A shop product icon: a small teal gift box tied with a golden ribbon, with a tiny black baseball cap with a letter A and a golden time capsule peeking out of the top. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-022 · Tienda: Golden Pass
- **Tipo:** Sprite estático (recortado sobre fondo de color)
- **Descripción de la imagen:** Boleto dorado con un engranaje en el centro y chispas. (Pieza nueva, añadida respecto al original.)
- **Tamaño / proporción:** 1:1 cuadrada, generar a 1024x1024 px (el pipeline deja máx. 128 px de lado)
- **Datos técnicos:** fondo magenta plano #FF00FF; sin sombras ni suelo; bordes limpios
- **Dónde se usa:** Tarjeta del producto `golden_pass` en la Tienda (shop_screen.gd, data/shop.json). NUEVO: el original no lo traía.
- **Referencia a adjuntar:** ninguna
- **Archivo de salida:** `icon_shop_golden_pass.png`
- **Origen:** nuevo (no estaba en el original)

```text
A shop product icon: a shiny golden ticket with a clock-gear emblem in the center, a scalloped edge and sparkles. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin warm dark-brown ink outlines, cute rounded shapes and friendly saturated colors. A single front-facing game icon, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF) with no shadow, no ground, no gradient, no text and no border. Crisp clean edges. Do not use magenta or pink anywhere on the icon. Square 1:1 image.
```

### D-023 · Squirmy skin Pirata: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `squirmy_skin_pirate`, Squirmy skin Pirata. Skin cosmética (tienda, producto skin_pirate).
- **Referencia a adjuntar:** hoja oficial de personaje de Squirmy hecha por Alfredo (adjuntarla si la tienes; la gorra con la A y los colores deben salir idénticos)
- **Archivo de salida:** `squirmy_skin_pirate_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia para las 5 animaciones de la skin; puede servir de imagen del producto en la Tienda (shop_screen.gd). No entra al juego como sprite.
- **Origen:** A06 (descripción de diseño)

```text
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks and two small simple hands, dressed as a pirate with a small black tricorn hat with a gold star instead of his cap and a tiny black eyepatch. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### D-024 · Squirmy skin Pirata: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_pirate`, Squirmy skin Pirata. Skin cosmética (tienda, producto skin_pirate).
- **Referencia a adjuntar:** `squirmy_skin_pirate_ref.png`
- **Archivo de salida:** `squirmy_skin_pirate_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `squirmy_skin_pirate_idle_x2_sheet.png` (celda 768 px / hoja 3840x3840 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 384 px / hoja 1920x1920 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** A06, fila 1 (idle loop)

```text
Using the attached reference image (squirmy_skin_pirate_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'idle' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a pirate: small black tricorn hat with a gold star and a tiny black eyepatch (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: Squirmy in his pirate outfit stands upright like a friendly question mark and breathes; he stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Standing tall, the whole body slowly rises (inhale), the hat brim lifts a little.
- Frames 7-13: Highest point of the breath, then the body starts to sink (exhale); the right little hand gives a tiny wave around frames 9-12.
- Frames 14-19: Body at its lowest, a very small weight shift to one side, the hat brim bobs down.
- Frames 20-25: The eyes blink once (about 2 frames closed), the body rises back to exactly the pose of frame 1.
- Skin-specific details to keep (they replace the cap of the base design): the body stands upright and slowly rises and sinks as if breathing, one little hand gives a tiny wave, the hat bobs, and the visible eye blinks once.
```

### D-025 · Squirmy skin Pirata: cast_slam (poder Squirm Slam)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_pirate`, Squirmy skin Pirata. Skin cosmética (tienda, producto skin_pirate).
- **Referencia a adjuntar:** `squirmy_skin_pirate_ref.png`
- **Archivo de salida:** `squirmy_skin_pirate_cast_slam_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_skin_pirate_cast_slam_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el cuerpo se estira hacia arriba y el golpe al suelo suelta chispas y grietas. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A06, fila 2 (casting Squirm Slam)

```text
Using the attached reference image (squirmy_skin_pirate_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'cast_slam' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a pirate: small black tricorn hat with a gold star and a tiny black eyepatch (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Casting Squirm Slam: Squirmy in his pirate outfit coils like a spring, rises high and slams his front half into the ground. Key moment (impact) on frame 18. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: Anticipation: the head leans back, both hands rise beside the head.
- Frames 6-10: The body coils like a spring, the lower body compresses, the tricorn hat tilts back.
- Frames 11-15: The whole front half rises high and stretches upward (tallest pose at frame 15), hands up.
- Frames 16-20: The front half slams down toward the ground with the tricorn hat tipping forward; impact at frame 18 with golden sparks and a small crack in the ground.
- Frames 21-25: Golden sparks fade, the body unwinds and returns to the idle standing pose of the first frame.
- Skin-specific details to keep (they replace the cap of the base design): the head leans back with the hat tilting, the body coils like a spring, then the front half rises high and slams down toward the ground, with golden sparks at the impact in the last part of the move.
```

### D-026 · Squirmy skin Pirata: cast_power (poder genérico)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_pirate`, Squirmy skin Pirata. Skin cosmética (tienda, producto skin_pirate).
- **Referencia a adjuntar:** `squirmy_skin_pirate_ref.png`
- **Archivo de salida:** `squirmy_skin_pirate_cast_power_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_skin_pirate_cast_power_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el remolino de luz dorada y turquesa con engranes crece alrededor del héroe. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A06, fila 3 (casting a generic power)

```text
Using the attached reference image (squirmy_skin_pirate_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'cast_power' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a pirate: small black tricorn hat with a gold star and a tiny black eyepatch (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Casting a generic power: Squirmy in his pirate outfit calls on a swirl of golden and teal light. Key moment (light burst) on frame 17. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The head tilts up, he takes a breath, the little hands rise from his sides.
- Frames 6-10: Both hands stretch toward the sky with a determined open-mouth battle cry, the tricorn hat stays on.
- Frames 11-15: A swirl of golden and teal light with tiny gears grows around his body, getting bigger each frame.
- Frames 16-20: The swirl reaches its biggest size and bursts outward at frame 17 with a bright pulse, the body stays stretched up.
- Frames 21-25: The light and gears fade away, the hands lower, the body returns to the idle standing pose.
- Skin-specific details to keep (they replace the cap of the base design): the head tilts up with a pirate battle cry, both little hands stretch toward the sky while a swirl of golden and teal light with tiny gears grows around him and fades.
```

### D-027 · Squirmy skin Pirata: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_pirate`, Squirmy skin Pirata. Skin cosmética (tienda, producto skin_pirate).
- **Referencia a adjuntar:** `squirmy_skin_pirate_ref.png`
- **Archivo de salida:** `squirmy_skin_pirate_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `squirmy_skin_pirate_hurt_x2_sheet.png` (celda 768 px / hoja 3840x3840 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 384 px / hoja 1920x1920 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** A06, fila 4 (getting hurt)

```text
Using the attached reference image (squirmy_skin_pirate_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'hurt' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a pirate: small black tricorn hat with a gold star and a tiny black eyepatch (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Getting hurt: a short flinch and a wobbling recovery; he stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-4: The hit lands: the body flinches backward sharply, the eyes squeeze shut, the tricorn hat tips down over one eye.
- Frames 5-10: The body leans back and wobbles, the little hands flail slightly.
- Frames 11-18: The body sways forward a little (smaller motion), the tricorn hat is pushed back up.
- Frames 19-25: He recovers to the idle standing pose with the eyes open again.
- Skin-specific details to keep (they replace the cap of the base design): the body flinches backward, the hat tips over one eye, the body wobbles, then he recovers.
```

### D-028 · Squirmy skin Pirata: celebrate (celebrar)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_pirate`, Squirmy skin Pirata. Skin cosmética (tienda, producto skin_pirate).
- **Referencia a adjuntar:** `squirmy_skin_pirate_ref.png`
- **Archivo de salida:** `squirmy_skin_pirate_celebrate_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_skin_pirate_celebrate_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — hay un salto con giro y los brazos arriba. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A06, fila 5 (celebrating)

```text
Using the attached reference image (squirmy_skin_pirate_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'celebrate' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a pirate: small black tricorn hat with a gold star and a tiny black eyepatch (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Celebrating: a happy jump with a fist pump, a spin and a tricorn hat tip. Key moment (top of the jump) around frame 12. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: Anticipation: the body crouches and squashes down, one fist gathers beside him.
- Frames 6-11: He bounces up into a happy jump, one fist pumped in the air, the tricorn hat stays on.
- Frames 12-17: At the top he does a small spin in the air, body stretched.
- Frames 18-22: He descends and lands with a squash, a cheerful bounce.
- Frames 23-25: He straightens and gives a tiny tip of the hat, ending in the idle standing pose.
- Skin-specific details to keep (they replace the cap of the base design): the body bounces up in a happy jump with one fist pumped, a small spin in the air, the hat stays on, and a cheerful landing with a tiny bow.
```

### D-029 · Squirmy skin Caballero: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `squirmy_skin_knight`, Squirmy skin Caballero. Skin cosmética (tienda, producto skin_knight).
- **Referencia a adjuntar:** hoja oficial de personaje de Squirmy hecha por Alfredo (adjuntarla si la tienes; la gorra con la A y los colores deben salir idénticos)
- **Archivo de salida:** `squirmy_skin_knight_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia para las 5 animaciones de la skin; puede servir de imagen del producto en la Tienda (shop_screen.gd). No entra al juego como sprite.
- **Origen:** A07 (descripción de diseño)

```text
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks and two small simple hands, dressed as a knight with a tiny shiny silver helmet with a blue plume instead of his cap and a small round silver shield strapped to his body. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### D-030 · Squirmy skin Caballero: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_knight`, Squirmy skin Caballero. Skin cosmética (tienda, producto skin_knight).
- **Referencia a adjuntar:** `squirmy_skin_knight_ref.png`
- **Archivo de salida:** `squirmy_skin_knight_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `squirmy_skin_knight_idle_x2_sheet.png` (celda 768 px / hoja 3840x3840 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 384 px / hoja 1920x1920 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** A07, fila 1 (idle loop)

```text
Using the attached reference image (squirmy_skin_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'idle' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a knight: tiny shiny silver helmet with a blue plume and a small round silver shield strapped on (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: Squirmy in his knight outfit stands upright like a friendly question mark and breathes; he stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Standing tall, the whole body slowly rises (inhale), the plume lifts a little.
- Frames 7-13: Highest point of the breath, then the body starts to sink (exhale); the right little hand gives a tiny wave around frames 9-12.
- Frames 14-19: Body at its lowest, a very small weight shift to one side, the plume bobs down.
- Frames 20-25: The eyes blink once (about 2 frames closed), the body rises back to exactly the pose of frame 1.
- Skin-specific details to keep (they replace the cap of the base design): the body stands upright and slowly rises and sinks as if breathing, the helmet plume sways, and the eyes blink once.
```

### D-031 · Squirmy skin Caballero: cast_slam (poder Squirm Slam)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_knight`, Squirmy skin Caballero. Skin cosmética (tienda, producto skin_knight).
- **Referencia a adjuntar:** `squirmy_skin_knight_ref.png`
- **Archivo de salida:** `squirmy_skin_knight_cast_slam_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_skin_knight_cast_slam_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el cuerpo se estira hacia arriba y el golpe al suelo suelta chispas y grietas. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A07, fila 2 (casting Squirm Slam)

```text
Using the attached reference image (squirmy_skin_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'cast_slam' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a knight: tiny shiny silver helmet with a blue plume and a small round silver shield strapped on (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Casting Squirm Slam: Squirmy in his knight outfit coils like a spring, rises high and slams his front half into the ground. Key moment (impact) on frame 18. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: Anticipation: the head leans back, both hands rise beside the head.
- Frames 6-10: The body coils like a spring, the lower body compresses, the helmet tilts back.
- Frames 11-15: The whole front half rises high and stretches upward (tallest pose at frame 15), hands up.
- Frames 16-20: The front half slams down toward the ground with the helmet tipping forward; impact at frame 18 with golden sparks and a small crack in the ground.
- Frames 21-25: Golden sparks fade, the body unwinds and returns to the idle standing pose of the first frame.
- Skin-specific details to keep (they replace the cap of the base design): the head leans back, the body coils like a spring, then the front half rises and slams down with the shield forward, with golden sparks at the impact in the last part of the move.
```

### D-032 · Squirmy skin Caballero: cast_power (poder genérico)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_knight`, Squirmy skin Caballero. Skin cosmética (tienda, producto skin_knight).
- **Referencia a adjuntar:** `squirmy_skin_knight_ref.png`
- **Archivo de salida:** `squirmy_skin_knight_cast_power_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_skin_knight_cast_power_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el remolino de luz dorada y turquesa con engranes crece alrededor del héroe. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A07, fila 3 (casting a generic power)

```text
Using the attached reference image (squirmy_skin_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'cast_power' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a knight: tiny shiny silver helmet with a blue plume and a small round silver shield strapped on (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Casting a generic power: Squirmy in his knight outfit calls on a swirl of golden and teal light. Key moment (light burst) on frame 17. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The head tilts up, he takes a breath, the little hands rise from his sides.
- Frames 6-10: Both hands stretch toward the sky with a determined open-mouth battle cry, the helmet stays on.
- Frames 11-15: A swirl of golden and teal light with tiny gears grows around his body, getting bigger each frame.
- Frames 16-20: The swirl reaches its biggest size and bursts outward at frame 17 with a bright pulse, the body stays stretched up.
- Frames 21-25: The light and gears fade away, the hands lower, the body returns to the idle standing pose.
- Skin-specific details to keep (they replace the cap of the base design): the head tilts up with a brave battle cry, both little hands stretch toward the sky while a swirl of golden and teal light with tiny gears grows around him and fades.
```

### D-033 · Squirmy skin Caballero: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_knight`, Squirmy skin Caballero. Skin cosmética (tienda, producto skin_knight).
- **Referencia a adjuntar:** `squirmy_skin_knight_ref.png`
- **Archivo de salida:** `squirmy_skin_knight_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `squirmy_skin_knight_hurt_x2_sheet.png` (celda 768 px / hoja 3840x3840 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 384 px / hoja 1920x1920 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** A07, fila 4 (getting hurt)

```text
Using the attached reference image (squirmy_skin_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'hurt' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a knight: tiny shiny silver helmet with a blue plume and a small round silver shield strapped on (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Getting hurt: a short flinch and a wobbling recovery; he stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-4: The hit lands: the body flinches backward sharply, the eyes squeeze shut, the helmet wobbles on his head.
- Frames 5-10: The body leans back and wobbles, the little hands flail slightly.
- Frames 11-18: The body sways forward a little (smaller motion), the helmet is pushed back up.
- Frames 19-25: He recovers to the idle standing pose with the eyes open again.
- Skin-specific details to keep (they replace the cap of the base design): the body flinches backward, the plume bends, the shield lifts to block, the body wobbles, then he recovers.
```

### D-034 · Squirmy skin Caballero: celebrate (celebrar)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_knight`, Squirmy skin Caballero. Skin cosmética (tienda, producto skin_knight).
- **Referencia a adjuntar:** `squirmy_skin_knight_ref.png`
- **Archivo de salida:** `squirmy_skin_knight_celebrate_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_skin_knight_celebrate_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — hay un salto con giro y los brazos arriba. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A07, fila 5 (celebrating)

```text
Using the attached reference image (squirmy_skin_knight_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'celebrate' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as a knight: tiny shiny silver helmet with a blue plume and a small round silver shield strapped on (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Celebrating: a happy jump with a fist pump, a spin and a helmet tip. Key moment (top of the jump) around frame 12. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: Anticipation: the body crouches and squashes down, one fist gathers beside him.
- Frames 6-11: He bounces up into a happy jump, one fist pumped in the air, the helmet stays on.
- Frames 12-17: At the top he does a small spin in the air, body stretched.
- Frames 18-22: He descends and lands with a squash, a cheerful bounce.
- Frames 23-25: He straightens and gives a small proud nod, ending in the idle standing pose.
- Skin-specific details to keep (they replace the cap of the base design): the body bounces up in a happy jump with the shield raised high, a small spin, and a proud landing.
```

### D-035 · Squirmy skin Astronauta: referencia de personaje
- **Tipo:** Referencia de personaje (sprite individual, pose estática única)
- **Aplica a:** `squirmy_skin_astronaut`, Squirmy skin Astronauta. Skin cosmética (tienda, producto skin_astronaut).
- **Referencia a adjuntar:** hoja oficial de personaje de Squirmy hecha por Alfredo (adjuntarla si la tienes; la gorra con la A y los colores deben salir idénticos)
- **Archivo de salida:** `squirmy_skin_astronaut_ref.png`
- **Tamaño:** 1:1 cuadrada, 1024x1024 px
- **Datos técnicos:** fondo magenta plano #FF00FF; vista 3/4 mirando a la derecha; cuerpo completo y objetos visibles; margen vacío alrededor
- **Dónde se usa:** Solo como referencia para las 5 animaciones de la skin; puede servir de imagen del producto en la Tienda (shop_screen.gd). No entra al juego como sprite.
- **Origen:** A08 (descripción de diseño)

```text
Squirmy, a small cheerful bright-green earthworm with a lighter yellow-green segmented belly, big round brown eyes with white highlights, soft peach-pink blushing cheeks and two small simple hands, dressed as an astronaut with a round clear glass space helmet instead of his cap and a small white backpack with a tiny antenna. Storybook watercolor illustration with soft hand-painted washes, subtle paper grain, thin dark-green ink outlines, cute rounded shapes and friendly saturated colors. One single full-body subject, standing in a relaxed neutral idle pose, three-quarter view slightly turned toward the right, facing right, the whole body and all held items fully visible, centered with a wide empty margin, drawn on a perfectly flat solid magenta background (#FF00FF). Crisp clean edges, no shadow, no ground, no gradient, no text and no border. Do not use magenta or pink anywhere on the subject. Square 1:1 image, high resolution.
```

### D-036 · Squirmy skin Astronauta: idle (reposo)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_astronaut`, Squirmy skin Astronauta. Skin cosmética (tienda, producto skin_astronaut).
- **Referencia a adjuntar:** `squirmy_skin_astronaut_ref.png`
- **Archivo de salida:** `squirmy_skin_astronaut_idle_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `squirmy_skin_astronaut_idle_x2_sheet.png` (celda 768 px / hoja 3840x3840 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 384 px / hoja 1920x1920 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** A08, fila 1 (idle loop)

```text
Using the attached reference image (squirmy_skin_astronaut_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'idle' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as an astronaut: round clear glass space helmet and a small white backpack with a tiny antenna (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: A calm looping idle: Squirmy in his astronaut outfit stands upright like a friendly question mark and breathes; he stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
This is a LOOP: frame 25 must flow smoothly into frame 1 (the pose after frame 25 is the pose of frame 1), so the cycle repeats with no jump or pause.
Motion by frames:
- Frames 1-6: Standing tall, the whole body slowly rises (inhale), the backpack antenna lifts a little.
- Frames 7-13: Highest point of the breath, then the body starts to sink (exhale); the right little hand gives a tiny wave around frames 9-12.
- Frames 14-19: Body at its lowest, a very small weight shift to one side, the backpack antenna bobs down.
- Frames 20-25: The eyes blink once (about 2 frames closed), the body rises back to exactly the pose of frame 1.
- Skin-specific details to keep (they replace the cap of the base design): the body stands upright and slowly rises and sinks as if breathing, the antenna on the backpack wobbles, and the eyes blink once.
```

### D-037 · Squirmy skin Astronauta: cast_slam (poder Squirm Slam)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_astronaut`, Squirmy skin Astronauta. Skin cosmética (tienda, producto skin_astronaut).
- **Referencia a adjuntar:** `squirmy_skin_astronaut_ref.png`
- **Archivo de salida:** `squirmy_skin_astronaut_cast_slam_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_skin_astronaut_cast_slam_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el cuerpo se estira hacia arriba y el golpe al suelo suelta chispas y grietas. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A08, fila 2 (casting Squirm Slam)

```text
Using the attached reference image (squirmy_skin_astronaut_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'cast_slam' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as an astronaut: round clear glass space helmet and a small white backpack with a tiny antenna (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Casting Squirm Slam: Squirmy in his astronaut outfit coils like a spring, rises high and slams his front half into the ground. Key moment (impact) on frame 18. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: Anticipation: the head leans back, both hands rise beside the head.
- Frames 6-10: The body coils like a spring, the lower body compresses, the helmet tilts back.
- Frames 11-15: The whole front half rises high and stretches upward (tallest pose at frame 15), hands up.
- Frames 16-20: The front half slams down toward the ground with the helmet tipping forward; impact at frame 18 with golden sparks and a small crack in the ground.
- Frames 21-25: Golden sparks fade, the body unwinds and returns to the idle standing pose of the first frame.
- Skin-specific details to keep (they replace the cap of the base design): the head leans back, the body coils like a spring, then the front half rises and slams down, with golden sparks at the impact in the last part of the move.
```

### D-038 · Squirmy skin Astronauta: cast_power (poder genérico)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_astronaut`, Squirmy skin Astronauta. Skin cosmética (tienda, producto skin_astronaut).
- **Referencia a adjuntar:** `squirmy_skin_astronaut_ref.png`
- **Archivo de salida:** `squirmy_skin_astronaut_cast_power_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_skin_astronaut_cast_power_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — el remolino de luz dorada y turquesa con engranes crece alrededor del héroe. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A08, fila 3 (casting a generic power)

```text
Using the attached reference image (squirmy_skin_astronaut_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'cast_power' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as an astronaut: round clear glass space helmet and a small white backpack with a tiny antenna (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Casting a generic power: Squirmy in his astronaut outfit calls on a swirl of golden and teal light. Key moment (light burst) on frame 17. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: The head tilts up, he takes a breath, the little hands rise from his sides.
- Frames 6-10: Both hands stretch toward the sky with a determined open-mouth battle cry, the helmet stays on.
- Frames 11-15: A swirl of golden and teal light with tiny gears grows around his body, getting bigger each frame.
- Frames 16-20: The swirl reaches its biggest size and bursts outward at frame 17 with a bright pulse, the body stays stretched up.
- Frames 21-25: The light and gears fade away, the hands lower, the body returns to the idle standing pose.
- Skin-specific details to keep (they replace the cap of the base design): the head tilts up with an excited shout, both little hands stretch toward the sky while a swirl of golden and teal light with tiny gears grows around him and fades.
```

### D-039 · Squirmy skin Astronauta: hurt (herido)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_astronaut`, Squirmy skin Astronauta. Skin cosmética (tienda, producto skin_astronaut).
- **Referencia a adjuntar:** `squirmy_skin_astronaut_ref.png`
- **Archivo de salida:** `squirmy_skin_astronaut_hurt_sheet.png`
- **Archivo con lienzo doble (solo si te sale cortado):** `squirmy_skin_astronaut_hurt_x2_sheet.png` (celda 768 px / hoja 3840x3840 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 384 px / hoja 1920x1920 px; imagen 1:1
- **¿Puede sobresalir de la celda?:** no — movimiento contenido junto al cuerpo. Lienzo normal.
- **Origen:** A08, fila 4 (getting hurt)

```text
Using the attached reference image (squirmy_skin_astronaut_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'hurt' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as an astronaut: round clear glass space helmet and a small white backpack with a tiny antenna (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Getting hurt: a short flinch and a wobbling recovery; he stays in place. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-4: The hit lands: the body flinches backward sharply, the eyes squeeze shut, the helmet wobbles on his head.
- Frames 5-10: The body leans back and wobbles, the little hands flail slightly.
- Frames 11-18: The body sways forward a little (smaller motion), the helmet is pushed back up.
- Frames 19-25: He recovers to the idle standing pose with the eyes open again.
- Skin-specific details to keep (they replace the cap of the base design): the body flinches backward, the helmet glass shows a tiny crack of light, the antenna bends, the body wobbles, then he recovers.
```

### D-040 · Squirmy skin Astronauta: celebrate (celebrar)
- **Tipo:** Hoja de animación 5x5 (25 fotogramas, orden izquierda→derecha y arriba→abajo)
- **Aplica a:** `squirmy_skin_astronaut`, Squirmy skin Astronauta. Skin cosmética (tienda, producto skin_astronaut).
- **Referencia a adjuntar:** `squirmy_skin_astronaut_ref.png`
- **Archivo de salida:** `squirmy_skin_astronaut_celebrate_x2_sheet.png`
- **Archivo con lienzo normal (alternativo):** `squirmy_skin_astronaut_celebrate_sheet.png` (celda 384 px / hoja 1920x1920 px)
- **Datos técnicos:** cuadrícula 5x5 de celdas cuadradas, fondo magenta plano #FF00FF, mirada a la derecha, celda 768 px / hoja 3840x3840 px (lienzo doble recomendado); imagen 1:1
- **¿Puede sobresalir de la celda?:** sí — hay un salto con giro y los brazos arriba. Recomendado lienzo doble: celda 768 px, hoja 3840x3840 px (el personaje ocupa solo la mitad central de cada celda).
- **Origen:** A08, fila 5 (celebrating)

```text
Using the attached reference image (squirmy_skin_astronaut_ref.png) as the exact design of the character, draw an animation sprite sheet of the hero Squirmy performing the 'celebrate' animation.
Character identity, to stay consistent: Squirmy the bright-green worm dressed as an astronaut: round clear glass space helmet and a small white backpack with a tiny antenna (no cap).
Same storybook watercolor look as the reference: soft hand-painted washes, subtle paper grain, thin ink outlines, cute rounded shapes, friendly saturated colors.
Layout: one strict grid of 5 columns by 5 rows, 25 equal square cells, read left to right then top to bottom (frame 1 is the top-left cell, frame 25 the bottom-right cell). Each cell holds exactly one full-body copy of the same character, side view facing right, with identical size, identical proportions and the same standing line in every cell, centered in its cell with an empty margin so nothing touches the cell edges. The cells are deliberately roomy: draw the character at the same scale as in the reference and keep it in the central half of each cell, so weapon swings, effects and falls have space and never cross into a neighbouring cell.
Background: one perfectly flat solid magenta (#FF00FF) with no grid lines, no borders, no labels, no numbers, no text, no shadows and no ground. Do not use magenta or pink anywhere on the character. Square 1:1 image.
Animation: Celebrating: a happy jump with a fist pump, a spin and a helmet tip. Key moment (top of the jump) around frame 12. It must be smooth and fluid, like a hand-drawn animation: use all 25 frames, draw gentle in-between poses so no pose jumps from one frame to the next, and keep the volumes and the character design identical in every frame.
Not a loop: frame 1 is the neutral pose just before the action starts and frame 25 is back in that neutral idle pose, so it can cut back to idle.
Motion by frames:
- Frames 1-5: Anticipation: the body crouches and squashes down, one fist gathers beside him.
- Frames 6-11: He bounces up into a happy jump, one fist pumped in the air, the helmet stays on.
- Frames 12-17: At the top he does a small spin in the air, body stretched.
- Frames 18-22: He descends and lands with a squash, a cheerful bounce.
- Frames 23-25: He straightens and gives a small wave, ending in the idle standing pose.
- Skin-specific details to keep (they replace the cap of the base design): the body floats up in a slow happy bounce as if in low gravity, a gentle spin, and a soft landing with a small wave.
```
