---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt (dpkg)
base: Ubuntu
---

# Sabores de Ubuntu (Ubuntu Flavors)

## Definición

Los **sabores oficiales** (official flavors) de Ubuntu son distribuciones que comparten la misma base técnica de Ubuntu (repositorios, kernel, ciclo de actualizaciones) pero se diferencian en el **entorno de escritorio** y el conjunto de aplicaciones preinstaladas. Cada sabor está mantenido por un equipo distinto, pero todos lanzan simultáneamente con Ubuntu y usan los mismos repositorios `apt`.

No deben confundirse con derivados independientes como [[Linux Mint]] o [[Pop OS]], que aunque basados en Ubuntu, tienen sus propios repositorios, herramientas y filosofía.

> Ver la nota principal: [[Ubuntu]].

---

## Sabores oficiales actuales (2026)

| Sabor | DE | Desde | Mantenido por | Público objetivo |
|---|---|---|---|---|
| **Kubuntu** | [[KDE Plasma]] | 2005 (5.04) | Blue Systems | Usuarios que quieren KDE completo y customizable |
| **Xubuntu** | [[XFCE]] | 2006 (6.06) | Comunidad Xubuntu | Equipos ligeros, usuarios que buscan simplicidad |
| **Lubuntu** | LXQt | 2009 (9.04) | Comunidad Lubuntu | Equipos con poca RAM (< 2 GB) |
| **Ubuntu MATE** | [[MATE]] | 2014 (14.10) | Comunidad Ubuntu MATE | Usuarios de GNOME 2 clásico |
| **Ubuntu Budgie** | [[Budgie]] | 2017 (17.04) | Comunidad Ubuntu Budgie | Escritorio moderno pero ligero |
| **Ubuntu Studio** | KDE Plasma + apps multimedia | 2007 (7.04) | Comunidad Ubuntu Studio | Producción de audio, video y gráficos |
| **Ubuntu Cinnamon** | [[Cinnamon]] | 2022 (22.04) | Comunidad Ubuntu Cinnamon | Usuarios de Linux Mint |
| **Ubuntu Kylin** | UKUI (QT) | 2013 (13.04) | Gob. de China + Canonical | Usuarios chinos, gobierno chino |

| Sabor | RAM mínima recomendada | Peso ISO | Aplicaciones distintivas |
|---|---|---|---|
| **Kubuntu** | 4 GB | ~4 GB | KDE Gear: Dolphin, Kate, Okular, Ktorrent, Amarok |
| **Xubuntu** | 1 GB | ~3 GB | Thunar, Mousepad, Ristretto, Parole, Gigolo |
| **Lubuntu** | 512 MB - 1 GB | ~2.5 GB | PCManFM-Qt, FeatherPad, qpdfview, Trojita |
| **Ubuntu MATE** | 1-2 GB | ~3 GB | Caja, Pluma, Eye of MATE, Atril |
| **Ubuntu Budgie** | 2 GB | ~3 GB | Budgie Desktop, Raven sidebar, Budgie Control Center |
| **Ubuntu Studio** | 8 GB | ~5 GB | Ardour, Blender, Kdenlive, GIMP, OBS, LMMS |
| **Ubuntu Cinnamon** | 2 GB | ~3 GB | Nemo, Gedit, Xreader, Nemo Actions |
| **Ubuntu Kylin** | 2 GB | ~3.5 GB | UKUI, Youker Assistant, Kylin Menu |

---

## Sabores históricos / descontinuados

| Sabor | Años | DE | Motivo del fin |
|---|---|---|---|
| **Ubuntu GNOME** | 2012-2017 | GNOME Shell | Canonical volvió a GNOME como DE predeterminado en 17.10 |
| **Edubuntu** | 2005-2014 (revivido 2023) | GNOME (antes KDE) | Falta de mantenedores; revivido como flavor oficial en 23.04 |
| **Mythbuntu** | 2005-2017 | XFCE | Reemplazado por MythTV directo sobre Ubuntu |
| **Gobuntu** | 2007-2008 | GNOME | Solo FLOSS; absorbido por Ubuntu (componente main + free) |
| **Ubuntu Netbook Edition** | 2008-2011 | GNOME + Unity | Netbooks desaparecieron del mercado |
| **Ubuntu JeOS** | 2007-2010 | Sin DE (server) | Reemplazado por Ubuntu Server minimal |
| **Ubuntu Touch** | 2013-2017 | Unity 8 (Lomiri) | Abandonado por Canonical; sobrevive como UBports |
| **Ubuntu Unity** | 2020-2024 | Unity 7 | Revivido por la comunidad como flavor no oficial; descontinuado |

---

## Kubuntu — KDE Plasma

**Kubuntu** fue el primer flavor oficial de Ubuntu (lanzado junto con Ubuntu 5.04 en abril de 2005). Usa [[KDE Plasma]] como entorno de escritorio, ofreciendo una experiencia rica, altamente configurable, similar a Windows en su diseño predeterminado.

**Historia**: Creado por la comunidad KDE tras el lanzamiento de Ubuntu 4.10 (Warty Warthog) que solo incluía GNOME. Canonical lo reconoció como flavor oficial en 2005. Desde 2012 es mantenido por **Blue Systems**.

**Aplicaciones preinstaladas**: Dolphin (archivos), Kate (editor), Okular (PDF), Ktorrent, Amarok, K3b, Kontact, LibreOffice, Firefox.

**Requisitos**: 4 GB RAM, 2 GHz dual-core, 25 GB disco. No es para equipos muy antiguos.

```bash
# Instalar Kubuntu sobre Ubuntu
sudo apt install kubuntu-desktop

# Diferenciar: kubuntu-desktop vs kubuntu-full
sudo apt install kubuntu-full       # todo el ecosistema KDE
```

---

## Xubuntu — XFCE ligero

**Xubuntu** usa [[XFCE]], un escritorio tradicional, ligero y configurable. Ideal para equipos con recursos limitados o para quienes prefieren un escritorio clásico y estable.

**Historia**: Lanzado por primera vez con Ubuntu 6.06 (Dapper Drake) en 2006. XFCE se eligió como alternativa ligera a GNOME/KDE.

**Aplicaciones**: Thunar (archivos), Mousepad (editor), Ristretto (visor imágenes), Parole (reproductor), Gigolo (montaje remoto), LibreOffice.

**Requisitos**: 1 GB RAM, CPU de cualquier núcleo. Funciona bien en equipos de 15+ años.

```bash
# Instalar Xubuntu sobre Ubuntu
sudo apt install xubuntu-desktop
```

---

## Lubuntu — LXQt ultraligero

**Lubuntu** es el sabor más ligero de Ubuntu. Originalmente usaba LXDE (GTK2), pero migró a **LXQt** (Qt) en 2018 (18.10). Está diseñado para equipos muy antiguos o con poca RAM.

**Historia**: Primer lanzamiento con Ubuntu 8.10 (2008) usando LXDE. En 2018, tras la fusión de LXDE-Qt y Razor-qt, migró a LXQt.

**Aplicaciones**: PCManFM-Qt (archivos), FeatherPad (editor), qpdfview, Trojita (correo), Discover (software center), LibreOffice.

**Requisitos**: **512 MB - 1 GB RAM**. Funciona en equipos Pentium 4 o superiores.

```bash
# Instalar Lubuntu sobre Ubuntu
sudo apt install lubuntu-desktop
```

---

## Ubuntu MATE — El clásico GNOME 2

**Ubuntu MATE** ofrece **MATE Desktop**, un fork de GNOME 2 que preserva la experiencia clásica de Ubuntu de la era 2006-2011.

**Historia**: Creado por Martin Wimpress en 2014. Canonical lo aceptó como flavor oficial en 2015 (15.04).

**Aplicaciones**: Caja (archivos), Pluma (editor), Eye of MATE (imágenes), Atril (PDF), MATE Terminal, LibreOffice.

**Requisitos**: 1-2 GB RAM. Balance entre ligereza y funcionalidad.

```bash
# Instalar Ubuntu MATE sobre Ubuntu
sudo apt install ubuntu-mate-desktop
```

---

## Ubuntu Budgie — Moderno y ligero

**Ubuntu Budgie** usa **Budgie Desktop**, un escritorio moderno desarrollado por el proyecto Solus. Combina un diseño limpio con bajo consumo de recursos.

**Historia**: Creado en 2016 por la comunidad Solus. Canonical lo aceptó como flavor oficial para Ubuntu 17.04.

**Características**: Escritorio GTK3, Raven sidebar (notificaciones + controles), Budgie Menu, escritorios virtuales.

**Requisitos**: 2 GB RAM. Más ligero que KDE/GNOME pero moderno.

```bash
# Instalar Ubuntu Budgie sobre Ubuntu
sudo apt install ubuntu-budgie-desktop
```

---

## Ubuntu Studio — Producción multimedia

**Ubuntu Studio** está orientado a **producción de audio, video, gráficos y fotografía**. Históricamente usaba XFCE para ahorrar recursos para las apps de creación; desde 22.04 LTS usa **KDE Plasma**.

**Historia**: Lanzado con Ubuntu 7.04 (2007). Flavor oficial desde el inicio con foco en audio profesional (JACK, Ardour). En 2022 migró a KDE para mejor integración con herramientas creativas.

**Aplicaciones**: Ardour (DAW), Blender (3D), Kdenlive (video editor), GIMP, OBS Studio, Inkscape, Audacity, LMMS, Plume Creator, Scribus.

**Requisitos**: 8 GB RAM, CPU multi-núcleo, tarjeta de audio dedicada recomendada.

```bash
# Instalar Ubuntu Studio sobre Ubuntu
sudo apt install ubuntustudio-desktop
```

---

## Tabla comparativa completa

| Característica | Kubuntu | Xubuntu | Lubuntu | MATE | Budgie | Studio | Cinnamon | Kylin |
|---|---|---|---|---|---|---|---|---|
| **DE** | KDE Plasma 6 | XFCE 4 | LXQt | MATE | Budgie | KDE Plasma | Cinnamon | UKUI |
| **Toolkit** | Qt6 | GTK3 | Qt5/6 | GTK3 | GTK3 | Qt6 | GTK3 | Qt5 |
| **RAM mínima** | 4 GB | 1 GB | 0.5-1 GB | 1-2 GB | 2 GB | 8 GB | 2 GB | 2 GB |
| **Rendimiento** | Medio | ⭐ Rápido | ⭐⚡ Muy rápido | ✅ Rápido | ✅ Medio | ⚠️ Pesado | ✅ Medio | ✅ Medio |
| **Personalizable** | ⭐ Extremo | ✅ Alto | ✅ Medio | ✅ Medio | ✅ Medio | ✅ Medio | ✅ Alto | ✅ Medio |
| **Uso típico** | Escritorio moderno | PC viejos, servidores | PC muy antiguos | Clásico, transición | Moderno + ligero | Audio/Video | Mint users | China |

---

## ¿Cómo elegir un sabor?

| Si tienes... | Y quieres... | Elige... |
|---|---|---|
| **PC moderno (8 GB+ RAM)** | La experiencia más completa | **Kubuntu** o **Ubuntu** (GNOME) |
| **PC de gama media (4 GB RAM)** | Algo ligero pero funcional | **Xubuntu** o **Ubuntu Budgie** |
| **PC muy antiguo (1-2 GB RAM)** | Que funcione fluido | **Lubuntu** |
| **Vienes de Windows 7/XP** | Una transición suave | **Ubuntu MATE** o **Kubuntu** |
| **Producción de audio/video** | Apps creativas preinstaladas | **Ubuntu Studio** |
| **Vienes de Linux Mint** | Cinnamon en Ubuntu | **Ubuntu Cinnamon** |
| **Solo 512 MB de RAM** | Linux en hardware extremo | **Lubuntu** |

---

## Instalación y coexistencia

```bash
# Descargar ISOs de sabores
# https://ubuntu.com/download/flavours

# Probar en vivo sin instalar
# Cada sabor tiene su propia imagen ISO arrancable

# Instalar escritorio de otro sabor sobre una instalación existente
sudo apt install kubuntu-desktop            # añade KDE a tu Ubuntu
sudo apt install xubuntu-desktop            # añade XFCE a tu Ubuntu
sudo apt install lubuntu-desktop            # añade LXQt a tu Ubuntu

# Al reiniciar, elegir sesión desde el display manager (SDDM, LightDM, GDM)
```

> ⚠️ No se recomienda instalar múltiples escritorios en el mismo sistema. Aunque es posible, los menús se duplican, los temas se mezclan, y los ajustes de un DE pueden interferir con otro. Si quieres probar varios, usa Live USB o VMs.

---

## Ver también

- [[Ubuntu]] — la distro base de todos los sabores
- [[Debian]] — la base de Ubuntu
- [[KDE Plasma]] · [[XFCE]] · [[MATE]] · [[Budgie]] · [[Cinnamon]] — escritorios usados
- [[Linux Mint]] — basado en Ubuntu, con Cinnamon
- [[Pop OS]] — basado en Ubuntu, con COSMIC (Rust)
- [[Proceso de Instalacion General]] — cómo instalar cualquier sabor
- [[Gestores de Paquetes]] — apt, dpkg, Snap

## Enlaces externos

- [Ubuntu Flavours (oficial)](https://ubuntu.com/download/flavours)
- [Kubuntu](https://kubuntu.org/) · [Xubuntu](https://xubuntu.org/) · [Lubuntu](https://lubuntu.me/)
- [Ubuntu MATE](https://ubuntu-mate.org/) · [Ubuntu Budgie](https://ubuntubudgie.org/)
- [Ubuntu Studio](https://ubuntustudio.org/) · [Ubuntu Cinnamon](https://ubuntucinnamon.org/)
- [Wikipedia: Sabores de Ubuntu](https://es.wikipedia.org/wiki/Ubuntu#Sabores_oficiales)

#distro #ubuntu
