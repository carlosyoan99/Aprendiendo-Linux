---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: concepto
prioridad: baja
---

# MS-DOS

> Disk Operating System — el sistema operativo de línea de comandos que dominó los PC personales en los años 80 y principios de los 90. Su legado pervive en la sintaxis de Windows CMD.

## Definición

**MS-DOS** (Microsoft Disk Operating System) fue un sistema operativo monousuario, sin multitarea y basado en línea de comandos, desarrollado por Microsoft para los PC compatibles con IBM.

| Versión | Año | Relevancia |
|---|---|---|
| **1.0** | 1981 | Primera versión, para IBM PC |
| **2.0** | 1983 | Soporte de discos duros, subdirectorios |
| **3.3** | 1987 | Versión más popular, estandarizada |
| **5.0** | 1991 | Editor EDIT, Memory Manager, undelete |
| **6.22** | 1993 | Última versión standalone (defrag, scan disk, antivirus) |
| **7.0/8.0** | 1995-2000 | Solo como bootloader de Windows 9x |

**Origen**: Microsoft licenció **86-DOS** (de Seattle Computer Products), que era un clone de **CP/M** (de Digital Research) adaptado al Intel 8086.

## Por qué importa para un usuario de Linux

- **Comandos heredados**: Muchos comandos de Windows CMD vienen directamente de MS-DOS (`dir`, `copy`, `del`, `type`, `ren`). Conocer el origen explica por qué son tan diferentes de Unix.
- **Sintaxis de paths**: MS-DOS usa `\` y letras de unidad (`C:\`), mientras Unix usa `/` y una sola raíz. Esta diferencia es la fuente de confusión #1 para migrantes.
- **FAT filesystem**: Los pendrives y tarjetas SD todavía usan FAT32, un legado directo de MS-DOS. Linux lo soporta nativamente.
- **Batch scripting**: Los archivos `.bat` / `.cmd` son el equivalente DOS de los scripts bash. Compararlos ayuda a entender la filosofía de cada sistema.

## MS-DOS vs Bash: comparación de comandos

| Acción | MS-DOS / CMD | Bash (Linux) |
|---|---|---|
| Listar archivos | `dir` | `ls -la` |
| Cambiar directorio | `cd`, `chdir` | `cd` |
| Copiar | `copy` | `cp` |
| Mover/renombrar | `move`, `ren` | `mv` |
| Eliminar | `del` | `rm` |
| Ver archivo | `type` | `cat`, `less` |
| Buscar texto | `findstr` | `grep` |
| Crear directorio | `md`, `mkdir` | `mkdir -p` |
| Limpiar pantalla | `cls` | `clear` |
| Ayuda | `help`, `command /?` | `man`, `--help` |
| Variables | `%VAR%` | `$VAR` |
| Condicionales | `if exist` | `if [ -f ]` |
| Redirección | `>` y `>>` | `>` y `>>` (igual) |
| Pipes | `|` | `|` (igual) |

## Estructura del filesystem

```
MS-DOS:                          Linux:
C:\                              /
├── DOS/                         ├── bin/
├── WINDOWS/                     ├── etc/
├── USERS/                       ├── home/
│   └── Carlos/                  │   └── carlos/
│       ├── Documents/           │       ├── Documents/
│       └── AUTOEXEC.BAT         │       └── .bashrc
├── PROGRAM FILES/               ├── usr/
└── CONFIG.SYS                   └── var/
```

Diferencia clave: MS-DOS usa **letras de unidad** (A:, B:, C:, D:), Linux usa un **árbol único** montado en `/`.

## Casos prácticos

### Formatear un pendrive en Windows (FAT32)
```cmd
:: Desde CMD de Windows
format E: /FS:FAT32 /Q
```

### Montar FAT32 en Linux
```bash
# Linux soporta FAT32 nativamente
sudo mount -t vfat /dev/sdb1 /mnt/usb
# Leer y escribir sin problemas
ls /mnt/usb/
```

### Crear un archivo BAT equivalente a un script bash
```cmd
:: script.bat (MS-DOS)
@echo off
echo Hola desde DOS
dir C:\Users
pause
```

```bash
#!/bin/bash
# script.sh (Linux)
echo "Hola desde bash"
ls /home
read -p "Presiona Enter..."
```

## Notas personales

- MS-DOS es la razón por la que Windows tiene CMD y no una shell tipo Unix.
- La sintaxis `\` en paths de Windows viene de MS-DOS — en Unix siempre es `/`.
- Las letras de unidad (C:, D:) son un concepto que no existe en Linux; todo se monta bajo un solo árbol.
- Aunque MS-DOS murió como SO independiente, su legado vive en PowerShell (`Get-ChildItem` = `ls`, `Copy-Item` = `cp`).

## Enlaces externos
- [Wikipedia — MS-DOS](https://en.wikipedia.org/wiki/MS-DOS)
- [Wikipedia — CP/M](https://en.wikipedia.org/wiki/CP/M) — el SO que MS-DOS clonó
- [MS-DOS History](https://www.os2museum.com/wp/dos-history/) — historia detallada
- [DOSBox](https://www.dosbox.com/) — emulador para ejecutar programas DOS

## Ver también
- [[Windows]] — sucesor de MS-DOS
- [[Que es Linux]] — fundamentos del SO que reemplazó a DOS en servidores
- [[Filesystem Hierarchy Standard]] — cómo Linux organiza archivos (vs la estructura DOS)
- [[Variables de Entorno y PATH]] — concepto que MS-DOS y Linux manejan de forma similar

#concepto
