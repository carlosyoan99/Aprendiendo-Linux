---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: alta
---

# df

## Sintaxis

```bash
df [opciones] [directorio/archivo]
```

## Descripción

**df** (disk free) muestra el espacio libre y usado de los sistemas de archivos montados. Esencial para diagnosticar "No space left on device". Viene en `coreutils`.

## Opciones

| Flag | Efecto |
|---|---|
| `-h` | Tamaño legible (GB, MB, KB) |
| `-T` | Mostrar tipo de sistema de archivos |
| `-i` | Mostrar uso de inodos |
| `--total` | Suma de todos los montajes |
| `-x <tipo>` | Excluir un tipo de FS |

## Ejemplos

```bash
df -h                                          # todos los montajes
df -hT                                         # con tipo de FS
df -h / /home /var                             # particiones específicas
df -i /                                        # inodos
df -h --total                                  # total general
df -h -x tmpfs -x devtmpfs                     # solo discos reales
```

## Ver también

- [[du]] — estimar espacio usado por directorios
- [[Disco lleno (No space left on device)]]
- [[free]] — memoria RAM y swap

## Enlaces externos

- [Wikipedia — df](https://en.wikipedia.org/wiki/Df_(Unix))
- [Arch Wiki — df](https://man.archlinux.org/man/df.1)

#comando
