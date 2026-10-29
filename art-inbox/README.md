# art-inbox

Deja aquí tus imágenes **crudas** (tal como las generó la IA, con fondo magenta o blanco plano; sirven PNG, JPG y WEBP),
con el nombre EXACTO del archivo final (por ejemplo `title_hero.jpg`, `stick_idle.png`, `coin.png`, `bg_egipto.png`).

**Súbelas directo a git** (por ejemplo, en GitHub: *Add file → Upload files* a esta carpeta, en la rama `main`).
El flujo «Procesar arte» las convierte solo (quita el fondo, corta los cuadros, ajusta el tamaño), guarda el resultado en
`public/assets/` y vuelve a publicar la demo en 1-2 minutos. También puedes hacerlo en tu computadora con `npm run art`.

Lista de nombres exactos: `art-prompts/README.md`. Paso a paso del título e intro: `art-prompts/LANDING.md`.
