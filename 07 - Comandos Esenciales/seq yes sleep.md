---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-09-01
estado: resuelto
categoria: comando
prioridad: baja
---

# seq, yes, sleep

> Tres utilidades de `coreutils` para controlar la dinámica de un script: `seq` genera secuencias numéricas, `yes` repite un string infinitamente y `sleep` pausa la ejecución.

## Qué son

Son tres utilidades simples, **no relacionadas entre sí**, pero que aparecen juntas constantemente en bucles y automatizaciones:

- **`seq`** — genera una secuencia de números, uno por línea. Es la forma tradicional de producir rangos para loops y `xargs` (la expansión `{1..5}` del shell es la alternativa moderna).
- **`yes`** — repite un string (por defecto `y`) infinitamente hasta que se interrumpe (`Ctrl+C`) o se cierra la tubería (`SIGPIPE`). Su función principal es auto-responder prompts interactivos.
- **`sleep`** — pausa la ejecución un tiempo dado. Acepta sufijos `s`/`m`/`h`/`d` (y decimales en GNU) para regular la cadencia de reintentos y esperas.

Todas vienen en `coreutils`: disponibles en cualquier distro sin instalación.

## Sintaxis y opciones por comando

### `seq`

```bash
seq [OPCIÓN] INICIO FINAL
seq [OPCIÓN] INICIO INCREMENTO FINAL
```

| Opción | Efecto |
|---|---|
| `-f FORMATO` | Formato printf de salida (p.ej. `%03g` para padding) |
| `-s SEPARADOR` | Separador entre números (por defecto `\n`) |
| `-w` | Igualar el ancho con ceros a la izquierda |

```bash
seq 1 3          # 1 2 3
seq 0 2 10       # 0 2 4 6 8 10
seq -w 8 12      # 08 09 10 11 12
seq -s ' ' 1 3   # 1 2 3 (en una línea)
seq -f '%.2f' 1 3   # 1.00 2.00 3.00
```

### `yes`

```bash
yes [STRING]     # repite STRING (por defecto 'y' 'y' 'y'...)
```

| Precauciones | Detalle |
|---|---|
| Ctrl+C | Única salida limpia esperada |
| SIGPIPE | Se detiene solo si la tubería se cierra (`yes | cmd`) |
| Riesgo | **Solo usarlo en prompts que SÍ acepten la respuesta** (ej: instaladores de paquete/gestión de repos). Confirmar que el comando no pregunta algo destructivo |

### `sleep`

```bash
sleep [NÚMERO][s/m/h/d]...   # acepta varias magnitudes en GNU
```

| Precauciones | Detalle |
|---|---|
| Decimales | `sleep 0.5` y `sleep 1.5` funcionan en GNU coreutils |
| Múltiples | `sleep 1m 30s` suma y espera 90 s |
| Backoff | Combinar con un bucle para reintentos con espera creciente: `sleep $((attempt * 2))` |

## Tabla comparativa

| Aspecto | `seq` | `yes` | `sleep` |
|---|---|---|---|
| Qué produce | Números en secuencia | Un string infinito | Nada (simplemente espera) |
| Cuándo termina | Al alcanzar el límite | Nunca (Ctrl+C / SIGPIPE) | Cuando pasa el tiempo |
| Uso típico | Rangos para loops | Responder prompts | Retardos entre pasos |
| Opciones relevantes | `-f`, `-s`, `-w` | String personalizado | Sufijos `s`/`m`/`h`/`d` |

## Cuándo usar cada uno

- **`seq`** — generar índices, crear archivos numerados, iterar un rango en un `for` o pasar rangos a [[xargs]].
- **`yes`** — aceptar automáticamente confirmaciones de instaladores (`yes | apt install ...`), scripts o comandos heredados, y generar mucho texto para pruebas.
- **`sleep`** — esperar a que un servicio arranque, espaciar reintentos de red o imponer el ritmo de un loop de monitoreo.

## Ejemplos de uso combinado

```bash
# Bucle típico: seq genera el rango, sleep marca el ritmo
for i in $(seq 1 5); do
  echo "Intento $i"
  sleep 1
done

# Crear 100 archivos numerados con padding
seq -f "file_%03g.txt" 100 | xargs touch

# Reintentar hasta que un servicio responda (seq + sleep + curl)
for i in $(seq 1 10); do
  curl -s localhost:8080 > /dev/null && break
  sleep 2
done
echo "Servicio listo"

# Auto-responder un instalador (¡con cuidado!)
yes | sudo apt install paquete

# Generar texto de prueba acotado
yes "línea de prueba" | head -n 1000 > demo.txt

# Pausa entre pasos de un pipeline
seq 1 20 | xargs -I{} sh -c 'echo "Paso {}"; sleep 0.3'
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `seq` produce decimales con comas locales | Localización (locale) | `LC_ALL=C seq 0 0.5 3` |
| `yes` lanza un instalador que pide algo irreversible | El prompt aceptaba la confirmación por defecto | Usar `echo 'n'` y responder manualmente si hay duda |
| `sleep` avisa `invalid time interval` | Formato decimal con `,` en vez de `.` | `sleep 0,5` → `sleep 0.5` |
| `seq` lento o command substitution excesiva | Generar rangos con `$(seq ...)` dentro de un bucle es costoso | Preferir `for i in {1..100}` (brace expansion) o `seq` una vez |

## Ver también

- [[seq]] — formato, separadores, padding con ceros
- [[yes]] — auto-respuesta de prompts y precauciones
- [[sleep]] — sufijos temporales, decimales y backoff
- [[xargs]] — consumir las secuencias de `seq` como argumentos
- [[watch]] — alternativa a `sleep` en loops de monitoreo
- [[bash-avanzado]] — loops `for`/`while` y expansión `{n..m}`

## Enlaces externos

- [GNU Coreutils — seq](https://www.gnu.org/software/coreutils/manual/html_node/seq-invocation.html)
- [Wikipedia — yes (Unix)](https://en.wikipedia.org/wiki/Yes_(Unix))
- [GNU Coreutils — sleep](https://www.gnu.org/software/coreutils/manual/html_node/sleep-invocation.html)

#comando