---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: comando
prioridad: media
---

# ncdu

> Analizador de uso de disco con interfaz TUI interactivo. Navega por directorios, ordena por tamaño y elimina archivos directamente desde la terminal.

## Sintaxis

```bash
ncdu [opciones] [directorio]
```

## Descripción

**ncdu** (NCurses Disk Usage) es una alternativa interactiva a `du` y `baobab`. Escanea un directorio y muestra una vista de árbol ordenada por tamaño, permitiendo navegar, buscar y eliminar archivos sin salir de la terminal.

## Instalación

```bash
sudo apt install ncdu                # Debian / Ubuntu
sudo pacman -S ncdu                  # Arch / CachyOS
sudo dnf install ncdu                # Fedora
```

## Ejemplos prácticos

```bash
ncdu                                    # escanear directorio actual
ncdu /home                              # escanear /home
ncdu /var                               # explorar uso en /var
ncdu -x /                               # escanear sin cruzar dispositivos
ncdu -e /home/user                      # habilitar show hidden files
ncdu -o scan.json /home                 # exportar escaneo a JSON
ncdu -f scan.json                       # cargar escaneo previo (sin re-escanear)
```

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `↑/↓` | Navegar entre archivos/directorios |
| `Enter` | Entrar en un directorio |
| `d` | Eliminar archivo/directorio |
| `g` | Mostrar gráfico de barras |
| `n` | Ordenar por nombre |
| `s` | Ordenar por tamaño |
| `c` | Ordenar por items |
| `e` | Mostrar archivos ocultos |
| `i` | Mostrar información detallada |
| `r` | Re-escanear directorio |
| `q` | Salir |
| `?` | Ayuda |

## Uso avanzado

```bash
# Escanear sin cruzar mount points (útil en /)
ncdu -x /

# Exportar escaneo para análisis posterior
ncdu -o /tmp/scan-$(date +%F).json /home

# Cargar un escaneo previo
ncdu -f /tmp/scan-2026-09-02.json

# Escanear sistema completo sin cruzar dispositivos
sudo ncdu -x / --exclude /proc --exclude /sys
```

## ncdu vs du vs baobab

| Aspecto | ncdu | du + sort | baobab |
|---|---|---|---|
| Interfaz | TUI interactivo | CLI | GUI |
| Navegación | Sí (interactiva) | No | Sí (ratón) |
| Eliminar archivos | Sí (desde TUI) | No | No |
| Exportar JSON | Sí | No | No |
| Ideal | Diagnóstico rápido | Scripts | Escritorio |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Escaneo muy lento | Directorio enorme con millones de archivos | Usar `ncdu -x /` y excluir `/proc` `/sys` |
| "Permission denied" en algunos archivos | Falta sudo | Ejecutar con `sudo ncdu` |
| No muestra archivos ocultos | Por defecto los oculta | Pulsar `e` o usar `ncdu -e` |
| Salida JSON corrupta | Interrupción durante escaneo | Re-escanear con `-o` |

## Ver también

- [[du]] — uso de disco (CLI)
- [[df y du]] — índice comparativo
- [[lsblk]] — listar dispositivos de bloque
- [[gparted]] — editor de particiones gráfico

## Enlaces externos

- [ncdu — sitio oficial](https://dev.yorhel.nl/ncdu)
- [Arch Wiki — ncdu](https://wiki.archlinux.org/title/Ncdu)

#comando #disco #tui
