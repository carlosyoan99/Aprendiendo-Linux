---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: automatizacion
prioridad: media
tipo: Tutorial de script
---

# OCR de pantalla con noctalia-ocr

Extrae texto de una región de la pantalla usando el selector nativo de Noctalia + tesseract, y lo copia al portapapeles. Keybind en niri: `Mod+Print`.

## Instalación

```bash
sudo pacman -S tesseract tesseract-data-eng   # mínimo (inglés)
sudo pacman -S tesseract-data-spa             # opcional: español nativo
```

El script resuelve idiomas automáticamente: si `spa` está instalado usa `spa+eng`, si no cae a `eng`. Se puede forzar con `NOCTALIA_OCR_LANGS`.

## Uso

```bash
noctalia-ocr     # selecciona una región; el texto va al portapapeles (wl-copy)
```

## Cómo funciona

1. Lanza `noctalia msg screenshot-region` (selector con overlay; `Esc` cancela).
2. Espera el nuevo PNG en `~/Imágenes/Screenshot/` (nombre `screenshot_*.png`).
3. Pasa la imagen por `tesseract --oem 1 --psm 6`.
4. Copia el texto con `wl-copy` y notifica `Copiados N caracteres al portapapeles`.

Notificaciones en español (éxito, cancelación, OCR sin resultado, tesseract ausente).

## Ver también

- [[Scripts de personalización del sistema]]
- [[Niri]] — keybinds (Mod+Print)

#automatizacion #scripts #ocr #noctalia