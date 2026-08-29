---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: BSD-2-Clause
alternativas: [[ranger]], [[yazi]], [[lf]]
---

# nnn

> Gestor de archivos de terminal (TUI) extremadamente ligero, escrito en **C**: ideal para WMs minimalistas y sistemas con pocos recursos.

## Qué es

**nnn** es un gestor de archivos y buscador para terminal, escrito en **C** con licencia BSD-2, diseñado desde cero para ser **ultrarrápido y ultraligero**. En lugar de depender del escritorio o de un entorno gráfico, funciona en cualquier emulador de terminal y encaja perfectamente en WMs tiling como [[i3]], [[DWM]], [[Hyprland]] o [[Niri]], así como en servidores sin interfaz gráfica. Está orientado a **usuarios avanzados** que prefieren operar el sistema con el teclado y que valoran el consumo mínimo de recursos y el arranque instantáneo. Incluye búsqueda, vista detallada de tamaños, gestor de plugins y scripts de automatización.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install nnn

# Arch
sudo pacman -S nnn

# Fedora
sudo dnf install nnn

# Compilar desde fuente (última versión)
git clone https://github.com/jarun/nnn
cd nnn && make
```

## Configuración básica

La configuración se guarda en `~/.config/nnn/`. Primeros pasos:

```bash
# Definir el editor por defecto para abrir archivos
export EDITOR=nvim

# Habilitar la barra de información superior
export NNN_OPTS="H"

# Establecer plugins y visualizador (bat)
export NNN_PLUG='p:preview-tui;v:imgview'
export NNN_FIFO=/tmp/nnn.fifo
```

Se ejecuta sencillamente con `nnn` y se navega con el teclado; la primera ejecución ofrece un asistente de integración del shell.

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `↑↓` / `j k` | Navegar |
| `/` | Buscar archivo (fzf si está instalado) |
| `!` | Abrir shell en el directorio actual |
| `.` | Toggle archivos ocultos |
| `d` | Detalle de tamaño de directorio |
| `Enter` | Abrir archivo/carpeta |
| `Ctrl+R` | Mostrar reverse-time listado |
| `q` | Salir |

## Uso avanzado

```bash
# Lanzar plugins instalados (vista previa de imágenes, etc.)
nnn -p

# Arrancar con vista detallada de tamaño de directorios
nnn -d

# Usar fzf para la búsqueda integrada
nnn -f

# Abrir el gestor en una ruta concreta
nnn /ruta/al/directorio
```

Los plugins viven en `~/.config/nnn/plugins/` y se gestionan con `nnn -P plugin` o con el script `installer`.

## Comparativa con alternativas

| Aspecto | nnn | ranger | yazi | lf |
|---|---|---|---|---|
| **Rendimiento** | Muy alto | Medio | Alto | Alto |
| **Facilidad** | Media | Media | Media | Alta |
| **Características** | Extensas | Previews | Modernas | Básicas |
| **Licencia** | BSD-2 | MIT | MIT | MIT |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| La búsqueda no encuentra | Falta `fzf` integrado | Instalar fzf y reiniciar nnn |
| Los plugins no funcionan | Ruta o permisos | Verificar `~/.config/nnn/plugins/` y permisos +x |
| Gesto de colores raro | Variable `LS_COLORS` | Exportar `LS_COLORS` adecuado en el shell |

## Notas y advertencias

- Es **extremadamente ligero** y arranca al instante; ideal para servidores o sistemas embebidos.
- Se usa por completo con el teclado, sin necesidad de ratón ni escritorio.
- Requiere cierta curva de aprendizaje frente a gestores gráficos, pero gana en productividad para tareas repetitivas.
- Depende de herramientas externas (fzf, bat, etc.) para funciones avanzadas como búsqueda o preview.

## Enlaces externos

- [GitHub — nnn](https://github.com/jarun/nnn)
- [Wiki de nnn](https://github.com/jarun/nnn/wiki)
- [Arch Wiki — nnn](https://wiki.archlinux.org/title/Nnn)

## Ver también

- [[ranger]] — navegador tipo vim con preview
- [[yazi]] — gestor TUI moderno en Rust
- [[lf]] — gestor TUI rápido en Go
- [[Gestores de Archivos]] — índice + comparativa
- [[La Shell]] — fundamento para su uso en terminal

#programa #archivos
