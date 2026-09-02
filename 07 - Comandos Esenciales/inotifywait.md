---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: comando
prioridad: media
---

# inotifywait

> Espera y reporta eventos del sistema de archivos en tiempo real (creación, modificación, eliminación de archivos). La herramienta base para watchers, sync y automatización.

## Sintaxis

```bash
inotifywait [opciones] archivo/directorio
```

## Descripción

**inotifywait** forma parte de **inotify-tools** y usa el sistema `inotify` del kernel Linux para monitorear eventos de archivos/directorios. Es la herramienta estándar para scripts de auto-ejecución cuando cambian archivos.

## Instalación

```bash
sudo apt install inotify-tools        # Debian / Ubuntu
sudo pacman -S inotify-tools          # Arch / CachyOS
sudo dnf install inotify-tools        # Fedora
```

## Ejemplos prácticos

```bash
# Esperar a que se modifique un archivo
inotifywait -e modify /etc/nginx/nginx.conf
echo "¡Se modificó nginx.conf!"

# Monitorear un directorio (eventos:create,delete,modify)
inotifywait -m -r -e create,delete,modify ~/proyecto/

# Ejecutar un comando al detectar cambio
while inotifywait -e modify -r ~/docs/; do
  echo "Cambio detectado, sincronizando..."
  rsync -av ~/docs/ backup@server:/backup/docs/
done

# Monitorear con formato de salida
inotifywait -m --format '%w%f %e' ~/archivos/

# Monitorear solo archivos .md
inotifywait -m -r -e modify --include '\.md$' ~/vault/
```

## Eventos soportados

| Evento | Significado |
|---|---|
| `access` | Archivo leído |
| `modify` | Archivo modificado |
| `attrib` | Metadatos cambiados (chmod, chown) |
| `close_write` | Archivo cerrado tras escritura |
| `create` | Archivo/directorio creado |
| `delete` | Archivo/directorio eliminado |
| `moved_to` | Archivo movido al directorio |
| `moved_from` | Archivo movido fuera del directorio |
| `open` | Archivo abierto |

## Opciones útiles

| Opción | Efecto |
|---|---|
| `-m` | Monitorear continuamente (no salir) |
| `-r` | Recursivo en subdirectorios |
| `-e <evento>` | Filtrar por tipo de evento |
| `--format` | Formato de salida personalizado |
| `--include` | Patrón regex para incluir archivos |
| `--exclude` | Patrón regex para excluir archivos |

## Uso avanzado: watchers systemd

```bash
# Crear un servicio systemd que reaccione a cambios
cat > /etc/systemd/system/vault-watcher.service <<EOF
[Unit]
Description=Watcher del vault Obsidian
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/inotifywait -m -r -e modify,create,delete \\
  --include '\.md$' /home/user/vault/ \\
  --format '%w%f %e' | while read f e; do
  echo "Cambio: $f ($e)"
done
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

## inotifywait vs fswatch vs watchdog

| Aspecto | inotifywait | fswatch (macOS) | watchdog (Python) |
|---|---|---|---|
| Sistema | inotify (Linux) | FSEvents (macOS) | multiplataforma |
| Instalación | `inotify-tools` | `fswatch` (brew) | `pip install watchdog` |
| Uso | CLI | CLI | API Python |
| Ideal | Scripts bash | macOS | Apps Python |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "No space left on device" | Demasiados watchers | Aumentar `fs.inotify.max_user_watches` en sysctl |
| No detecta eventos | Falta soporte inotify en filesystem | Verificar con `cat /proc/sys/fs/inotify/max_user_watches` |
| Eventos perdidos | Alta frecuencia de cambios | Usar `close_write` en vez de `modify` |

## Ver también

- [[rsync]] — sincronización de archivos
- [[cron]] — tareas programadas
- [[systemd timers]] — timers systemd
- [[Git hooks para el vault]] — automatización del vault

## Enlaces externos

- [inotify-tools — GitHub](https://github.com/rvoicilas/inotify-tools)
- [Arch Wiki — inotify](https://wiki.archlinux.org/title/Inotify)

#comando #automatizacion #fswatch
