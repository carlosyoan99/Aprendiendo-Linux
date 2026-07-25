---
fecha_creacion: 2026-07-23
estado: resuelto
categoria: troubleshooting
sistema: teclado / input
prioridad: alta
---

# Teclado con layout incorrecto

> El teclado escribe símbolos que no corresponden a las teclas físicas (ej. aprietas "Y" y sale "Z", o los números dan símbolos, o la Ñ no aparece).

## Síntoma

- Las teclas no corresponden a lo impreso en el teclado físico
- La tecla `Ñ` no funciona (especialmente en teclados en español)
- Símbolos como `@`, `~`, `[ ]`, `{ }` aparecen en posiciones incorrectas
- El layout cambia solo después del login (consola vs escritorio)
- En TTY (Ctrl+Alt+F2) el layout es diferente al del escritorio

## Diagnóstico

```bash
# 1. Ver layout actual
localectl status                          # configuración del sistema
setxkbmap -query                          # layout actual en X11/Wayland (si corre)

# 2. Ver layouts disponibles
localectl list-keymaps                    # todos los layouts disponibles (systemd)
localectl list-x11-keymap-layouts         # layouts X11

# 3. Probar un layout específico (cambio temporal)
setxkbmap es                              # español (solo sesión X11 actual)
setxkbmap latam                           # español latinoamericano
setxkbmap us                              # inglés US

# 4. Para TTY (consola pura, sin X11)
cat /etc/vconsole.conf                    # layout de consola (distros con systemd)
cat /etc/default/keyboard                 # layout de consola (Debian/Ubuntu)

# 5. Ver variables de entorno
echo $LANG
echo $LC_ALL
locale                                    # configuración regional completa
```

## Causa

1. **Configuración incorrecta del layout en el DE** — GNOME/KDE tienen su propia configuración que puede sobreescribir la del sistema.
2. **Consola vs escritorio desincronizados** — el layout de TTY se configura con `/etc/vconsole.conf`; el de X11/Wayland con `setxkbmap` o la configuración del DE.
3. **Teclado detectado como inglés por defecto** — muchas distros instalan con layout US si no se selecciona español durante la instalación.
4. **Hotkeys del DE cambiando el layout** — combinaciones como `Alt+Shift` o `Super+Space` pueden cambiar de idioma sin que el usuario lo sepa.
5. **Múltiples layouts configurados** — el DE puede tener varios layouts activos con un atajo de teclado para alternar.

## Solución

### 1. Cambio permanente con localectl (systemd — todas las distros modernas)

```bash
# Español de España
sudo localectl set-keymap es
sudo localectl set-x11-keymap es

# Español latinoamericano
sudo localectl set-keymap latam
sudo localectl set-x11-keymap latam

# Verificar
localectl status
```

### 2. Debian/Ubuntu (método legacy con /etc/default/keyboard)

```bash
sudo nano /etc/default/keyboard
# Contenido:
# XKBLAYOUT=es
# XKBVARIANT=
# BACKSPACE=guess

sudo dpkg-reconfigure keyboard-configuration  # asistente interactivo
sudo setupcon                                  # aplicar cambios en consola
```

### 3. Configurar desde el escritorio (GNOME/KDE)

```bash
# GNOME
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'es')]"
# Alternativa: ir a Configuración → Región e Idioma → Fuente de entrada

# KDE
# Configuración del Sistema → Dispositivos de entrada → Teclado → Disposiciones
# Añadir "Español" y eliminar "Inglés (US)"

# XFCE
# Configuración → Teclado → Disposición → Marcar "Usar disposiciones específicas del sistema"
```

### 4. Para TTY (consola pura)

```bash
# Arch/manual (editar /etc/vconsole.conf)
sudo nano /etc/vconsole.conf
# KEYMAP=es
# FONT=Lat2-Terminus16

# Luego regenerar initramfs si usas teclado encriptado
sudo mkinitcpio -P                      # Arch
sudo update-initramfs -u                # Debian/Ubuntu
```

### 5. Eliminar atajos de cambio de layout (si cambia solo)

```bash
# GNOME
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"

# KDE
# Configuración → Dispositivos de entrada → Teclado → Disposiciones adicionales
# Desmarcar "Cambiar disposición con:" o cambiar la combinación
```

### Verificación

```bash
# Probar que el layout es correcto
echo "La Ñ y los acentos funcionan: áéíóú ñÑ @~"

# Verificar configuración persistente
localectl status
# System Locale: LANG=es_ES.UTF-8
# VC Keymap: es
# X11 Layout: es
```

## Prevención

- Durante la instalación de la distro, seleccionar siempre "Español (España)" o "Español (Latinoamérica)" como layout
- Tras instalar, verificar con `localectl status` que el layout sea correcto
- Si usas teclado en TTY (partición encriptada), asegurar que el keymap se cargue en initramfs
- Desactivar atajos de cambio de layout si solo usas un idioma

## Enlaces externos

- [Arch Wiki — Keyboard configuration](https://wiki.archlinux.org/title/Keyboard_configuration)
- [Debian Wiki — Keyboard](https://wiki.debian.org/Keyboard)
- [Ubuntu Help — Keyboard shortcuts](https://help.ubuntu.com/stable/ubuntu-help/keyboard-shortcuts-set.html)

## Ver también

- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — variables de entorno y locale
- [[Variables de Entorno y PATH]] — LANG y locale
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — keymap en initramfs

#troubleshooting
