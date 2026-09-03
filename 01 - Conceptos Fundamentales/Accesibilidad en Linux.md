---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: concepto
prioridad: media
---

# Accesibilidad en Linux

> Herramientas y configuraciones para hacer Linux usable por personas con discapacidades visuales, motoras, cognitivas o auditivas. Incluye lectores de pantalla, alto contraste, lupas, teclado virtual y soporte para daltonismo.

## Qué es

La accesibilidad (a11y) en Linux se gestiona a través de **AT-SPI2** (Assistive Technology Service Provider Interface), el estándar de freedesktop.org que permite que las aplicaciones y los lectores de pantalla se comuniquen. Los DEs principales (GNOME, KDE) tienen integración nativa; los WMs requieren más configuración manual.

## Lectores de pantalla

| Lector | DE | Instalación | Notas |
|---|---|---|---|
| **Orca** | GNOME | `sudo apt install orca` | El más completo; funciona con GTK y apps web |
| **Speech-dispatcher** | Cualquiera | `sudo apt install speech-dispatcher` | Backend de síntesis de voz; Orca lo usa |
| **Festival** | Cualquiera | `sudo apt install festival` | Síntesis de voz alternativa |
| **espeak-ng** | Cualquiera | `sudo apt install espeak-ng` | Ligero, multi-idioma, sin dependencias GRFX |

### Configurar Orca

```bash
# Iniciar Orca
orca

# Atajos de Orca
Super + Alt + S       # Activar/desactivar Orca
Super + Alt + F       # Enfocar panel de Orca
Super + Alt + B       # Leer desde el cursor

# Configurar (GNOME)
orca-settings        # Panel de configuración gráfico

# Cambiar velocidad de voz
spd-say -s 150 "probando velocidad"
```

### Orca en la práctica

| Atajo | Efecto |
|---|---|
| `Super + Alt + S` | Activar/desactivar Orca |
| `Super + Alt + Flechas` | Navegar por la interfaz |
| `Super + Alt + F` | Panel de control de Orca |
| `Super + Alt + R` | Leer desde el cursor |
| `Super + Alt + B` | Leer la barra de estado |
| `Super + Alt + U` | Modo de revisión (navegar el texto) |

## Alto contraste y temas de alto contraste

### GNOME

```bash
# Activar alto contraste
gsettings set org.gnome.desktop.a11y.interface high-contrast true

# Listar temas de alto contraste disponibles
ls /usr/share/themes/ | grep -i high-contrast

# Activar tema específico
gsettings set org.gnome.desktop.interface gtk-theme 'HighContrast'
gsettings set org.gnome.desktop.interface icon-theme 'HighContrast'
```

### KDE Plasma

```
Ajustes → Apariencia → Colores → Alto contraste
Ajustes → Accesibilidad → Alto contraste
```

### Configuración universal (GTK)

```bash
# Forzar alto contraste en todas las apps GTK
export GTK_THEME=HighContraste
# Añadir a ~/.profile o ~/.bashrc para que sea permanente
```

## Lupa / ampliador de pantalla

| Herramienta | DE | Comando | Notas |
|---|---|---|---|
| **GNOME magnifier** | GNOME | `gsettings set org.gnome.desktop.a11y.magnifier mag-factor 2.0` | Integrado en GNOME |
| **kmag** | KDE | `sudo apt install kmag` | Lupa independiente |
| **xzoom** | X11 | `sudo apt install xzoom` | Lupa simple para X11 |
| **wl-magnify** | Wayland | Compilar desde fuente | Lupa para compositores Wayland |

### Configurar GNOME Magnifier

```bash
# Activar lupa
gsettings set org.gnome.desktop.a11y.magnifier mag-factor 2.0

# Posición de la lupa
gsettings set org.gnome.desktop.a11y.magnifier mag-position 'focus'

# Opciones
gsettings set org.gnome.desktop.a11y.magnifier show-cross-hairs true
gsettings set org.gnome.desktop.a11y.magnifier show-pixel-grid false

# Atajos (GNOME)
Super + Alt + 8       # Activar/desactivar lupa
Super + Alt + +/-     # Aumentar/disminuir zoom
```

## Teclado virtual (on-screen keyboard)

| Herramienta | DE | Comando | Notas |
|---|---|---|---|
| **Caribou** | GNOME | `sudo apt install caribou` | Teclado virtual de GNOME |
| **onboard** | Cualquiera | `sudo apt install onboard` | Alternativa con más personalización |
| **Florence** | X11 | `sudo apt install florence` | Teclado virtual flotante |

```bash
# Activar teclado virtual en GNOME
gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true

# Onboard como teclado virtual
onboard
```

## Soporte para daltonismo (colorblind)

### GNOME

```bash
# Activar filtros de color
gsettings set org.gnome.desktop.a11y.color-caling filter-type 'protanopia'

# Tipos disponibles:
# 'none'           → sin filtro
# 'grayscale'      → escala de grises
# 'protanopia'     → daltonismo rojo-verde (sin rojos)
# 'deuteranopia'   → daltonismo rojo-verde (sin verdes)
# 'tritanopia'     → daltonismo azul-amarillo

# Ajustar intensidad del filtro
gsettings set org.gnome.desktop.a11y.color-caling brightness 0.8
```

### KDE Plasma

```
Ajustes → Accesibilidad → Filtros de color
# Protanopia, Deuteranopia, Tritanopia
```

### Herramientas independientes

| Herramienta | Función | Instalación |
|---|---|---|
| **Color Oracle** | Simulador de daltonismo (ver cómo se ve tu pantalla) | `sudo apt install color-oracle` |
| **Gnome Colorblind** | Extensión GNOME para filtros | Extensiones GNOME |

## Atajos de teclado y accesibilidad del teclado

### Sticky Keys (teclas pegajosas)

Permite pulsar combinaciones de teclas una a la vez (útil para movilidad reducida):

```bash
# GNOME
gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable true

# Atajo para activar/desactivar
# Pulsar Shift 5 veces seguidas
```

### Slow Keys (teclas lentas)

Ignora pulsaciones involuntarias, requiere mantener la tecla pulsada un tiempo:

```bash
# GNOME
gsettings set org.gnome.desktop.a11y.keyboard slowkeys-enable true
gsettings set org.gnome.desktop.a11y.keyboard slowkeys-delay 300  # milisegundos
```

### Bounce Keys (rebote de teclas)

Ignora teclas pulsadas rápidamente varias veces:

```bash
# GNOME
gsettings set org.gnome.desktop.a11y.keyboard bouncekeys-enable true
gsettings set org.gnome.desktop.a11y.keyboard bouncekeys-delay 50  # milisegundos
```

### Mouse Keys (ratón con teclado)

Controlar el cursor del ratón con el teclado numérico:

```bash
# GNOME
gsettings set org.gnome.desktop.a11y.keyboard mousekeys-enable true

# Activar con: pulsar Shift + Num Lock 5 veces
# Navegar con: teclas numéricas (8=arriba, 2=abajo, 4=izq, 6=der)
# Clic con: 5 (clic), + (arrastrar)
```

## Zoom de pantalla (desktop zoom)

```bash
# GNOME — zoom global del escritorio
gsettings set org.gnome.desktop.a11i.zoom desktop Zoom-enabled true
gsettings set org.gnome.desktop.a11i.zoom desktop zoom-factor 150

# Atajo: Super + Alt + 8 para activar/desactivar
```

## Navegación por teclado (sin ratón)

```bash
# GNOME — activar foco automático (sin necesidad de clic)
gsettings set org.gnome.desktop.a11i.keyboard GNOME.FOCUS-FOLLOWS-MOUSE true

# KDE — atajos de navegación por teclado
# Tab para cambiar entre paneles
# Flechas para navegar dentro de paneles
# Enter para activar elemento

# Navegación por teclado en la terminal
# tmux: Ctrl+B +方向键 para mover paneles
# screen: Ctrl+A +方向键
```

## Aplicaciones accesibles

| App | Tipo | Accesibilidad |
|---|---|---|
| **Firefox** | Navegador | Soporte completo Orca; modo lectura; alto contraste |
| **LibreOffice** | Ofimática | Navegación por teclado completa; estilos de pantalla |
| **GNOME Terminal** | Terminal | Alto contraste; zoom; fuente grande |
| **Nautilus** | Gestor archivos | Navegación por teclado; voz con Orca |
| **gparted** | Partitionador | Accesibilidad básica; pantalla completa |

## Configuración desde la línea de comandos

```bash
# ── Alto contraste ──
gsettings set org.gnome.desktop.interface high-contrast true
gsettings set org.gnome.desktop.a11i.interface high-contrast true

# ── Lupa ──
gsettings set org.gnome.desktop.a11i.magnifier mag-factor 2.0

# ── Teclado virtual ──
gsettings set org.gnome.desktop.a11i.applications screen-keyboard-enabled true

# ── Daltonismo ──
gsettings set org.gnome.desktop.a11i.color-caling filter-type 'protanopia'

# ── Teclas pegajosas ──
gsettings set org.gnome.desktop.a11i.keyboard stickykeys-enable true

# ── Revisar configuración actual ──
gsettings list-recursively org.gnome.desktop.a11i
```

## Accesibilidad en servidores (SSH)

```bash
# Conexión SSH con soporte de voz
ssh -t usuario@servidor "spd-say 'conectado'"

# Compresión para conexiones lentas (mejor rendimiento)
ssh -C usuario@servidor

# Terminal con alta legibilidad
export TERM=xterm-256color
export GREP_COLORS='ms=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
alias ls='ls --color=auto'
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Orca no lee las apps | AT-SPI2 no iniciado | `export GTK_MODULES=gail:atk-bridge` + reiniciar sesión |
| Orca no lee en Firefox | Extensión de accesibilidad desactivada | `about:config` → ` accessibility.force_disabled = 0` |
| Lupa no funciona en Wayland | Protocolo no soportado por el compositor | Usar lupa del DE (GNOME/KDE) en vez de herramienta X11 |
| Alto contraste no aplica en apps Qt | Tema Qt no configurado | `export QT_STYLE_OVERRIDE=HighContrast` |
| Teclado virtual no aparece | Caribou no instalado o no iniciado | `sudo apt install caribou && caribou` |
| Filtro daltonismo no aplica | DE no soporta a11y color | Usar Color Oracle como alternativa |

## Ver también

- [[GNOME]] — configuración de accesibilidad en GNOME
- [[KDE Plasma]] — configuración de accesibilidad en KDE
- [[Variables de Entorno y PATH]] — configurar variables de entorno
- [[Shells (bash zsh fish)]], [[Fish]] — shells con auto-sugerencias
- [[Wayland vs X11]] — compatibilidad de herramientas de accesibilidad

## Enlaces externos

- [GNOME Accessibility](https://help.gnome.org/users/gnome-help/stable/accessibility.html)
- [Arch Wiki — Accessibility](https://wiki.archlinux.org/title/Accessibility)
- [freedesktop.org — AT-SPI2](https://wiki.linuxfoundation.org/accessibility/at-spi2)
- [Orca Screen Reader](https://wiki.gnome.org/Projects/Orca)
- [Wikipedia — Accessibility](https://en.wikipedia.org/wiki/Accessibility)

#concepto #accesibilidad #a11y
