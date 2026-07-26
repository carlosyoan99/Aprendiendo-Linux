---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: concepto
prioridad: alta
---

# UNIX

> Sistema operativo creado en 1969 en Bell Labs. Es el ancestro directo de Linux, macOS y BSD. Su filosofía de diseño — herramientas pequeñas que hacen una cosa bien — define Linux hasta hoy.

## Definición

UNIX fue creado por **Ken Thompson** y **Dennis Ritchie** en Bell Labs (AT&T) en 1969, inicialmente en un PDP-7. Su diseño revolucionario se basó en principios que siguen vigentes:

| Principio | Significado |
|---|---|
| **Hacer una cosa bien** | Cada herramienta tiene una única función |
| **Componer herramientas** | Combinar pequeños programas con pipes |
| **Jerarquía de archivos** | Árbol unificado de directorios (no letras de unidad) |
| **Multiusuario** | Múltiples usuarios en la misma máquina |
| **Portabilidad** | Escrito en C (revolucionario para la época) |

## Línea temporal de UNIX

```
1969  Ken Thompson y Dennis Ritchie crean UNIX en Bell Labs (PDP-7)
1971  Primera edición en PDP-11
1973  Reescrito en C — revolución de portabilidad
1974  Paper académico publica UNIX al mundo
      ↓
1977  BSD (Berkeley Software Distribution) — universidad
      ↓                    ↓
1983  AT&T System V       4.2BSD (introduce TCP/IP)
      ↓                    ↓
1988  Guerra de UNIX      POSIX (estandarización)
      ↓                    ↓
1991  Linus Torvalds crea el kernel Linux
      GNU + Linux = sistema operativo completo
      ↓
2000s Linux domina servidores
2020s Linux domina nube, móviles (Android), IoT, supercomputación
```

## Las tres ramas de UNIX

### AT&T System V
- UNIX comercial, propietario
- Introdujo SVR4, Streams, administración de arranque
- Licencias caras → fragmentación del mercado

### BSD (Berkeley Software Distribution)
- UNIX académico, abierto parcialmente
- Añadió TCP/IP, vi, csh, job control
- Derivados: FreeBSD, OpenBSD, NetBSD
- macOS usa BSD como userland (a través de Darwin)

### POSIX (estandarización)
- **Portable Operating System Interface** (IEEE 1003.1, 1988)
- Define API estándar: forks, signals, pipes, filesystem
- Linux cumple POSIX → software Unix funciona en Linux
- Single UNIX Specification (SUS) — consolidación posterior

## Filosofía UNIX y su herencia en Linux

| Principio UNIX | Implementación en Linux |
|---|---|
| "Todo es un archivo" | `/dev/`, `/proc/`, `/sys/` |
| Pipes y composición | `ls \| grep \| wc -l` |
| Shell como lenguaje de programación | bash, zsh, fish |
| Herramientas de texto | sed, awk, grep, sort, uniq |
| Configuración en texto plano | `/etc/` completo |
| Permiso mínimo (security) | `chmod`, `chown`, `sudo` |

## UNIX vs Linux: diferencias clave

| Aspecto | UNIX (tradicional) | Linux |
|---|---|---|
| **Código fuente** | Propietario (AT&T, IBM, Oracle) | Abierto (GPL v2) |
| **Costo** | Licencias caras ($1,000+) | Gratuito |
| **Hardware** | Workstations, mainframes | Cualquier PC |
| **Init** | System V init | systemd, OpenRC, runit |
| **Paquetes** | PKG, depot, SWinstall | apt, pacman, dnf, rpm |
| **Certificación** | Single UNIX Specification | (no necesita certificación) |
| **Comunidad** | Corporativa | Open source global |

### Sistemas operativos basados en UNIX o certificados UNIX

| SO | Familia | Estado |
|---|---|---|
| **AIX** (IBM) | System V | Activo (mainframes) |
| **HP-UX** (HPE) | System V | Legado |
| **Solaris** (Oracle) | System V | Legado |
| **FreeBSD** | BSD | Activo |
| **OpenBSD** | BSD | Activo (seguridad) |
| **macOS** | BSD/Darwin | Activo (certificado UNIX) |
| **Linux** | POSIX-compliant | Dominante |

## Casos prácticos

### Verificar conformidad POSIX en Linux
```bash
# Linux cumple POSIX pero no está "certificado"
getconf ARG_MAX           # límite de argumentos (POSIX define)
getconf PATH_MAX          # límite de PATH
```

### Comandos UNIX que sobreviven en Linux
```bash
# Estos comandos vienen directamente de UNIX (1970s)
who                        # quién está logueado
w                          # quién está y qué hace
last                       # historial de logins
finger                     # información de usuario (puede estar deshabilitado)
mail                       # cliente de correo de terminal
```

### Shell original de UNIX (Bourne Shell)
```bash
# sh (Bourne Shell) — la shell original de UNIX (1979)
# bash (Bourne Again Shell) — la evolución GNU (1989)
# Ambos usan sintaxis similar:
for i in 1 2 3; do echo $i; done
if [ -f archivo ]; then echo "existe"; fi
```

## Notas personales

- La filosofía "todo es un archivo" es la idea más poderosa de UNIX. En `/proc` puedes ver procesos como archivos, en `/dev` los dispositivos como archivos, y en `/sys` el kernel como archivos.
- Linux no es UNIX — es un clon que cumple POSIX. La diferencia importa: Linux es gratis y abierto, UNIX original era caro y propietario.
- La "Guerra de UNIX" (System V vs BSD) en los 80s fue lo que permitió a Linux ganar: fragmentación del mercado propietario dejó la puerta abierta al software libre.
- BSD (FreeBSD, OpenBSD) es tan antiguo como Linux y todavía se usa en servidores, PlayStation, y la base de macOS.

## Enlaces externos
- [Wikipedia — UNIX](https://en.wikipedia.org/wiki/Unix)
- [The Unix Heritage Society](http://www.tuhs.org/) — archivo histórico de UNIX
- [The Art of Unix Programming — Eric S. Raymond](http://www.catb.org/esr/writings/taoup/) — filosofía UNIX
- [Wikipedia — BSD](https://en.wikipedia.org/wiki/Berkeley_Software_Distribution)
- [Wikipedia — POSIX](https://en.wikipedia.org/wiki/POSIX)
- [Single UNIX Specification](https://pubs.opengroup.org/publications/bundled-pages/c19std050/chap03.html)

## Ver también
- [[Que es Linux]] — cómo Linux se relaciona con UNIX
- [[GNU y Linux]] — la otra mitad del sistema operativo
- [[Historia de Linux]] — nacimiento de Linux como alternativa a UNIX
- [[La Shell]] — la herencia de la shell de UNIX
- [[Filesystem Hierarchy Standard]] — la jerarquía de archivos heredada de UNIX
- [[macOS]] — basado en BSD/UNIX a través de Darwin
- [[Regular Expressions]] — concepto nacido en UNIX (ed, grep, sed)

#concepto
