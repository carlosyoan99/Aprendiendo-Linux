---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: baja
---

# gitui

> Cliente Git TUI escrito en Rust. Rápido, con teclado tipo Vim, temas integrados. Alternativa a [[lazygit]] para quienes prefieren más velocidad y menos dependencias.

## Qué es

**gitui** es un cliente Git interactivo para terminal, similar a lazygit pero escrito en Rust. Se enfoca en ser rápido y responsive incluso en repos grandes. Incluye temas de color integrados (Nord, Gruvbox, Dracula, etc.) sin configuración extra.

Un solo binario estático (~5 MB).

## Instalación

```bash
# Debian/Ubuntu
sudo apt install gitui

# Arch
sudo pacman -S gitui

# Fedora
sudo dnf install gitui

# Desde GitHub (binario estático)
# https://github.com/extrawurst/gitui/releases

# Con cargo (Rust)
cargo install gitui
```

## Atajos esenciales

### Navegación

| Tecla | Acción |
|---|---|
| `Tab` | Cambiar entre paneles |
| `Flechas` | Navegar |
| `Enter` | Expandir/ver detalle |
| `Esc` | Volver atrás / cancelar |
| `q` | Salir (o volver al nivel anterior) |

### Acciones

| Tecla | Acción |
|---|---|
| `s` | Stage archivo seleccionado |
| `S` | Stage todo |
| `d` | Open diff |
| `c` | Commit (escribir mensaje) |
| `m` | Merge branch |
| `b` | Listar branches |
| `h` | Push |
| `H` | Pull |
| `r` | Rebase |
| `g` | Reset |
| `?` | Ayuda |

### Temas

```bash
# gitui incluye temas listos para usar
# Por defecto usa el tema del sistema (seguir preferencia claro/oscuro)
# Para cambiar tema: editar ~/.config/gitui/theme.ron

# Temas disponibles:
# - nord (por defecto oscuro)
# - gruvbox_dark / gruvbox_light
# - dracula
# - monokai
# - solarized_dark / solarized_light
```

## lazygit vs gitui

| Aspecto | lazygit | gitui |
|---|---|---|
| **Lenguaje** | Go | Rust |
| **Velocidad** | Muy rápida | ⚡ Más rápida |
| **Binario** | ~15 MB | ~5 MB |
| **Temas integrados** | ❌ Config manual | ✅ 10+ temas |
| **Stash visual** | ✅ Completo | ✅ |
| **Rebase interactivo** | ✅ Visual | ✅ |
| **Resolución conflictos** | ✅ | ✅ |
| **Curva aprendizaje** | Muy baja | Baja |

> Ambos son excelentes. **lazygit** tiene más funciones y mejor UX para principiantes. **gitui** es más rápido, más pequeño, y tiene temas nativos. Para uso diario, cualquiera sirve.

## Ver también

- [[lazygit]] — Git TUI interactivo (Go, más funcionalidades)
- [[tig]] — visor de commits y log (más rápido para consultas)
- [[Git]] — nota general sobre Git en el vault
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — extrawurst/gitui](https://github.com/extrawurst/gitui)
- [Documentación](https://extrawurst.github.io/gitui/)

#programa #tui #git
