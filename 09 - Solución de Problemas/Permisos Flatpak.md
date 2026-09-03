---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: troubleshooting
prioridad: media
---

# Permisos Flatpak

> Una aplicación Flatpak no puede acceder a archivos, cámaras, micrófonos, carpetas específicas, o la red. Flatpak usa un sistema de permisos basado en portals y sandboxing que restringe el acceso por defecto.

## Síntoma

- La app no puede abrir archivos fuera de ~/Downloads, ~/Documents, etc.
- La cámara o micrófono no funciona en la app Flatpak.
- La app no puede acceder a carpetas personalizadas (ej: /mnt/datos, ~/.config/otra-app).
- La app no puede usar la red o conectarse a servidores locales.
- La app no puede acceder a dispositivos USB o Bluetooth.
- "Permission denied" al intentar escribir en rutas no estándar.
- La app no muestra archivos al intentar abrir/guardar (portal no funciona).

## Diagnóstico

```bash
# 1. Ver permisos actuales de una app
flatpak info --show-permissions com.app.Ejemplo

# 2. Ver permisos detallados (JSON)
flatpak info --show-permissions com.app.Ejemplo | python3 -m json.tool 2>/dev/null || \
  flatpak info --show-permissions com.app.Ejemplo

# 3. Ver qué portales están disponibles
flatpak list --runtime | grep -i portal
ls /usr/share/xdg-desktop-portal/portals/ 2>/dev/null
ls /var/lib/flatpak/exports/share/xdg-desktop-portal/portals/ 2>/dev/null

# 4. Verificar que xdg-desktop-portal funciona
systemctl --user status xdg-desktop-portal
systemctl --user status xdg-desktop-portal-gtk     # o -gnome, -kde
busctl --user list | grep portal

# 5. Ver logs de la app Flatpak
flatpak run --command=sh com.app.Ejemplo           # lanzar shell en el sandbox
flatpak run --command=ls com.app.Ejemplo /          # ver qué ve la app

# 6. Ver permisos de filesystem
flatpak info --show-permissions com.app.Ejemplo | grep -i filesystem

# 7. Verificar overrides
flatpak override --show com.app.Ejemplo
cat ~/.local/share/flatpak/overrides/com.app.Ejemplo 2>/dev/null
```

### Logs relevantes

```bash
# Logs de xdg-desktop-portal
journalctl --user -u xdg-desktop-portal --no-pager -n 30
journalctl --user -u xdg-desktop-portal-gtk --no-pager -n 30

# Logs de la app Flatpak
journalctl --user | grep -i "com.app.Ejemplo" | tail -20

# Verificar que el portal responde
busctl --user call org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop \
  org.freedesktop.DBus.Properties GetAll "s" "org.freedesktop.portal.FileChooser"
```

## Causa

1. **Sandboxing por defecto** — Flatpak restringe acceso a filesystem, cámara, micrófono, red, etc. por defecto.
2. **Portal no instalado** — `xdg-desktop-portal` o su backend (gtk/gnome/kde) no está instalado.
3. **Portal no compatible con el compositor** — portal GTK en sesión KDE, o viceversa.
4. **Permisos insuficientes** — la app necesita acceso a rutas que no están en las excepciones por defecto.
5. **Filesystem exception mal configurada** — la excepción usa el nombre de portal viejo o una ruta incorrecta.
6. **App legacy que no usa portales** — apps que intentan abrir `/home/user/archivo` directamente en vez de usar el file chooser portal.

## Solución

### Caso 1: dar acceso a una carpeta específica

```bash
# Dar acceso de lectura/escritura a una carpeta
flatpak override --user --filesystem=~/datos com.app.Ejemplo

# Acceso a un dispositivo montado
flatpak override --user --filesystem=/mnt/datos com.app.Ejemplo
flatpak override --user --filesystem=/media/$USER/USB com.app.Ejemplo

# Acceso completo al home (⚠️ rompe el sandbox)
flatpak override --user --filesystem=home com.app.Ejemplo

# Acceso completo al sistema (⚠️ NO recomendado)
flatpak override --user --filesystem=host com.app.Ejemplo

# Verificar que se aplicó
flatpak override --show com.app.Ejemplo
```

### Caso 2: cámara o micrófono no funciona

```bash
# Habilitar dispositivo de cámara
flatpak override --user --device=dri com.app.Ejemplo      # GPU
flatpak override --user --socket=wayland com.app.Ejemplo  # Wayland
flatpak override --user --socket=x11 com.app.Ejemplo      # X11

# Para cámara específica:
flatpak override --user --filesystem=xdg-run/pipewire com.app.Ejemplo
flatpak override --user --socket=pipewire com.app.Ejemplo

# Verificar que xdg-desktop-portal funciona:
flatpak list --runtime | grep portal
# Si falta:
sudo flatpak install flathub org.freedesktop.Platform.GL.default
flatpak install flathub org.freedesktop.Platform

# Para apps de cámara (ej: OBS):
flatpak override --user --device=dri com.obsproject.Studio
flatpak override --user --filesystem=xdg-run/pipewire com.obsproject.Studio
```

### Caso 3: portal no instalado o incompatible

```bash
# Instalar portal para tu desktop environment
# GNOME:
sudo apt install xdg-desktop-portal-gnome          # Debian/Ubuntu
sudo pacman -S xdg-desktop-portal-gnome              # Arch

# KDE:
sudo apt install xdg-desktop-portal-kde              # Debian/Ubuntu
sudo pacman -S xdg-desktop-portal-kde                # Arch

# GTK (genérico, funciona en la mayoría):
sudo apt install xdg-desktop-portal-gtk              # Debian/Ubuntu
sudo pacman -S xdg-desktop-portal-gtk                # Arch

# Reiniciar portal
systemctl --user restart xdg-desktop-portal

# Verificar que el portal correcto está activo:
busctl --user list | grep portal
# Debe mostrar: org.freedesktop.portal.Desktop
```

### Caso 4: app no puede acceder a la red

```bash
# Habilitar acceso a la red
flatpak override --user --share=network com.app.Ejemplo

# Para localhost/servidores locales
flatpak override --user --share=network --system-talk-name=org.freedesktop.Resolve com.app.Ejemplo

# Desactivar sandbox de red completamente (⚠️ NO recomendado)
flatpak override --user --share=network --share=ipc com.app.Ejemplo
```

### Caso 5: resetear todos los permisos de una app

```bash
# Eliminar todos los overrides
flatpak override --user --reset com.app.Ejemplo

# Verificar que se limpiaron
flatpak override --show com.app.Ejemplo
# Debe retornar vacío o error
```

### Caso 6:-permisos desde Flatseal (GUI)

```bash
# Instalar Flatseal (editor gráfico de permisos Flatpak)
flatpak install flathub com.github.tchx84.Flatseal

# Abrir Flatseal y seleccionar la app
flatpak run com.github.tchx84.Flatseal
# Desde ahí puedes activar/desactivar:
# - Filesystem: home, host, custom paths
# - Devices: dri, all, camera, microphone
# - Sockets: wayland, x11, network, pulseaudio, pipewire
# - Variables de entorno
```

### Verificación

```bash
# Tras aplicar cambios:
flatpak info --show-permissions com.app.Ejemplo | grep filesystem
# Debe mostrar las rutas que añadiste

# Test: lanzar la app y verificar acceso
flatpak run com.app.Ejemplo
# Intentar abrir/guardar archivos en la carpeta configurada
```

## Escenarios / Variantes

| Variante / Síntoma | Causa típica | Solución rápida |
|---|---|---|
| **No puede abrir archivos** | Sin `--filesystem=home` | `flatpak override --user --filesystem=home` |
| **Cámara no funciona** | Sin `--device=dri` ni pipewire socket | `--device=dri --socket=pipewire --filesystem=xdg-run/pipewire` |
| **No hay sonido** | Sin pulseaudio/pipewire socket | `--socket=pulseaudio --socket=pipewire` |
| **No puede imprimir** | Sin acceso a CUPS | `--system-talk-name=org.freedesktop.RealtimeKit1` |
| **File chooser no muestra archivos** | Portal no instalado | Instalar `xdg-desktop-portal-gtk` |
| **App vieja no abre archivos** | No usa portals | `--filesystem=home` o `--filesystem=host` |
| **Flatpak no actualiza** | Permisos de repo | `flatpak remote-modify --user --no-gpg-verify flathub` |
| **App no inicia** | Runtime faltante | `flatpak install flathub org.freedesktop.Platform//XX.X` |

## Prevención

1. **Usar Flatseal** para gestionar permisos visualmente — es más seguro que la CLI.
2. **Instalar `xdg-desktop-portal` + backend** al instalar Flatpak — necesario para la mayoría de las apps.
3. **No usar `--filesystem=host`** a menos que sea estrictamente necesario — rompe el sandbox.
4. **Preferir apps que usen portales** — las apps que usan portals funcionan correctamente sin overrides.
5. **Al instalar una app Flatpak**, verificar sus permisos con `flatpak info --show-permissions` antes de usarla.

## Notas adicionales

- Las `--filesystem=xdg-*` (xdg-download, xdg-documents, etc.) son las rutas estándar que Flatpak expone por defecto.
- `--filesystem=host` expone TODO el filesystem — es equivalente a no tener sandboxing para archivos.
- Si una app Flatpak no funciona y no sabes por qué, prueba con la versión nativa del sistema (apt/pacman) — puede que la app tenga bugs en su build Flatpak.
- `flatpak override --user` solo afecta al usuario actual. Para overrides globales, usar `flatpak override --system`.
- Al desinstalar una app Flatpak, los overrides se eliminan automáticamente.

## Enlaces externos

- [Flatpak docs — Sandboxing permissions](https://docs.flatpak.org/en/latest/sandbox-permissions.html)
- [Arch Wiki — Flatpak](https://wiki.archlinux.org/title/Flatpak)
- [Flatseal](https://github.com/tchx84/Flatseal)
- [xdg-desktop-portal](https://flatpak.github.io/xdg-desktop-portal/)
- [Flatpak FAQ](https://github.com/flatpak/flatpak/wiki/FAQ)

## Ver también

- [[Flatpak]] — instalación, uso, comparativa con Snap
- [[Error de permisos]] — permisos en Linux
- [[Docker permiso denegado]] — permisos en contenedores
- [[Disco lleno (No space left on device)]] — Flatpak ocupa mucho espacio

#troubleshooting #flatpak #sandbox
