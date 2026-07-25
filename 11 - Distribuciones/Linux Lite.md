---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
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

> Distribución Linux ligera basada en **Ubuntu LTS** con escritorio **XFCE**, diseñada específicamente para **migrantes de Windows** con hardware modesto. Fundada en Nueva Zelanda por Jerry Bezencon (2012).

## Filosofía / público objetivo

Linux Lite nació en 2012 cuando Ubuntu adoptó Unity y muchos usuarios de Windows XP buscaban un reemplazo ligero y familiar. Su objetivo es **introducir a usuarios de Windows en Linux** con una interfaz similar a Windows XP/7, funcionando en hardware antiguo.

Lema: *"Simple, rápido, libre"* (*Simple, fast, free*).

A diferencia de otras distros, los menús de Linux Lite listan el software por **qué hace** (ej: "Editor de imágenes") en vez del nombre técnico ("GIMP"), reduciendo la fricción para quien viene de Windows.

> Opinión: Críticos avanzados la consideran "simplificada en exceso", pero para su público objetivo (migrantes Windows con hardware antiguo) cumple perfectamente — es estable, familiar y no requiere terminal.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Ubuntu LTS (actual: 24.04) |
| **Gestor de paquetes** | APT + Lite Software + Synaptic |
| **Init** | systemd |
| **Modelo** | Fixed (cada 2 años sobre LTS) |
| **Entorno por defecto** | XFCE personalizado (tema Windows-like) |
| **Instalador** | Ubiquity |
| **Snap/Flatpak** | No incluidos por defecto (usan APT nativo) |
| **Solo 64-bit** | Desde Linux Lite 6.x |
| **Desarrollador** | Jerry Bezencon (Nueva Zelanda) |

### Software propio (herramientas para migrantes)

| Herramienta | Función |
|---|---|
| **Lite Welcome** | Pantalla de bienvenida al primer inicio — "Start Here" con acceso a updates, drivers, restore points y temas |
| **Lite Tweaks** | Centro de mantenimiento: limpieza del sistema, gestión de kernels antiguos, reparación de paquetes rotos |
| **Lite Software** | Instalador gráfico por checkboxes de apps populares (Chrome, Steam, VirtualBox, codecs, Java) |
| **Lite User Manager** | Gestión gráfica de usuarios del sistema |
| **Lite Manual** | Guía del sistema en ventana (cubre primeros pasos, troubleshooting común) |
| **Lite Fix** | Reparación automática de problemas comunes (gestor de paquetes, permisos, GRUB) |

### Software incluido por defecto

| Categoría | Aplicación |
|---|---|
| **Navegador** | Google Chrome (por defecto) + Firefox |
| **Oficina** | LibreOffice (Writer, Calc, Impress) |
| **Correo** | Thunderbird |
| **Multimedia** | VLC, GIMP, Audacity |
| **Utilidades** | Timeshift (backups del sistema), Synaptic, GParted |
| **Juegos** | Steam (instalable vía Lite Software) |

## Requisitos del sistema (actualizados para Linux Lite 7.x)

| Componente | Mínimo (6.x) | Recomendado (7.x) |
|---|---|---|
| **CPU** | 1 GHz | 1.5 GHz Dual Core |
| **RAM** | 768 MB | 4 GB |
| **Disco** | 8 GB | 40 GB (SSD recomendado) |
| **Pantalla** | 1024×768 | 1366×768 o superior |

> Linux Lite funciona bien en equipos de ~2010-2015 con 4 GB RAM y SSD. No esperes fluidez con 768 MB — el mínimo es realista pero incómodo con navegación web moderna.

## Migración desde Windows: qué esperar

| Concepto Windows | Equivalente en Linux Lite |
|---|---|
| **Inicio** | Menú Whisker (similar al menú Inicio clásico) |
| **Explorador de archivos** | Thunar (similar al explorador de Windows) |
| **Panel de control** | Configuración de XFCE + Lite Tweaks |
| **Restaurar sistema** | Timeshift (snapshots del sistema completo) |
| **msconfig** | Lite Tweaks (gestión de inicio y servicios) |
| **Administrador de dispositivos** | Lite Driver Manager (drivers NVIDIA, WiFi, impresoras) |
| **Windows Update** | Lite Updates (wrapper de APT más amigable) |
| **Programas y características** | Lite Software (instalación guiada) |

### 5 diferencias clave para el migrante

1. **No hay .exe** — Las apps se instalan desde el centro de software o con `apt`, no descargando .exe
2. **No hay C:\** — El sistema de archivos empieza en `/`, no en `C:`
3. **No hace falta antivirus** — La seguridad de Linux y la estructura de permisos lo hacen innecesario
4. **Las actualizaciones no requieren reinicio** — Casi ningún cambio necesita reboot (excepto el kernel)
5. **Wine no es magia** — Las apps de Windows no corren igual; mejor buscar alternativas nativas

### Alternativas nativas a software Windows

| App Windows | Alternativa en Linux Lite |
|---|---|
| **Microsoft Office** | LibreOffice |
| **Photoshop** | GIMP |
| **Outlook** | Thunderbird |
| **Chrome** | Chrome (nativo) |
| **Notepad++** | Mousepad (viene incluido) |
| **Paint.NET** | GIMP o Pinta |
| **iTunes** | VLC + Clementine |
| **Visual Studio** | VS Code (instalable vía Lite Software) |

## Lanzamientos principales

| Versión | Nombre | Base Ubuntu | Fecha | Soporte hasta |
|---|---|---|---|---|
| 1.0 | Amethyst | 12.04 | 2012-10 | 2017 |
| 2.0 | Beryl | 14.04 | 2014-06 | 2019 |
| 3.0 | Citrine | 16.04 | 2016-05 | 2021 |
| 4.0 | Diamond | 18.04 | 2018-05 | 2023 |
| 5.0 | Emerald | 20.04 | 2020-05 | 2025 |
| 6.x | Fluorite | 22.04 | 2022-05 | 2027 |
| **7.x** | **Galena** | **24.04** | **2024-05** | **2029** |

## Linux Lite vs otras distros para migrantes

| Aspecto | Linux Lite | Zorin OS | Linux Mint | LXLE |
|---|---|---|---|---|
| **Base** | Ubuntu LTS | Ubuntu LTS | Ubuntu LTS | Ubuntu LTS |
| **DE** | XFCE custom | GNOME custom | Cinnamon | LXDE |
| **RAM mínima** | 768 MB | 2 GB | 2 GB | 512 MB |
| **Estilo Windows** | XP/7 | Win 7/10/11 | XP/7 | XP |
| **Público** | Migrantes + hardware modesto | Migrantes + moderno | Migrantes + usuarios general | Hardware muy antiguo |
| **Soporte** | 5 años (LTS) | 5 años (LTS) | 5 años (LTS) | 5 años (LTS) |

## Enlaces externos

- [Sitio oficial](https://www.linuxliteos.com/)
- [Wikipedia — Linux Lite](https://es.wikipedia.org/wiki/Linux_Lite)
- [DistroWatch](http://distrowatch.com/table.php?distribution=lite)
- [Linux Lite 7.6 Review — FOSS Force](https://fossforce.com/2025/09/linux-lite-7-6-plenty-for-windows-refugees-but-too-dumbed-down-for-comfort/)

## Ver también

- [[XFCE]] — escritorio por defecto (personalizado con tema Windows-like)
- [[Ubuntu]] — distribución base (LTS)
- [[Linux Mint]] — distro amigable similar, más popular
- [[Zorin OS]] — otra distro estilo Windows, más moderna
- [[LXLE Linux]] — alternativa ligera similar para hardware aún más antiguo
- [[De Windows a Linux]] — guía completa de migración

#distro #ligera #principiantes
