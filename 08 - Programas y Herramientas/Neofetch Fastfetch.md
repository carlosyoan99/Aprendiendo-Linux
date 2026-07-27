---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: alta
---

# Neofetch / Fastfetch

## Qué son

**Neofetch** y **Fastfetch** son herramientas de línea de comandos que muestran información del sistema (distro, kernel, uptime, paquetes instalados, resolución, etc.) de forma visual y estilizada, acompañada del logo ASCII de la distribución.

- **Neofetch** — clásico, escrito en Bash. **Proyecto archivado** (desde abril 2024, su creador lo dio por finalizado).
- **Fastfetch** — sucesor moderno, escrito en **C**. Mucho más rápido, más configurable, más mantenido.

```bash
$ fastfetch

           ██████████████  carlos@fedora
         ████████████████  ------------
        █████████████████  OS: Fedora Linux 41 (Workstation Edition)
       ██████████████████  Host: ThinkPad T14s Gen 4
       ██████████████████  Kernel: 6.12.5-200.fc41.x86_64
       ██████████████████  Uptime: 3 hours, 12 mins
       ██████████████████  Packages: 2345 (rpm)
       ██████████████████  Shell: zsh 5.9
      ██████████████████   Resolution: 1920x1200
      ██████████████████   DE: GNOME 47
     ██████████████████    WM: Mutter
    ██████████████████     WM Theme: Adwaita
    █████████████████      Theme: Adwaita [GTK2/3]
   ████████████████        Icons: Adwaita [GTK2/3]
   ██████████████          Terminal: kgx
                            CPU: Intel i7-1355U (12) @ 5.00GHz
                            GPU: Intel Iris Xe Graphics
                            Memory: 4827MiB / 15837MiB
```

### Diferencia clave: Neofetch está muerto

| Aspecto | Neofetch | Fastfetch |
|---|---|---|
| **Lenguaje** | Bash (lento) | **C** (rápido) |
| **Estado** | Archivado (abril 2024) | **Activo** |
| **Última versión** | 7.1.0 (2021) | 2.30+ (2026) |
| **Velocidad** | ~0.5-1.5s | **~1-10ms** |
| **Configuración** | ~/.config/neofetch/config.conf | TOML/Lua/JSON |
| **Logos** | Limitados | Más logos, soporte de imágenes reales |
| **JSON output** | No | **Sí** (`--json`) |
| **Detección HW** | Limitada | Más precisa (memoria, GPU) |

## Instalación

```bash
# === Neofetch (archivado, no recomendado para nuevo uso) ===
sudo apt install neofetch              # Debian/Ubuntu
sudo pacman -S neofetch                # Arch
sudo dnf install neofetch              # Fedora

# === Fastfetch (recomendado) ===
# Debian/Ubuntu (desde repositorios recientes)
sudo apt install fastfetch

# Arch
sudo pacman -S fastfetch

# Fedora
sudo dnf install fastfetch

# Compilar desde fuente (última versión siempre)
git clone https://github.com/fastfetch-cli/fastfetch
cd fastfetch
mkdir build && cd build
cmake ..
make
sudo make install
```

## Uso básico

```bash
# === Neofetch ===
neofetch                    # mostrar información del sistema
neofetch --off              # modo sin color (texto plano)
neofetch --help             # ayuda completa

# === Fastfetch ===
fastfetch                   # mostrar información del sistema
fastfetch --json            # salida en JSON (para scripting)
fastfetch -l small          # logo pequeño
fastfetch -c arch           # logo de Arch Linux (forzar)
fastfetch --list-logos      # listar logos disponibles
fastfetch -s os kernel host uptime  # módulos específicos
fastfetch --help            # ayuda completa
```

## Módulos de información

Fastfetch organiza la información en **módulos** que se pueden activar/desactivar individualmente:

```bash
fastfetch -s os kernel host uptime cpu gpu memory disk display
fastfetch -s os separator kernel                     # con separador
fastfetch --structure os:separator:kernel:separator   # formato alternativo
```

| Módulo | Muestra |
|---|---|
| `os` | Sistema operativo y versión |
| `host` | Marca y modelo del equipo |
| `kernel` | Versión del kernel |
| `uptime` | Tiempo encendido |
| `packages` | Número de paquetes instalados |
| `shell` | Shell y versión |
| `resolution` | Resolución de pantalla |
| `de` | Entorno de escritorio |
| `wm` | Gestor de ventanas |
| `wmtheme` | Tema del WM |
| `theme` | Tema GTK |
| `icons` | Tema de iconos |
| `font` | Fuente del sistema |
| `terminal` | Emulador de terminal |
| `cpu` | CPU y uso |
| `gpu` | GPU (integrada y dedicada) |
| `memory` | RAM usada / total |
| `disk` | Uso de disco |
| `battery` | Estado de la batería |
| `localip` | IP local |
| `bluetooth` | Dispositivos Bluetooth |
| `wifi` | Red WiFi actual |

## Configuración

### Fastfetch: `~/.config/fastfetch/config.jsonc`

```jsonc
// ~/.config/fastfetch/config.jsonc
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "small"
    // o "type": "kitty" para imágenes reales en terminales compatibles
  },
  "display": {
    "separator": " → ",
    "color": "cyan"
  },
  "modules": [
    "os",
    "host",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "de",
    "wm",
    "terminal",
    "cpu",
    "gpu",
    "memory",
    {
      "key": "  Disco",
      "type": "disk"
    },
    {
      "key": "  Batería",
      "type": "battery"
    }
  ]
}
```

### Neofetch: `~/.config/neofetch/config.conf`

```bash
# ~/.config/neofetch/config.conf
# (formato shell, se genera con neofetch --print_config)
print_info() {
    info title
    info underline
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "DE" de
    info "WM" wm
    info "Terminal" term
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory
}

# Color del logo
image_backend="ascii"
ascii_distro="auto"
```

## Fastfetch con imágenes reales

Fastfetch soporta mostrar imágenes (logos de distro, fotos) en terminales compatibles con kitty protocol o sixel:

```bash
# Mostrar imagen real como logo
fastfetch --logo /ruta/a/imagen.png

# En terminales compatibles (Kitty, WezTerm, Ghostty, Konsole)
fastfetch --logo kitty

# Escalar la imagen
fastfetch --logo-width 20

# Configuración permanente en config.jsonc
# "logo": { "type": "kitty" }
```

## Uso en scripts

```bash
# Fastfetch como sysinfo para scripts
system_info=$(fastfetch --json)
echo "$system_info" | jq '.os'
echo "$system_info" | jq '.kernel'

# Extraer solo ciertos campos
fastfetch --json | jq '.os.name'        # nombre del SO
fastfetch --json | jq '.memory.used'    # RAM usada en bytes
fastfetch --json | jq '.cpu.name'       # modelo de CPU
```

## Alternativas

| Herramienta | Lenguaje | Estado | Característica |
|---|---|---|---|
| **Fastfetch** | C | ✅ Activo | Rápido, moderno, configurable |
| **Neofetch** | Bash | ❌ Archivado | Clásico, no seguir usando |
| **Screenfetch** | Bash | ⚠️ Mantenimiento | Antiguo, predecesor de neofetch |
| **CPU-X** | C | ⚠️ Mantenimiento | Enfocado en CPU |
| **inxi** | Perl | ✅ Activo | Completo, detallado, sin logo |
| **archey4** | Python | ⚠️ Semiactivo | Fork de Archey, popular en Arch |
| **pfetch** | Bash | ✅ Activo | Minimalista, rápido |
| **macchina** | Rust | ✅ Activo | Moderno, vistoso |

```bash
# inxi — sin logo ASCII pero con más información técnica
inxi -F                       # información completa
inxi -Sxxx                    # solo sistema (detallado)
inxi -G                       # solo GPU
inxi -M                       # solo motherboard

# pfetch — ultra minimalista
pfetch                        # solo lo esencial, sin dependencias
```

## Notas y advertencias

- **Neofetch está archivado** (abril 2024). No recibirá más actualizaciones. Migra a Fastfetch.
- Fastfetch se ejecuta en **milisegundos** frente a los segundos de Neofetch — la diferencia es notable.
- Fastfetch soporta JSON output, ideal para scripting y panels (polybar, waybar).
- Para mostrar imágenes reales, necesitas una terminal que soporte kitty protocol o sixel.
- Fastfetch detecta correctamente GPUs discretas e integradas (algo que Neofetch a menudo fallaba).

## Enlaces externos

- [Fastfetch GitHub](https://github.com/fastfetch-cli/fastfetch) — repositorio oficial
- [Neofetch GitHub](https://github.com/dylanaraps/neofetch) — archivado
- [Screenfetch GitHub](https://github.com/KittyKatt/screenFetch)
- [inxi GitHub](https://github.com/smxi/inxi) — alternativa sin logo

## Ver también

- [[Personalización en Linux]] — cómo personalizar la salida
- [[htop btop]] — monitores de sistema similares
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — información HW detallada
- [[Monitorización (Prometheus node_exporter)]] — monitorización de servidores
- [[Shells (bash zsh fish)]] — shells donde se ejecutan estos comandos

#programa
