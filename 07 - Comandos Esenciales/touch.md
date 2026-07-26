---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: media
---

# touch

## Sintaxis

```bash
touch [opciones] archivo...
```

## Descripción

`touch` actualiza las marcas de tiempo (atime, mtime) de un archivo a la hora actual. Si el archivo no existe, **lo crea vacío**. Esencial para scripts que necesitan crear archivos vacíos o forzar recompilaciones (make usa timestamps).

## Opciones

| Flag | Efecto |
|---|---|
| `-a` | Cambiar solo atime |
| `-m` | Cambiar solo mtime |
| `-c` | No crear si no existe |
| `-t timestamp` | Timestamp específico (YYYYMMDDhhmm.ss) |
| `-d "fecha"` | Fecha en formato texto |
| `-r archivo` | Usar timestamp de otro archivo |

## Ejemplos

```bash
touch nota.txt                              # crear archivo vacío
touch archivo-{1..5}.txt                    # crear múltiples
touch -c solo-si-existe.txt                 # no crear si no existe
touch -t 202612251200 año-nuevo.txt          # timestamp específico
touch -d "2 weeks ago" viejo.txt            # fecha relativa
touch -r modelo.txt nuevo.txt               # copiar timestamp de otro
```

## Ver también

- [[cat]] — ver contenido de archivos
- [[history]] — historial de comandos

## Enlaces externos

- [Wikipedia — touch (Unix)](https://en.wikipedia.org/wiki/Touch_(Unix))
- [GNU Coreutils — touch](https://www.gnu.org/software/coreutils/manual/html_node/touch-invocation.html)

#comando
