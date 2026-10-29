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
| Soldados | **3 cartas** (cuerpo a cuerpo, a distancia, fuerte) con ataque/vida/crítico | 4 unidades por era | **3 soldados por era** (ver §5.0) |
| Progreso permanente | Estadísticas % por carta | Mejoras permanentes con monedas | Estadísticas permanentes por carta + mejoras generales (ver §5.2) |
| Coleccionables | **Recuerdos** (polaroids) + Medidor de Amor | «Álbum de recuerdos» (idea) | Recuerdos del video |
| Tienda | **Worm Mart**: ofertas diarias + paquetes de gemas | IAP + cofre gratis con anuncio | Worm Mart con las 3 cosas |
| Eventos | 4 eventos temporales con cronómetro | Modo «Rescate» (endless) | Eventos temporales (fase posterior) |
| Combate | (no se ve en el video) | Lane battler por eras con anomalías de portal | **Se conserva tal cual** |
| Personajes | Gusanito verde con gorra «A», Gusanita rosa con lentes | Gusanito rosa / Gusanita lila | **Se adopta el aspecto del video** |
| Estilo | Tinta marrón, papel crema, piedra y madera | Cartoon «sticker» | Se adopta el estilo del video (`art-prompts/00-style-bible.md`) |

## 3. Recorrido del usuario
```text
ABRIR APP
   │
   ├─ ¿primera vez? ──► INTRO (3 paneles de cómic, «toca para continuar»)
   │                         │
   ▼                         ▼
 TÍTULO (logo + JUGAR) ◄─────┘
   │   (primera vez: consentimiento de privacidad)
   ▼
 HUB / BATALLA ─────────┬──────────┬───────────┬────────────┐
   │ JUGAR              │ Mapa     │ Recuerdos │ Mejoras    │ Tienda
   │ (siguiente nivel)  │ (elegir  │ (álbum +  │ (3 cartas  │ (Worm Mart)
   │                    │  nivel)  │  amor)    │  soldado)  │
   ▼                    ▼
 ¿primer nivel de una era nueva? ── sí ──► PANEL DE CAPÍTULO + mensaje de Gusanita
   │ no                                         │
   ▼◄───────────────────────────────────────────┘
 BATALLA ── derrota ──► REVIVIR (anuncio opcional o 10 💎) ──► sigue la batalla
   │ victoria
   ▼
 RESULTADOS (estrellas, monedas, +Amor)
   │      └─ «Duplicar» con anuncio opcional
   ├─ si el Amor llega a un umbral ──► RECUERDO DESBLOQUEADO
   ▼
 HUB
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

### 4.6 Batalla ✅🔧 (hoy `Battle`)
Ya implementada la economía de §5.0: 3 botones de soldado (los 2 últimos con 🔒 y su costo en huesos 🦴), contador de huesos, botón «⚡+» para subir la regeneración de energía, botón del agujero de gusano y anuncio opcional «Energía x2». Pendiente de rediseño: estilo de piedra/madera (`hud_unit_btn`, `bone_coin`, `wormhole`).

### 4.7 Resultados 🔧
Ventana `popup_frame` con estrellas, monedas ganadas, progreso del Medidor de Amor, botón **«Duplicar 📺»** (opcional), y **Revivir** en derrota. Botones: Reintentar · Mapa · Siguiente.

### 4.8 Recuerdos 🆕
- Rejilla de 2×3 polaroids (`memory_01..06`): Encuentro, Primera cita, Pequeña pelea, Reencuentro, Tour por la madriguera, Cacería en pareja. Bloqueados con `memory_locked`.
- **Medidor de Amor** (barra con gusano y corazón) abajo; sube al ganar niveles y estrellas. Cada umbral desbloquea un recuerdo (brillo + sello «NUEVO»). Tocar un recuerdo desbloqueado lo muestra en grande.

### 4.9 Mejoras (cartas de soldado) 🔧 (hoy `Upgrades`)
- Panel de estadísticas de la era actual: **Ataque, Vida, Crítico** con su porcentaje total.
- **3 cartas = los 3 soldados de la era** (cuerpo a cuerpo, a distancia, fuerte). Cada carta se mejora con monedas del hub y sube sus propios % de ataque, vida y crítico.
- Las cartas aún no desbloqueadas se ven como «?» (se desbloquean al llegar a esa era).
- Las mejoras generales actuales (energía, hogar, héroe) se mantienen como sección «Entrenamiento».
- *Por validar:* si el botón **Reroll** del video existe en el juego final (ver §8).

### 4.10 Tienda — The Worm Mart 🔧 (hoy `Shop`)
- Cabecera con saldo de monedas y gemas (+ botón «añadir gemas»), tendero con frase («¿Necesitas poder prehistórico?»).
- **Ofertas diarias:** 3 casillas que cambian cada día, con cronómetro (poción de energía, carta de ataque, paquete de monedas).
- **Paquetes de gemas:** Bolsita · Canasta · Montón (los de `docs/MONETIZATION.md`).
- Cofre gratis con anuncio opcional, Restaurar compras, productos únicos (Pack inicial, Monedas x2).

### 4.11 Ajustes / Menú / Misiones 🆕
- **Ajustes:** sonido, música, vibración, idioma, privacidad (reabre el consentimiento), ver historia, créditos.
- **Menú ☰:** logros (más adelante), soporte, política de privacidad.
- **Misiones diarias 📜:** 3 misiones por día (ganar N niveles, invocar N unidades, usar el agujero de gusano) con recompensa de monedas/gemas.

## 5. Sistemas
### 5.0 Economía de la batalla ✅ (estilo WeAreWarriors; ya implementada)
- **3 soldados por era** y cada uno cuesta **energía** distinta: ① cuerpo a cuerpo (barato, ⚡20) · ② a distancia (⚡40) · ③ el fuerte, con mucha vida y mucha fuerza (⚡90). Cada era tiene sus propios 3 soldados (Prehistoria: garrote · honda · roca; Egipto: lancero · arquero · sarcófago; Edad Media: espadachín · ballestero · caballero; Oeste: vaquero · pistolero · barril).
- La **energía** se regenera sola (y se puede acelerar, ver abajo).
- **Huesos 🦴 (monedas de batalla)**: se ganan **al derrotar enemigos** (pequeño 10 · mediano 16 · jefe 150) y se gastan **dentro del nivel** para:
  - **desbloquear el soldado ②** (70 🦴) y **el soldado ③** (200 🦴);
  - **subir la regeneración de energía** (4 niveles: 60 · 120 · 200 · 300 🦴, +30 % cada uno).
- Los huesos **se reinician en cada nivel**. Al ganar, las **monedas del hub** (permanentes) se pagan por estrellas, como antes.
- Los valores viven en `BATTLE_ECON` (`src/game/data.ts`) para balancear sin tocar escenas.

### 5.1 Medidor de Amor y Recuerdos
`love` (entero) sube **+1 por estrella** ganada por primera vez y **+3 al derrotar un jefe**. Umbrales de ejemplo: 3, 9, 18, 30, 45, 60 → recuerdos 01-06. Datos en `src/game/data` (no en las escenas).

### 5.2 Cartas de soldado y estadísticas permanentes
Cada soldado de la era es una **carta** con tres estadísticas porcentuales permanentes: **Ataque, Vida y Crítico** (los % del panel del video). Se mejoran con las monedas del hub y se **suman a los `Mods`** de la batalla (hoy: `energyRegen`, `baseHp`, `heroDamage`; se añadirán `unitAttack[3]`, `unitHealth[3]` y `crit`). Es compatible con las mejoras generales actuales.

### 5.3 Ofertas diarias y eventos (fase posterior)
**Ofertas diarias (propuesta):** 3 casillas que cambian cada día (la fecha decide cuáles, sin servidor), sacadas de un grupo de 6 artículos:
| Artículo | Qué hace | Precio |
|---|---|---|
| Poción de energía | Empiezas el siguiente nivel con la energía llena | 15 💎 o $0.99 |
| Paquete de monedas | 500 monedas del hub | 20 💎 |
| Cofre misterioso | Monedas + gemas aleatorias | Gratis viendo un anuncio (1 al día) |
| Mejora de ataque / vida | +% temporal para un nivel | 150 monedas |
| Pase de rescate | Un «Revivir» gratis guardado | 10 💎 |
| Impulso de huesos | Empiezas con 100 🦴 en el siguiente nivel | 50 monedas |

**Eventos temporales (los 4 recuadros con cronómetro del mapa):** son desafíos con tiempo límite que dan recompensas extra (por ejemplo «derrota 30 enemigos»). Los definimos cuando el núcleo esté estable; hasta entonces el mapa no muestra esa franja.

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

## 8. Decisiones
### Tomadas
- **Moneda premium:** el **cristal** (gema).
- **Soldados:** 3 por era con economía de huesos como WeAreWarriors (§5.0).
- **La «A» de la gorra:** parte del arte final; no se especifica en el código.

### Pendientes (con propuesta por defecto)
1. **Ofertas diarias:** propuesta en §5.3. ¿Te gusta o cambias algo?
2. **Reroll de cartas** (el botón del video): ¿qué rerolleaba? Si no lo tenías claro, lo omitimos.
3. **Eventos temporales:** ¿los dejamos para después? (propuesta: sí).
4. **Nombre de la moneda de batalla:** propuse «huesos» 🦴 para no confundirla con las monedas del hub; ¿te parece?
5. **Soldados «por nivel»:** entendí que son **por era** (3 soldados por cada una de las 4 eras). Si querías 3 soldados distintos **en cada uno de los niveles**, sería mucho más arte; dime.
