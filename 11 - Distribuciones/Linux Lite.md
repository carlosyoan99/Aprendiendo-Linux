---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt (dpkg)
base: Ubuntu LTS
modelo_lanzamiento: Fixed (LTS)
init: systemd
arquitecturas:
  - x86_64
---

# Linux Lite

> Distribución Linux ligera basada en **Ubuntu LTS** con escritorio **XFCE**, diseñada específicamente para **migrantes de Windows** con hardware modesto. Fundada en Nueva Zelanda por Jerry Bezencon.

## Filosofía / público objetivo

Linux Lite nació en 2012 cuando Ubuntu adoptó Unity y muchos usuarios de Windows XP buscaban un reemplazo ligero y familiar. Su objetivo es **introducir a usuarios de Windows en Linux** con una interfaz similar a Windows XP/7, funcionando en hardware antiguo.

Lema: *"Simple, rápido, libre"* (*Simple, fast, free*).

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Ubuntu LTS |
| **Gestor de paquetes** | APT + Lite Software (script propio) |
| **Init** | systemd |
| **Modelo** | Fixed (cada 2 años sobre LTS) |
| **Entorno por defecto** | XFCE personalizado |
| **Instalador** | Ubiquity |
| **Desarrollador** | Jerry Bezencon (Nueva Zelanda) |

### Software propio

- **Lite Software**: script para instalar/remover Chrome, Steam, VirtualBox, codecs, Java
- **Lite User Manager**: gestión de usuarios
- **Lite Manual**: guía del sistema
- **Lite Fix**: herramientas de reparación

### Software incluido

- LibreOffice + Firefox/Chrome + Thunderbird + VLC + GIMP

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| CPU | 1 GHz | 1.5 GHz |
| RAM | 768 MB | 1 GB+ |
| Disco | 8 GB | 20 GB+ |

## Lanzamientos principales

| Versión | Nombre | Fecha | Soporte hasta |
|---|---|---|---|
| 1.0 | Amethyst | 2012-10 | — |
| 2.0 | Beryl | 2014-06 | 2019 |
| 3.0 | Citrine | 2016-05 | 2021 |
| 4.0 | Diamond | 2018-05 | 2023 |
| 5.0 | Emerald | 2020-05 | 2025 |
| 6.x | Fluorite | 2022-05 | 2027 |
| **7.0** | **Galena** | **2024-05** | **2029** |

## Enlaces externos

- [Sitio oficial](https://www.linuxliteos.com/)
- [Wikipedia — Linux Lite](https://es.wikipedia.org/wiki/Linux_Lite)
- [DistroWatch](http://distrowatch.com/table.php?distribution=lite)

## Ver también

- [[XFCE]] — escritorio por defecto
- [[Ubuntu]] — distribución base
- [[Linux Mint]] — distro amigable similar
- [[Zorin OS]] — otra distro estilo Windows
- [[LXLE Linux]] — alternativa ligera similar

#distro #ligera #principiantes
