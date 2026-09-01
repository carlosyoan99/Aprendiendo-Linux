---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: alta
---

# du

> Estima el espacio en disco usado por archivos y directorios. Herramienta esencial para diagnosticar discos llenos y entender qué consume espacio.

## Sintaxis

```bash
du [opciones] [directorio/archivo...]
```

## Descripción

**du** (disk usage) calcula el espacio en disco usado por cada archivo o directorio. Recorre el árbol de directorios sumando tamaños. Viene en `coreutils` — disponible en toda distro sin instalación. Es la contraparte de [[df]]: `df` muestra espacio libre por partición, `du` muestra espacio usado por contenido.

## Opciones principales

| Flag | Efecto |
|---|---|
| `-h` | Tamaño legible (K, M, G) |
| `-s` | Solo el total del directorio (summary) |
| `-c` | Mostrar total al final |
| `-d <N>` | Profundidad máxima |
| `--exclude=<patrón>` | Excluir archivos/directorios |
| `-t <tamaño>` | Mostrar solo si superan un tamaño |
| `-a` | Mostrar también archivos (no solo directorios) |
| `--apparent-size` | Tamaño real en disco (no bloques asignados) |
| `--time` | Mostrar última fecha de modificación |
| `--max-depth=1` | Alias de `-d 1` |

## Ejemplos

```bash
# Tamaño total del directorio home
du -sh ~

# Un nivel de profundidad en /var
du -hd 1 /var

# Los 10 directorios más pesados desde /
sudo du -sh /* 2>/dev/null | sort -rh | head -10

# Home excluyendo caché
du -sh --exclude=.cache ~

# Archivos más pesados en el directorio actual
du -ah . 2>/dev/null | sort -rh | head -20

# Tamaño por extensión
du -sh */ 2>/dev/null | sort -rh

# Directorios que pesan más de 100 MB
du -sh --threshold=100M /home/*

# Con fecha de modificación
du -sh --time /var/log/* | sort -rh | head -10

# Tamaño aparente vs asignado (útil en Btrfs/ZFS con deduplicación)
du -sh --apparent-size archivo
du -sh archivo
```

## Casos de uso

### Diagnóstico de disco lleno

```bash
# 1. Ver qué partición está llena
df -h

# 2. Buscar los directorios más pesados
sudo du -sh /particion/* | sort -rh | head -10

# 3. Profundizar en el directorio sospechoso
sudo du -sh /particion/sospechoso/* | sort -rh | head -10

# 4. Encontrar archivos grandes
sudo find /particion -type f -size +100M -exec ls -lh {} \;

# 5. Verificar caché de paquetes
sudo du -sh /var/cache/apt/   # Debian/Ubuntu
sudo du -sh /var/cache/pacman/pkg/  # Arch
```

### Tamaño por tipo de archivo

```bash
# Usar find + du para archivos por extensión
find . -name "*.log" -exec du -ch {} + | tail -1
find . -name "*.mp4" -exec du -ch {} + | tail -1

# Usar ncdu para exploración interactiva (alternativa visual)
ncdu /
```

## Comparativa con alternativas

| Herramienta | Enfoque | Interfaz |
|---|---|---|
| **du** | Tamaño por directorio | CLI texto |
| **ncdu** | Exploración interactiva | TUI (navegación con flechas) |
| **duf** | df moderno con colores | CLI (muestra particiones, no contenido) |
| **baobab** | Análisis visual de disco | GUI gráfica (GNOME) |
| **filelight** | Mapa de anidación | GUI (KDE) |

> **Regla práctica**: usa `du -sh *` para un vistazo rápido, `ncdu /` para explorar interactivamente, y `baobab` si necesitas una visualización gráfica.

## Ver también

- [[df]] — espacio libre en particiones
- [[lsblk]] — estructura de discos y particiones
- [[Disco lleno (No space left on device)]] — troubleshooting completo
- [[Sistemas de Archivos]] — ext4, Btrfs, XFS
- `ncdu` — alternativa interactiva y visual (no hay nota dedicada)

## Enlaces externos

- [Wikipedia — du](https://en.wikipedia.org/wiki/Du_(Unix))
- [Man page — du](https://man7.org/linux/man-pages/man1/du.1.html)
- [Arch Wiki — du](https://man.archlinux.org/man/du.1)

#comando #disco
