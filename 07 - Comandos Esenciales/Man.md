---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: alta
---

# Man (páginas de manual)

## Sintaxis
```
man [opciones] [sección] nombre
man -k palabra_clave    # equivalente a apropos
man -f nombre           # equivalente a whatis
```

## Descripción

**`man`** (manual) es el sistema de documentación integrado de Unix/Linux. Cada comando, función de biblioteca, archivo de configuración y llamada al sistema tiene una página de manual (man page) que describe su uso, opciones y a menudo ejemplos.

A diferencia de `--help` (resumen rápido), `man` proporciona documentación completa y detallada.

## Secciones del manual

Las man pages están organizadas en **secciones** numeradas:

| Sección | Contenido | Ejemplo |
|---|---|---|
| **0** | Archivos de cabecera C (disponible con `manpages-posix-dev`) | `man 0 stdio.h` |
| **1** | Comandos de usuario (ejecutables) | `man 1 ls`, `man 1 bash` |
| **2** | Llamadas al sistema (kernel) | `man 2 fork`, `man 2 open` |
| **3** | Funciones de biblioteca (libc) | `man 3 printf`, `man 3 fopen` |
| **4** | Dispositivos especiales (/dev) | `man 4 null`, `man 4 tty` |
| **5** | Formatos de archivos de configuración | `man 5 passwd`, `man 5 crontab` |
| **6** | Juegos | `man 6 lolcat` (si existe) |
| **7** | Miscelánea, convenciones, paquetes | `man 7 pipe`, `man 7 signal`, `man 7 boot` |
| **8** | Comandos de administración (root) | `man 8 fdisk`, `man 8 mount` |
| **9** | Rutinas del kernel (no estándar en todas las distros) | `man 9 vfs` |

```bash
# Especificar sección (útil cuando hay ambigüedad)
man 1 passwd              # comando passwd (cambiar contraseña)
man 5 passwd              # formato del archivo /etc/passwd
man -a passwd             # mostrar todas las secciones en orden
```

## Navegación dentro de man

`man` usa **less** como paginador por defecto. Atajos:

| Tecla | Acción |
|---|---|
| `Space` / `f` | Avanzar página |
| `b` | Retroceder página |
| `j` / `k` | Avanzar / retroceder línea |
| `/texto` | Buscar hacia adelante |
| `?texto` | Buscar hacia atrás |
| `n` / `N` | Siguiente / anterior resultado de búsqueda |
| `g` / `G` | Ir al inicio / final |
| `q` | Salir |
| `h` | Ayuda de atajos de less |

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-k` | Buscar por palabra clave (apropos) | `man -k compress` |
| `-f` | Mostrar descripción breve (whatis) | `man -f ls` |
| `-a` | Mostrar todas las secciones | `man -a printf` |
| `-w` | Mostrar ruta de la man page | `man -w ls` |
| `-l` | Abrir un archivo como man page | `man -l README.md` |
| `-t` | Generar PDF (requiere groff) | `man -t ls > ls.ps` |
| `-P` | Usar un paginador distinto | `man -P cat ls` (texto plano) |
| `-M` | Especificar ruta de manuales | `man -M /usr/share/man ls` |
| `-S` | Limitar a secciones específicas | `man -S 1:8 ls` |
| `-E` | Especificar encoding | `man -E UTF-8 ls` |

## Ejemplos

```bash
# Documentación básica
man ls                      # página del comando ls
man 7 signal                # documentación de señales (sección 7)
man -k usb                  # buscar páginas relacionadas con USB (apropos)
man -f printf               # descripción breve de printf (whatis)

# Rutas de las man pages
man -w ls                   # /usr/share/man/man1/ls.1.gz

# Exportar man page a texto
man ls | col -b > ls.txt    # a texto plano (col -b quita retrocesos)

# Ver man page en navegador (con información formateada)
man -Thtml ls > ls.html
```

## apropos (`man -k`)

Busca páginas de manual por palabra clave en la descripción corta:

```bash
apropos compress            # busca todo lo relacionado con compresión
man -k network              # busca "network" en todas las descripciones
man -k '^find'              # expresiones regulares en la búsqueda

# Ejemplos de salida:
# bzip2          (1) - compresor de archivos
# compress       (1) - comprimir datos
# gzip           (1) - comprimir/expandir archivos
# uncompress     (1) - descomprimir archivos comprimidos con compress
```

## whatis (`man -f`)

Muestra la **descripción de una línea** de una página de manual:

```bash
whatis ls                   # ls (1) - lista el contenido de un directorio
man -f printf               # printf (1) - mostrar formato y datos
                            # printf (3) - función de salida con formato
```

## Buscar páginas de manual por tema

```bash
# Listar todas las páginas disponibles
man -k . | wc -l            # cuenta total de man pages (~6000 en Arch)

# Temas específicos
man -k '^git'               # todos los comandos git
man -k '^systemd\.'         # todas las unidades systemd
man -k '^dbus'              # páginas de D-Bus
man -k '^xfce'              # páginas de XFCE

# Programas vs secciones
man -k '^(crontab|fstab|passwd)' | sort
```

## Formato de una man page

```
NOMBRE
    comando - descripción breve

SINTAXIS
    comando [opciones] argumentos

DESCRIPCIÓN
    Explicación detallada de qué hace

OPCIONES
    -v, --verbose   Muestra información detallada

VALORES DE SALIDA (EXIT STATUS)
    0 = éxito, 1 = error

ARCHIVOS (FILES)
    Rutas relevantes que usa el comando

EJEMPLOS (EXAMPLES)
    Uso práctico

VER TAMBIÉN (SEE ALSO)
    Comandos o páginas relacionadas
```

## Instalar documentación adicional

```bash
# Algunos paquetes separan las man pages en paquetes -doc
sudo apt install man-db man-pages-posix man-pages-es   # Debian/Ubuntu (español)
sudo pacman -S man-pages man-db                         # Arch

# Documentación de desarrollo (secciones 2, 3, 9)
sudo apt install manpages-dev                           # Debian/Ubuntu
sudo pacman -S man-pages                                # Arch

# Páginas en español
sudo apt install manpages-es manpages-es-extra          # Debian/Ubuntu
```

## man vs info vs help

| Comando | Cuándo usarlo | Ejemplo |
|---|---|---|
| `man comando` | Documentación completa | `man ls` |
| `comando --help` / `comando -h` | Resumen rápido de opciones | `ls --help` |
| `info comando` | Documentación de GNU (formato hypertexto) | `info coreutils` |
| `help comando` | Ayuda de built-ins de shell | `help cd` |

GNU prefiere `info` sobre `man` para sus herramientas (bash, coreutils, gcc). `info` tiene navegación por nodos similar a hipervínculos.

```bash
# Convertir info a man si prefieres el formato clásico
info ls                     # página info de ls
man ls                      # puede redirigir a info en sistemas GNU
```

## Notas y advertencias

- Las man pages son el **recurso de documentación más importante** en Linux — acostúmbrate a consultarlas.
- `man -k` (apropos) es el mejor amigo cuando no recuerdas el nombre exacto de un comando.
- No todas las secciones están presentes en todos los sistemas. La sección 9 es rara.
- Si una man page no se muestra correctamente, instala `man-db` o prueba con `MANWIDTH=80 man ls`.
- Las páginas de terceros (aplicaciones no empaquetadas) pueden ir en `/usr/local/share/man/`.

## Ver también

- [[Nano]] — editor para leer y navegar man pages
- [[less]] — paginador usado por man (ver comandos de navegación)
- [[Cheat Sheet - Comandos Esenciales]] — resumen rápido de comandos
- [[GNU y Linux]] — contexto del proyecto GNU (man vs info)

## Enlaces externos

- [Wikipedia - man page](https://en.wikipedia.org/wiki/Man_page)
- [man7.org - Linux man pages](https://man7.org/linux/man-pages/)

#comando
