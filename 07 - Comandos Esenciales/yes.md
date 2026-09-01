---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: baja
---

# yes

> Repite un string infinitamente hasta que se interrumpe (Ctrl+C) o se cierra la tubería (SIGPIPE). Su uso principal es **auto-responder prompts interactivos** de forma no interactiva.

## Sintaxis

```bash
yes [string]
```

## Descripción

`yes` imprime una línea de texto repetidamente en stdout hasta que recibe SIGPIPE (el receptor cierra la tubería) o se interrumpe con Ctrl+C. Es la herramienta más simple para automatizar confirmaciones de "¿Estás seguro?" en comandos interactivos.

## Opciones principales

| Flag / Opción | Efecto |
|---|---|
| `yes [string]` | Repetir un string personalizado |
| `yes ""` | Emitir línea en blanco (aceptar valor por defecto) |
| `yes --help` | Mostrar ayuda |
| `yes --version` | Mostrar versión (GNU) |

## Ejemplos

```bash
# Auto-aceptar prompts (responder "y")
yes | sudo apt install paquete
yes | sudo pacman -S paquete
yes | sudo dnf install paquete

# Aceptar valores por defecto
yes '' | make install

# Responder con texto personalizado
yes "n" | script-interactivo    # responder "no" a todo
```

## Casos de uso

### Auto-aceptar instaladores

```bash
# Instalador que pregunta "¿Continuar? [S/n]"
yes | sh script-instalador.sh

# Compilar e instalar sin preguntar
make && yes | make install
```

### Generar datos para pruebas

```bash
# Crear archivo de 1000 líneas para pruebas
yes "línea de prueba" | head -n 1000 > demo.txt

# Generar archivo grande rápido
yes "$(head -c 1024 /dev/urandom | base64)" | head -n 100 > datos.txt

# Llenar disco para pruebas (¡cuidado!)
yes | head -n 1000000 > /tmp/testfile
```

### Pipelines útiles

```bash
# limita la cantidad de salida (evita el bucle infinito)
yes | head -n 5

# alimenta comandos que preguntan continuamente
yes "opción" | comando-interactivo

# Copiar/sobrescribir archivos sin preguntar
yes | cp -r origen/ destino/
```

### Alternativa a prompts repetitivos

```bash
# En vez de:
sudo apt install paquete    # pregunta Y/n cada vez

# Usar:
yes | sudo apt install paquete    # responde "y" siempre

# O mejor (con flag nativo):
sudo apt install -y paquete       # flag nativo -y
sudo apt install --yes paquete    # flag nativo --yes
```

## Comparativa con alternativas

| Herramienta | Uso | Ventaja |
|---|---|---|
| **`yes`** | Auto-respuesta infinita | Funciona con cualquier comando |
| **`printf 'y\n'`** | Respuesta única | No necesita SIGPIPE para parar |
| **`-y` / `--yes`** | Flag nativo del comando | Más limpio, más seguro |
| **`expect`** | Scripts interactivos complejos | Puede manejar múltiples prompts diferentes |

> **Regla simple**: si el comando soporta `-y` o `--yes`, usa ese flag en vez de `yes |`. Solo usa `yes` cuando el comando no tiene flag nativo de auto-aceptación.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `yes: write error: Broken pipe` | `head`/`sort` cerró la tubería | Normal — es SIGPIPE, no un fallo real. Suprimir con `2>/dev/null` |
| Bucle infinito sin fin | `yes` sin `head` ni cierre de tubería | Usar `Ctrl+C` o pipe a `head -n N` |
| `yes` no responde a prompt | El comando no lee de stdin | Verificar que el comando acepta input por stdin |

## Notas y advertencias

- **Peligro**: `yes | comando_destructivo` auto-acepta confirmaciones — úsalo con cuidado (ej. `yes | rm -rf`, `yes | dd`).
- En la mayoría de shells modernos, `yes | ...` ya no es necesario porque los comandos aceptan `-y` (apt) o `--assume-yes` (dnf).
- `yes` consume CPU al infinito — siempre pipea a algo que cierre la tubería.
- El texto personalizado se repite **tal cual** — no interpreta variables ni comandos.

## Ver también

- [[seq]] — generar secuencias numéricas
- [[sleep]] — pausar ejecución
- [[xargs]] — ejecutar comandos con argumentos de stdin
- [[bash-avanzado]] — pipelines y redirección
- [[nohup-timeout-at]] — ejecución no interactiva

## Enlaces externos

- [Wikipedia — yes (Unix)](https://en.wikipedia.org/wiki/Yes_(Unix))
- [GNU Coreutils — yes](https://www.gnu.org/software/coreutils/manual/html_node/yes-invocation.html)
- [Man page — yes](https://man7.org/linux/man-pages/man1/yes.1.html)

#comando #scripts #automatizacion
