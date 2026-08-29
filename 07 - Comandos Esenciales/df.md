---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: alta
---

# df

> **disk free** — espacio libre y usado de los sistemas de archivos montados.

## Sintaxis

```bash
df [opciones] [archivo|directorio]
```

## Descripción

`df` muestra el espacio total, usado y disponible de cada sistema de archivos montado. Al pasarle un archivo o directorio como argumento, muestra los datos del sistema de archivos que lo contiene. Forma parte de `coreutils`. No requiere sudo (solo lectura) y no es destructivo. Es el primer comando a lanzar ante un disco lleno, siempre junto a [[du]] para saber qué lo llena.

## Formato de salida

Sin opciones muestra bloques de 1 KiB; con `-h` pasa a unidades legibles.

| Columna | Significado |
|---|---|
| `Filesystem` | Dispositivo o ubicación del FS montado |
| `Size` | Tamaño total (con `-h`) |
| `Used` | Espacio usado |
| `Avail` | Espacio disponible para el usuario |
| `Use%` | Porcentaje de ocupación |
| `Mounted on` | Punto de montaje |

## Opciones frecuentes

| Flag / Opción | Efecto | Ejemplo |
|---|---|---|
| `-h` | Tamaño legible (K, M, G) | `df -h` |
| `-T` | Añade el tipo de FS | `df -hT` |
| `-i` | Muestra inodos en vez de bloques | `df -i /` |
| `-x tipo` | Excluye un tipo de FS | `df -x tmpfs` |
| `--total` | Añade fila con la suma de todo | `df -h --total` |
| `-a` | Incluye FS con 0 bloques | `df -ha` |
| `-t tipo` | Solo FS del tipo indicado | `df -t ext4` |

## Ejemplos de uso

```bash
df -h                                       # todos los montajes, unidades legibles
df -hT /                                    # tipo de FS y uso de la raíz
df -h /home /var /tmp                       # sistemas concretos
df -i /                                     # inodos: llenarse aquí también bloquea escrituras
df -h -x tmpfs -x devtmpfs -x overlay      # solo discos reales
df -h --total                              # gran total
```

## Casos de uso reales

- El sistema avisa `No space left on device`: `df -h` para localizar qué montaje está al 100 %.
- `touch: cannot touch 'x': No space left on device` con `df -h` al 40 % suele ser inodos: comprobar con `df -i`.
- Listar los montajes que más presión tienen: `df -h | sort -k5 -rn | head`.
- Antes de copiar un ISO o hacer un backup, comprobar el destino con `df -h /destino`.

## Combinaciones comunes con pipe

```bash
df -h | sort -k5 -rn                       # ordenar por porcentaje de uso
df -hT | awk '{gsub("%","",$5); if ($5 > 80) print $NF, $5"%"}'  # montajes > 80%
df -hT | grep -vE 'tmpfs|devtmpfs|overlay' # quitar pseudo-filesystems
df -h | column -t                          # alinear columnas
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `df -h` | `duf` | Tablas coloreadas, separa discos reales de pseudo-FS |
| `df -i` | `duf --inodes` | Mismo dato con mejor presentación |
| `df -hT` | `duf -only local` | Filtros por tipo de dispositivo |
| — | `lsblk` | Vista árbol dispositivo a punto de montaje |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `df -h` al 100 % pero no encuentras qué ocupa | Archivos borrados pero abiertos por un proceso | `lsof +L1` o reiniciar el proceso |
| `No space left` con disco al 40 % | Falta de inodos | `df -i /` y eliminar archivos pequeños |
| Cifras en bloques de 1K ilegibles | `df` sin `-h` | Usar `df -h` o `df -hT` |
| Muchos montajes irrelevantes en la salida | tmpfs, devtmpfs, overlay | Filtrar con `-x` o `grep -vE` |

## Notas y advertencias

- `df` es de solo lectura: no requiere privilegios y no altera nada.
- Parte del espacio aparece como "no disponible" por el bloque reservado a root (~5 % en ext4), por eso `Used + Avail` no suma `Size`.
- Espacio en bloques e inodos son dos problemas distintos: revisar ambos con `df -h` e `df -i`.
- `df` dice cuánto hay en un FS; `du` dice qué lo llena — son complementarios, no opcionales.

## Enlaces externos

- [Wikipedia — df (Unix)](https://en.wikipedia.org/wiki/Df_(Unix))
- [GNU Coreutils — df invocation](https://www.gnu.org/software/coreutils/manual/html_node/df-invocation.html)
- [man df(1)](https://man7.org/linux/man-pages/man1/df.1.html)

## Ver también

- [[df y du]] — comparativa y diagnóstico combinado
- [[du]] — espacio usado por directorio
- [[Disco lleno (No space left on device)]] — troubleshooting del error clásico
- [[Sistemas de Archivos]] — contexto de los montajes
- [[free]] — memoria RAM y swap
- [[duf]] — alternativa moderna con mejor formato
- [[mount]] — montar y desmontar sistemas de archivos
- [[lsblk]] — relación dispositivos y puntos de montaje

#comando