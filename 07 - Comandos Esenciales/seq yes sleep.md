---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-29
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