---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: terminal
prioridad: media
---

# GNU Screen

## Qué es

**GNU Screen** es el multiplexor de terminal clásico (anterior a [[tmux]]). Permite tener múltiples ventanas y paneles dentro de una sola terminal, desconectarse de una sesión y reconectarse después sin perder los procesos en ejecución. Es el predecesor de tmux, más limitado pero presente en prácticamente cualquier sistema Unix desde hace décadas.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install screen

# Arch
sudo pacman -S screen

# Fedora
sudo dnf install screen

# macOS
brew install screen
```

## Uso básico

```bash
screen                                     # iniciar sesión
screen -S trabajo                          # iniciar sesión con nombre
screen -ls                                 # listar sesiones activas
screen -r                                  # reconectar a la única sesión detached
screen -r trabajo                          # reconectar a sesión "trabajo"
screen -x                                  # compartir sesión (dos usuarios ven lo mismo)
screen -d -r trabajo                       # forzar detach remoto y reconectar
```

## Atajos de teclado

Todos los comandos comienzan con **Prefix** (`Ctrl+A` por defecto):

| Atajo | Acción |
|---|---|
| `Prefix + c` | Crear nueva ventana |
| `Prefix + n/p` | Siguiente/anterior ventana |
| `Prefix + 0-9` | Ir a la ventana N |
| `Prefix + "` | Listar ventanas (menú interactivo) |
| `Prefix + A` | Renombrar ventana actual |
| `Prefix + d` | Detach (desconectarse, la sesión sigue) |
| `Prefix + k` | Cerrar ventana actual |
| `Prefix + K` | Matar ventana actual (sin confirmación) |
| `Prefix + S` | Split horizontal |
| `Prefix + Tab` | Saltar al siguiente split |
| `Prefix + X` | Cerrar split actual |
| `Prefix + Esc` | Entrar en modo scroll (copiar) |
| `Prefix + ]` | Pegar |
| `Prefix + :` | Línea de comandos de Screen |

## Configuración (`~/.screenrc`)

```bash
# ~/.screenrc — configuración básica
startup_message off                       # quitar mensaje de bienvenida
defscrollback 10000                       # más historial
hardstatus alwayslastline "%{= kW}%-w%{= BW}%n %t%{= kW}%+w"  # barra con ventanas

# Atajos personalizados
bindkey -k k1 title                       # F1 como ayuda
bind r source ~/.screenrc                 # recargar config con Prefix + r

# Desactivar visual bell
vbell off
```

## Scrollback y copia

```bash
# 1. Presionar Prefix + Esc para entrar en modo copia
# 2. Navegar con flechas, PageUp, PageDown
# 3. Presionar Enter para iniciar selección, mover cursor, Enter para copiar
# 4. Prefix + ] para pegar
```

## Caso de uso típico

```bash
# Trabajo remoto persistente
ssh servidor
screen -S admin                           # iniciar sesión
# ... hacer cosas ...
# Prefix + d para desconectarse
# (desconexión de red, ir a casa, etc.)
ssh servidor
screen -r admin                           # todo sigue exactamente igual
```

## tmux vs screen

| Característica | tmux | screen |
|---|---|---|
| Splits vertical y horizontal | ✅ Ambos | ❌ Solo horizontal por defecto (vertical con `Prefix + \` o `:split -v`) |
| Prefix por defecto | `Ctrl+B` | `Ctrl+A` |
| 256 colores out-of-box | ✅ | ❌ Requiere `defcolors 256` y `term screen-256color` |
| Config file | `~/.tmux.conf` | `~/.screenrc` |
| Soporte mouse | ✅ Nativo | ❌ Limitado |
| Scrollback con vi-keys | ✅ | ✅ (más engorroso) |
| Popularidad actual | ✅ Alta | ❀ Baja |
| Instalado por defecto | ❌ | ✅ En muchas distros mínimas y BSD |

## Notas y advertencias

- Screen es más limitado que tmux pero **está en todas partes**, incluso en sistemas muy minimalistas donde tmux no está instalado. Saber lo básico de screen (`screen -ls`, `screen -r`, `Prefix + d`) te salva en servidores ajenos.
- El mayor dolor de screen: los splits son engorrosos comparados con tmux. Si usas splits seguido, instala tmux.
- Si `screen -r` falla con "Cannot open your terminal '/dev/pts/..." puede ser un problema de permisos del terminal. Solución: `script /dev/null` antes de `screen -r`.

## Enlaces externos

- [Wikipedia — GNU Screen](https://en.wikipedia.org/wiki/GNU_Screen)
- [Repositorio oficial (Savannah)](https://git.savannah.gnu.org/cgit/screen.git)
- [GNU Screen — sitio oficial](https://www.gnu.org/software/screen/)

## Ver también

- [[tmux]] — el reemplazo moderno, más potente
- [[La Shell]]
- [[SSH]]
- [[Emuladores de Terminal]]

#terminal #screen
