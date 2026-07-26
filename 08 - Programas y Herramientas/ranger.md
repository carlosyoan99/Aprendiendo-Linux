---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# ranger

> Gestor de archivos TUI escrito en Python con vista previa de archivos, tree view y integración con vim. Alternativa ligera a yazi, lf y nnn.

## Sintaxis

```bash
ranger [directorio]                 # abrir en directorio actual
ranger --choosefile=archivo         # seleccionar archivo y salir
ranger --choosedir=directorio       # seleccionar directorio
```

## Descripción

`ranger` es un explorador de archivos en terminal con tres paneles: directorio padre, directorio actual y vista previa. Usa vim como editor por defecto y soporta previsualización de imágenes (w3m), PDFs, videos y más.

## Opciones principales

| Opción | Descripción |
|---|---|
| `ranger` | Abrir en directorio actual |
| `ranger /path` | Abrir en directorio específico |
| `-d` | Modo diff (comparar dos archivos) |
| `--choosefile=f` | Seleccionar archivo y exportar a stdout |
| `--choosedir=d` | Seleccionar directorio y exportar a stdout |

## Atajos de teclado esenciales

| Tecla | Acción |
|---|---|
| `h/l` | Subir/bajar nivel (o ←/→) |
| `j/k` | Mover arriba/abajo |
| `Enter` | Abrir archivo / entrar en directorio |
| `Space` | Seleccionar archivo |
| `v` | Modo selección visual |
| `d` | Mover a papelera (trash) |
| `dd` | Cortar |
| `yp` | Copiar |
| `pp` | Pegar |
| `A` | Crear archivo/directorio |
| `r` | Renombrar |
| `cw` | Rename bulk |
| `:` | Abrir console (ejecutar comando) |
| `/` | Buscar |
| `f` | Filtro (mostrar solo archivos que matcheen) |
| `zh` | Mostrar archivos ocultos |
| `i` | Abrir archivo en vim |
| `S` | Abrir shell en directorio actual |
| `w` | Abrir associations (elegir programa) |
| `~` | Ir a home |
| `Ctrl+f` | Ir a directorio específico |

## Ejemplos

### Abrir y navegar
```bash
ranger                           # directorio actual
ranger ~/Documents               # directorio específico
ranger --choosefile=/tmp/selected  # modo selección
```

### Configurar vista previa de imágenes (w3m)
```bash
# Instalar w3m para previsualización de imágenes
sudo apt install w3m

# ranger detecta w3m automáticamente
# Configurar en ~/.config/ranger/rc.conf:
set preview_images true
set preview_images_method w3m
```

### Integración con vim
```bash
# Abrir ranger desde vim
:Ranger                          # abrir ranger como selector de archivos

# Abrir vim desde ranger
# Presionar 'i' sobre un archivo .txt/.py/.sh
```

## Formato de salida

```
┌──────────────────┬──────────────────┬──────────────────┐
│  ../             │  .bashrc         │  [ contenido de  │
│  .config/        │  .profile        │  .bashrc aqui ]  │
│  Documents/      │  archivo.txt     │                  │
│  Downloads/      │  imagen.png      │                  │
│  Pictures/       │  video.mp4       │                  │
│                  │                  │                  │
└──────────────────┴──────────────────┴──────────────────┘
   Padre         │  Actual          │  Vista previa
```

## Casos de uso

### Gestión rápida de archivos
```bash
# Abrir, mover algunos archivos, salir
ranger
# navegar, space para seleccionar, dd para cortar, pp para pegar
# q para salir
```

### Seleccionar archivo para otro programa
```bash
# Seleccionar archivo para subir a un servidor
FILE=$(ranger --choosefile=/tmp/selected)
scp "$FILE" user@server:/path/
```

## Combinaciones pipe

```bash
# Abrir ranger y ejecutar comando al salir
ranger --cmd "set dotfiles true"

# Seleccionar directorio para cd
cd $(ranger --choosedir=/tmp/dir)
```

## Alternativas modernas

| Herramienta | Ventaja sobre ranger |
|---|---|
| **yazi** | Más rápido (Rust), async, mejor preview |
| **lf** | Más rápido (Go), configuración simple |
| **nnn** | Extremadamente rápido, plugins |
| **broot** | Árbol visual, fuzzy find |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Sin vista previa de imágenes | w3m no instalado | `sudo apt install w3m` y config |
| Lento con muchos archivos | Python overhead | Usar lf o yazi en su lugar |
| No abre archivos | Asociaciones no configuradas | `rifle --detect` o editar rifle.conf |

## Ver también

- [[yazi]] — gestor de archivos TUI en Rust (más rápido)
- [[lf]] — gestor de archivos TUI en Go
- [[Gestores de Archivos]] — gestores gráficos (Nautilus, Dolphin, Thunar)
- [[Emuladores de Terminal]] — terminales para usar ranger

## Enlaces externos

- [Wikipedia — ranger](https://en.wikipedia.org/wiki/Ranger_(file_manager))
- [GitHub — ranger](https://github.com/ranger/ranger)
- [Arch Wiki — ranger](https://wiki.archlinux.org/title/ranger)
- [Ranger User Guide](https://github.com/ranger/ranger/wiki)

#programa #tui #archivos
