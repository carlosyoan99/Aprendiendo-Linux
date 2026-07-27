---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# locate

> Busca archivos en una base de datos indexada. Mucho más rápida que `find`, pero el índice puede estar desactualizado.

## Sintaxis

```bash
locate [opciones] patrón
locate -i -l 20 '*.conf'              # buscar sin importar mayúsculas, top 20
locate -r '\.(conf|ini)$'              # regex: archivos .conf o .ini
```

## Descripción

`locate` busca archivos en una base de datos pre-indexada (actualizada con `updatedb`). Es **mucho más rápida que `find`** porque no recorre el disco en vivo, sino que consulta un índice. La desventaja es que los archivos creados hoy pueden no aparecer hasta la próxima ejecución de `updatedb` (normalmente diaria vía systemd timer).

Requiere instalar `plocate` (recomendado, más rápido) o `mlocate` (legacy):

```bash
sudo apt install plocate        # Debian/Ubuntu
sudo pacman -S plocate          # Arch
sudo dnf install plocate        # Fedora

# Actualizar el índice manualmente
sudo updatedb
```

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-i` | Ignorar mayúsculas/minúsculas | `locate -i readme` → README, Readme, readme... |
| `-c` | Mostrar solo el conteo, no los archivos | `locate -c .jpg` → "2451" |
| `-l N` | Limitar a N resultados | `locate -l 5 nginx` → solo 5 resultados |
| `-r` | Usar regex en lugar de wildcard | `locate -r '\.conf$'` |
| `-e` | Solo mostrar archivos existentes (más lento) | `locate -e nginx.conf` |
| `-b` | Buscar solo el nombre base (sin ruta) | `locate -b bashrc` |
| `-A` | Mostrar resultados después de limpiar la base de datos | `locate -A '*.log'` |
| `-d <ruta>` | Usar una base de datos específica | `locate -d /var/cache/custom.db '*.txt'` |
| `-S` | Mostrar estadísticas de la base de datos | `locate -S` |

## Formato de salida

```bash
locate .bashrc
# /etc/skel/.bashrc
# /home/carlos/.bashrc
# /home/carlos/.backup/.bashrc.old
# /root/.bashrc
```

Las rutas absolutas separadas por salto de línea. Con `-c` solo muestra el número total.

## Ejemplos

```bash
# 1. Buscar un archivo por nombre
locate .bashrc

# 2. Ignorar mayúsculas/minúsculas
locate -i readme

# 3. Contar cuántos archivos de un tipo hay
locate -c .jpg

# 4. Limitar resultados (útil cuando hay cientos)
locate -l 10 '*.log'

# 5. Usar regex: archivos que terminan en .conf
locate -r '\.conf$'

# 6. Solo si el archivo existe al momento de buscar
locate -e nginx.conf

# 7. Estadísticas de la base de datos
locate -S
# Database: /var/lib/plocate/plocate.db
# Size: 124 MB
# Filenames: 1,245,678
# Directories: 98,765

# 8. Buscar solo el nombre base (no la ruta)
locate -b 'bashrc'

# 9. Actualizar índice y luego buscar
sudo updatedb && locate nginx

# 10. Buscar archivos de configuración específicos
locate -r '\.(conf|ini|cfg)$' | head -20
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Encontrar todas las copias de un archivo de configuración** | `locate .bashrc` |
| **Saber cuántos MP3/FLAC tienes** | `locate -c -i '\.(mp3|flac)$'` |
| **Encontrar un comando perdido** | `locate -b 'ffmpeg'` |
| **Verificar que un archivo se borró correctamente** | `locate -e archivo_peligroso.txt` (vacío = no existe) |
| **Buscar logs de un servicio** | `locate -r '/var/log/nginx/.*\.log$'` |
| **Saber talla de la BD** | `locate -S` |

## Combinaciones comunes con pipe

```bash
# Contar resultados (alternativa a -c)
locate '*.conf' | wc -l

# Filtrar por directorio específico
locate -i 'README' | grep -i '/home/'

# Pipear a fzf para selección interactiva
locate '*.conf' | fzf

# Ver tamaño total de archivos encontrados
locate '*.jpg' | xargs du -ch 2>/dev/null | tail -1

# Buscar y ejecutar acción sobre resultados
locate -b '*.bak' | xargs rm -v
```

## Alternativas modernas

| Herramienta | Ventaja |
|---|---|
| **plocate** | Sucesor de mlocate. Índice más compacto y búsquedas más rápidas. Usar `plocate` en vez de `locate` si está disponible |
| **fd** (fd-find) | `fd 'patrón'` — búsqueda rápida en tiempo real (no indexada), con colores, respeta .gitignore. Mejor que locate para búsquedas en proyectos |
| **fzf** | Búsqueda difusa interactiva. Combinado con locate o fd, permite filtrar resultados en vivo |

## locate vs find

| Característica | locate | find |
|---|---|---|
| **Velocidad** | ⭐ Instantáneo | 🐢 Recorre el disco |
| **Actualización** | Base de datos (puede estar desactualizada) | Tiempo real |
| **Filtros** | Por nombre principalmente (regex básico) | Nombre, tipo, tamaño, fecha, permisos, propietario |
| **Acciones** | Solo mostrar | `-exec`, `-delete`, `-ok`, `-print` |
| **Instalación** | Requiere `plocate` o `mlocate` | Viene en todo Linux (GNU Findutils) |
| **Ideal para** | Búsquedas rápidas del sistema, conteos | Scripts, backups, operaciones precisas |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `locate: command not found` | plocate/mlocate no instalado | `sudo apt install plocate` |
| `locate: can not stat ()` | Base de datos no existe o corrupta | `sudo updatedb` para regenerar |
| `WARNING: The locate database is older than 7 days` | El timer de updatedb no se ejecuta | `sudo updatedb` manual; verificar timer: `systemctl status plocate-updatedb.timer` |
| `locate: /var/lib/plocate/plocate.db: Permission denied` | No tienes permisos de lectura de la BD | Ejecutar `locate` sin sudo (debería funcionar) o `sudo locate` |
| Archivo recién creado no aparece | La BD no se actualizó aún | `sudo updatedb` y buscar de nuevo |

## Notas y advertencias

- **La base de datos se actualiza diariamente** vía un timer de systemd (`plocate-updatedb.timer`). Ejecuta `sudo updatedb` manualmente si necesitas resultados frescos.
- **Archivos en ubicaciones excluidas**: por defecto, `updatedb` excluye `/tmp`, `/proc`, `/sys`, `/media`, `/mnt`, `/run`. Para incluir más rutas, editar `/etc/updatedb.conf`.
- **plocate vs mlocate**: plocate es el estándar moderno en Debian 12+, Ubuntu 22.04+, Arch y Fedora. El comando sigue siendo `locate`, pero usa el backend plocate.
- **Seguridad**: el índice es legible por todos los usuarios. Cualquiera puede saber qué archivos existen en el sistema.

## Enlaces externos

- [Wikipedia — locate (Unix)](https://en.wikipedia.org/wiki/Locate_(Unix))
- [GNU Findutils — locate manual](https://www.gnu.org/software/findutils/manual/html_node/find_html/Locate-Invocation.html)
- [Arch Wiki — locate](https://wiki.archlinux.org/title/Locate)
- [plocate GitHub](https://github.com/rfjakob/plocate)
- [Linux man page — locate(1)](https://man.archlinux.org/man/locate.1)

## Ver también

- [[find]] — búsqueda en tiempo real con filtros avanzados
- [[grep]] — buscar contenido dentro de archivos
- [[which]] — localizar ejecutables en el PATH
- [[fd-find]] — alternativa moderna con búsqueda difusa
- [[fzf]] — búsqueda interactiva desde terminal
- [[Cheat Sheet - Comandos Esenciales]]

#comando