---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# mkdir

## Sintaxis
```bash
mkdir [opciones] directorio...
```

## Descripción
Crea uno o varios directorios. Es uno de los comandos más básicos y esenciales para organizar archivos.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-p` | Crea directorios padres intermedios si no existen (¡el más importante!) |
| `-v` | Verboso — muestra qué directorios va creando |
| `-m` | Establece permisos al crear (modo octal) |

## Ejemplos
```bash
mkdir nuevo                    # crear un directorio
mkdir -p a/b/c/d              # crear estructura anidada (si a/ no existe, lo crea)
mkdir -p proyectos/{src,docs,test,tmp}  # crear varios subdirectorios con brace expansion
mkdir -m 700 privado           # crear con permisos 700 (solo dueño)
mkdir -v datos                 # crear y mostrar mensaje
mkdir "mi carpeta"             # con espacios (comillas necesarias)
mkdir ~/backups/$(date +%F)   # crear carpeta con fecha actual
```

## Casos de uso reales

### Crear estructura de proyecto desde cero

```bash
mkdir -p mi-proyecto/{src/{components,utils},docs,test,public}
# Crea: mi-proyecto/src/components/
#       mi-proyecto/src/utils/
#       mi-proyecto/docs/
#       mi-proyecto/test/
#       mi-proyecto/public/
```

### Crear carpeta con fecha para backups

```bash
mkdir -p ~/backups/$(date +%Y-%m-%d)
# Crea: ~/backups/2026-07-24/
# Ideal para backups diarios automáticos
```

### Preparar estructura para servir archivos (servidor web)

```bash
sudo mkdir -p /var/www/mi-sitio/{html,logs,ssl,cgi-bin}
sudo chown -R $USER:$USER /var/www/mi-sitio/
```

## Combinaciones comunes con pipe

```bash
# Crear directorios a partir de una lista en un archivo
cat directorios.txt | xargs mkdir -p

# Crear estructura a partir de rutas encontradas
find . -name "*.md" -exec dirname {} \; | sort -u | xargs mkdir -p
```

## Alternativas modernas

| Comando clásico | Alternativa | Nota |
|---|---|---|
| `mkdir -p` | — | `mkdir -p` sigue siendo la herramienta estándar, no hay alternativa directa |
| `mkdir directorio` | `install -d directorio` | Crea directorio con permisos específicos |

```bash
# install -d también crea directorios padres como -p
install -d -m 700 ~/privado
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `mkdir: cannot create directory 'dir': File exists` | El directorio ya existe | Usar `-p` para ignorar si existe |
| `mkdir: cannot create directory 'a/b/c': No such file or directory` | Falta `-p` para crear padres | Añadir `-p`: `mkdir -p a/b/c` |
| `mkdir: cannot create directory 'dir': Permission denied` | Sin permiso de escritura en la ruta | Usar `sudo mkdir` o cambiar permisos del padre |
| `mkdir: invalid option -- 'p'` | El flag no existe en esa plataforma | En sistemas BSD/macOS, `-p` sí existe — verificar sintaxis |

## Notas
- `mkdir -p` es **esencial**: evita errores cuando los padres no existen.
- El `-p` también es seguro si el directorio ya existe (no da error).
- La expansión `{a,b,c}` la hace el shell, no mkdir.

```bash
# Error típico sin -p:
mkdir a/b/c       # error: a/ no existe
# Con -p funciona:
mkdir -p a/b/c    # crea a/, a/b/, a/b/c
```

## Ver también
- [[rm]] — eliminar directorios (`rm -rf`)
- [[ls]] — listar directorios
- [[touch]] — crear archivos
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — mkdir](https://en.wikipedia.org/wiki/Mkdir)
- [GNU Coreutils — mkdir manual](https://www.gnu.org/software/coreutils/manual/html_node/mkdir-invocation.html)

#comando