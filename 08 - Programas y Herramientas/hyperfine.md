---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# hyperfine

> Benchmarking de comandos CLI con análisis estadístico. Compara rendimiento de herramientas con múltiples ejecuciones y detección de outliers.

## Sintaxis

```bash
hyperfine [opciones] [comando...]
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-N` / `--warmup <n>` | Ejecuciones de calentamiento |
| `-m` / `--min-runs <n>` | Mínimo de ejecuciones |
| `-M` / `--max-runs <n>` | Máximo de ejecuciones |
| `-p` / `--parameter <n> <vals>` | Variar parámetro |
| `--export-markdown <file>` | Exportar a Markdown |
| `--export-json <file>` | Exportar a JSON |
| `-r` / `--runs <n>` | Número fijo de ejecuciones |

## Ejemplos

```bash
# Comparar dos herramientas
hyperfine 'grep -r "pattern" .' 'rg "pattern" .'

# Con warmup
hyperfine -N 3 'find . -name "*.md"'

# Variar tamaño de entrada
hyperfine -p '{1}' --parameter-list 1 10,100,1000 'sleep {1}ms'

# Exportar resultados
hyperfine --export-markdown bench.md 'command1' 'command2'

# Comparar versiones de herramienta
hyperfine 'python2 script.py' 'python3 script.py'
```

## Formato de salida

```
Benchmark 1: command1
  Time (mean ± σ):     123.4 ms ±   5.6 ms
  Range (min … max):   115.2 ms … 135.7 ms  (10 runs)

Benchmark 2: command2
  Time (mean ± σ):      45.2 ms ±   2.1 ms
  Range (min … max):    41.8 ms …  50.1 ms  (10 runs)

Summary
  command2 ran 2.73 ± 0.16 times faster than command1
```

## Ver también

- [[perf]] — profiling de bajo nivel
- time — timing básico de comandos
- [[strace]] — trazar syscalls
- [[Optimización de rendimiento]] — kernel tuning

## Enlaces externos

- [GitHub — hyperfine](https://github.com/sharkdp/hyperfine)
- [Wikipedia — hyperfine](https://en.wikipedia.org/wiki/Hyperfine_(software))

#programa #benchmark
