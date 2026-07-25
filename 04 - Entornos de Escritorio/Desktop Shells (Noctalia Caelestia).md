---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
---

# Desktop Shells

## Qué son

Las **Desktop Shells** son capas de personalización visual que se sitúan sobre un entorno de escritorio o gestor de ventanas para cambiar radicalmente la apariencia sin cambiar de DE/WM. No son entornos completos, sino **temas globales** que modifican paneles, docks, notificaciones, animaciones, esquemas de color y disposición de los elementos.

Mientras que los entornos de escritorio (GNOME, KDE) tienen su propio aspecto por defecto, las desktop shells permiten transformar la experiencia visual completa manteniendo la misma base tecnológica.

## Noctalia

**Noctalia** es un tema global / desktop shell para GNOME que transforma el escritorio en una experiencia oscura y elegante, con animaciones suaves, paneles translúcidos y una disposición minimalista. Está inspirado en diseños modernos como macOS y Windows 11 pero adaptado a GNOME.

```bash
# Instalación (GNOME)
# Se instala como conjunto de extensiones y temas:
# 1. Tema GTK (Noctalia GTK)
# 2. Tema de shell GNOME (Noctalia Shell)
# 3. Extensiones complementarias

# Desde GitHub:
git clone https://github.com/noctalia/desktop-shell
cd desktop-shell
./install.sh

# O manualmente:
mkdir -p ~/.themes ~/.icons ~/.local/share/gnome-shell/extensions
cp -r themes/Noctalia ~/.themes/
cp -r icons/Noctalia ~/.icons/
```

**Características**:
- Tema oscuro completo con acentos configurables (azul, púrpura, verde)
- Panel superior translúcido con efecto blur
- Animaciones suaves en ventanas y transiciones
- Dock integrado (usando Dash-to-Dock personalizado)
- Notificaciones redondeadas con bordes translúcidos
- Esquema de colores de alto contraste para accesibilidad
- Compatible con GNOME 45+

## Caelestia

**Caelestia** es una desktop shell para GNOME y KDE Plasma con una estética celeste/espacial. Colores claros, azules suaves y elementos flotantes. Ideal para quienes prefieren un escritorio luminoso y aireado.

```bash
# Instalación (GNOME)
# Tema GTK + Shell
git clone https://github.com/caelestia/shell
cd shell
./setup.sh

# Instalación (KDE Plasma)
# Se instala como tema global de Plasma
# System Settings → Appearance → Global Themes → Instalar desde archivo
# O desde: https://store.kde.org/
```

**Características**:
- Temas claro y oscuro (Caelestia Light / Dark)
- Efectos de difuminado (blur) en paneles y menús
- Transparencia sutil en ventanas inactivas
- Iconos redondeados con sombras suaves
- Compatible con GNOME 44+ y KDE Plasma 6+

## Otras desktop shells populares

| Shell | Base | Estilo | Estado |
|---|---|---|---|
| **WhiteSur** | GNOME | macOS-like | ✅ Activo |
| **Orchis** | GNOME | Moderno, redondeado | ✅ Activo |
| **Fluent** | GNOME | Windows 11-like | ✅ Activo |
| **Tokyo Night** | GNOME, KDE | Oscuro, neón | ✅ Activo |
| **Lavanta** | GNOME | Pastel, suave | ⚠️ Semiactivo |
| **Nordic** | GNOME, KDE, WM | Ártico, minimalista | ✅ Activo |
| **Catppuccin** | GNOME, KDE, WM, apps | Pastel | ✅ Activo |
| **Graphite** | GNOME | Plano, oscuro | ✅ Activo |

## Desktop shells vs Entornos de escritorio

| Aspecto | Desktop Shell | Entorno de escritorio |
|---|---|---|
| **¿Qué es?** | Tema global + extensiones | Sistema completo |
| **Base tecnológica** | GTK/Qt themes + extensiones | Window manager + paneles + apps |
| **Cambia comportamiento** | ❌ Solo apariencia | ✅ Todo |
| **Peso adicional** | Bajo (~10-50 MB) | Alto (~200 MB - 2 GB) |
| **Rendimiento** | Mismo que la DE base | Depende de la DE |
| **Instalación** | Script o copiar archivos | Gestor de paquetes |
| **Ejemplos** | Noctalia, Caelestia, WhiteSur, Orchis | GNOME, KDE, XFCE, i3 |

## Cómo instalar una desktop shell

### En GNOME

```bash
# Requisitos:
# - GNOME Shell (versión específica)
# - User Themes extension
# - Extensiones complementarias (Dash-to-Dock, Blur-my-Shell, etc.)

# 1. Instalar extensiones necesarias
sudo apt install gnome-shell-extensions
# Desde web: https://extensions.gnome.org/

# 2. Descargar e instalar el tema
# La mayoría de shells se instalan con:
git clone <repo>
cd <repo>
./install.sh              # o make install

# 3. Activar tema
# GNOME Tweaks → Apariencia → Shell → Elegir tema
# O por CLI:
gsettings set org.gnome.shell.extensions.user-theme name "Noctalia"

# 4. Configurar extensiones adicionales
# Dash-to-Dock, Blur-my-Shell, Vitals, etc.
```

### En KDE Plasma

```bash
# KDE Plasma usa "Global Themes" que cambian todo de una vez:
# System Settings → Appearance → Global Themes → Get New Global Themes

# O desde terminal:
kpackagetool5 -i caelestia.tar.gz      # instalar tema
# Luego activar desde System Settings
```

## Ver también

- [[GNOME]] — base más común para desktop shells
- [[KDE Plasma]] — soporta temas globales
- [[Personalización en Linux]] — temas GTK, iconos, cursores
- [[Neofetch Fastfetch]] — mostrar la shell activa en el fetch

#entorno-escritorio #personalizacion
