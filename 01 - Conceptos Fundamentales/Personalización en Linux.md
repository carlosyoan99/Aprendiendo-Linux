---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: alta
---

# Personalización en Linux

## Definición

Linux permite personalizar casi todos los aspectos visuales y funcionales del sistema: desde temas GTK y Qt hasta iconos, cursores, fuentes, fondos de pantalla, pantallas de inicio de sesión, gestores de ventanas y shells. La personalización es una de las razones por las que muchos usuarios eligen Linux, especialmente en el ecosistema de entornos de escritorio y gestores de ventanas.

## Capas de personalización

```
  ┌────────────────────────────────────────────┐
  │              Tema del sistema               │
  │  (GTK theme, Qt theme, iconos, cursores)   │
  ├────────────────────────────────────────────┤
  │             Entorno de escritorio           │
  │  (GNOME, KDE, XFCE: paneles, widgets,      │
  │   dock, notificaciones, fondos)            │
  ├────────────────────────────────────────────┤
  │            Gestor de ventanas              │
  │  (i3, Hyprland: layouts, atajos, bordes,  │
  │   gaps, animaciones, barra de estado)      │
  ├────────────────────────────────────────────┤
  │            Aplicaciones del usuario         │
  │  (Terminal: alacritty/kitty, shell:        │
  │   zsh/fish, prompt, editor)               │
  ├────────────────────────────────────────────┤
  │         Pantalla de login (DM)             │
  │  (GDM, SDDM, LightDM: tema, fondo,         │
  │   usuario por defecto)                     │
  └────────────────────────────────────────────┘
```

## Temas GTK y Qt

### GTK (GNOME, XFCE, Cinnamon, MATE)

```bash
# Temas instalados
ls /usr/share/themes/
ls ~/.local/share/themes/
ls ~/.themes/

# Aplicar tema vía línea de comandos
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.wm.preferences theme "Adwaita-dark"

# Temas populares
# - Adwaita (default GNOME)
# - Arc (https://github.com/horst3180/arc-theme)
# - Catppuccin (https://github.com/catppuccin/gtk)
# - Nordic (https://github.com/EliverLara/Nordic)
# - Orchis (https://github.com/vinceliuice/Orchis-theme)
```

### Qt (KDE, LXQt)

```bash
# KDE Plasma — System Settings → Appearance
# O por CLI:
kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme "BreezeDark"

# Temas populares para KDE
# - Breeze (default KDE)
# - Layan (https://github.com/vinceliuice/Layan-kde)
# - Catppuccin para KDE
```

### Unificar GTK y Qt

Para que las apps GTK y Qt tengan la misma apariencia:

```bash
# Instalar el tema GTK para Qt (qt5-styleplugins o qt5gtk2)
sudo apt install qt5-style-plugins      # Debian/Ubuntu
export QT_STYLE_OVERRIDE=gtk2           # Qt usará el tema GTK
# O añadir a ~/.profile o /etc/environment

# Con kvantum (motor de temas Qt más potente)
sudo apt install qt5-style-kvantum      # Debian/Ubuntu
# Aplicar tema Kvantum desde su GUI: kvantummanager
```

## Iconos

```bash
# Instalación
ls /usr/share/icons/
ls ~/.local/share/icons/
ls ~/.icons/

# Cambiar tema de iconos
gsettings set org.gnome.desktop.interface icon-theme "Papirus"

# Temas populares
# - Papirus (https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
# - Tela (https://github.com/vinceliuice/Tela-icon-theme)
# - Numix (https://github.com/numixproject/numix-icon-theme)
# - Candy (https://github.com/EliverLara/candy-icons)
```

## Cursores

```bash
# Instalación
ls /usr/share/icons/                     # los cursores están en este directorio
ls ~/.local/share/icons/

# Cambiar tema de cursores
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic"
gsettings set org.gnome.desktop.interface cursor-size 24

# Temas populares
# - Bibata (https://github.com/ful1e5/Bibata_Cursor)
# - Capitaine (https://github.com/keeferrourke/capitaine-cursors)
# - Nordzy (https://github.com/alvatip/Nordzy-cursors)
```

## Fuentes

```bash
# Fuentes instaladas
fc-list                                 # lista de fuentes
fc-list | grep -i mono                  # fuentes monospace
fc-match monospace                       # fuente monospace por defecto

# Instalar fuentes manualmente
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
# Descargar y descomprimir aquí
fc-cache -fv                            # refrescar caché

# Fuentes populares para terminal y programación
# - JetBrains Mono (https://www.jetbrains.com/lp/mono/)
# - Fira Code (https://github.com/tonsky/FiraCode)
# - Nerd Fonts (https://www.nerdfonts.com/) — con iconos
# - IBM Plex Mono
# - Cascadia Code

# Fuentes populares para interfaz
# - Inter (https://rsms.me/inter/)
# - Noto Sans (Google, multilenguaje)
# - Ubuntu Font
```

## Fondos de pantalla

```bash
# Directores comunes
ls /usr/share/backgrounds/
ls ~/.local/share/backgrounds/

# Cambiar fondo (GNOME)
gsettings set org.gnome.desktop.background picture-uri "file:///ruta/a/fondo.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///ruta/a/fondo-dark.jpg"

# Cambiar fondo (KDE Plasma)
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
    var wallpaper = new WallpaperImage;
    wallpaper.currentWallpaperPath = "/ruta/a/fondo.jpg";
    ...
'
```

## Pantalla de login (Display Manager)

```bash
# GDM (GNOME) — personalizar fondo
sudo cp fondo.jpg /usr/share/backgrounds/
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/fondo.jpg"

# SDDM (KDE, XFCE, i3)
# Editar /etc/sddm.conf:
# [Theme]
# Current=breeze
# CursorTheme=bibata
# Hay temas SDDM: sugar-candy, sddm-astronaut-theme, catppuccin-sddm
```

## Personalización de terminal

```bash
# Alacritty — config en ~/.config/alacritty/alacritty.toml
# Kitty — ~/.config/kitty/kitty.conf
# Konsole — ~/.local/share/konsole/
# GNOME Terminal — dconf (gsettings)

# Shell prompts: Starship (https://starship.rs/)
curl -sS https://starship.rs/install.sh | sh
# Config: ~/.config/starship.toml

# Shell prompts: Oh My Zsh (https://ohmyz.sh/)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Shell prompts: Powerlevel10k (https://github.com/romkatv/powerlevel10k)
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

## Herramientas de personalización

| Herramienta | Propósito | URL |
|---|---|---|
| **lxappearance** | Cambiar tema GTK, iconos, cursores (GUI) | Paquete del sistema |
| **nwg-look** | Alternativa moderna a lxappearance (GTK3) | `https://github.com/nwg-piotr/nwg-look` |
| **kde-config-gtk-style** | Integración GTK en KDE | `https://invent.kde.org/plasma/kde-gtk-config` |
| **Ocs-Store** | Tienda de temas de opendesktop.org en KDE | `https://www.opendesktop.org/` |
| **Gradience** | Personalizar Adwaita (GNOME 42+) | `https://github.com/GradienceTeam/Gradience` |
| **Wallpaper Engine** | Fondos animados (KDE) | `https://github.com/catsout/wallpaper-engine-kde-plugin` |
| **plasma-engines** | Widgets KDE Plasma | Incluidos en KDE |

## Distribuciones conocidas por personalización

| Distribución | Personalizable por defecto | Ideal para |
|---|---|---|
| **KDE Neon** | ⭐⭐⭐⭐⭐ | Personalización visual máxima |
| **Arch Linux** | ⭐⭐⭐⭐⭐ | Personalización total desde cero |
| **Fedora KDE Spin** | ⭐⭐⭐⭐ | KDE + estabilidad |
| **Garuda Linux** | ⭐⭐⭐⭐⭐ | Tema gaming, preconfigurado |
| **EndeavourOS** | ⭐⭐⭐⭐ | Arch + ayudas visuales |
| **Ubuntu** | ⭐⭐ | Limitado, pero funcional |

## Enlaces externos

- [r/unixporn](https://www.reddit.com/r/unixporn/) — inspiración de personalización en Reddit
- [Pling / opendesktop.org](https://www.pling.com/) — repositorio de temas GTK, iconos, cursores
- [Nerd Fonts](https://www.nerdfonts.com/) — fuentes con iconos para terminal
- [Catppuccin](https://github.com/catppuccin) — tema pastel popular (GTK, terminals, apps)
- [Nord Theme](https://www.nordtheme.com/) — tema ártico para múltiples apps
- [Gruvbox](https://github.com/morhetz/gruvbox) — tema retro, tierra

## Ver también

- [[XDG Base Directory y dotfiles modernos]] — cómo organizar la configuración
- [[Shells (bash zsh fish)]] — personalización del shell
- [[Neofetch Fastfetch]] — mostrar información del sistema estilizada
- [[Symlinks y Dotfiles]] — gestionar archivos de configuración

#concepto
