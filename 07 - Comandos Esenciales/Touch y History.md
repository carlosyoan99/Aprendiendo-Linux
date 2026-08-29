---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: media
---

# Touch y History

> `touch` crea archivos vacíos y modifica sus timestamps; `history` muestra y gestiona el historial de comandos de la shell. No tienen relación funcional: uno trabaja con el sistema de archivos y el otro con la sesión interactiva.

## Qué son

Son dos comandos **no relacionados** que se agrupan por ser imprescindibles del trabajo diario en terminal:

- **`touch`** — actualiza las marcas de tiempo (atime/mtime) de un archivo y, si no existe, **lo crea vacío**. Imprescindible para generar archivos de trabajo, forzar recompilaciones con `make` (que compara timestamps) o crear archivos en masa.
- **`history`** — builtin de la shell que lista los comandos ejecutados en la sesión actual y permite **re-ejecutarlos** sin releerlos (`!!`, `!n`, `!texto`, `!$`). Su comportamiento depende de variables de entorno.

## Tabla comparativa

| Aspecto | `touch` | `history` |
|---|---|---|
| Naturaleza | Comando externo (coreutils) | Builtin de la shell |
| Ámbito | Sistema de archivos | Sesión interactiva |
| Acción principal | Crear archivos / timestamps | Registrar y re-ejecutar comandos |
| Persistencia | En disco | Archivo de historial (`.bash_history`) |
| Variables de entorno | No | Sí (HISTFILE, HISTSIZE, HISTCONTROL) |

## Cuándo usar cada uno

- **`touch`**: crear un archivo vacío (p. ej. un `README.md` nuevo), actualizar la fecha de un archivo para forzar su procesamiento, o sincronizar timestamps con `-r archivo`.
- **`history`**: recordar cómo hiciste algo hace un rato, repetir un comando largo sin teclear (`!!`, `!$` para el último argumento) o buscar con `Ctrl+r`.

## Ejemplos de uso combinado

### touch — crear archivos y manipular timestamps

```bash
touch nota.txt                        # crear archivo vacío
touch -c solo-si-existe.txt           # NO crear si no existe
touch -t 202612251200 fecha.txt       # timestamp específico (YYYYMMDDhhmm.ss)
touch -d "2 weeks ago" viejo.txt      # fecha relativa
touch archivo-{1..5}.txt              # crear cinco a la vez
seq -f "cap_%02g.txt" 10 | xargs touch   # numerados con padding
```

### history — historial de la shell

```bash
history                    # listar el historial numerado
history 20                 # últimos 20 comandos
!!                         # repetir el último comando
!100                       # ejecutar el comando nº 100
!vi                        # último comando que empieza con "vi"
!$                         # último argumento del comando anterior
^pacman^yay                # en el último comando: reemplazar pacman → yay
```

### Configuración del historial

El historial se controla con [[Variables de Entorno y PATH]]:

```bash
export HISTFILE=~/.bash_history     # archivo donde persiste
export HISTSIZE=10000               # comandos retenidos en memoria
export HISTFILESIZE=100000          # líneas máximas en el archivo
export HISTCONTROL=ignoredups       # ignorar duplicados
export HISTTIMEFORMAT="%F %T  "     # fechas junto a cada comando
```

Cómo lo maneja cada shell en particular se explica en [[La Shell]].

## Ver también

- [[touch]] — opciones -a, -m, -c, -t, -r
- [[history]] — atajos de teclado y control del historial
- [[cat]] — ver el contenido de los archivos que creaste
- [[Variables de Entorno y PATH]] — HISTFILE, HISTSIZE, HISTCONTROL
- [[La Shell]] — dónde vive el historial de cada shell

## Enlaces externos

- [Wikipedia — touch (Unix)](https://en.wikipedia.org/wiki/Touch_(Unix))
- [GNU Coreutils — touch](https://www.gnu.org/software/coreutils/manual/html_node/touch-invocation.html)
- [Wikipedia — history (command)](https://en.wikipedia.org/wiki/History_(command))

#comando