---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: troubleshooting
sistema: gráficos / monitores
prioridad: alta
---

# Resolución de pantalla incorrecta / configuración multi-monitor

> El monitor muestra una resolución incorrecta (pixelada, estirada, o muy pequeña), el segundo monitor no se detecta, o la configuración de pantallas extendidas no funciona como se espera.

## Síntoma

- La resolución máxima disponible es más baja de la que soporta el monitor (ej. 1024×768 en un monitor 1920×1080)
- El segundo monitor conectado no se detecta
- Las pantallas se muestran clonadas en vez de extendidas
- La imagen se ve estirada o con relaciones de aspecto incorrectas
- Al cerrar la tapa del laptop, la pantalla externa también se apaga
- La posición relativa de los monitores no se guarda al reiniciar

## Diagnóstico

```bash
# 1. Ver monitores detectados y resoluciones disponibles
xrandr                                     # X11 (muestra todos los outputs y modos)
wlr-randr                                  # Wayland (compositor wlroots-based)
kscreen-doctor --outputs                   # KDE Wayland
gnome-control-center display               # GNOME

# 2. GPU y driver en uso
lspci -k | grep -A 3 -E "(VGA|3D)"
glxinfo -B | grep "OpenGL renderer"       # driver de OpenGL

# 3. Modos de video disponibles y activos
xrandr --prop                              # propiedades detalladas de cada monitor
xrandr --listmonitors                      # lista resumen de monitores

# 4. Qué conexiones de video tiene la GPU
cat /sys/class/drm/*/status                # connected/disconnected
cat /sys/class/drm/*/edid                  # EDID del monitor (información del fabricante)
```

### Logs relevantes

```bash
journalctl -xe | grep -i "drm\|modeset\|edid\|display"
dmesg | grep -i "drm\|edid\|hdmi\|dp"
```

## Causa

1. **Driver gráfico incorrecto o no instalado** — sin el driver adecuado (NVIDIA, AMD, Intel), el sistema usa modos VESA genéricos limitados a 1024×768.
2. **EDID no detectado o corrupto** — el monitor no envía correctamente su información de resolución al sistema.
3. **Cable HDMI/DP defectuoso o incompatible** — cables HDMI viejos o DisplayPort con versión incorrecta limitan la resolución.
4. **X11 vs Wayland diferencias** — ciertos drivers NVIDIA legacy no soportan múltiples monitores correctamente en Wayland.
5. **Configuración de monitor en modo espejo** — la sesión se inicia con mirror activado en vez de extended.
6. **Perfil de energía al cerrar tapa** — systemd-logind apaga la pantalla interna al cerrar la tapa si no se configura correctamente.

## Solución

### 1. Driver gráfico — asegurar el correcto

```bash
# NVIDIA
sudo nvidia-settings                       # herramienta de configuración NVIDIA

# AMD
sudo apt install mesa-utils               # Debian/Ubuntu — drivers Mesa (incluidos en el kernel)

# Intel
# Los drivers Intel vienen en el kernel, pero instalar firmware si es necesario
sudo apt install intel-media-va-driver     # Debian/Ubuntu (codificación/decodificación)
```

Ver [[Pantalla en negro tras actualizar drivers]] si hay problemas con el driver.

### 2. Forzar resolución manualmente con xrandr

```bash
# Ver qué outputs existen y qué modo quieres
xrandr                                     # ej. HDMI-1, eDP-1 (pantalla laptop), DP-1

# Si tu resolución 1920×1080 no aparece, créala:
cvt 1920 1080 60                           # genera modeline
# Ejemplo output: Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync

# Crear el nuevo modo y asignarlo
xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
xrandr --addmode HDMI-1 "1920x1080_60.00"
xrandr --output HDMI-1 --mode "1920x1080_60.00"
```

### 3. Configurar multi-monitor (extendido, no clonado)

```bash
# Extender escritorio: monitor HDMI-1 a la derecha del laptop
xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1

# Extender a la izquierda
xrandr --output eDP-1 --auto --output HDMI-1 --auto --left-of eDP-1

# Espejo (clonar)
xrandr --output eDP-1 --auto --output HDMI-1 --same-as eDP-1

# Solo monitor externo (apagar laptop)
xrandr --output eDP-1 --off --output HDMI-1 --auto

# Posición + resolución específica
xrandr --output eDP-1 --mode 1920x1080 --output HDMI-1 --mode 2560x1440 --right-of eDP-1
```

### 4. Configurar al cerrar la tapa (laptops)

```bash
# Editar /etc/systemd/logind.conf
sudo nano /etc/systemd/logind.conf
# HandleLidSwitch=ignore                     # no hacer nada al cerrar tapa
# HandleLidSwitchExternalPower=lock          # bloquear si está enchufado
# HandleLidSwitchDocked=ignore               # si hay dock, ignorar

sudo systemctl restart systemd-logind
```

### 5. Guardar configuración para que persista al reiniciar

```bash
# Crear script y ejecutarlo al inicio
sudo nano /usr/local/bin/setup-monitors.sh
# Contenido:
# #!/bin/bash
# xrandr --output eDP-1 --mode 1920x1080 --output HDMI-1 --mode 2560x1440 --right-of eDP-1

sudo chmod +x /usr/local/bin/setup-monitors.sh

# Añadir a inicio automático:
# GNOME: Ajustes → Aplicaciones al inicio
# KDE: Preferencias del Sistema → Inicio y cierre → Autoinicio
# O usar systemd user service
```

### 6. Wayland específico (GNOME/KDE/Sway)

```bash
# GNOME (configuración guardada automáticamente en dconf)
gsettings set org.gnome.mutter check-alsasrc false      # evitar problemas con sonido

# KDE — kscreen guarda la configuración automáticamente
# Si no se guarda: eliminar ~/.local/share/kscreen/ y reconfigurar

# Sway (compositor wlroots) — configuración en ~/.config/sway/config
# output HDMI-A-1 mode 2560x1440@60Hz position 1920,0
# output eDP-1 mode 1920x1080@60Hz position 0,0
```

### Verificación

```bash
xrandr | grep " connected"                 # todos los monitores detectados y su estado
xrandr --current | grep -E "*\b"           # resolución activa (asterisco marca la activa)
# Debe mostrar la resolución deseada con un * al lado
```

## Prevención

- Usar cables HDMI 2.0+ o DisplayPort 1.4+ para resoluciones 4K a 60Hz
- Verificar que el driver gráfico esté instalado antes de conectar monitores externos
- Si usas dock/laptop, configurar `HandleLidSwitchDocked=ignore` en logind.conf
- En GNOME/KDE, la configuración multi-monitor se guarda automáticamente — forzarla con xrandr solo si no persiste
- Para sesiones en X11, crear un script xrandr y ejecutarlo al inicio

## Enlaces externos

- [Arch Wiki — Multi-monitor](https://wiki.archlinux.org/title/Multi-monitor)
- [Arch Wiki — xrandr](https://wiki.archlinux.org/title/Xrandr)
- [Ubuntu Help — Displays](https://help.ubuntu.com/stable/ubuntu-help/display-dual-monitors.html)

## Ver también

- [[Pantalla en negro tras actualizar drivers]] — cuando el driver falla directamente
- [[Wayland vs X11]] — diferencias entre servidores gráficos
- [[NVIDIA no detecta]] — driver NVIDIA no disponible
- [[Bootloaders (GRUB Limine systemd-boot)]] — parámetros de video en arranque

#troubleshooting
