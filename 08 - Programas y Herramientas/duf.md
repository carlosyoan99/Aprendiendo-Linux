---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# duf

> df moderno con colores, barras de progreso y mejor formato. Alternativa visual al clásico [[df y du]].

## Sintaxis

```bash
duf [opciones] [dispositivo...]
```

## Opciones

| Opción | Descripción |
|---|---|
| `--only <tipo>` | Filtrar por tipo (local, network, fuse, etc.) |
| `--sort <campo>` | Ordenar por: size, used, avail, inodes |
| `--theme <tema>` | Tema de colores (dark, light, bw) |
| `--json` | Salida JSON |
| `--width <n>` | Ancho máximo de columnas |

## Ejemplos

```bash
duf                                      # mostrar todos los filesystems
duf /                                     # solo raíz
duf --only local                          # solo locales (sin red)
duf --sort size                           # ordenar por tamaño
duf --theme dark                          # tema oscuro
duf --json | jq                           # procesar con jq
```

## Formato de salida

```
  Device       Mount          Size   Used  Avail  Use% bar
  /dev/nvme0n1 /           476.9G  123.4G 338.5G  27% ████░░░░░░░░░░░░░░░░
  /dev/sda1    /boot        512.0M  128.0M 368.0M  25% ███░░░░░░░░░░░░░░░░░
  tmpfs        /tmp           8.0G    0.0G   8.0G   0% ░░░░░░░░░░░░░░░░░░░░
  /dev/nvme0n2 /mnt/data    931.5G  456.2G 447.3G  49% █████░░░░░░░░░░░░░░░
```

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install duf` |
| Arch | `sudo pacman -S duf` |
| Fedora | `sudo dnf install duf` |
| Alpine | `sudo apk add duf` |
| macOS | `brew install duf` |

```bash
# Verificar
duf --version

# Alternativa: instalar desde GitHub releases
curl -sL https://github.com/muesli/duf/releases/latest/download/duf_linux_amd64.deb -o duf.deb
sudo dpkg -i duf.deb
```

## Filtrado avanzado

```bash
# Solo filesystems locales
duf --only local

# Solo red
duf --only network

# Solo FUSE (sshfs, rclone, etc.)
duf --only fuse

# Excluir tipos
duf --only local,local-noroot

# Ordenar por diferentes campos
duf --sort size    # por tamaño total
duf --sort used   # por usado
duf --sort avail  # por disponible
duf --sort inode  # por inodos

# Salida JSON para procesamiento
duf --json | jq '.[] | select(.percent > 80)'

# Ancho de columnas
duf --width 120
```

## Configuración

```bash
# ~/.config/duf.json (temas personalizados)
{
  "theme": "dark",
  "sort": "mountpoint",
  "style": "256"
}
```

## Comparativa con df clásico

| Característica | duf | df |
|---|---|---|
| Formato | Tabla con barras | Tabla texto plano |
| Colores | ✅ Temas integrados | ❌ Necesita awk/sed |
| Filtrado | `--only local,network` | `-t ext4`, etc. |
| JSON | `--json` | ❌ |
| Velocidad | Muy rápido (Go) | Rápido (C) |
| Bind mount | ❌ No siempre | ✅ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `duf: command not found` | No instalado | `sudo apt install duf` |
| No muestra bind mounts | Limitación | Usar `df -h` para bind mounts |
| Colores rotos en SSH | Terminal sin 256 colores | `duf --theme bw` |
| No muestra tmpfs | Filtrado por defecto | `duf --only local,local-noroot` |

## Enlaces externos

- [GitHub — duf](https://github.com/muesli/duf)
- [Arch Wiki — duf](https://wiki.archlinux.org/title/Duf)

## Ver también

- [[df y du]] — comandos clásicos de espacio en disco
- ncdu — explorador interactivo de uso de disco
- [[lsblk]] — listar dispositivos de bloque

#programa #tui #disco
