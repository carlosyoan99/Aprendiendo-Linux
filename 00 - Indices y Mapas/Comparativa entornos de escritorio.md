---
fecha_creacion: 2026-07-24
estado: resuelto
categoria: indice
prioridad: alta
---

# Comparativa de entornos de escritorio (Desktop Environments)

> Guía completa para elegir Entorno de Escritorio en Linux. Cubre todos los DEs documentados en el vault, organizados por tipo, recursos y público objetivo.

Linux ofrece la mayor variedad de entornos de escritorio de cualquier sistema operativo: desde minimalistas como LXQt (~250 MB RAM) hasta completos como KDE Plasma (~1-2 GB RAM), pasando por opciones modernas como GNOME, Deepin o Budgie.

---

## Guía rápida de elección

| Si eres... | Y quieres... | DE recomendado |
|---|---|---|
| **Principiante en Linux** | Algo que funcione desde el inicio, familiar | **[[Linux Mint]] con [[Cinnamon]]** — el escritorio clásico hecho bien |
| **Ex-usuario de Windows** | Transición sin fricción | **[[KDE Plasma]]** o **[[Cinnamon]]** — barra de tareas, menú inicio, bandeja |
| **Ex-usuario de macOS** | Estética cuidada, dock inferior | **[[Deepin]]** o **[[Pantheon]]** — diseño macOS-like |
| **PC antiguo (< 4 GB RAM)** | Máximo rendimiento | **[[LXQt]]** (~250 MB) o **[[XFCE]]** (~400 MB) |
| **PC muy antiguo (< 2 GB RAM)** | Funcionalidad básica | **[[Enlightenment]]** (~200 MB) o **[[LXQt]]** |
| **Desarrollador/productividad** | Flujo moderno, atajos, Wayland | **[[GNOME]]** con extensiones o **[[KDE Plasma]]** |
| **Minimalista** | Escritorio limpio, sin distracciones | **[[GNOME]]** — vista de actividades, workspaces |
| **Personalizarlo todo** | Control absoluto sobre cada pixel | **[[KDE Plasma]]** — miles de opciones desde GUI |
| **Diseño y estética** | El escritorio más bonito posible | **[[Deepin]]** — el DE más pulido visualmente |
| **Educación infantil** | Entorno para niños | **[[Sugar]]** — actividades educativas, OLPC |
| **Nostálgico Unix** | Escritorio clásico de los 90 | **[[Common Desktop Environment (CDE)]]** |

---

## Tabla comparativa general

### Por toolkit, protocolo y recursos

| DE | Toolkit | Protocolo | Config | Gestor ventanas | RAM idle | Wayland |
|---|---|---|---|---|---|---|
| **[[GNOME]]** | GTK + libadwaita | Wayland (default) | GUI + dconf/gsettings | Mutter | ~800 MB - 1.2 GB | ✅ Nativo |
| **[[KDE Plasma]]** | Qt 6 | Wayland (default) | GUI (System Settings) | KWin | ~800 MB - 1.5 GB | ✅ Nativo (Plasma 6) |
| **[[XFCE]]** | GTK 3 | X11 | GUI (Settings Manager) | XFWM | ~350-500 MB | ⚠️ Experimental |
| **[[Cinnamon]]** | GTK + Cinnamon | X11 | GUI (System Settings) | Muffin (fork Mutter) | ~500-700 MB | ⚠️ En desarrollo |
| **[[MATE]]** | GTK 2/3 | X11 | GUI (Control Center) | Marco (fork Metacity) | ~350-550 MB | ❌ No |
| **[[Budgie]]** | GTK 3/4 | Wayland (default) | GUI + Raven | Mutter | ~500-800 MB | ✅ Nativo |
| **[[LXQt]]** | Qt 5/6 | X11 | GUI | Openbox | ~250-400 MB | ⚠️ En desarrollo |
| **[[Deepin]]** | Qt + DTK | X11 | GUI (Control Center) | KWin modificado | ~800 MB - 1.2 GB | ⚠️ Básico |
| **[[Pantheon]]** | GTK + Granite | X11 | GUI (System Settings) | Gala (fork Mutter) | ~500-700 MB | ⚠️ Experimental |
| **[[Enlightenment]]** | EFL (propio) | X11 | GUI (Settings) | Enlightenment WM | ~200-400 MB | ⚠️ Básico |
| **[[Sugar]]** | GTK + Python | X11 | Actividades (no GUI tradicional) | Sugar WM (Metacity) | ~150-300 MB | ❌ No |
| **[[Trinity]]** | Qt 3 (TQt) | X11 | GUI (KDE 3-style) | Twin (KWin 3 fork) | ~200-350 MB | ❌ No |
| **[[Common Desktop Environment (CDE)]]** | Motif | X11 | GUI (Style Manager) | Motif WM | ~100-200 MB | ❌ No |

### Por facilidad y comunidad

| DE | Curva aprendizaje | Comunidad | Documentación | Personalización | Apps nativas |
|---|---|---|---|---|---|
| **GNOME** | 🟡 Media | ⭐⭐⭐⭐⭐ | Excelente | ⚠️ (vía extensiones) | Mínimas (Core) |
| **KDE Plasma** | 🟡 Media | ⭐⭐⭐⭐⭐ | Excelente | ✅ Total (GUI) | Muchas (KDE Gear) |
| **XFCE** | 🟢 Baja | ⭐⭐⭐⭐ | Buena | ✅ Buena | Básicas |
| **Cinnamon** | 🟢 Baja | ⭐⭐⭐⭐ | Buena | ✅ Buena (applets) | Moderadas |
| **MATE** | 🟢 Baja | ⭐⭐⭐ | Buena | ✅ Buena | Moderadas (forks GNOME 2) |
| **Budgie** | 🟢 Baja | ⭐⭐⭐ | Buena | ⚠️ Limitada | Básicas |
| **LXQt** | 🟢 Baja | ⭐⭐⭐ | Buena | ✅ Buena | Mínimas |
| **Deepin** | 🟢 Baja | ⭐⭐ | Buena | ✅ Buena | Muchas (todo el stack DDE) |
| **Pantheon** | 🟢 Baja | ⭐⭐ | Buena | ⚠️ Limitada | Moderadas (elementary apps) |
| **Enlightenment** | 🔴 Alta | ⭐⭐ | Buena (técnica) | ✅ Total (GUI + módulos) | Básicas (depende de EFL) |
| **Sugar** | 🟢 Baja (niños) | ⭐ | Buena | ❌ No aplica | Actividades educativas |
| **Trinity** | 🟢 Baja | ⭐ | Buena | ✅ Como KDE 3 | Las de KDE 3 |
| **CDE** | 🟡 Media | ⭐ | Limitada (histórica) | ⚠️ Limitada | Las de CDE (históricas) |

---

## Categorías detalladas

### DEs modernos (GNOME y afines)

| DE | Filosofía | Diferenciador | Ideal para |
|---|---|---|---|
| **[[GNOME]]** | Minimalismo, vista de actividades, workspaces | Extensions.gnome.org, Wayland nativo | Usuarios que quieren un escritorio moderno y limpio |
| **[[Budgie]]** | Moderno pero con panel tradicional | Raven (panel lateral), GTK + Mutter | Usuarios que quieren GNOME pero con barra de tareas |
| **[[Pantheon]]** | macOS-like, HIG propias, ecosistema cerrado | AppCenter, diseño coherente | Usuarios de elementary OS, amantes del diseño |

### DEs completos y personalizables

| DE | Filosofía | Diferenciador | Ideal para |
|---|---|---|---|
| **[[KDE Plasma]]** | Personalización total, completo out-of-the-box | KRunner, KDE Connect, widgets | Usuarios que quieren control total y muchas features |
| **[[Deepin]]** | Estética cuidada, animaciones fluidas | Dock macOS-like, apps nativas DTK | Usuarios que priorizan el diseño visual |

### DEs clásicos (escritorio tradicional)

| DE | Filosofía | Diferenciador | Ideal para |
|---|---|---|---|
| **[[Cinnamon]]** | Tradicional moderno, fork de GNOME | Applets, Nemo (gestor archivos) | Migrantes de Windows, usuarios Linux Mint |
| **[[MATE]]** | Continuación de GNOME 2 | Marco, Caja, Pluma (forks GNOME 2) | Nostálgicos de GNOME 2, PCs medios |
| **[[Trinity]]** | Continuación de KDE 3 | TQt, apariencia KDE 3 | Nostálgicos de KDE 3.x |

### DEs ligeros

| DE | Filosofía | Diferenciador | Ideal para |
|---|---|---|---|
| **[[XFCE]]** | Ligero, estable, predecible | xfce4-goodies, Whisker Menu | PCs antiguos, servidores con escritorio |
| **[[LXQt]]** | Ligero en Qt, sucesor de LXDE | PCManFM-Qt, usa Openbox como WM | Hardware limitado, amantes de Qt |
| **[[Enlightenment]]** | Ligero con efectos visuales nativos | EFL propio, módulos integrados, Everything | PCs antiguos que quieren verse bien |

### DEs históricos y educativos

| DE | Filosofía | Diferenciador | Ideal para |
|---|---|---|---|
| **[[Sugar]]** | Educativo, actividades, interfaz infantil | OLPC, metáfora de actividades | Educación infantil, proyectos educativos |
| **[[Common Desktop Environment (CDE)]]** | Unix clásico, estándar de los 90 | Motif, Panel, Style Manager | Nostálgicos Unix, sistemas legacy |

---

## Por ecosistema

### DEs con ecosistema propio (apps nativas)

| DE | Gestor archivos | Terminal | Editor texto | Visor imágenes | Captura pantalla | Tienda apps |
|---|---|---|---|---|---|---|
| **GNOME** | Nautilus | GNOME Terminal | Gedit | Eye of GNOME | GNOME Screenshot | GNOME Software |
| **KDE Plasma** | Dolphin | Konsole | Kate | Gwenview | Spectacle | Discover |
| **Cinnamon** | Nemo | GNOME Terminal | Xed | Pix | Screenshot | Gdebi + Software Manager |
| **MATE** | Caja | MATE Terminal | Pluma | Eye of MATE | MATE Screenshot | — |
| **Deepin** | DDE File Manager | Deepin Terminal | Deepin Editor | Deepin Image Viewer | Deepin Screenshot | Deepin Store |
| **Pantheon** | Files | Terminal (pantheon) | Code (Scratch) | Photos | Screenshot | AppCenter |
| **LXQt** | PCManFM-Qt | QTerminal | FeatherPad | LXImage-Qt | Screengrab | — |
| **XFCE** | Thunar | Terminal (xfce4) | Mousepad | Ristretto | xfce4-screenshooter | — |
| **Enlightenment** | efm | Terminology | — | — | — | — |

### DEs que dependen de herramientas externas

| DE | Barra | Lanzador | Notificaciones | Compositor | Wallpaper |
|---|---|---|---|---|---|
| **GNOME** | GNOME Shell | Activities Overview | GNOME Notifications | Mutter (integrado) | GNOME Settings |
| **KDE Plasma** | Plasma Panel | KRunner | KDE Notifications | KWin (integrado) | Plasma Settings |
| **XFCE** | xfce4-panel | Whisker Menu | xfce4-notifyd | xfwm4 (básico) | xfdesktop |
| **Cinnamon** | Cinnamon Panel | Cinnamon Menu | Cinnamon Notifications | Muffin (integrado) | Cinnamon Settings |
| **Budgie** | Budgie Panel | Budgie Menu | Raven | Mutter (integrado) | Budgie Settings |
| **LXQt** | lxqt-panel | lxqt-runner | lxqt-notificationd | picom (externo) | feh |
| **Deepin** | DDE Dock | DDE Launcher | DDE Notifications | KWin (modificado) | DDE Settings |

---

## Recomendaciones por caso de uso

### 🖥️ Escritorio personal moderno

```bash
# Si quieres algo moderno y funcional desde el inicio
# GNOME: sudo apt install gnome-shell ubuntu-desktop (Ubuntu)
# KDE:   sudo apt install kde-plasma-desktop
# ⭐ GNOME o KDE Plasma: los dos grandes, elige según prefieras minimalismo o personalización
```

### 💻 Portátil con batería limitada

```bash
# Si priorizas duración de batería
sudo apt install xfce4 xfce4-goodies
# ⭐ XFCE: ligero, sin efectos, máxima duración
```

### 🖥️ PC antiguo (4 GB RAM o menos)

```bash
# Para darle vida nueva a un PC de 2010-2015
sudo apt install lxqt          # ~250-400 MB RAM
sudo apt install xfce4         # ~350-500 MB RAM
# ⭐ LXQt o XFCE: ligeros, funcionales, sin sacrificar usabilidad
```

### 🐌 PC muy antiguo (1-2 GB RAM)

```bash
# Máxima eficiencia
sudo apt install enlightenment   # ~200 MB RAM con efectos
# ⭐ Enlightenment: efectos visuales nativos con consumo mínimo
```

### 🏢 Entorno de trabajo / Oficina

```bash
# Estabilidad y productividad
# Cinnamon (Linux Mint) o KDE Plasma
# ⭐ Cinnamon: estable, predecible, curva baja. Ideal para entornos corporativos
```

### 👨‍👩‍👧‍👦 PC familiar / Educación infantil

```bash
# Para niños
# Sugar (si es para aprender) o Linux Mint con Cinnamon (para uso general)
# ⭐ Sugar: diseñado específicamente para niños
```

### 🔧 Desarrollador

```bash
# Mínima fricción, buena integración con herramientas de desarrollo
# GNOME: atajos, workspaces, terminal integrado
# KDE: KRunner, Dolphin con terminal, Konsole con splits
# ⭐ GNOME para minimalismo productivo, KDE para un escritorio completo
```

---

## Evolución histórica

```
CDE (1993, Unix comercial)
│
├── Motif ── toolkit estándar Unix
│
├── KDE 1 (1998) ── Qt ── KDE 3 (2002) ── KDE 4 (2008) ── KDE Plasma 5 (2014) ── Plasma 6 (2024)
│   │
│   └── Trinity (2010) ── fork de KDE 3
│
├── GNOME 1 (1999) ── GTK ── GNOME 2 (2002) ── GNOME 3 (2011) ── GNOME 40+ (2021)
│   │
│   ├── MATE (2011) ── fork de GNOME 2
│   │
│   ├── Cinnamon (2011) ── fork de GNOME Shell
│   │
│   └── Budgie (2014) ── inspirado en GNOME, panel propio
│
├── XFCE (1996) ── ligero, estable, GTK
│
├── Enlightenment (1996) ── EFL, efectos visuales
│
├── LXDE (2006) ── GTK 2, muy ligero ── LXQt (2013) ── Qt, sucesor
│
├── Sugar (2006) ── OLPC, educativo
│
├── Pantheon (2011) ── elementary OS, macOS-like
│
└── Deepin (2013) ── Qt + DTK, estética cuidada
```

---

## Notas personales

- Si estás empezando en Linux, **no necesitas probar todos los DEs**. Empieza con el que viene por defecto en tu distro y, si algo no te gusta, cambia.
- **KDE Plasma** y **GNOME** son los dos grandes ecosistemas. Entre ellos, elige según tu filosofía: GNOME te dice cómo usar el escritorio; KDE te deja decidir.
- Para **PCs antiguos**, XFCE y LXQt son los reyes indiscutibles. Enlightenment es la sorpresa: consume menos que XFCE y tiene efectos visuales.
- **Deepin** es el más bonito, pero las preocupaciones de privacidad (proyecto chino) son reales. Si te importa, usa GNOME o KDE con temas.
- Los DEs clásicos (Cinnamon, MATE, XFCE) tienen la ventaja de que **no cambian drásticamente entre versiones**. Lo que aprendes hoy, te sirve dentro de 5 años.
- Si vienes de **Windows**, Cinnamon o KDE Plasma son las mejores opciones. Si vienes de **macOS**, Deepin o Pantheon.
- No subestimes **XFCE**: es aburrido, pero ese es su superpoder. Nunca se rompe, nunca cambia, siempre funciona.

## Enlaces externos

- [Wikipedia — Comparison of desktop environments](https://en.wikipedia.org/wiki/Comparison_of_X_Window_System_desktop_environments)
- [Arch Wiki — Desktop environment](https://wiki.archlinux.org/title/Desktop_environment)
- [GNOME](https://www.gnome.org/) · [KDE](https://kde.org/) · [XFCE](https://xfce.org/) · [Cinnamon](https://github.com/linuxmint/cinnamon)
- [MATE](https://mate-desktop.org/) · [Budgie](https://buddiesofbudgie.org/) · [LXQt](https://lxqt-project.org/)
- [Deepin](https://www.deepin.org/en/dde/) · [Pantheon](https://elementary.io/) · [Enlightenment](https://www.enlightenment.org/)
- [Sugar Labs](https://sugarlabs.org/) · [Trinity](https://trinitydesktop.org/) · [CDE](https://sourceforge.net/projects/cdesktopenv/)
- [r/unixporn](https://reddit.com/r/unixporn) — inspiración para personalizar DEs

## Ver también

- [[GNOME]] · [[KDE Plasma]] · [[XFCE]] · [[Cinnamon]] · [[MATE]]
- [[Budgie]] · [[LXQt]] · [[Deepin]] · [[Pantheon]] · [[Enlightenment]]
- [[Sugar]] · [[Trinity]] · [[Common Desktop Environment (CDE)]]
- [[Comparativa gestores de ventanas]] — la otra comparativa del vault (WMs)
- [[Wayland vs X11]] — diferencias entre los dos protocolos
- [[Personalización en Linux]] — theming, iconos, fuentes

#indice #entorno-escritorio #comparativa
