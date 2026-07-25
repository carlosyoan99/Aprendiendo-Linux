---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: media
---

# Versiones de Debian

## Ciclo de lanzamiento

Debian no tiene un calendario fijo de lanzamientos; las versiones estables se publican aproximadamente **cada 2 años**. El proyecto mantiene tres ramas activas simultáneamente:

| Rama | Nombre en clave | Descripción |
|---|---|---|
| **Stable** (estable) | El nombre Toy Story actual | Versión de producción. Solo recibe parches de seguridad |
| **Testing** (de prueba) | El siguiente nombre en orden alfabético | Paquetes promocionados desde unstable tras ser probados |
| **Unstable** (inestable) | **Sid** (siempre) | Desarrollo activo, paquetes recién subidos. Puede romperse |

Cuando una versión estable se reemplaza, la anterior pasa a llamarse **oldstable**, luego **oldoldstable**, y finalmente se archiva.

## Convenio de denominación

Los nombres en clave de Debian son **personajes de Toy Story**:

- **Sid** (el vecino que destruye juguetes) → rama inestable — siempre se llama así
- **Buzz**, **Woody**, **Rex**, **Hamm**, **Slinky**, etc. → versiones estables
- El orden alfabético determina la secuencia de versiones

## Tabla de lanzamientos (base Ubuntu)

| Versión | Nombre código | Fecha lanzamiento | Fin soporte (LTS/ELTS) |
|---|---|---|---|
| 1.1 | Buzz | 1996-06-17 | — |
| 1.2 | Rex | 1996-12-12 | — |
| 1.3 | Bo | 1997-06-05 | — |
| 2.0 | Hamm | 1998-07-24 | — |
| 2.1 | Slink | 1999-03-09 | — |
| 2.2 | Potato | 2000-08-15 | — |
| 3.0 | Woody | 2002-07-19 | — |
| 3.1 | Sarge | 2005-06-06 | — |
| 4.0 | Etch | 2007-04-08 | 2010-02 (LTS) |
| 5.0 | Lenny | 2009-02-14 | 2012-02 (LTS) |
| 6.0 | Squeeze | 2011-02-06 | 2014-02 (LTS) / 2016-02 (ELTS) |
| 7 | Wheezy | 2013-05-04 | 2016-04 (LTS) / 2018-05 (ELTS) |
| 8 | Jessie | 2015-04-25 | 2018-06 (LTS) / 2020-06 (ELTS) |
| 9 | Stretch | 2017-06-17 | 2020-06 (LTS) / 2022-06 (ELTS) |
| 10 | Buster | 2019-07-06 | 2022-06 (LTS) / 2024-06 (ELTS) |
| 11 | Bullseye | 2021-08-14 | 2024-08 (LTS) / 2026-08 (ELTS) |
| 12 | Bookworm | 2023-06-10 | 2026-06 (LTS) / 2028-06 (ELTS) |
| 13 | Trixie | ~2025 (previsto) | — |

## Soporte

| Fase | Duración | Qué incluye |
|---|---|---|
| **Soporte de seguridad** | ~3 años tras lanzamiento | Parches de seguridad por el Debian Security Team |
| **LTS** (Long Term Support) | +2 años (~5 años total) | Mantenido por el Debian LTS Team (voluntarios) |
| **ELTS** (Extended LTS) | +2 años (~7 años total) | Patrocinado por Freexian (comercial, pero gratuito para uso no comercial) |

## ¿Qué versión elegir?

| Necesitas | Elige |
|---|---|
| Producción, máximo estabilidad | **Stable** (Bookworm 12 actualmente) |
| Software actualizado, estable | **Testing** (Trixie actualmente) |
| Lo último, toleras bugs | **Unstable** (Sid) |
| Rolling release estable basado en Testing | Usar Testing como rolling |

```bash
# Ver tu versión actual
cat /etc/debian_version
lsb_release -a
# o
cat /etc/os-release

# Ver qué rama tiene más paquetes recientes
apt-cache policy firefox
```

## Notas personales

- La regla general: **Stable para servidores, Testing para escritorio, Sid para desarrollo**
- Si vienes de Arch, Sid te resultará familiar (rolling, se rompe de vez en cuando)
- LMDE (Linux Mint Debian Edition) usa Testing como base, lo que lo hace más estable que Sid pero más actualizado que Stable

## Enlaces externos

- [Debian Releases (página oficial)](https://www.debian.org/releases/)
- [Debian LTS](https://wiki.debian.org/LTS)
- [Freexian ELTS](https://www.freexian.com/extended-lts/)
- [Wikipedia — Versiones de Debian](https://es.wikipedia.org/wiki/Anexo:Versiones_de_Debian)
- [Debian Wiki: Ciclo de vida de lanzamientos](https://wiki.debian.org/DebianReleases)

## Ver también

- [[Debian]] — distribución principal
- [[Post-Instalacion Checklist]] — guía de instalación de Debian
- [[Linux Mint]] — LMDE usa Debian Testing como base
- [[Ubuntu]] — derivado de Debian (Testing + inestable históricamente)

#distro #debian
