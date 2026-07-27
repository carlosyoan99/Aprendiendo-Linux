---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# zellij

> Multiplexor de terminal moderno con layout automatizado, paneles redimensionables, pestañas, plugins y un sistema de diseño integrado. Alternativa moderna a [[tmux]].

## Qué es

**zellij** es un multiplexor de terminal (como tmux o screen) que añade funcionalidades modernas: un sistema de paneles inteligente que se redimensionan automáticamente al dividirlos, pestañas, un menú integrado (accesible con `Ctrl+p`), plugins (scrolling, búsqueda, etc.), y un diseño que funciona bien incluso en terminales con poco espacio.

Escrito en Rust. El nombre viene de una flor de tulipán 🧩.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install zellij

# Arch
sudo pacman -S zellij

# Fedora
sudo dnf install zellij

# Homebrew (macOS/Linux)
brew install zellij

# Desde GitHub (binario estático recomendado)
# https://github.com/zellij-org/zellij/releases
bash <(curl -sL https://git.io/JJ0EN)   # script de instalación oficial
```

## Atajos esenciales

### Globales

| Tecla | Acción |
|---|---|
| `Ctrl+p` | Abrir menú principal (mosaico de opciones) |
| `Ctrl+t` | Nueva pestaña |
| `Ctrl+q` | Cerrar panel actual |
| `Ctrl+o` | Entrar/salir de modo editor (pasar teclas a la terminal) |
| `Ctrl+g` | Ir a un panel específico por número |
| `Ctrl+h/j/k/l` | Moverse entre paneles (Vim) |
| `Ctrl+n` | Nuevo panel vertical |
| `Ctrl+d` | Nuevo panel horizontal |
| `Alt+h/j/k/l` | Redimensionar panel |
| `Esc` | Salir de modo actual |

### Sesiones

| Comando | Acción |
|---|---|
| `Ctrl+p` → sesiones | Listar y cambiar de sesión |
| `Ctrl+p` → cerrar | Cerrar panel actual |
| `Ctrl+p` → ayuda | Ayuda completa |
| `zellij` | Nueva sesión |
| `zellij --session trabajo` | Sesión con nombre |
| `zellij attach trabajo` | Adjuntarse a sesión |
| `zellij list-sessions` | Listar sesiones |
| `zellij kill-all-sessions` | Matar todas las sesiones |

## Modo editor vs modo normal

zellij tiene dos modos clave:

```bash
# MODO NORMAL (por defecto)
# Ctrl+p abre menú, Ctrl+n nuevo panel, etc.
# Las teclas son interceptadas por zellij

# MODO EDITOR (Ctrl+o para entrar/salir)
# Todas las teclas pasan directamente a la terminal
# Útil para: nano, vim, helix, less, etc.
# La barra inferior cambia de color para indicar el modo

# Ctrl+o de nuevo para volver al modo normal
```

## Uso básico

```bash
# Iniciar sesión
zellij

# Con layout específico
zellij --layout dev

# Compartir sesión (dos personas ven lo mismo)
zellij attach trabajo

# Sin barra de estado (compacto)
zellij --no-frame
```

## Layouts: `~/.config/zellij/layouts/`

```yaml
# ~/.config/zellij/layouts/dev.yaml
---
tabs:
  - name: "editor"
    direction: Horizontal
    parts:
      - direction: Vertical
        parts:
          - direction: Vertical
            split_size:
              Fixed: 1
            plugin: tab-bar
          - direction: Vertical
            body: true
      - direction: Vertical
        split_size:
          Percent: 30
        run:
          command: "htop"
  - name: "terminal"
    run:
      command: "bash"
```

### Layouts predefinidos

```bash
# zellij incluye layouts para:
# - dev (editor + terminal + filetree)
# - logs (seguimiento de logs)
# - stranger (modo kiosko para pantallas públicas)

# Usar layout al iniciar
zellij --layout dev
```

## Personalización: `~/.config/zellij/config.kdl`

```kdl
// Tema
theme "nord"

// Comportamiento
pane_framed true
mouse_mode true
copy_command "xclip -selection clipboard"
scroll_buffer_size 10000

// Atajos personalizados
keybinds {
    normal {
        bind "Alt \"[\"" { SwitchToMode "locked"; }
        bind "Ctrl \"o\"" { SwitchToMode "pane"; }
    }
}
```

## Temas de color

```bash
# Listar temas disponibles
zellij --theme

# Temas incluidos:
# - default (oscuro)
# - dragon
# - gruvbox
# - monokai
# - nord
# - catppuccin
# - solarized (dark/light)

# Usar tema
zellij --theme nord
# O en config.kdl: theme "nord"
```

## Comparativa

| Aspecto | zellij | tmux | screen |
|---|---|---|---|
| **Layout automatizado** | ✅ Al dividir se redimensionan | ❌ Manual | ❌ Manual |
| **Menú visual** | ✅ `Ctrl+p` (mosaico) | ❌ Prefijos | ❌ Prefijos |
| **Plugins** | ✅ Layouts, plugins integrados | ❌ No nativo | ❌ |
| **Modo editor** | ✅ `Ctrl+o` (pasar teclas) | ❌ Prefix primero | ❌ Prefix primero |
| **Soporte mouse** | ✅ Excelente | ✅ Bueno | ❌ Limitado |
| **Temas** | ✅ 10+ incluidos | ✅ Manual | ❌ |
| **Rendimiento** | Rápido | ⚡ Muy rápido | ✅ Muy rápido |
| **Instalado por defecto** | ❌ | ❌ | ✅ En muchas distros |
| **Curva aprendizaje** | Baja | Alta | Media |
| **Peso** | ~15 MB | ~1 MB | ~1 MB |

> zellij es mejor para quienes se inician en multiplexores: no necesitas memorizar prefijos, el menú visual lo guía todo. tmux es mejor para usuarios avanzados que quieren control total y eficiencia máxima (menos peso, más rápido, más configurable).

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No funciona con SSH | Necesita TERM adecuado | `export TERM=xterm-256color` antes de SSH |
| El modo editor no funciona | Confusión de modos | `Ctrl+o` para salir del modo editor |
| No veo las pestañas | Pantalla muy pequeña | Mínimo 80×24, o usar `--no-frame` |
| Plugin no carga | Versión desactualizada | `zellij --version` y actualizar binario |

## Ver también

- [[tmux]] — el multiplexor clásico, más rápido y configurable
- [[screen]] — el abuelo, preinstalado en distros mínimas
- [[Emuladores de Terminal]] — donde se ejecutan los multiplexores
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — zellij-org/zellij](https://github.com/zellij-org/zellij)
- [Sitio oficial](https://zellij.dev/)
- [Documentación](https://zellij.dev/documentation/)
- [Arch Wiki — Zellij](https://wiki.archlinux.org/title/Zellij)

#programa #tui #terminal
