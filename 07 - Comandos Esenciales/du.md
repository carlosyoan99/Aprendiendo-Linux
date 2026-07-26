---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: alta
---

# du

## Sintaxis

```bash
du [opciones] [directorio/archivo...]
```

## Descripción

**du** (disk usage) estima el espacio en disco usado por archivos y directorios. Sirve para encontrar qué está ocupando espacio. Viene en `coreutils`.

## Opciones

| Flag | Efecto |
|---|---|
| `-h` | Tamaño legible |
| `-s` | Solo total del directorio |
| `-c` | Mostrar total al final |
| `-d <N>` | Profundidad máxima |
| `--exclude=<patrón>` | Excluir archivos/directorios |
| `-t <tamaño>` | Mostrar solo si superan un tamaño |

## Ejemplos

```bash
du -sh ~                                       # total del home
du -hd 1 /var                                  # un nivel de profundidad
du -sh /* 2>/dev/null | sort -rh | head -10    # directorios más pesados
du -sh --exclude=.cache ~                      # home excluyendo caché
```

## Casos de uso

```bash
# Espacio usado por cada directorio en home
du -hd 1 ~ 2>/dev/null | sort -rh

# Diagnóstico de disco lleno
sudo du -sh /ruta/particion/* | sort -rh | head -15
```

## Alternativas

- `ncdu` — alternativa interactiva y visual a du
- `duf` — df moderno con colores

## Ver también

- [[df]] — espacio libre en particiones
- [[Disco lleno (No space left on device)]]
- [[Sistemas de Archivos]]

## Enlaces externos

- [Wikipedia — du](https://en.wikipedia.org/wiki/Du_(Unix))
- [Arch Wiki — du](https://man.archlinux.org/man/du.1)

#comando
