---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: automatizacion
prioridad: media
tipo: Nota de systemd user units
---

# systemd user watchers para temas Noctalia

Units de usuario (`~/.config/systemd/user/`) que vigilan el archivo de paleta que Noctalia reescribe en cada cambio de tema (`~/.config/alacritty/themes/noctalia.toml`) y disparan acciones para que otras apps actualicen sus colores en vivo.

## Patrón PathChanged → oneshot

| Unit | Path vigila | Servicio | Ejecuta |
|---|---|---|---|
| `noctalia-alacritty.path` | `%h/.config/alacritty/themes/noctalia.toml` | `noctalia-alacritty.service` | `touch %h/.config/alacritty/alacritty.toml` (fuerza live reload) |
| `noctalia-kew.path` | `%h/.config/alacritty/themes/noctalia.toml` | `noctalia-kew.service` | `%h/.config/kew/gen-noctalia.sh` (regenera tema de kew) |

### noctalia-alacritty.path

```systemd
[Unit]
Description=Vigila la paleta Noctalia para forzar la recarga del tema en Alacritty

[Path]
PathChanged=%h/.config/alacritty/themes/noctalia.toml
Unit=noctalia-alacritty.service

[Install]
WantedBy=default.target
```

### noctalia-alacritty.service

```systemd
[Unit]
Description=Recarga el tema en instancias de Alacritty abiertas

[Service]
Type=oneshot
ExecStart=/usr/bin/touch %h/.config/alacritty/alacritty.toml
```

### noctalia-kew.path

```systemd
[Unit]
Description=Vigila la paleta Noctalia para regenerar el tema de kew

[Path]
PathChanged=%h/.config/alacritty/themes/noctalia.toml
Unit=noctalia-kew.service

[Install]
WantedBy=default.target
```

### noctalia-kew.service

```systemd
[Unit]
Description=Genera el tema de kew a partir de la paleta Noctalia

[Service]
Type=oneshot
ExecStart=%h/.config/kew/gen-noctalia.sh
```

## Gestión

```bash
systemctl --user daemon-reload
systemctl --user enable --now noctalia-alacritty.path
systemctl --user enable --now noctalia-kew.path
systemctl --user status noctalia-alacritty.path
systemctl --user show noctalia-alacritty.service -p Result    # Result=success
```

## Por qué tocar alacritty.toml

Alacritty tiene `live_config_reload = true` pero **solo vigila su config principal**, no los archivos importados. Noctalia usa *write-if-changed*: en un cambio de tema solo reescribe el archivo de paleta importado, así que el mtime de `alacritty.toml` no cambia y las instancias abiertas no recargan. `touch` fuerza la recarga.

## Ver también

- [[Scripts de personalización del sistema]]
- [[Desktop Shells (Noctalia Caelestia)]] — temas Material You por app
- [[Niri]]

#automatizacion #systemd #temas #noctalia