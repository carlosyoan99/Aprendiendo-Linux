---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: comando
prioridad: alta
---

# uname

## Sintaxis

```bash
uname [opciones]
```

## Descripción

Muestra información del **kernel y la arquitectura del sistema** donde se ejecuta. Es el primer comando que ejecutas cuando necesitas saber qué versión de kernel corres, si el sistema es de 32 o 64 bits, el nombre del hostname, o la arquitectura del procesador.

Viene en el paquete `coreutils` — disponible en toda distro sin instalación adicional.

## Opciones frecuentes

| Flag | Efecto | Ejemplo de salida |
|---|---|---|
| `-a` | **Todo** (kernel name, hostname, kernel release, kernel version, machine, processor, hardware platform, OS) | `Linux carlos-laptop 6.6.30-1-lts #1 SMP PREEMPT_DYNAMIC ... x86_64 GNU/Linux` |
| `-s` | Kernel name | `Linux` |
| `-n` | Hostname | `carlos-laptop` |
| `-r` | **Kernel release** (la más usada) | `6.6.30-1-lts` |
| `-v` | Kernel version (fecha de compilación, gcc version) | `#1 SMP PREEMPT_DYNAMIC ...` |
| `-m` | **Machine** (arquitectura CPU) | `x86_64` / `aarch64` / `armv7l` |
| `-p` | Processor | `x86_64` |
| `-i` | Hardware platform | `x86_64` |
| `-o` | OS | `GNU/Linux` |

## Ejemplos

```bash
uname -a                                     # toda la info de un solo golpe
uname -r                                     # solo la versión del kernel (lo más usado)
uname -m                                     # arquitectura: x86_64 (64-bit), aarch64 (ARM), i686 (32-bit)
uname -n                                     # hostname de la máquina
```

## Casos de uso reales

### Identificar arquitectura para descargar el binario correcto

```bash
# ¿Soy 64-bit o 32-bit? (crítico para descargar paquetes binarios)
uname -m
# x86_64 → descargar binario para linux-amd64
# aarch64 → descargar binario para linux-arm64
# armv7l → descargar binario para linux-arm (32-bit)
```

### Reportar versión del kernel en un bug/foro de ayuda

```bash
# Cuando pides ayuda, este comando proporciona la información que te van a pedir:
uname -a
# Devuelve: Linux hostname 6.6.30-1-lts #1 SMP ...
```

### Verificar si estás usando un kernel personalizado

```bash
# El kernel release incluye el sufijo de la distro o modificación
uname -r
# 6.6.30-1-lts → Arch LTS kernel
# 6.8.0-45-generic → Ubuntu generic kernel
# 6.1.0-23-amd64 → Debian amd64 kernel
# 6.9.3-zen1 → Arch Zen kernel (optimizado para escritorio)
# 6.6.42 → kernel vanilla de kernel.org
```

### Script de diagnóstico del sistema

```bash
echo "Kernel: $(uname -r), Arquitectura: $(uname -m), Host: $(uname -n)"
# Kernel: 6.6.30-1-lts, Arquitectura: x86_64, Host: carlos-laptop
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `uname -p` o `-i` muestra "unknown" | Kernel no reporta esa información | Usar `uname -m` o `lscpu` |
| Quieres saber la versión exacta del kernel pero `uname -r` te da algo como `6.6.30-1-lts` | El sufijo (-lts, -generic, -amd64) es la variante del kernel que empaquetó la distro | `uname -r` te da la versión exacta que necesita saber qué cargar |

## Notas y advertencias

- `uname -a` es uno de los comandos más comunes en soporte técnico — cuando preguntes en un foro, siempre incluye su salida.
- `uname -m` distingue entre `x86_64` (64-bit), `i686` (32-bit), `aarch64` (ARM 64-bit), y `armv7l` (ARM 32-bit).
- Para información más detallada del hardware (no solo kernel), usar `lscpu`, `lspci`, o `dmidecode`.
- En contenedores Docker, `uname -a` muestra el **kernel del host**, no del contenedor (todos los contenedores comparten el kernel anfitrión).

## Enlaces externos

- [Wikipedia — uname](https://en.wikipedia.org/wiki/Uname)
- [Arch Wiki — uname](https://man.archlinux.org/man/uname.1)
- [Linux man page online](https://man7.org/linux/man-pages/man1/uname.1.html)

## Ver también

- [[Proc y Sys]] — información del kernel vía /proc y /sys
- [[Módulos del kernel (lsmod modprobe blacklist)]] — gestión de módulos del kernel
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — info detallada de hardware
- [[Cheat Sheet - Comandos Esenciales]]

#comando
