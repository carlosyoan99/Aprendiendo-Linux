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

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install hyperfine` |
| Arch | `sudo pacman -S hyperfine` |
| Fedora | `sudo dnf install hyperfine` |
| macOS | `brew install hyperfine` |
| Cargo | `cargo install hyperfine` |

## Ejemplos avanzados

```bash
# Comparar compiladores
g++ -O2 main.cpp -o main_clang && clang++ -O2 main.cpp -o main_gcc
hyperfine './main_clang' './main_gcc'

# Medir con exportación a JSON (para CI/CD)
hyperfine --export-json results.json 'command1' 'command2'

# Exportar a Markdown para README
echo '# Benchmark Results' > bench.md
hyperfine --export-markdown bench.md 'command1' 'command2'

# Benchmark de scripts
echo 'echo test' > test.sh
hyperfine 'bash test.sh' 'zsh test.sh' 'fish -c "echo test"'

# Variable paramétrica (probar con diferentes tamaños)
hyperfine --parameter-list n 100,1000,10000 \
  'sort -n < /dev/urandom | head -n {n}'

# Benchmark con shell diferente
hyperfine -S bash 'echo test'
hyperfine -S zsh 'echo test'
hyperfine -S fish 'echo test'

# Guardar referencia
echo 'command2' > old.txt
hyperfine --reference 'command1' 'command2'

# Timeout
echo 'sleep 0.1' > fast.sh
echo 'sleep 100' > slow.sh
hyperfine --timeout 1 'fast.sh' 'slow.sh'

# Variables de entorno
echo 'echo $MY_VAR' > test.sh
hyperfine -p 'export MY_VAR=hello' 'bash test.sh'
```

## Formato de salida avanzado

```
Benchmark 1: command1
  Time (mean ± σ):     123.4 ms ±   5.6 ms    [User: 120.1 ms, System: 2.1 ms]
  Range (min … max):   115.2 ms … 135.7 ms    (10 runs)

Benchmark 2: command2
  Time (mean ± σ):      45.2 ms ±   2.1 ms    [User: 43.8 ms, System: 1.2 ms]
  Range (min … max):    41.8 ms …  50.1 ms    (10 runs)

Summary
  command2 ran 2.73 ± 0.16 times faster than command1
```

## Exportación de datos

| Formato | Flag | Uso |
|---|---|---|
| JSON | `--export-json` | Post-procesamiento, CI/CD |
| Markdown | `--export-markdown` | Documentación |
| CSV | `--export-csv` | Hojas de cálculo |
| XML | `--export-xml` | Integración con herramientas |
| REPL | `--export-repl` | Interactivo |

## Comparativa con alternatives

| Herramienta | Enfoque |
|---|---|
| **hyperfine** | Estadísticas, warmup, múltiples ejecuciones |
| **time** | Una ejecución, sin estadísticas |
| **perf stat** | Contadores del CPU, muy preciso |
| **bench** | Benchmarks de microoperaciones |
| **Gatling** | Load testing (HTTP, no CLI) |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `hyperfine: command not found` | No instalado | `sudo apt install hyperfine` |
| Outliers muy altos | Proceso interferido | Añadir `-N 3` warmup y más runs |
| Resultados inconsistentes | CPU governor (power save) | `sudo cpupower frequency-set -g performance` |
| No exporta correctamente | Permisos | Verificar path de salida |

## Enlaces externos

- [GitHub — hyperfine](https://github.com/sharkdp/hyperfine)
- [Wikipedia — hyperfine](https://en.wikipedia.org/wiki/Hyperfine_(software))

## Ver también

- [[perf]] — profiling de bajo nivel
- time — timing básico de comandos
- [[strace]] — trazar syscalls
- [[Optimización de rendimiento]] — kernel tuning

#programa #benchmark
