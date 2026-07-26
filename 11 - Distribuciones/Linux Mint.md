---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: apt (dpkg)
base: Ubuntu LTS (edición LMDE basada en Debian)
modelo_lanzamiento: Fixed (LTS)
init: systemd
arquitecturas:
  - x86_64
  - ARM (soporte limitado)
---

# Linux Mint

> Distribución basada en Ubuntu diseñada para que la transición desde Windows sea lo más suave posible: menú de inicio tradicional, configuración \"que funciona\" desde el primer arranque, y un enfoque conservador que prioriza la estabilidad sobre las novedades. Una de las distros más populares para usuarios domésticos.

## Filosofía / público objetivo

Linux Mint nació en **2006** con el objetivo de ofrecer una experiencia de escritorio completa y funcional \"out of the box\", sin necesidad de instalar codecs, drivers o plugins manualmente. Sus principios rectores:

- **Usabilidad ante todo**: interfaz familiar para usuarios de Windows (menú inicio, barra de tareas, bandeja del sistema)
- **Conservadurismo inteligente**: usar software maduro y estable, no la última versión
- **Privacidad**: sin telemetría, sin cuentas obligatorias, sin publicidad en el sistema
- **Libertad del usuario**: el DE principal (Cinnamon) es desarrollado por Mint, no depende de GNOME ni KDE

Es la distro recomendada para **nuevos usuarios de Linux** y para quienes vienen de Windows y quieren una experiencia sin sobresaltos.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Ubuntu LTS (cada 2 años) + LMDE (Debian Testing) |
| **Gestor de paquetes** | `apt` + `dpkg` + Gestor de Actualizaciones propio |
| **Init** | systemd |
| **Modelo** | Fixed release (punto de versiones sobre base LTS) |
| **Arquitecturas** | x86_64 (principal) |
| **Entorno por defecto** | Cinnamon (principal), MATE, Xfce |
| **Instalador** | Ubiquity |
| **Popularidad** | #2 en DistroWatch (años en el top 3) |

## Gestor de paquetes

```bash
# Actualizar repositorios
sudo apt update

# Actualizar todos los paquetes
sudo apt upgrade

# Instalar un paquete
sudo apt install firefox

# Buscar un paquete
apt search editor

# Eliminar un paquete (y su configuración)
sudo apt remove --purge firefox

# Limpiar paquetes huérfanos
sudo apt autoremove
```

### Gestor de Actualizaciones (mintupdate)

Mint incluye su propio gestor gráfico de actualizaciones que clasifica las actualizaciones por **niveles de riesgo**:

| Nivel | Riesgo | Incluye | Acción por defecto |
|---|---|---|---|
| 1-3 | Bajo | Parches de seguridad, correcciones de bugs | Visible y seleccionado |
| 4-5 | Alto | Nuevas versiones de kernel, drivers | Visible pero NO seleccionado (decisión del usuario) |

```bash
# Lanzar el gestor de actualizaciones
mintupdate

# Actualizar todo desde terminal (incluye niveles 4-5)
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade
```

### Repositorios adicionales

Mint deshabilita Snap por decisión del proyecto (valoran la libertad sobre el formato de Canonical):
```bash
# Flatpak y Flathub vienen preconfigurados
flatpak install flathub org.gimp.GIMP

# PPAs funcionan (heredados de Ubuntu)
sudo add-apt-repository ppa:whatever/ppa
sudo apt update
sudo apt install whatever
```

## Ediciones

| Edición | DE | Recomendada para |
|---|---|---|
| **Cinnamon** | [[Cinnamon]] | La principal, ideal para usuarios Windows |
| **MATE** | [[MATE]] | Hardware más modesto (GNOME 2 legacy) |
| **Xfce** | [[XFCE]] | Hardware antiguo o muy limitado |
| **LMDE** | Cinnamon | Quienes prefieren base Debian sobre Ubuntu |

### LMDE (Linux Mint Debian Edition)

Edición basada directamente en **Debian Testing** (en lugar de Ubuntu LTS). No hereda los repositorios de Canonical (Snap, PPAs). Ideal para quienes quieren Mint sin nada de Ubuntu.

```bash
# LMDE usa apt igual que Ubuntu, pero sin PPAs
sudo apt update && sudo apt upgrade
```

## Ciclo de lanzamiento

Hay dos lanzamientos de Linux Mint por año, aproximadamente **un mes después de cada lanzamiento de Ubuntu**. Cada versión tiene un número de versión y un **nombre código** femenino en orden alfabético (Ada, Barbara, Cassandra, Daryna...).

Las versiones **LTS** (basadas en Ubuntu LTS) tienen soporte por 5 años. Las versiones no LTS tienen soporte por 18 meses.

### Historial completo de lanzamientos

#### Base Ubuntu

| Versión | Nombre código | Fecha | Base Ubuntu | LTS |
|---|---|---|---|---|
| 1.0 | Ada | 2006-08-27 | Kubuntu 6.06 | ❌ |
| 2.0 | Barbara | 2006-11-13 | Ubuntu 6.10 | ❌ |
| 2.1 | Bea | 2006-12-20 | Ubuntu 6.10 | ❌ |
| 2.2 | Bianca | 2007-02-20 | Ubuntu 6.10 | ❌ |
| 3.0 | Cassandra | 2007-05-30 | Ubuntu 7.04 | ❌ |
| 3.1 | Celena | 2007-09-24 | Ubuntu 7.04 | ❌ |
| 4.0 | Daryna | 2007-10-15 | Ubuntu 7.10 | ❌ |
| 5 | Elyssa | 2008-06-08 | Ubuntu 8.04 | ✅ |
| 6 | Felicia | 2008-12-15 | Ubuntu 8.10 | ❌ |
| 7 | Gloria | 2009-05-26 | Ubuntu 9.04 | ❌ |
| 8 | Helena | 2009-11-28 | Ubuntu 9.10 | ❌ |
| 9 | Isadora | 2010-05-18 | Ubuntu 10.04 | ✅ |
| 10 | Julia | 2010-11-12 | Ubuntu 10.10 | ❌ |
| 11 | Katya | 2011-05-26 | Ubuntu 11.04 | ❌ |
| 12 | Lisa | 2011-11-26 | Ubuntu 11.10 | ❌ |
| 13 | Maya | 2012-05-23 | Ubuntu 12.04 | ✅ |
| 14 | Nadia | 2012-11-20 | Ubuntu 12.10 | ❌ |
| 15 | Olivia | 2013-05-29 | Ubuntu 13.04 | ❌ |
| 16 | Petra | 2013-11-30 | Ubuntu 13.10 | ❌ |
| 17.x | Qiana → Rosa | 2014-05 → 2016-01 | Ubuntu 14.04 | ✅ |
| 18.x | Sarah → Sylvia | 2016-06 → 2017-12 | Ubuntu 16.04 | ✅ |
| 19.x | Tara → Tricia | 2018-06 → 2019-12 | Ubuntu 18.04 | ✅ |
| 20.x | Ulyana → Una | 2020-06 → 2022-01 | Ubuntu 20.04 | ✅ |
| 21.x | Vanessa → Virginia | 2022-07 → 2024-01 | Ubuntu 22.04 | ✅ |
| **22.x** | **Wilma → Zena** | **2024-07 → 2026-01** | **Ubuntu 24.04** | **✅** |

#### LMDE (Linux Mint Debian Edition)

| Versión | Nombre código | Fecha | Base Debian | Fin soporte |
|---|---|---|---|---|
| 1 | — | 2014-03 | Debian 8 (Jessie) | 2016 |
| 2 | Betsy | 2015-04 | Debian 8 (Jessie) | 2019 |
| 3 | Cindy | 2018-08 | Debian 9 (Stretch) | 2020 |
| 4 | Debbie | 2020-08 | Debian 10 (Buster) | 2022 |
| 5 | Elsie | 2022-03 | Debian 11 (Bullseye) | 2024 |
| 6 | Faye | 2023-09 | Debian 12 (Bookworm) | 2026 |

### Convenio de nomenclatura

- Nombres femeninos en orden alfabético: Ada, Barbara, Bianca, Cassandra, Celena, Daryna, Elyssa, Felicia...
- Las versiones puntuales (17.1, 17.2...) mantienen la misma inicial (R: Qiana, Rebecca, Rafaela, Rosa)
- Las versiones LMDE también siguen orden alfabético: Betsy, Cindy, Debbie, Elsie, Faye

### Soporte actual (2026)

| Versión | Soporte hasta | Estado |
|---|---|---|
| **22.x (Wilma → Zena)** | Abril 2029 | ✅ Activo — la recomendada |
| 21.x (Vanessa → Virginia) | Abril 2027 | ⚠️ Soporte vigente |
| 20.x (Ulyana → Una) | Abril 2025 | ❌ Fin de soporte |
| LMDE 6 (Faye) | 2026 | ✅ Activo |

```bash
# Ver tu versión de Mint
cat /etc/os-release | grep -E '^(NAME|VERSION)'
hostnamectl
```

## Requisitos del sistema

| Componente | Mínimo (Xfce) | Recomendado (Cinnamon) |
|---|---|---|
| **CPU** | 1 GHz (x86_64) | 2 GHz dual-core |
| **RAM** | 1 GB | 4 GB (8 GB ideal) |
| **Disco** | 15 GB | 30 GB + |
| **GPU** | Cualquier GPU compatible | Integrada o dedicada moderna |
| **Resolución** | 1024×768 | 1920×1080 o superior |

## Instalación

1. Descargar ISO desde [linuxmint.com](https://linuxmint.com/download.php)
2. Crear USB booteable (ver [[Creación de USB Booteable]])
3. Arrancar desde USB, elegir "Start Linux Mint"
4. Probar el escritorio en vivo (Live session) antes de instalar
5. Hacer doble clic en "Install Linux Mint"
6. Elegir idioma, zona horaria, distribucion de teclado
7. Particionado: usar "Borrar disco e instalar Linux Mint" o particionado manual
8. Crear usuario y contraseña
9. Esperar a que termine la instalación y reiniciar

## Post-instalación recomendada

Ver la guía completa en [[Post-Instalación Checklist]]. Para Mint en particular:

```bash
# 1. Actualizar sistema
sudo apt update && sudo apt upgrade -y

# 2. Instalar controladores NVIDIA si aplica
sudo apt install nvidia-driver-550

# 3. Codecs multimedia
sudo apt install mint-meta-codecs

# 4. Timeshift (snapshots del sistema)
sudo timeshift --create --comments "Post-instalacion"

# 5. Configurar firewall
sudo ufw enable

# 6. Flatpak ya viene configurado (Flathub incluido)
```

## Herramientas propias de Mint

Mint desarrolla sus propias herramientas que mejoran la experiencia de usuario:

| Herramienta | Función |
|---|---|
| **Cinnamon** | Entorno de escritorio (desarrollado por Mint) |
| **Nemo** | Gestor de archivos (fork de Nautilus) |
| **mintupdate** | Gestor de actualizaciones con niveles de riesgo |
| **mintinstall** | Tienda de software (Software Manager) |
| **mintstick** | Creador de USBs booteables |
| **mintbackup** | Herramienta de backup |
| **mintwelcome** | Pantalla de bienvenida al primer arranque |
| **xreader** | Visor de documentos (PDF, ePub, CBZ) personalizado |
| **xed** | Editor de texto personalizado |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Snap se instaló pese a estar deshabilitado | Ubuntu base incluye Firefox como snap por defecto | No ocurre en Mint (Firefox viene como .deb) |
| Repositorio PPA no funciona | PPA incompatible con la versión de Mint | Verificar LTS base: `lsb_release -a` y buscar PPA para esa versión |
| NVIDIA no detecta | Driver nouveau en lugar de nvidia | `sudo apt install nvidia-driver-550` o usar Driver Manager |
| WiFi no funciona | Falta firmware propietario | `sudo apt install linux-firmware` |
| Pantalla se congela al suspender | Problema de hibridación NVIDIA+Intel | Usar Driver Manager → elegir driver NVIDIA on-demand |
| Actualizaciones lentas | Muchos PPAs y repos | `sudo apt-add-repository -r ppa:problematico` |

## Comparativa con otras distros

| Aspecto | Linux Mint | Ubuntu | Fedora | Windows (usuario migrando) |
|---|---|---|---|---|
| **Facilidad** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | — |
| **Estabilidad** | Alta (base LTS) | Alta (LTS cada 2 años) | Alta (Fedora estable) | — |
| **Software actualizado** | Bajo (solo LTS + backports) | Medio | Alto (6 meses ciclo) | — |
| **Snap** | ❌ Deshabilitado | ✅ Por defecto | ❌ No incluido | — |
| **Flatpak** | ✅ Incluido | ⚠️ Manual | ✅ Incluido | — |
| **DE por defecto** | Cinnamon (propio) | GNOME | GNOME | — |
| **Transición Windows** | Excelente | Buena | Buena | — |
| **Público** | Hogar, principiantes | General, servidores, cloud | Desarrolladores, Sysadmin | Todos |

## Notas personales

-

## Enlaces externos

- [Sitio oficial Linux Mint](https://linuxmint.com/)
- [Blog de Linux Mint](https://blog.linuxmint.com/)
- [Wikipedia — Linux Mint](https://en.wikipedia.org/wiki/Linux_Mint)
- [Foro oficial](https://forums.linuxmint.com/)
- [Linux Mint en DistroWatch](https://distrowatch.com/table.php?distribution=mint)
- [Repositorio GitHub de Mint](https://github.com/linuxmint)
- [Guía de instalación oficial](https://linuxmint.com/download.php)

## Ver también

- [[Cinnamon]] — DE por defecto de Linux Mint
- [[Ubuntu]] — distribución base
- [[Debian]] — base de LMDE
- [[Post-Instalación Checklist]] — guía post-instalación
- [[Snap y Flatpak]] — formatos portables en Mint
- [[XFCE]] — edición ligera
- [[MATE]] — edición clásica

#distro
