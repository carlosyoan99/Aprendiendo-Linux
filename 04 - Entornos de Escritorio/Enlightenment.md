---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE
---

# Enlightenment (E)

## Qué es

**Enlightenment** (también conocido como **E** o **E21+**) es un gestor de ventanas y entorno de escritorio **ligero, visualmente llamativo y altamente configurable** para X11 (con soporte básico de Wayland). Utiliza su propia toolkit **EFL** (Enlightenment Foundation Libraries), completamente independiente de GTK y Qt.

Creado originalmente por **Carsten Haitzler (Rasterman)** en 1996. Durante años fue conocido principalmente como un gestor de ventanas experimental con efectos visuales avanzados (transparencias, desvanecimientos, sombras) — mucho antes de que existiera Compiz. Hoy es un DE completo pero ligero.

```bash
┌─────────────────────────────────────────────────┐
│              Enlightenment (E)                    │
├─────────────────────────────────────────────────┤
│  1996 — Primeros experimentos de Rasterman       │
│  1997 — DR0.1 (desktop release 0.1)              │
│  2000 — E16, estabilidad, usado en pantallas     │
│         táctiles y dispositivos embebidos        │
│  2012 — E17, rediseño completo, EFL maduro       │
│  2020 — E25, Wayland experimental                │
│  2025 — E27+, actualizaciones continuas          │
└─────────────────────────────────────────────────┘
```

## Filosofía

- **Ligero pero bonito**: efectos visuales sin consumir recursos excesivos
- **Toolkit propio (EFL)**: no depende de GTK ni Qt — es 100% independiente
- **Altamente configurable**: casi todo se puede personalizar desde la GUI
- **Modular**: los módulos (temperature, cpu, clock, etc.) se activan/desactivan desde el menú
- **Portátil**: funciona en escritorios, tablets, pantallas táctiles, embebidos

## Instalación

```bash
# Debian/Ubuntu
sudo apt install enlightenment

# Arch Linux
sudo pacman -S enlightenment

# Fedora
sudo dnf install enlightenment

# openSUSE
sudo zypper install enlightenment

# Bodhi Linux (viene preinstalado)
# Bodhi usa Enlightenment como DE por defecto
```

## Características clave

### 1. EFL (Enlightenment Foundation Libraries)

EFL es el conjunto de librerías que usa Enlightenment. Incluye:

| Librería | Propósito |
|---|---|
| **Ecore** | Bucle de eventos, IPC, timers |
| **Edje** | Motor de diseño de interfaces (temas, layouts) |
| **Eet** | Almacenamiento de datos (binarios, imágenes, strings) |
| **Efreet** | Estándares freedesktop.org (íconos, .desktop) |
| **Evas** | Canvas/rendering de gráficos 2D |
| **Elementary** | Widget toolkit (botones, entradas, diálogos) |
| **Ephysics** | Motor de físicas 2D integrado |
| **Emotion** | Reproducción de video |

```bash
# Instalar EFL por separado (para desarrollar)
sudo apt install libefl-dev
```

### 2. Gestión de escritorios virtuales

Enlightenment usa una metáfora de **escritorios virtuales** con transición animada entre ellos. Por defecto son 4, organizados en una cuadrícula de 2×2:

```bash
# Atajos por defecto
Ctrl + Alt + Left/Right     # cambiar escritorio horizontal
Ctrl + Alt + Up/Down        # cambiar escritorio vertical
Ctrl + Alt + Shift + Left/Right   # mover ventana entre escritorios
```

### 3. Módulos (widgets integrados)

Enlightenment incluye módulos que se añaden al escritorio directamente desde el menú:

| Módulo | Propósito |
|---|---|
| **Clock** | Reloj analógico/digital |
| **Battery** | Estado de la batería |
| **CPU** | Monitor de uso de CPU |
| **Temperature** | Temperatura del sistema |
| **Mixer** | Control de volumen |
| **Pager** | Vista de todos los escritorios |
| **ibar** | Barra de lanzamiento rápido |
| **iBox** | Bandeja de iconos |
| **SysTray** | Bandeja de sistema (NM, bluetooth, etc.) |
| **Everything** | Lanzador de aplicaciones universal |
| **Tiling** | Modo de mosaico (experimental) |

```bash
# Acceder a módulos:
# Clic derecho en escritorio → Configuration → Modules
# O desde: Settings → Modules
```

### 4. Temas (Edje)

Los temas de Enlightenment usan el motor **Edje**, que permite animaciones, transiciones y diseños complejos:

```bash
# Cambiar tema:
# Settings → Theme → Seleccionar archivo .edj

# Los temas están en:
/usr/share/enlightenment/data/themes/
~/.e/e/themes/

# Temas populares:
# - Default (Flat, moderno desde E20+)
# - Glass (transparencias clásicas)
# - Dark (oscuro minimalista)
```

### 5. Everything (lanzador universal)

El módulo **Everything** es un lanzador de aplicaciones integrado que busca en:
- Aplicaciones instaladas (.desktop)
- Archivos recientes
- Configuraciones de Enlightenment
- Acciones del sistema

```bash
# Activar: Ctrl + Space (por defecto)
# O configura otro atajo en Settings → Key Bindings
```

### 6. Ibox e Ibar

| Elemento | Descripción |
|---|---|
| **Ibar** | Barra de lanzamiento rápido en la parte superior |
| **Ibox** | Bandeja que agrupa iconos de ventanas minimizadas |
| **Pager** | Miniaturas de escritorios virtuales |
| **SysTray** | Bandeja de sistema estándar |

## Requisitos

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64, 1 GHz | 2 GHz dual-core |
| **RAM** | 256 MB | 1 GB |
| **GPU** | Cualquier con aceleración 2D | Aceleración OpenGL (EFL la usa para animaciones) |
| **Disco** | 500 MB | 2 GB |
| **Display Manager** | Entrance (propio), LightDM, SDDM | LightDM |

## Enlightenment vs alternativas

| Aspecto | Enlightenment | XFCE | LXQt | MATE |
|---|---|---|---|---|
| **Toolkit** | EFL (propio) | GTK | Qt | GTK |
| **RAM idle** | ~200 MB | ~350 MB | ~250 MB | ~400 MB |
| **Efectos visuales** | ✅ Nativos (EFL) | ❌ No (requiere picom) | ❌ No | ❌ No |
| **Configuración GUI** | ✅ Muy completa | ✅ Completa | ✅ Completa | ✅ Completa |
| **Modular** | ✅ Módulos integrados | ❌ Paneles externos | ❌ Paneles externos | ❌ Paneles externos |
| **Wayland** | ⚠️ Experimental | ⚠️ Experimental | ⚠️ Experimental | ❌ No |
| **Popular en** | Bodhi Linux | Mint Xfce, Xubuntu | Lubuntu, Fedora LXQt | Ubuntu MATE |
| **Ideal para** | Hardware antiguo + efectos | Equilibrio ligero/completo | Qt lovers, bajo consumo | Usuarios GNOME 2 |

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **EFL apps se ven diferentes** | EFL no usa GTK/Qt — los widgets son propios | No es un problema, es diseño de EFL |
| **No hay integración con GTK/Qt** | Enlightenment es independiente | Instalar `lxappearance` para GTK, `qt5ct` para Qt |
| **Módulo Tiling experimental** | No está maduro como i3/Sway | Desactivar si causa problemas |
| **Fondo de pantalla no se muestra** | Módulo de fondo desactivado | Activar en Settings → Modules |
| **Everything no encuentra apps** | Caché de aplicaciones no actualizado | Ejecutar `eupdatedb` como usuario |

## Notas personales

- Enlightenment es una joya infravalorada. Su toolkit propio (EFL) le da una independencia única de GTK y Qt, y sus efectos visuales son nativos, no postizos con picom.
- En Bodhi Linux, E consume ~200 MB RAM con efectos visuales activados. Es el DE con mejor ratio de estética/rendimiento.
- El lanzador Everything (`Ctrl+Space`) es tan potente como KRunner de KDE, pero menos conocido.
- La pega: EFL hace que las apps GTK/Qt se vean fuera de lugar. Es un DE para vivir en su ecosistema.

## Ver también

- [[XFCE]] — DE ligero pero con GTK en lugar de EFL
- [[LXQt]] — DE ligero en Qt
- [[MATE]] — DE clásico (continuación GNOME 2)
- [[Comparativa entornos de escritorio]] — comparativa de todos los DEs
- [[Personalización en Linux]] — theming, iconos, fuentes
- [[Gestores de Archivos]] — Enlightenment incluye su propio gestor (efm)

## Enlaces externos

- [Enlightenment — Página oficial](https://www.enlightenment.org/)
- [Enlightenment — Documentación](https://www.enlightenment.org/docs)
- [Enlightenment — GitHub](https://github.com/Enlightenment/)
- [Enlightenment — ArchWiki](https://wiki.archlinux.org/title/Enlightenment)
- [Enlightenment — Wikipedia](https://en.wikipedia.org/wiki/Enlightenment_(software))
- [EFL — Documentación desarrolladores](https://docs.enlightenment.org/)
- [Bodhi Linux — Distribución que usa E por defecto](https://www.bodhilinux.com/)
- [Temas Enlightenment — E-Stuff](https://e-stuff.org/)

#entorno-escritorio
