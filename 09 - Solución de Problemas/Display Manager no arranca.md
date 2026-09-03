---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: troubleshooting
prioridad: alta
---

# Display Manager no arranca

> El gestor de pantalla (GDM, SDDM, LightDM, LXDM) no muestra la pantalla de login o se cae al intentar iniciar sesión. El escritorio no carga, la pantalla parpadea y vuelve al login, o aparece un error gráfico.

## Síntoma

- La pantalla de login (greeter) no aparece — solo se ve un cursor o pantalla negra.
- Al introducir usuario y contraseña, vuelve al login sin cargar el escritorio.
- La pantalla parpadea y se reinicia al intentar iniciar sesión.
- Error "Oh no! Something has gone wrong" (GNOME/GDM).
- La sesión se cierra inmediatamente después de abrirla (logout automático).
- `systemctl status gdm` / `sddm` / `lightdm` muestra "failed" o "inactive".

## Diagnóstico

```bash
# 1. ¿Qué display manager está instalado y activo?
systemctl status display-manager           # cuál está activo
cat /etc/X11/default-display-manager 2>/dev/null  # Debian/Ubuntu
ls /etc/systemd/system/display-manager.service    # symlink activo

# 2. ¿Está corriendo?
systemctl status gdm3
systemctl status sddm
systemctl status lightdm

# 3. Ver logs del display manager
sudo journalctl -u gdm3 -b --no-pager -n 50
sudo journalctl -u sddm -b --no-pager -n 50
sudo journalctl -u lightdm -b --no-pager -n 50

# 4. Ver logs de Xorg / Wayland
cat /var/log/Xorg.0.log | grep -E "EE|WW" | tail -20    # errores X11
journalctl -b | grep -iE "wayland|wayfire|gnome-shell"  # errores Wayland

# 5. Verificar espacio en disco
df -h / /tmp /home

# 6. Verificar que no hay sesiones X residuales
ps aux | grep -E "Xorg|Xwayland|gnome-shell|plasmashell"
ls /tmp/.X*-lock 2>/dev/null                             # locks de X

# 7. Verificar permisos
ls -la /tmp/.X11-unix/
id $USER | grep -o "video\|input"                        # usuario en grupos video/input

# 8. Verificar drivers gráficos
lspci -k | grep -A 3 -i vga
glxinfo | grep "OpenGL renderer" 2>/dev/null
cat /var/log/Xorg.0.log | grep "driver" | head -5
```

### Logs relevantes

```bash
# GDM
sudo journalctl -u gdm3 -b --no-pager | grep -iE "error|fail|cannot|unable" | tail -30

# SDDM
sudo journalctl -u sddm -b --no-pager | grep -iE "error|fail|cannot" | tail -30
cat /var/log/sddm.log 2>/dev/null | tail -30

# LightDM
sudo journalctl -u lightdm -b --no-pager | grep -iE "error|fail" | tail -30
cat /var/log/lightdm/lightdm.log 2>/dev/null | tail -30
cat /var/log/lightdm/seat0-greeter.log 2>/dev/null | tail -30

# GNOME session
journalctl -b | grep -iE "gnome-session|gnome-shell" | grep -iE "error|crash|segfault" | tail -20

# Logs de la sesión del usuario
cat ~/.xsession-errors 2>/dev/null | tail -30
cat ~/.local/share/xorg/Xorg.0.log 2>/dev/null | grep "EE" | tail -10
```

## Causa

1. **Drivers gráficos ausentes o rotos** — NVIDIA proprietary desinstalado a medias, nouveau blacklist sin alternativa, AMDGPU no cargado.
2. **Espacio en disco lleno** — /tmp, /home o / no tienen espacio para la sesión.
3. **Sesión X residual** — un proceso X anterior no terminó limpiamente y bloquea el nuevo.
4. **Configuración de pantalla corrupta** — resolución, frecuencia o configuración multi-monitor incorrecta.
5. **Permisos incorrectos** — usuario no está en el grupo `video` o `input`, /tmp no tiene permisos correctos.
6. **Display manager equivocado** — conflicto entre display managers instalados (GDM + LightDM).
7. **Compositor/DE corrupto** — gnome-shell, plasmashell o sway con configuración rota.
8. **Wayland incompatible** — hardware o drivers no soportan Wayland, pero el DM intenta usarlo.

## Solución

### Caso 1: sesión X residual bloqueando

```bash
# Desde TTY (Ctrl+Alt+F2 o F3):
# Matar sesiones residuales
sudo killall -9 Xorg
sudo killall -9 Xwayland
sudo killall -9 gnome-shell
sudo killall -9 plasmashell

# Limpiar locks
sudo rm -f /tmp/.X*-lock
sudo rm -f /tmp/.ICE-socket

# Reiniciar el DM
sudo systemctl restart gdm3       # o sddm, lightdm
```

### Caso 2: espacio en disco lleno

```bash
# Desde TTY:
df -h / /tmp /home

# Liberar espacio urgente
sudo journalctl --vacuum-size=50M
sudo apt clean                    # Debian/Ubuntu
sudo pacman -Scc                  # Arch
sudo rm -rf /tmp/*
sudo rm -rf ~/.cache/thumbnails/*
du -sh ~/.cache/* | sort -rn | head -10  # ver qué pesa más
```

### Caso 3: drivers gráficos rotos

```bash
# Desde TTY:

# --- NVIDIA ---
# Desinstalar completamente y reinstalar
sudo apt purge 'nvidia-*'        # Debian/Ubuntu
sudo pacman -Rns nvidia-utils    # Arch
# Reinstalar
sudo ubuntu-drivers autoinstall  # Ubuntu
sudo pacman -S nvidia-utils      # Arch

# --- Si no hay GPU dedicada, usar nouveau ---
sudo apt install xserver-xorg-video-nouveau

# --- Verificar que el driver carga ---
lsmod | grep -E "nvidia|nouveau|amdgpu|radeon|i915"
dmesg | grep -iE "gpu|drm|nvidia|amdgpu" | tail -10
```

### Caso 4: display manager equivocado (conflicto)

```bash
# Verificar qué DMs están instalados
dpkg -l | grep -E "gdm|lightdm|sddm|lxdm"  # Debian/Ubuntu
pacman -Qs -E "gdm|lightdm|sddm"             # Arch

# Desactivar todos excepto uno
sudo systemctl disable gdm3
sudo systemctl disable lightdm
sudo systemctl disable sddm
sudo systemctl enable gdm3       # o el que quieras usar
sudo reboot
```

### Caso 5: permisos incorrectos

```bash
# Desde TTY:
# Agregar usuario a grupos necesarios
sudo usermod -aG video,input $USER
sudo usermod -aG audio $USER

# Corregir permisos de /tmp
sudo chmod 1777 /tmp
sudo chown root:root /tmp

# Corregir permisos de home (si cambiaron)
chmod 700 ~/
chmod -R u+rw ~/.config ~/.local
```

### Caso 6: Wayland incompatible (forzar X11)

```bash
# GDM: al login, hacer clic en el ícono de engranaje → "Ubuntu on Xorg"
# O forzar permanentemente:
sudo mkdir -p /etc/gdm3/custom.conf.d/
echo "WaylandEnable=false" | sudo tee /etc/gdm3/custom.conf.d/10-no-wayland.conf
# O editar /etc/gdm3/custom.conf:
#   [daemon]
#   WaylandEnable=false
sudo systemctl restart gdm3

# SDDM:
# En /etc/sddm.conf:
#   [General]
#   DisplayServer=x11
sudo systemctl restart sddm
```

### Caso 7: configuración de sesión corrupta

```bash
# Resetear configuración de GNOME
dconf reset -f /org/gnome/      # ⚠️ borra todas las preferencias GNOME
rm -rf ~/.config/gnome-shell     # configuración de GNOME Shell
rm -rf ~/.local/share/gnome-shell

# Resetear configuración de KDE
rm -rf ~/.config/plasmashell*
rm -rf ~/.config/plasma-*

# Resetear configuración de Sway/Hyprland
mv ~/.config/sway/config ~/.config/sway/config.bak
mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.bak
```

### Verificación

```bash
# Tras aplicar la solución:
sudo reboot

# Verificar que el DM funciona:
systemctl status display-manager    # debe mostrar "active (running)"
loginctl list-sessions              # sesión activa

# Verificar drivers:
glxinfo | grep "OpenGL renderer"   # debe mostrar tu GPU
xrandr --listmonitors              # monitores detectados
```

## Escenarios / Variantes

| Variante / Síntoma | Causa típica | Solución rápida |
|---|---|---|
| **"Oh no! Something has gone wrong"** (GNOME) | gnome-shell crash o extensión rota | `dconf reset -f /org/gnome/` o desactivar extensiones desde TTY |
| **Login vuelve al login (loop)** | Sesión corrupta o falta compositor | Crear usuario temporal para diagnosticar, o `dconf reset` |
| **Pantalla negra con cursor** | Compositor no carga (Wayland/X11) | Cambiar a X11 en GDM (ícono engranaje) o `WaylandEnable=false` |
| **DM funciona pero sesión está en negro** | .xsession-errors lleno, extensión rota | Revisar `~/.xsession-errors`, renombrar `~/.config/gnome-shell` |
| **LightDM muestra "failed to start session"** | Sesión .xsession corrupta | Verificar `~/.xsession` tiene `exec startxfce4` (o tu DE) |
| **GDM muestra solo "Cancel"** | No hay sesiones disponibles | `sudo dpkg-reconfigure gdm3` desde TTY |
| **SDDM no muestra usuarios** | /etc/passwd corrupto o sddm.conf mal | Verificar `/etc/passwd` tiene tu usuario, reinstall sddm |
| **Login funciona pero escritorio crashea** | GPU driver issue | `lspci -k` verificar driver, reinstalar driver GPU |

## Prevención

1. **No instalar múltiples display managers** simultáneamente — elige uno y desactiva los demás.
2. **Hacer snapshot antes de actualizar drivers GPU** — `timeshift` o `snapper`.
3. **Mantener espacio en /tmp** — systemd limpia /tmp al reiniciar, pero verifica periódicamente.
4. **No instalar extensiones GNOME de fuentes no oficiales** sin verificar compatibilidad.
5. **Verificar Wayland antes de actualizar** —有些 apps y hardware no funcionan en Wayland aún.
6. **Mantener el usuario en los grupos `video` e `input`** — sin ellos, el DM no puede acceder al hardware gráfico.

## Notas adicionales

- Si puedes acceder a TTY (Ctrl+Alt+F2), el problema es solo el display manager, no el kernel.
- Si TTY tampoco funciona, el problema es más grave — revisar [[Pantalla en negro tras actualizar drivers]].
- `startx` desde TTY puede servir como workaround temporal si el DM no arranca.
- Si cambias de GDM a LightDM (o viceversa), ejecuta `sudo dpkg-reconfigure <nuevo-dm>` para configurarlo correctamente.

## Enlaces externos

- [Arch Wiki — Display manager](https://wiki.archlinux.org/title/Display_manager)
- [Arch Wiki — GDM](https://wiki.archlinux.org/title/GDM)
- [Arch Wiki — SDDM](https://wiki.archlinux.org/title/SDDM)
- [Ubuntu Wiki — GDM troubleshooting](https://help.ubuntu.com/community/GNOMEShell/GDM)
- [Arch Wiki — Xorg troubleshooting](https://wiki.archlinux.org/title/Xorg/Troubleshooting)

## Ver también

- [[Pantalla en negro tras actualizar drivers]] — troubleshooting GPU específico
- [[Resolución de pantalla y multi-monitor]] — configuración de pantalla
- [[NVIDIA no detecta]] — drivers NVIDIA
- [[Sistema no arranca]] — troubleshooting general de arranque
- [[Compatibilidad Wayland]] — qué funciona en Wayland

#troubleshooting #display-manager #x11 #wayland
