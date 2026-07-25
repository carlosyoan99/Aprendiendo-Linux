---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: troubleshooting
sistema: fontconfig / fuentes
prioridad: baja
---

# Fuentes que se ven mal o faltan

> Las fuentes en el sistema se ven pixeladas, con cuadrados (□) en lugar de caracteres, los emojis no se muestran, o las aplicaciones no encuentran las fuentes que instalaste.

## Síntoma

- Caracteres mostrados como **cuadrados** (□) o signos de interrogación (�)
- Las fuentes se ven **pixeladas** o con serifs incorrectos (ej. fuente courier en lugar de sans-serif)
- **Emojis sin color** o directamente no aparecen
- `fc-list` no muestra las fuentes que instalaste
- Aplicaciones como GIMP, Inkscape o terminales no detectan fuentes nuevas
- El sistema muestra fuente **muy pequeña o muy grande** en algunas apps

## Diagnóstico

```bash
# 1. Listar fuentes instaladas
fc-list                                    # todas las fuentes
fc-list | grep -i "nombre"                 # buscar fuente específica (ej. "JetBrains")
fc-list | grep -i mono                     # fuentes monospace
fc-list | wc -l                            # cuántas fuentes hay instaladas

# 2. Ver fuente por defecto para un tipo
fc-match sans                              # fuente sans-serif por defecto
fc-match serif                             # fuente serif por defecto
fc-match monospace                         # fuente monospace por defecto

# 3. Verificar directorios de fuentes
fc-cache -v                                # verbose: muestra qué directorios escanea
# Directorios comunes:
ls /usr/share/fonts/                       # fuentes del sistema
ls /usr/local/share/fonts/                 # fuentes locales del sistema
ls ~/.local/share/fonts/                   # fuentes de usuario (recomendado)
ls ~/.fonts/                               # legacy (obsoleto, pero aún funciona)

# 4. Probar renderizado de fuente específica
fc-query /ruta/a/una/fuente.ttf            # info detallada de la fuente
pango-view --text="Hola Mundo ñÑ áéíóú" --font="NombreFuente 16"  # previsualizar (si tienes pango)
```

## Causa

1. **Fuentes no instaladas en los directorios correctos** — las fuentes deben estar en un directorio que fontconfig escanee.
2. **Caché de fuentes desactualizada** — tras instalar fuentes nuevas, hay que refrescar con `fc-cache`.
3. **Faltan fuentes base del sistema** — paquetes como `fonts-dejavu`, `fonts-noto` o `fontconfig` no instalados.
4. **Faltan fuentes para emoji** — emojis requieren una fuente específica (Noto Color Emoji, Twitter Emoji, etc.).
5. **Conflicto entre fuentes** — dos fuentes con el mismo nombre o prioridad incorrecta.
6. **Hinting/anti-aliasing desactivado** — configuración de renderizado de fuentes incorrecta.

## Solución

### 1. Instalar paquetes de fuentes base

```bash
# Debian/Ubuntu — el pack completo de fuentes
sudo apt install fonts-dejavu fonts-liberation fonts-noto fonts-noto-cjk fonts-noto-color-emoji fonts-firacode fonts-jetbrains-mono

# Arch
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-fira-code ttf-jetbrains-mono

# Fedora
sudo dnf install dejavu-sans-fonts liberation-fonts google-noto-fonts-common google-noto-emoji-fonts fira-code-fonts jetbrains-mono-fonts
```

### 2. Instalar fuentes manualmente

```bash
# Método correcto: ~/.local/share/fonts/ (XDG compliant)
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

# Descargar y descomprimir (ejemplo con JetBrains Mono)
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip
rm JetBrainsMono.zip

# Refrescar caché
fc-cache -fv

# Verificar
fc-list | grep -i "JetBrains"
```

### 3. Refrescar caché de fuentes

```bash
# Siempre tras instalar fuentes nuevas:
fc-cache -fv                               # refrescar todo
fc-cache -fv ~/.local/share/fonts          # solo un directorio
```

### 4. Solucionar emojis rotos

```bash
# Instalar fuente de emoji a color
# Debian/Ubuntu
sudo apt install fonts-noto-color-emoji

# Arch
sudo pacman -S noto-fonts-emoji

# Configurar prioridad de fuentes emoji
# Crear /etc/fonts/local.conf (o ~/.config/fontconfig/fonts.conf)
```

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Priorizar emoji como fallback para todos los tipos -->
  <match target="pattern">
    <test qual="any" name="family"><string>sans-serif</string></test>
    <edit name="family" mode="append_last">
      <string>Noto Color Emoji</string>
    </edit>
  </match>
</fontconfig>
```

### 5. Configurar renderizado (anti-aliasing, hinting)

```bash
# La configuración de renderizado se hereda del escritorio, pero puedes
# forzarla a nivel de fontconfig:

# GNOME
gsettings set org.gnome.desktop.interface font-antialiasing "rgba"
gsettings set org.gnome.desktop.interface font-hinting "slight"

# KDE
# System Settings → Appearance → Fonts → Anti-Aliasing
```

```xml
<!-- ~/.config/fontconfig/fonts.conf — configuración de usuario -->
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Anti-aliasing -->
  <match target="font">
    <edit name="antialias" mode="assign"><bool>true</bool></edit>
  </match>
  <!-- Hinting ligero (mejor en pantallas LCD) -->
  <match target="font">
    <edit name="hinting" mode="assign"><bool>true</bool></edit>
    <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
  </match>
  <!-- Subpixel rendering RGB -->
  <match target="font">
    <edit name="rgba" mode="assign"><const>rgb</const></edit>
  </match>
</fontconfig>
```

### 6. Desactivar fuentes conflictivas

```bash
# Si una fuente se muestra mal, puedes desactivarla temporalmente:
# Renombrar el archivo (no eliminarlo, por si acaso):
mv /usr/share/fonts/truetype/mala-fuente/MalaFuente.ttf /usr/share/fonts/truetype/mala-fuente/MalaFuente.ttf.disabled
fc-cache -fv

# O crear un archivo de fontconfig que ignore la fuente:
# ~/.config/fontconfig/conf.d/99-ignorar.conf
```

## Prevención

- Después de instalar una distro, instalar los paquetes de fuentes base (DejaVu, Noto, Liberation) como parte del post-instalación
- Usar `~/.local/share/fonts/` para fuentes manuales (no mezclar con fuentes del sistema)
- Ejecutar `fc-cache -fv` después de cada instalación manual
- Para desarrollo/web, instalar Nerd Fonts (versión parcheada con iconos)
- Para emojis, instalar `noto-fonts-emoji` y configurar como fallback

## Enlaces externos

- [Arch Wiki — Fonts](https://wiki.archlinux.org/title/Fonts)
- [Arch Wiki — Font configuration](https://wiki.archlinux.org/title/Font_configuration)
- [Debian Wiki — Fonts](https://wiki.debian.org/Fonts)
- [fontconfig man page](https://man.archlinux.org/man/fonts-conf.5)
- [Nerd Fonts](https://www.nerdfonts.com/)

## Ver también

- [[Personalización en Linux]] — temas GTK/Qt, iconos, cursores, fuentes
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — skel para fuentes por defecto
- [[Locale y configuracion de idioma]] — charset UTF-8 necesario para caracteres especiales
- [[Post-Instalacion Checklist]] — fuentes como parte de la instalación inicial

#troubleshooting
