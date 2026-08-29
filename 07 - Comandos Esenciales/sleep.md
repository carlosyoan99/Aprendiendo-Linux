---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: baja
---

# sleep

## Sintaxis

```bash
sleep [N][sufijo] [N][sufijo]...
```

## Descripción

Pausa la ejecución durante el tiempo especificado. Acepta sufijos: `s` (segundos, por defecto), `m` (minutos), `h` (horas), `d` (días). Acepta decimales (GNU) y múltiples argumentos que se **suman**. Esencial en scripts para regular la cadencia de loops, esperar servicios o limitar la frecuencia de reintentos.

## Opciones frecuentes

| Flag / Opción | Efecto |
|---|---|
| `sleep N` | N segundos |
| `sleep Nm` / `Nh` / `Nd` | N minutos / horas / días |
| `sleep 1.5` | Decimales (GNU) |
| `sleep 1h 30m` | Suma de varios intervalos |

## Ejemplos

```bash
sleep 5                          # 5 segundos
sleep 0.5                        # 500 ms
sleep 2m                         # 2 minutos
sleep 1h 30m                     # 1 hora 30 minutos
```

## Casos de uso

```bash
# Esperar a que un servicio esté listo
while ! curl -s localhost:3000 > /dev/null; do sleep 1; done
echo "Servicio listo"

# Loop con pausa
for i in $(seq 1 5); do echo "Paso $i"; sleep 1; done

# Reintento con backoff simple (creciente)
intentos=0
until curl -s localhost:80; do
  intentos=$((intentos+1))
  [ "$intentos" -gt 5 ] && break
  sleep $((intentos * 2))
done
```

## Combinaciones comunes con pipe

```bash
# retardo antes de continuar en un pipeline temporal
sleep 3 && comando

# esperar y reintentar dentro de un while
while ! comando; do sleep 5; done
```

## Alternativas

| Herramienta | Uso |
|---|---|
| **`sleep`** | Pausa simple |
| **`timeout`** | A la inversa: limita un comando |
| **`wait`** | Espera jobs/backgrounds del shell |
| **`inotifywait` / `systemd-run --on-active`** | Espera basada en eventos o servicio |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `<sleep: invalid time interval '1h30m'` | Falta espacio entre intervalos | `sleep 1h 30m` |
| `sleep: invalid time interval '0.5'` (BSD/macOS) | Decimales no soportados | Usar `sleep 1` (segundo entero) o `gtimeout` |
| `sleep` no acepta `1.5s` | Sintaxis | Escribir `sleep 1.5` sin sufijo en GNU |

## Notas y advertencias

- `sleep` **no** es preciso para tiempos muy cortos ni para coordinación entre procesos (no es sincronización).
- En **Ubuntu/Coreutils** los decimales funcionan; en **BSD/macOS** solo enteros.
- Alternativa moderna para esperar eventos reales: `systemd-run` o `inotifywait` en vez de `sleep`-adivinando.

## Enlaces externos

- [GNU Coreutils — sleep](https://www.gnu.org/software/coreutils/manual/html_node/sleep-invocation.html)
- [man sleep(1)](https://man7.org/linux/man-pages/man1/sleep.1.html)

## Ver también

- [[seq]] — generar secuencias numéricas
- [[yes]] — repetir string infinitamente
- [[watch]] — ejecutar comando periódicamente
- [[timeout]] — limitar tiempo de ejecución

#comando
