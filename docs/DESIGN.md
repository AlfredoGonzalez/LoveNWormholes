# Diseño de producto y recorrido del usuario

> Mezcla del plan original (lane battler por eras, anuncios opcionales, tienda) con el **prototipo de Unity** del autor (video: intro en cómic, título, hub con casa de piedra, navegación de 5 pestañas, mapa en pergamino, Recuerdos, Mejoras con cartas y tienda «Worm Mart»).
> Estado: **propuesta lista para validar**. Lo que dice «por validar» son interpretaciones del video; ver «Decisiones abiertas» al final.

## 1. Pilares
1. **Pareja de gusanos, tono tierno y cómico.** Gusanito (verde, gorra negra con una «A») viaja por el tiempo para rescatar a Gusanita (rosa, lentes redondos, flor blanca).
2. **Batalla corta y clara** (lane battler vertical): invocas unidades con energía, el héroe pelea solo, usas el agujero de gusano en apuros.
3. **Un hub acogedor** donde siempre hay algo que hacer: jugar, mejorar, abrir recuerdos, comprar.
4. **Cero anuncios forzados.** Los anuncios son botones opcionales con recompensa (ver `docs/MONETIZATION.md`).
5. **Español e inglés** desde el inicio; ningún texto incrustado en imágenes.

## 2. Qué tomamos de cada lado
| Tema | Del prototipo de Unity (video) | Del plan original | Resultado |
|---|---|---|---|
| Historia | Intro con 3 paneles de cómic sobre papel | Mensajes de Gusanita al llegar a cada era | Intro al primer arranque + panel y mensaje por **capítulo (era)** |
| Título | Selva nocturna, logo de piedra, Gusanito con garrote, botón «JUGAR» de madera | — | Igual; texto del botón lo pone el juego (ES/EN) |
| Menú principal | **Hub**: casa de piedra + Gusanito + JUGAR, barra superior y 5 pestañas | Menú con botones | Hub del video; reemplaza el menú actual |
| Niveles | **Mapa en pergamino** con caminos, estrellas y jefe final | Mapa de eras con flechas ◀ ▶ | Mapa del video, un mapa por era (el selector de era se integra al mapa) |
| Progreso del héroe | **Mejoras con cartas** (3 ranuras, reroll) | Mejoras permanentes con monedas | Ambas: mejoras permanentes + cartas (ver §5) |
| Coleccionables | **Recuerdos** (polaroids) + Medidor de Amor | «Álbum de recuerdos» (idea) | Recuerdos del video |
| Tienda | **Worm Mart**: ofertas diarias + paquetes de gemas | IAP + cofre gratis con anuncio | Worm Mart con las 3 cosas |
| Eventos | 4 eventos temporales con cronómetro | Modo «Rescate» (endless) | Eventos temporales (fase posterior) |
| Combate | (no se ve en el video) | Lane battler por eras con anomalías de portal | **Se conserva tal cual** |
| Personajes | Gusanito verde con gorra «A», Gusanita rosa con lentes | Gusanito rosa / Gusanita lila | **Se adopta el aspecto del video** |
| Estilo | Tinta marrón, papel crema, piedra y madera | Cartoon «sticker» | Se adopta el estilo del video (`art-prompts/00-style-bible.md`) |

## 3. Recorrido del usuario
```mermaid
flowchart TD
  A[Abrir app] --> B{¿Primera vez?}
  B -- Sí --> C[Intro: 3 paneles de cómic<br/>«Toca para continuar»]
  B -- No --> D
  C --> D[Título: logo + JUGAR]
  D --> E[Consentimiento de privacidad<br/>(solo la primera vez)]
  E --> F[HUB / Batalla]
  F -- JUGAR --> G[Siguiente nivel sin terminar]
  F --> M[Mapa de niveles]
  F --> R[Recuerdos]
  F --> U[Mejoras]
  F --> S[Tienda Worm Mart]
  M -- elegir nivel --> G
  G --> H{¿Primer nivel de una era nueva?}
  H -- Sí --> I[Panel de capítulo + mensaje de Gusanita]
  H -- No --> J
  I --> J[Batalla]
  J --> K[Resultados: estrellas y monedas]
  K -- duplicar (anuncio opcional) --> K
  J -- derrota --> L[Revivir: anuncio opcional o 10 gemas]
  K --> F
  K -- subir Medidor de Amor --> N[Recuerdo desbloqueado]
  N --> F
```
**Regla de oro:** desde cualquier pantalla se llega al hub en un toque (pestaña central).

## 4. Pantallas
Leyenda de estado: ✅ ya existe · 🔧 existe y hay que rediseñar · 🆕 no existe.

### 4.1 Intro (cómic) 🆕
- Fondo `intro_bg` (papel con garabatos). Tres paneles `story_01..03` aparecen uno tras otro, ligeramente inclinados, con animación de «caer y rebotar». Texto fijo «TOCA PARA CONTINUAR…» (localizado).
- Se guarda `introSeen`; se puede revisar desde Ajustes → «Ver historia».

### 4.2 Título 🔧 (hoy `Menu`)
- Capas: `title_bg` (selva) + `logo` (arriba) + `title_hero` (centro) + botón de madera `btn_wood` con texto «JUGAR / PLAY».
- Toque en JUGAR → Hub. En la primera ejecución, antes de entrar, se muestra el consentimiento de privacidad.

### 4.3 Hub / Batalla (pestaña central) 🆕
- **Barra superior:** píldora de premium (izq.), título «PREHISTORIA I-1» (era + nivel actual, localizado) al centro, píldora de monedas (der.).
- Debajo: ⚙ **Ajustes** (izq.), ☰ **Menú** y 📜 **Misiones diarias** (der.).
- **Centro:** casa de piedra de la era (`base_<era>_home`) con Gusanito en su animación `idle` y armas decorativas en el suelo.
- **JUGAR** (madera): lanza el **siguiente nivel sin terminar** de la era actual.
- Fondo de papel con patrón por era (`hub_bg_<era>`).

### 4.4 Navegación inferior (5 pestañas) 🆕
Mapa · Recuerdos · **Batalla** (centro, elevada) · Mejoras · Tienda. Las pestañas muestran un **punto de aviso** cuando hay algo nuevo (recuerdo desbloqueado, oferta diaria sin ver, cofre listo, carta nueva).

### 4.5 Mapa de niveles 🔧 (hoy `EraMap`)
- Pergamino con camino punteado, nodos con forma de cueva (`map_node_<era>`), estrellas (0-3), **jefe final** de la era arriba (`map_boss_<era>`).
- Nodos bloqueados con candado. Cambiar de era: deslizar o botones ◀ ▶ en el encabezado (las eras bloqueadas se ven en gris).
- Abajo, **Eventos activos** (4 ranuras con cronómetro) — fase posterior; mientras tanto la franja no aparece.

### 4.6 Batalla 🔧 (hoy `Battle`)
Se conserva la mecánica. Cambios de interfaz: botones de unidad con `hud_unit_btn` (retrato del `idle` + coste), botón de agujero de gusano con el icono `wormhole`, barra de energía y anuncios opcionales («Energía x2») con el estilo de piedra/madera.

### 4.7 Resultados 🔧
Ventana `popup_frame` con estrellas, monedas ganadas, progreso del Medidor de Amor, botón **«Duplicar 📺»** (opcional), y **Revivir** en derrota. Botones: Reintentar · Mapa · Siguiente.

### 4.8 Recuerdos 🆕
- Rejilla de 2×3 polaroids (`memory_01..06`): Encuentro, Primera cita, Pequeña pelea, Reencuentro, Tour por la madriguera, Cacería en pareja. Bloqueados con `memory_locked`.
- **Medidor de Amor** (barra con gusano y corazón) abajo; sube al ganar niveles y estrellas. Cada umbral desbloquea un recuerdo (brillo + sello «NUEVO»). Tocar un recuerdo desbloqueado lo muestra en grande.

### 4.9 Mejoras 🔧 (hoy `Upgrades`)
- Panel de estadísticas (**Ataque, Vida, Crítico**) con su porcentaje total.
- **3 ranuras de cartas** (una con carta «ATAQUE +15 %», otras «?» = aún sin carta) y botón **Reroll** (cuesta monedas; también con anuncio opcional).
- Mejoras permanentes actuales (energía, hogar, héroe) se mantienen como una sección «Entrenamiento» con coste en monedas.
- *Por validar:* cómo funcionan exactamente las cartas (ver §5.2).

### 4.10 Tienda — The Worm Mart 🔧 (hoy `Shop`)
- Cabecera con saldo de monedas y gemas (+ botón «añadir gemas»), tendero con frase («¿Necesitas poder prehistórico?»).
- **Ofertas diarias:** 3 casillas que cambian cada día, con cronómetro (poción de energía, carta de ataque, paquete de monedas).
- **Paquetes de gemas:** Bolsita · Canasta · Montón (los de `docs/MONETIZATION.md`).
- Cofre gratis con anuncio opcional, Restaurar compras, productos únicos (Pack inicial, Monedas x2).

### 4.11 Ajustes / Menú / Misiones 🆕
- **Ajustes:** sonido, música, vibración, idioma, privacidad (reabre el consentimiento), ver historia, créditos.
- **Menú ☰:** logros (más adelante), soporte, política de privacidad.
- **Misiones diarias 📜:** 3 misiones por día (ganar N niveles, invocar N unidades, usar el agujero de gusano) con recompensa de monedas/gemas.

## 5. Sistemas nuevos
### 5.1 Medidor de Amor y Recuerdos
`love` (entero) sube **+1 por estrella** ganada por primera vez y **+3 al derrotar un jefe**. Umbrales de ejemplo: 3, 9, 18, 30, 45, 60 → recuerdos 01-06. Datos en `src/game/data` (no en las escenas).

### 5.2 Cartas (por validar)
Interpretación del video: antes de empezar (o desde la pestaña Mejoras) el jugador tiene **3 ranuras**; cada ranura contiene una carta que da un bono porcentual en la batalla (Ataque, Vida, Crítico o Energía). «Reroll» vuelve a sortear las cartas de las ranuras. Las ranuras «?» se desbloquean con el progreso (nivel de jugador / era).
Implementación propuesta: `cards.owned` (inventario), `cards.equipped[3]`, bonos se suman a `Mods` (hoy: `energyRegen`, `baseHp`, `heroDamage`; se añade `crit`). Es **compatible** con las mejoras permanentes actuales.

### 5.3 Eventos temporales y ofertas diarias (fase posterior)
Ofertas diarias: 3 casillas determinadas por la fecha (semilla) para que sean iguales sin servidor. Eventos: 4 desafíos con cronómetro (p. ej. «Caza», «Huesos», «Forja», «Fogata») que reparten recompensas; se definirán cuando el núcleo esté estable.

### 5.4 Guardado (SaveData v2)
Nuevos campos (con migración desde v1): `introSeen`, `chaptersSeen[]`, `lastLevelId`, `love`, `memories[]`, `cards{owned,equipped}`, `dailyDeals{day,bought[]}`, `quests{day,progress}`, `settings{sound,music,vibration}`.

## 6. Arquitectura en el código
- **Shell persistente:** una escena `Shell` (barra superior + navegación) que corre en paralelo (`scene.launch`) con las pestañas `Home`, `Map`, `Memories`, `Upgrades`, `Shop`. `Battle` se ejecuta sin shell.
- **Kit de interfaz:** `src/ui/kit.ts` con piezas reutilizables (botón de madera/piedra con texto, píldora de recurso, marco/ventana, tarjeta, punto de aviso) que usan las imágenes de `public/assets/ui/` y **caen a rectángulos de color** si faltan (igual que hoy).
- **Textos:** todo vía `i18n` (claves nuevas por pantalla). Las imágenes nunca llevan texto.
- **Resolución:** base 540×960 vertical; la barra inferior respeta el área segura (notch/gestos).

## 7. Hitos actualizados
| Hito | Contenido | Depende de arte |
|---|---|---|
| 1-5 ✅ | Prototipo, meta-juego, 4 eras, monetización, apps nativas | — |
| **6a** | Shell + Hub + Título + Intro (con el kit de interfaz y respaldos) | Sí, pero funciona con placeholders |
| **6b** | Mapa de niveles en pergamino + Resultados rediseñados | Sí |
| **6c** | Worm Mart (ofertas diarias + paquetes) | Sí |
| **6d** | Recuerdos + Medidor de Amor | Sí |
| **6e** | Cartas (Mejoras) | Sí |
| **6f** | Ajustes, Menú, Misiones diarias, eventos | Parcial |
| 7 | Audio, analítica real (Firebase), pruebas cerradas | — |
| 8 | Lanzamiento suave y ajuste de balance | — |

## 8. Decisiones abiertas (necesito tu respuesta)
1. **Moneda premium:** en la barra superior del video es un **diente**; en la tienda es un **cristal «R»**. ¿Cuál usamos? (Hoy: cristal/gema, `gem.png`.)
2. **Cartas:** ¿la interpretación de §5.2 es correcta? ¿Se obtienen en cofres, ofertas diarias o al subir de nivel?
3. **Eventos temporales (A-D):** ¿qué son? (¿modos especiales, desafíos diarios, cofres con cronómetro?)
4. **Gorra con «A»:** ¿es la marca del autor y va en todas las eras (propuesto) o solo en la Prehistoria?
5. **Recuerdos:** ¿6 en total o uno por cada nivel/era? (Propuesto: 6 al inicio, más con cada era.)
6. **Poción de energía y ofertas:** ¿qué debe vender cada casilla de las ofertas diarias?
7. **Ritmo de anuncios en Mejoras:** ¿«Reroll» gratis viendo un anuncio opcional?
