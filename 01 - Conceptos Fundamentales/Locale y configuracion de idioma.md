---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: media
---

# Locale y configuración de idioma

> El locale define cómo se muestran el idioma, formato de fecha, moneda, números y ordenación en tu sistema Linux. Configurarlo mal produce errores crípticos como `cannot set locale`, caracteres extraños en la terminal, y fechas en formato incorrecto.

## Definición

Un **locale** es un conjunto de variables de entorno que define convenciones culturales y lingüísticas: idioma, formato de números, moneda, fecha, hora, y orden de caracteres (collation). Linux usa POSIX locales para ello.

```bash
# Ver locales disponibles en el sistema
locale -a

# Ver variables de locale actuales
locale
# LANG=es_ES.UTF-8
# LC_CTYPE=es_ES.UTF-8
# LC_NUMERIC=es_ES.UTF-8
# LC_TIME=es_ES.UTF-8
# LC_COLLATE=es_ES.UTF-8
# LC_MONETARY=es_ES.UTF-8
# LC_MESSAGES=es_ES.UTF-8
# LC_ALL=
```

### Jerarquía de variables

| Variable | Controla | Ejemplo (`es_ES.UTF-8`) |
|---|---|---|
| `LANG` | **Valor por defecto** para todas las categorías LC_* | `es_ES.UTF-8` |
| `LC_CTYPE` | Clasificación de caracteres (mayúsculas, minúsculas, dígitos) | `es_ES.UTF-8` |
| `LC_NUMERIC` | Formato de números (separador decimal: `.` vs `,`) | `es_ES.UTF-8 → 1.234,56` |
| `LC_TIME` | Formato de fecha y hora | `es_ES.UTF-8 → 23 julio 2026` |
| `LC_COLLATE` | Orden de ordenación (collation, afecta a `sort`) | `es_ES.UTF-8` |
| `LC_MONETARY` | Formato de moneda | `es_ES.UTF-8 → 1.234,56 €` |
| `LC_MESSAGES` | Idioma de mensajes del sistema y apps | `es_ES.UTF-8` |
| `LC_ALL` | **Sobreescribe todas** las anteriores (no usarla en producción) | — |

**Regla**: `LC_ALL` > `LC_*` individual > `LANG`. `LC_ALL` sobreescribe todo, por eso solo debe usarse para depuración.

### Formato del nombre de locale

```
idioma_PAÍS.codificación
es_ES.UTF-8     → español de España, UTF-8
en_US.UTF-8     → inglés de EE.UU., UTF-8
pt_BR.UTF-8     → portugués de Brasil, UTF-8
C               → locale POSIX mínimo (inglés US, sin UTF-8)
C.UTF-8         → locale POSIX con UTF-8 (alternativa ligera)
```

## Generar un locale

Los locales no vienen todos pre-generados — hay que **generarlos** explícitamente:

```bash
# 1. Descomentar el locale deseado en /etc/locale.gen
sudo nano /etc/locale.gen
# Buscar y descomentar:
# es_ES.UTF-8 UTF-8
# en_US.UTF-8 UTF-8

# 2. Generar los locales descomentados
sudo locale-gen

# 3. Verificar que se generaron
locale -a | grep es_ES
```

### Por distro

```bash
# Debian/Ubuntu (método estándar con locale-gen)
sudo dpkg-reconfigure locales              # asistente interactivo
# O manual:
sudo nano /etc/locale.gen
sudo locale-gen

# Arch (más simple, los genera automáticamente al instalar)
# /etc/locale.gen es el archivo de configuración
sudo nano /etc/locale.gen
sudo locale-gen

# Fedora (usa localectl directamente)
sudo localectl set-locale LANG=es_ES.UTF-8
```

## Configurar el locale del sistema

```bash
# Método universal: /etc/locale.conf (systemd)
sudo nano /etc/locale.conf
# LANG=es_ES.UTF-8
# LC_TIME=es_ES.UTF-8
# LC_COLLATE=C                     # C para ordenar como sort espera (ver abajo)

# Aplicar cambios (sin reiniciar)
source /etc/locale.conf

# Con localectl (distros con systemd)
sudo localectl set-locale LANG=es_ES.UTF-8
sudo localectl set-locale LC_TIME=es_ES.UTF-8
sudo localectl set-locale LC_COLLATE=C

# Verificar
localectl status
```

### Configuración por usuario (~/.locale.conf o ~/.pam_environment)

```bash
# ~/.config/locale.conf (recomendado, XDG compliant)
echo "LANG=es_ES.UTF-8" > ~/.config/locale.conf

# O en ~/.profile añadir:
export LANG=es_ES.UTF-8
export LC_TIME=es_ES.UTF-8
```

## LC_COLLATE y el comando sort

`LC_COLLATE` determina **cómo se ordenan los caracteres**. Esto afecta directamente a `sort`, `ls`, y scripts que dependan de orden alfabético.

```bash
# Con LC_COLLATE=es_ES.UTF-8:
echo -e "a\nb\nA\nB\nñ\nz" | LC_COLLATE=es_ES.UTF-8 sort
# (puede ordenar: a A b B ñ z — mezcla mayúsculas y minúsculas)

# Con LC_COLLATE=C:
echo -e "a\nb\nA\nB\nñ\nz" | LC_COLLATE=C sort
# A B a b z ñ (ASCII puro, mayúsculas antes que minúsculas)
```

**Recomendación**: usar `LC_COLLATE=C` en scripts y en `/etc/locale.conf` para evitar comportamientos inesperados con `sort`, `grep` y rangos `[a-z]`.

## Errores comunes y troubleshooting

| Error | Causa | Solución |
|---|---|---|
| `locale: Cannot set LC_* to default locale: No such file or directory` | El locale no está generado | `sudo locale-gen` o descomentar en `/etc/locale.gen` |
| Caracteres raros (�) en la terminal | Terminal no interpreta UTF-8 | `export LANG=es_ES.UTF-8` y verificar que la terminal soporte UTF-8 |
| `sort` ordena de forma inesperada | `LC_COLLATE` configurado a `es_ES.UTF-8` en vez de `C` | Poner `LC_COLLATE=C` en `/etc/locale.conf` |
| mensajes del sistema en inglés aunque tengas `LANG=es_ES` | El paquete de traducción no está instalado | Instalar paquete de idioma (ej. `language-pack-es` en Ubuntu) |
| `ssh` muestra locale warning | El servidor no tiene el locale del cliente | Generar el locale en el servidor o configurar `SendEnv LANG` en `~/.ssh/config` |

## Configuración de teclado

Complementa la configuración de idioma con el layout del teclado (ver [[Teclado con layout incorrecto]] para troubleshooting):

```bash
# Con localectl (systemd)
sudo localectl set-keymap es               # teclado español (consola)
sudo localectl set-x11-keymap es            # teclado español (X11/Wayland)

# Método legacy (Debian/Ubuntu)
sudo dpkg-reconfigure keyboard-configuration

# Método manual (Arch)
# /etc/vconsole.conf:
# KEYMAP=es

# Por usuario (X11)
setxkbmap es                               # cambio temporal (solo sesión actual)
```

## Buenas prácticas

- **Siempre generar los locales** tras instalar una distro (uno de los primeros pasos del post-instalación)
- Usar `C.UTF-8` en lugar de `C` si necesitas compatibilidad UTF-8 sin las complicaciones de un locale completo
- Poner `LC_COLLATE=C` para evitar sorpresas con `sort`
- No tocar `LC_ALL` en producción — lo sobreescribe todo y puede romper scripts
- Para servidores: mantener `LANG=en_US.UTF-8` (los mensajes de error en inglés son más fáciles de buscar en Google)

## Enlaces externos

- [Arch Wiki — Locale](https://wiki.archlinux.org/title/Locale)
- [Debian Wiki — Locale](https://wiki.debian.org/Locale)
- [Ubuntu Help — Locale](https://help.ubuntu.com/community/Locale)
- [man 7 locale](https://man7.org/linux/man-pages/man7/locale.7.html)
- [Arch Wiki — Keyboard configuration](https://wiki.archlinux.org/title/Keyboard_configuration)

## Ver también

- [[Teclado con layout incorrecto]] — troubleshooting de layout de teclado
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — PAM puede afectar variables de entorno
- [[Variables de Entorno y PATH]] — cómo se propagan las variables de entorno
- [[date y timedatectl]] — formato de fecha influenciado por LC_TIME
- [[sort]] — el orden de sort depende de LC_COLLATE
- [[Post-Instalación Checklist]] — uno de los primeros pasos tras instalar

#concepto #configuracion
