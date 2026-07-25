---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# diff

## Sintaxis
```
diff [opciones] archivo1 archivo2
```

## Descripción
Compara dos archivos línea por línea y muestra las diferencias. Esencial para versionar configuraciones, ver cambios entre versiones de archivos, y verificar que una copia/backup sea idéntica al original.

## Opciones frecuentes

| Flag | Efecto |
|------|--------|
| `-u` | Formato unificado (más legible, el más usado) |
| `-c` | Formato contexto (muestra líneas alrededor) |
| `-i` | Ignora diferencias de mayúsculas/minúsculas |
| `-w` | Ignora espacios y tabs |
| `-b` | Ignora cambios en espacios en blanco |
| `-r` | Compara recursivamente directorios |
| `-q` | Solo indica si los archivos difieren o no |

## Ejemplos

```bash
diff archivo1.txt archivo2.txt                # diferencias básicas
diff -u config.old config.new                 # formato unificado (el más legible)
diff -u config.old config.new > cambios.patch # generar parche para aplicar con patch
diff -r directorio1/ directorio2/             # comparar dos directorios recursivamente
diff -q archivo1.txt archivo2.txt             # solo decir si son iguales o distintos
diff -w archivo1.txt archivo2.txt             # ignorar espacios

# diff en contexto real
diff -u ~/.bashrc ~/dotfiles/.bashrc          # ver diferencias entre config actual y la versionada
```

## diff vs cmp

| Comando | Compara | Uso |
|---|---|---|
| `diff` | Línea por línea | Ver diferencias detalladas |
| `cmp` | Byte por byte | Saber si dos archivos binarios son idénticos |

## Notas y advertencias
- `diff` sale con código 0 si no hay diferencias, 1 si hay diferencias, 2 si hay error. Útil en scripts: `if diff -q a.txt b.txt > /dev/null; then echo "iguales"; fi`.
- `diff -u` es el formato que usa Git para mostrar cambios. Aprender a leerlo:
  - Líneas con `-` están en archivo1 pero no en archivo2
  - Líneas con `+` están en archivo2 pero no en archivo1
- Para archivos binarios, `cmp` es más apropiado que `diff`.
- `sdiff` muestra las diferencias lado a lado.

## Ver también
- [[Cheat Sheet - Comandos Esenciales]]
- [[grep]]

## Enlaces externos

- [Wikipedia — diff](https://en.wikipedia.org/wiki/Diff)
- [GNU Diffutils — diff manual](https://www.gnu.org/software/diffutils/manual/diffutils.html)

#comando
