export interface ModalButton { label: string; value: string; enableAfterMs?: number; primary?: boolean }

/** Ventana HTML mínima para simular diálogos nativos (anuncio, compra, consentimiento) en el navegador. */
export function modal(title: string, body: string, buttons: ModalButton[]): Promise<string> {
  return new Promise(resolve => {
    const root = document.createElement('div');
    root.setAttribute('data-testid', 'mock-modal');
    root.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,.75);display:flex;align-items:center;justify-content:center;z-index:9999;font-family:system-ui,sans-serif';
    // Phaser escucha eventos a nivel de ventana: sin esto, tocar el diálogo también "toca" el juego de abajo.
    for (const ev of ['pointerdown', 'pointerup', 'mousedown', 'mouseup', 'touchstart', 'touchend', 'click'])
      root.addEventListener(ev, e => e.stopPropagation());
    const box = document.createElement('div');
    box.style.cssText = 'background:#2a1a4a;color:#fff;border:3px solid #6a2cdc;border-radius:14px;padding:20px;max-width:420px;width:86%;text-align:center';
    box.innerHTML = `<h2 style="margin:0 0 10px">${title}</h2><p style="margin:0 0 16px;white-space:pre-line">${body}</p>`;
    const row = document.createElement('div');
    row.style.cssText = 'display:flex;gap:10px;justify-content:center;flex-wrap:wrap';
    const timers: number[] = [];
    for (const b of buttons) {
      const el = document.createElement('button');
      el.textContent = b.label;
      el.setAttribute('data-value', b.value);
      el.style.cssText = `padding:10px 16px;border-radius:8px;border:0;font-size:16px;color:#fff;background:${b.primary ? '#2ea043' : '#555577'}`;
      if (b.enableAfterMs) {
        el.disabled = true; el.style.opacity = '.5';
        timers.push(window.setTimeout(() => { el.disabled = false; el.style.opacity = '1'; }, b.enableAfterMs));
      }
      el.onclick = () => { timers.forEach(clearTimeout); root.remove(); resolve(b.value); };
      row.appendChild(el);
    }
    box.appendChild(row); root.appendChild(box); document.body.appendChild(root);
  });
}
