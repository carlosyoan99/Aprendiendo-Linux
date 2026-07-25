---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: comando
prioridad: media
---

# locate

## Sintaxis
```bash
locate [opciones] patrón
```

## Descripción
Busca archivos en una base de datos indexada (mucho más rápida que `find`). El índice se actualiza periódicamente con `updatedb`. No busca en tiempo real como `find`, por lo que archivos recién creados pueden no aparecer hasta la próxima actualización.

Requiere instalar `plocate` o `mlocate`:

```bash
sudo apt install plocate        # Debian/Ubuntu (recomendado, más rápido)
sudo pacman -S plocate          # Arch
sudo updatedb                   # actualizar el índice manualmente
```

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-i` | Ignorar mayúsculas/minúsculas |
| `-c` | Mostrar solo el conteo, no los archivos |
| `-l N` | Limitar a N resultados |
| `-r` | Usar regex en lugar de wildcard |
| `-e` | Solo mostrar archivos que realmente existen (más lento) |

## Ejemplos
```bash
locate .bashrc                 # todas las copias de .bashrc en el sistema
locate -i README               # buscar README, Readme, readme...
locate -c .jpg                 # cuántos JPG hay en el sistema
locate -l 10 *.log             # solo 10 resultados
locate -r '\.conf$'            # regex: archivos que terminan en .conf
locate -e nginx.conf           # solo si el archivo existe al momento de buscar
```

## locate vs find

| Característica | locate | find |
|---|---|---|
| **Velocidad** | ⭐ Instantáneo | 🐢 Recorre el disco |
| **Actualización** | Base de datos (puede estar desactualizada) | Tiempo real |
| **Filtros** | Por nombre principalmente | Por nombre, tipo, tamaño, fecha, permisos |
| **Acciones** | Solo mostrar | -exec, -delete, -ok |
| **Instalación** | Requiere paquete extra | Viene en todo Linux |

## Notas
- Los archivos creados hoy no aparecerán hasta que ejecutes `sudo updatedb` o pase el timer de actualización (diario).
- `locate` es ideal para búsquedas rápidas del sistema; `find` para scripts y operaciones precisas.
- `plocate` (el sucesor moderno) es más rápido que `mlocate`.

## Ver también
- [[find]] — búsqueda en tiempo real con filtros avanzados
- [[grep]] — buscar contenido dentro de archivos
- [[which]] — localizar ejecutables en el PATH
- [[Cheat Sheet - Comandos Esenciales]]


## Enlaces externos

- [Wikipedia — locate](https://en.wikipedia.org/wiki/Locate_(Unix))
- [GNU Findutils — locate manual](https://www.gnu.org/software/findutils/manual/html_node/find_html/Locate-Invocation.html)

#comando