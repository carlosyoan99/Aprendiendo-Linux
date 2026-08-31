---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-30
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
| `Prefix + \|` (backslash) | Split vertical |
| `Prefix + Tab` | Saltar al siguiente split |
| `Prefix + X` | Cerrar split actual |
| `Prefix + Esc` | Entrar en modo scroll (copiar) |
| `Prefix + ]` | Pegar |
| `Prefix + :` | Línea de comandos de Screen |
| `Prefix + h` | Historial de comandos |
| `Prefix + [` | Modo scroll (copiar/pegar) |

## Configuración (~/.screenrc)

```bash
# ~/.screenrc — configuración completa

# ── Básico ──
startup_message off                       # quitar mensaje de bienvenida
defscrollback 10000                       # más historial de scroll
encoding UTF-8                            # forzar UTF-8

# ── Barra de estado ──
hardstatus alwayslastline "%{= kW}%-w%{= BW}%n %t%{= kW}%+w %{= kG}%= %{= kW}%C %d %M %Y"
caption always "%{= kW}%-w%{= kW}%n %t%{-}%+w%{= kW}%=%{= kG} %C %d %M %Y"

# ── Atajos personalizados ──
bindkey -k k1 title                       # F1 como ayuda
bind r source ~/.screenrc                 # recargar config con Prefix + r
bind h history                            # Prefix + h para historial

# ── Desactivar visual bell ──
vbell off
vbell_msg "   *beep*   "

# ── Logging ──
logfile ~/screen-logs/screen-%n-%Y%m%d-%H%M%S.log
deflog on                                 # activar logging por defecto

# ── Multi-usuario ──
acladd usuario2                           # dar acceso a usuario2
```

## Splits (paneles)

```bash
# Crear splits
Prefix + S            # split horizontal
Prefix + |            # split vertical

# Navegar entre splits
Prefix + Tab          # siguiente split
Prefix + Ctrl+Tab     # split anterior

# Cerrar split
Prefix + X            # cerrar split actual

# Navegar con flechas (si el split tiene foco)
# El foco se mueve con Tab/Shift+Tab
```

### Configuración de tamaño de splits

```bash
# Desde la línea de comandos (Prefix + :)
:resize +5            # aumentar 5 líneas
:resize -5            # reducir 5 líneas
:resize 50            # fijar a 50 líneas
```

## Logging

```bash
# Activar log de la ventana actual
Prefix + H            # toggle logging

# Configurar ruta del log en ~/.screenrc:
logfile ~/screen-logs/screen-%n-%Y%m%d-%H%M%S.log

# %n = número de ventana, %Y%m%d = fecha, %H%M%S = hora
# Logs útiles para auditoría o debugging de sesiones remotas
```

## Multi-usuario (colaboración)

```bash
# En el servidor:
screen -S sesion
# Prefix + : acladd usuario2        # añadir usuario
# Prefix + : aclchg usuario2 +x     # dar permiso de escritura
# Prefix + : aclshutdown             # cerrar todas las sesiones

# El usuario2 se conecta con:
screen -x usuario/sesion
```

## Scrollback y copia

```bash
# 1. Presionar Prefix + Esc para entrar en modo copia
# 2. Navegar con flechas, PageUp, PageDown
# 3. Presionar Enter para iniciar selección, mover cursor, Enter para copiar
# 4. Prefix + ] para pegar

# Modo scroll con búsqueda:
# Prefix + [ → luego / para buscar, n/N para siguiente/anterior
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

# Sesión con múltiples ventanas para un proyecto
screen -S proyecto
# Prefix + c → ventana 1: editor
# Prefix + c → ventana 2: servidor de desarrollo
# Prefix + c → ventana 3: git
# Prefix + d → desconectar
# Al reconectar: todo sigue corriendo
```

## tmux vs screen

| Característica | tmux | screen |
|---|---|---|
| Splits vertical y horizontal | ✅ Ambos | ✅ Ambos (Prefix + S / Prefix + \|) |
| Prefix por defecto | `Ctrl+B` | `Ctrl+A` |
| 256 colores out-of-box | ✅ | ❌ Requiere `defcolors 256` y `term screen-256color` |
| Config file | `~/.tmux.conf` | `~/.screenrc` |
| Soporte mouse | ✅ Nativo | ❌ Limitado |
| Scrollback con vi-keys | ✅ | ✅ (más engorroso) |
| Scripts/programación | ✅ `tmux -f` | ⚠️ Limitado |
| Popularidad actual | ✅ Alta | ❀ Baja |
| Instalado por defecto | ❌ | ✅ En muchas distros mínimas y BSD |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `Cannot open terminal` | Permisos de `/dev/pts/` | `script /dev/null` antes de `screen -r` |
| Colores rotos | Term no soportado | Añadir `defscrollback 10000` y `term screen-256color` en `.screenrc` |
| `There is a screen on...` (no detach) | Sesión stuck | `screen -X -S <id> quit` para forzar cierre |
| No hay scroll | Scrollback muy bajo | `defscrollback 10000` en `.screenrc` |
| UTF-8 roto | Encoding no configurado | `encoding UTF-8` en `.screenrc` |

## Notas y advertencias

- Screen es más limitado que tmux pero **está en todas partes**, incluso en sistemas muy minimalistas donde tmux no está instalado. Saber lo básico de screen (`screen -ls`, `screen -r`, `Prefix + d`) te salva en servidores ajenos.
- El mayor dolor de screen: los splits son engorrosos comparados con tmux. Si usas splits seguido, instala tmux.
- Si `screen -r` falla con "Cannot open your terminal '/dev/pts/...'" puede ser un problema de permisos del terminal. Solución: `script /dev/null` antes de `screen -r`.

## Enlaces externos

- [Wikipedia — GNU Screen](https://en.wikipedia.org/wiki/GNU_Screen)
- [Repositorio oficial (Savannah)](https://git.savannah.gnu.org/cgit/screen.git)
- [GNU Screen — sitio oficial](https://www.gnu.org/software/screen/)
- [Arch Wiki — GNU Screen](https://wiki.archlinux.org/title/GNU_Screen)

## Ver también

- [[tmux]] — el reemplazo moderno, más potente
- [[La Shell]]
- [[SSH]]
- [[Emuladores de Terminal]]

#terminal #screen
