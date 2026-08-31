---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: entorno-escritorio
prioridad: media
---

# Tema Material You en el escritorio

> Cadena de tematización de arriba a abajo: el wallpaper define la paleta (Material You), Noctalia la extrae y genera temas por aplicación, y unidades systemd recargan las apps en vivo. Cada app recibe su `noctalia.toml` / `.conf` / theme propio.

## La cadena (de wallpaper a cada app)

```text
Wallpaper → Noctalia "theme" extrae colores (Material You)
         → plantillas por app (templates-apply)
         → apps recargan con systemd watchers
```

1. `noctalia msg wallpaper-*` cambia el fondo y regenera el tema.
2. Noctalia escribe plantillas generadas por app:
   - `~/.config/alacritty/themes/noctalia.toml`
   - `~/.config/kitty/themes/noctalia.conf`
   - `~/.config/ghostty/themes/`
   - `~/.config/kew/` → `gen-noctalia.sh` → `themes/noctalia.theme`
3. Watchers systemd (usuario) detectan el cambio y recargan la app que no se recarga sola (emitido en notas de systemd automático).

## Comandos relacionados

| Comando | Acción |
|---|---|
| `noctalia msg wallpaper-*` | Cambiar/aleatorio fondo |
| `noctalia msg theme-mode-set` | Modo claro/oscuro |
| `noctalia msg templates-apply` | Reaplicar plantillas a apps |
| `noctalia msg color-scheme-get` | Consultar esquema actual |

## GTK

- `gsettings color-scheme 'prefer-dark'`
- Tema GTK: `adw-gtk3-dark`

## Ver también

- [[Desktop Shells (Noctalia Caelestia)]] — orquesta la cadena
- [[Niri]] — el compositor, recibe el tema vía `noctalia.kdl`
- [[Personalización en Linux]] — capas de personalización en general
- [[kew]] — ejemplo de app tematizada por Noctalia

#entorno-escritorio #tema #material-you