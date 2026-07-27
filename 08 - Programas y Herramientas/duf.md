---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
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

## Ver también

- [[df y du]] — comandos clásicos de espacio en disco
- ncdu — explorador interactivo de uso de disco
- [[lsblk]] — listar dispositivos de bloque

## Enlaces externos

- [GitHub — duf](https://github.com/muesli/duf)
- [Arch Wiki — duf](https://wiki.archlinux.org/title/Duf)

#programa #tui #disco
