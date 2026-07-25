---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: distribucion
prioridad: media
---

# Versiones de Debian

## Ciclo de lanzamiento

Debian no tiene un calendario fijo de lanzamientos — las versiones estables se publican aproximadamente **cada 2 años**, cuando están listas ("when it's ready"). El proceso sigue una cadena de promoción entre ramas:

```text
Desarrolladores suben paquetes  →  unstable (Sid)
         ↓  (tras 2-10 días sin bugs críticos)
testing recibe paquetes probados  →  testing (próxima stable)
         ↓  (frozen: ~6 meses antes del release)
testing se congela  →  solo bugs críticos
         ↓  (liberación)
stable (nueva)  →  oldstable (anterior)  →  oldoldstable → archive
```

### Las 3 ramas activas

| Rama | Nombre | Descripción | Uso |
|---|---|---|---|
| **Stable** | El nombre Toy Story actual (Bookworm 12) | Solo recibe parches de seguridad y bug fixes | Producción, servidores |
| **Testing** | El siguiente nombre (Trixie, futura 13) | Paquetes promocionados desde unstable tras ser probados | Escritorio hogareño, desarrollo |
| **Unstable** | **Sid** (siempre el mismo nombre) | Desarrollo activo, paquetes recién subidos. Puede romperse | Developers, entusiastas |

> **Sid** es el vecino que destruye juguetes en Toy Story — nombre deliberado porque es la rama donde \"los paquetes se rompen\". Es el único nombre permanente (todas las versiones estables usan personajes distintos).

### Freeze process (fases de congelación)

Antes de una release estable, testing pasa por varias fases de congelación:

| Fase | Qué ocurre | Duración típica |
|---|---|---|
| **Toolchain freeze** | Se congelan GCC, glibc, binutils | ~1 mes |
| **Soft freeze** | Nuevas funcionalidades: NO. Bugs críticos: SÍ | ~2 meses |
| **Hard freeze** | Solo bugs release-critical (RC) | ~2-3 meses |
| **Full freeze** | Solo bugs RC que afectan al instalador o al arranque | ~1 mes |
| **Release** | ¡Nueva stable! | — |

## Tabla de lanzamientos

| Versión | Nombre código | Fecha | Full Support | LTS | ELTS |
|---|---|---|---|---|---|
| 1.1 | Buzz | 1996-06-17 | — | — | — |
| 1.2 | Rex | 1996-12-12 | — | — | — |
| 1.3 | Bo | 1997-06-05 | — | — | — |
| 2.0 | Hamm | 1998-07-24 | — | — | — |
| 2.1 | Slink | 1999-03-09 | — | — | — |
| 2.2 | Potato | 2000-08-15 | — | — | — |
| 3.0 | Woody | 2002-07-19 | — | — | — |
| 3.1 | Sarge | 2005-06-06 | — | — | — |
| 4.0 | Etch | 2007-04-08 | 2009-02 | 2010-02 | — |
| 5.0 | Lenny | 2009-02-14 | 2011-02 | 2012-02 | — |
| 6.0 | Squeeze | 2011-02-06 | 2013-02 | 2014-02 | 2016-02 |
| 7 | Wheezy | 2013-05-04 | 2015-04 | 2016-04 | 2018-05 |
| 8 | Jessie | 2015-04-25 | 2017-04 | 2018-06 | 2020-06 |
| 9 | Stretch | 2017-06-17 | 2019-06 | 2020-06 | 2022-06 |
| 10 | Buster | 2019-07-06 | 2021-07 | 2022-06 | 2024-06 |
| **11** | **Bullseye** | **2021-08-14** | **2024-08** | **2026-08** | **2031-06** |
| **12** | **Bookworm** | **2023-06-10** | **2026-07-11** | **2028-06** | **2033-06** |
| **13** | **Trixie** | **2025-08-09** | **~2028** | **~2030** | **~2035** |
| 14 | Forky | TBD (2027?) | TBD | TBD | TBD |

> **Nota**: ELTS desde Squeeze (6.0) en adelante. Antes de eso no existía soporte extendido.

## Soporte: Full → LTS → ELTS

| Fase | Duración | Quién lo mantiene | Qué incluye |
|---|---|---|---|
| **Full Support** | ~3 años | Debian Security Team oficial | Parches de seguridad, bugs críticos |
| **LTS** | +2 años (~5 total) | Debian LTS Team (voluntarios) | Seguridad para arquitecturas amd64, i386, ARM |
| **ELTS** | +2-5 años (~7-10 total) | Freexian (comercial, gratuito para uso no comercial) | Seguridad extendida, arquitecturas limitadas |

```bash
# Verificar si tu versión está en soporte
# LTS: https://wiki.debian.org/LTS
# ELTS: https://www.freexian.com/extended-lts/
```

### ¿Qué versión elegir?

| Necesitas | Elige | Ejemplo |
|---|---|---|
| Producción, máxima estabilidad | **Stable** | Bookworm 12.x |
| Software actualizado sin ser rolling | **Testing** | Trixie |
| Lo último, toleras bugs | **Unstable (Sid)** | Sid |
| Servidor con soporte muy largo | **Stable + planificar migración ELTS** | Bookworm → LTS → ELTS |

### Point releases (Debian X.Y)

Entre versiones mayores, Debian publica **point releases** que consolidan parches de seguridad y bugs:

```bash
# Versión instalada vs último point release
cat /etc/debian_version                  # ej: 12.5
# Point releases de Bookworm: 12.0 → 12.1 → 12.2 → 12.3 → 12.4 → 12.5...
# Cada point release actualiza las ISOs oficiales para instalaciones nuevas
# No es necesario actualizar si ya tienes 12.x — apt upgrade te trae los parches igual
```

## Convenio de denominación

Todos los nombres en clave de Debian son **personajes de Toy Story** ordenados alfabéticamente:

```text
Buzz (1.0) → Rex (1.1) → Bo (1.2) → Hamm (2.0) → Slink (2.1) → Potato (2.2)
→ Woody (3.0) → Sarge (3.1) → Etch (4.0) → Lenny (5.0) → Squeeze (6.0)
→ Wheezy (7) → Jessie (8) → Stretch (9) → Buster (10) → Bullseye (11)
→ Bookworm (12) → Trixie (13) → Forky (14)
```

> **Curiosidad**: Buzz Lightyear fue la primera estable en 1996. Forky apareció en Toy Story 4 (2019) y será la Debian 14. Sid es el único personaje que NO fue versión estable — es eternalmente la rama inestable.

## Cómo verificar tu versión de Debian

```bash
# Método 1 — número de versión exacto (ej: 12.5)
cat /etc/debian_version

# Método 2 — nombre en clave (ej: bookworm)
lsb_release -sc

# Método 3 — información completa
lsb_release -a
cat /etc/os-release

# Método 4 — hostnamectl (incluye kernel)
hostnamectl

# ¿Estás en stable, testing o sid?
grep -E '^deb' /etc/apt/sources.list | head -1
# stable → bookworm, testing → trixie, unstable → sid
```

## Derivados notables de Debian

| Derivado | Base Debian | Propósito |
|---|---|---|
| **Ubuntu** | Testing + Sid (históricamente) | Escritorio amigable, LTS cada 2 años |
| **Kali Linux** | Testing | Pentesting, forense digital |
| **Devuan** | Stable | Fork sin systemd (init alternativa) |
| **Raspberry Pi OS** | Stable + Backports | Raspberry Pi |
| **MX Linux** | Stable | Escritorio ligero, herramientas propias |
| **LMDE** | Testing | Linux Mint sobre Debian directo (sin Ubuntu) |
| **Proxmox VE** | Stable | Virtualización (KVM + LXC) |

## Enlaces externos

- [Debian Releases (página oficial)](https://www.debian.org/releases/)
- [Debian LTS](https://wiki.debian.org/LTS)
- [Freexian ELTS](https://www.freexian.com/extended-lts/)
- [Wikipedia — Versiones de Debian](https://es.wikipedia.org/wiki/Anexo:Versiones_de_Debian)
- [Debian Wiki: Ciclo de vida de lanzamientos](https://wiki.debian.org/DebianReleases)
- [Debian Wiki: Point Releases](https://wiki.debian.org/DebianReleases/PointReleases)

## Ver también

- [[Debian]] — distribución principal, instalación y configuración
- [[Ubuntu]] — derivado de Debian, ciclo LTS
- [[Linux Mint]] — LMDE usa Debian Testing como base
- [[Kali Linux]] — derivado Debian para seguridad
- [[Proxmox VE]] — plataforma de virtualización sobre Debian
- [[Gestores de Paquetes]] — apt, dpkg, APT pinning
- [[Actualizacion entre versiones mayores]] — upgrade entre releases

#distro #debian
