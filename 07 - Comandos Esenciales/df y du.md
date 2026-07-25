---
fecha_creacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: alta
---

# df y du

## Sintaxis

```bash
df [opciones] [directorio/archivo]
du [opciones] [directorio/archivo...]
```

## Descripción

- **`df`** (disk free) — muestra el espacio libre y usado de los sistemas de archivos montados. Esencial para diagnosticar "No space left on device".
- **`du`** (disk usage) — estima el espacio en disco usado por archivos y directorios. Sirve para encontrar qué está ocupando espacio.

> Ambos comandos vienen en el paquete `coreutils` — disponibles en toda distro sin instalación adicional.

## Opciones frecuentes de `df`

| Flag | Efecto |
|---|---|
| `-h` | Tamaño legible (GB, MB, KB) |
| `-T` | Mostrar tipo de sistema de archivos (ext4, btrfs, tmpfs, etc.) |
| `-i` | Mostrar uso de **inodos** (no espacio) |
| `--total` | Suma de todos los montajes |
| `-x <tipo>` | Excluir un tipo de sistema de archivos (ej. `-x tmpfs`) |
| `-a` | Incluir sistemas de archivos con 0 bloques (como `/proc`, `/sys`) |

## Opciones frecuentes de `du`

| Flag | Efecto |
|---|---|
| `-h` | Tamaño legible |
| `-s` | Solo total del directorio (sin listar subdirectorios) |
| `-c` | Mostrar total al final |
| `-d <N>` | Profundidad máxima (ej. `-d 1` solo un nivel) |
| `--exclude=<patrón>` | Excluir archivos/directorios |
| `-t <tamaño>` | Mostrar archivos solo si superan un tamaño |
| `-a` | Incluir archivos individuales (no solo directorios) |
| `--max-depth=<N>` | Equivalente a `-d` |

## Ejemplos

```bash
# df — espacio en disco
df -h                                          # todos los montajes, formato legible
df -hT                                         # con tipo de sistema de archivos
df -h / /home /var                             # particiones específicas
df -i /                                        # inodos (útiles cuando hay espacio pero "no space left")
df -h --total                                  # total general de todos los montajes

# du — espacio usado por directorios
du -sh ~                                       # total del home en formato legible
du -hd 1 /var                                  # un nivel de profundidad en /var
du -sh /* 2>/dev/null | sort -rh | head -10    # los 10 directorios más pesados en la raíz
du -sh /var/log /var/cache /var/lib            # pesos específicos
du -sh --exclude=.cache ~                      # home excluyendo caché
du -sh ~/Descargas/* | sort -rh | head -5      # archivos más pesados en Descargas
```

## Casos de uso reales

### Diagnóstico de disco lleno

```bash
# 1. Ver qué partición está llena
df -h

# 2. Encontrar las carpetas más pesadas en esa partición
sudo du -sh /ruta/particion/* | sort -rh | head -15

# 3. Buscar archivos grandes en todo el sistema
sudo find / -type f -size +500M -exec ls -lh {} \; 2>/dev/null | sort -k5 -rh

# 4. Ver si el problema son inodos (muchos archivos pequeños)
df -i /
```

### Monitoreo rápido de varios servidores

```bash
# En combinación con ssh
for host in server1 server2 server3; do
  echo "=== $host ==="
  ssh "$host" "df -h /"
done
```

### Resumen de uso por directorio

```bash
# Espacio usado por cada directorio en el home, ordenado
du -hd 1 ~ 2>/dev/null | sort -rh
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `df` muestra 0 en `/` para algunas particiones | Usuario sin permisos | Usar `sudo df -h` |
| `du` tarda mucho en `/` o `/home` | Escanea todos los subdirectorios | Especificar profundidad con `-d 2` o excluir carpetas grandes con `--exclude` |
| `No space left on device` pero `df` muestra espacio libre | Inodos agotados | Verificar con `df -i /` |
| `du` y `df` no coinciden | Archivos borrados pero aún abiertos por procesos | `sudo lsof \| grep deleted` para encontrar procesos que retienen archivos |

## Notas y advertencias

- `du` sin `-s` o `-d` puede generar MUCHA salida (escanea recursivamente todo) — siempre limitar con `-d 1` o `-s` al explorar directorios grandes.
- `df -h` sin argumentos muestra **todos** los sistemas de archivos, incluyendo `tmpfs`, `devtmpfs`, `overlay` (Docker). Para ver solo discos reales, usar `df -h -x tmpfs -x devtmpfs`.
- La combinación `du -sh /* | sort -rh` es el atajo más usado para encontrar qué ocupa espacio rápidamente.
- `ncdu` (instalable vía apt/pacman) es una alternativa interactiva y visual a `du` — mucho más rápida para explorar.
- Si `du` y `df` no coinciden, puede haber archivos borrados pero retenidos por procesos activos — `sudo lsof +L1` los identifica (archivos con link count = 0).

## Enlaces externos

- [Wikipedia — df](https://en.wikipedia.org/wiki/Df_(Unix))
- [Wikipedia — du](https://en.wikipedia.org/wiki/Du_(Unix))
- [Arch Wiki — df](https://man.archlinux.org/man/df.1)
- [Arch Wiki — du](https://man.archlinux.org/man/du.1)

## Ver también

- [[Disco lleno (No space left on device)]] — troubleshooting completo
- [[free]] — memoria RAM y swap
- [[top]] — monitorización en tiempo real
- [[Sistemas de Archivos]] — tipos de sistemas de archivos
- [[Cheat Sheet - Comandos Esenciales]]

#comando
