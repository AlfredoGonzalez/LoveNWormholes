# Love N Wormholes

Lane battler de gusanos a través del tiempo (Phaser 3 + TypeScript + Vite; Capacitor para Android/iOS).

```bash
npm install
npm run dev     # jugar en el navegador
npm test        # lógica de combate (Vitest)
npm run build
```

Hito 1 = prototipo jugable de la Prehistoria.

Formato: **vertical (portrait) 540×960**. En el Hito 5 se bloqueará la orientación en Android (`screenOrientation="portrait"`) e iOS (`UISupportedInterfaceOrientations`).

## Arte
Genera con IA siguiendo `art-prompts/README.md`, deja los archivos crudos en `art-inbox/` y ejecuta `npm run art` (quita el fondo, corta los cuadros y los deja en `public/assets/`). `npm run art:status` muestra el avance.

Documentación: [`docs/DESIGN.md`](docs/DESIGN.md) (diseño y recorrido del usuario), [`docs/MONETIZATION.md`](docs/MONETIZATION.md), [`docs/RELEASE.md`](docs/RELEASE.md), [`art-prompts/README.md`](art-prompts/README.md) (arte).
