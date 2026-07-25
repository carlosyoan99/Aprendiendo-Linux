---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: APT + Flatpak + Snap
base: Debian (antes Lubuntu)
modelo_lanzamiento: Fixed
init: systemd
arquitecturas:
  - x86_64
---

# Peppermint OS

> Distribución Linux ligera que combina aplicaciones locales con **SSBs (Site-Specific Browsers)** para crear una experiencia híbrida web-escritorio. Basada en Debian con escritorio XFCE.

## Filosofía / público objetivo

Creada en 2010 con un enfoque único: en lugar de incluir aplicaciones nativas pesadas, muchas herramientas se integran como **SSBs** — accesos directos web que parecen aplicaciones nativas — mediante su herramienta **Ice**. Esto la hace extremadamente ligera en recursos y la posiciona como una distro ideal para equipos antiguos, netbooks y máquinas con poca RAM.

Está dirigida a usuarios que pasan la mayor parte del tiempo en servicios web (Gmail, YouTube, Google Docs, ChatGPT) pero quieren la flexibilidad de un sistema Linux completo para tareas locales.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Debian (Stable) / Devuan |
| **Gestor de paquetes** | APT + Flatpak + Snap |
| **Init** | systemd (Debian) / OpenRC (Devuan) |
| **Modelo** | Fixed release |
| **Entorno por defecto** | XFCE |
| **Instalador** | Calamares |
| **Ediciones** | Estándar + Peppermint Loaded |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64, 1 GHz | Dual-core 2 GHz |
| **RAM** | 2 GB | 4 GB |
| **Disco** | 10 GB | 20 GB (SSD) |
| **GPU** | Cualquier compatible con XFCE | —

Gracias a XFCE y al enfoque web-local, corre aceptablemente incluso en hardware de más de 10 años.

## SSBs y el enfoque web-local

El corazón de Peppermint es el concepto **SSB (Site-Specific Browser)** : un acceso directo que abre un servicio web en una ventana sin la interfaz completa del navegador (sin pestañas, barra de direcciones ni marcadores). Se ve y se siente como una aplicación nativa.

```bash
# Crear un SSB con Ice
ice --name "Gmail" --url "https://mail.google.com" --icon gmail

# Listar SSBs instalados
ice --list

# Eliminar un SSB
ice --remove "Gmail"
```

Ice se integra con el menú de aplicaciones de XFCE, permitiendo lanzar Gmail, YouTube Music o ChatGPT como si fueran apps instaladas. Esto reduce drásticamente el consumo de RAM frente a tener un navegador completo abierto todo el día.

## Herramientas propias

- **Ice**: crea y gestiona SSBs web con icono propio, ventana sin chrome y acceso desde el menú
- **Peppermint Hub**: centro de configuración unificado para sistema, apariencia y herramientas
- **Welcome to Peppermint**: asistente post-instalación para instalar paquetes, temas y navegadores
- **xDaily**: GUI ligera para mantenimiento del sistema (limpieza de paquetes, caché, logs)
- **pfetch**: reemplazo minimalista de Neofetch (menos dependencias, más rápido)
- **Btop++**: monitor de procesos y recursos incluido como reemplazo de Htop

## Edición Peppermint Loaded

Además de la edición estándar (mínima, el usuario elige qué instalar), existe **Peppermint Loaded**, pensada para quienes prefieren un sistema listo al primer arranque:

- Firefox + extensiones básicas
- LibreOffice (suite ofimática completa)
- GIMP (editor de imágenes)
- Thunderbird (cliente de correo)
- Timeshift (backups del sistema)
- Flatpak habilitado por defecto

## Gestor de paquetes

Al estar basada en Debian, usa APT con soporte adicional para Flatpak y Snap.

```bash
# Actualizar repos e instalar actualizaciones
sudo apt update && sudo apt upgrade -y

# Buscar e instalar un paquete
apt search chromium
sudo apt install chromium -y

# Eliminar paquete y dependencias no usadas
sudo apt remove --purge chromium
sudo apt autoremove --purge

# Flatpak para aplicaciones sandboxed
flatpak install flathub org.chromium.Chromium
flatpak run org.chromium.Chromium
```

Ver [[Gestores de Paquetes]] y [[apt]].

## Lanzamientos principales

| Versión | Fecha | Base |
|---|---|---|
| One | 2010-05 | Lubuntu 10.04 |
| 7 | 2016-06 | Lubuntu 16.04 |
| 10 | 2019-05 | Lubuntu 18.04 |
| 2022-02 | 2022-02 | Debian 11 |
| 2026 (actual) | 2025 | Debian 13 (Trixie) / Devuan |

### Cambio de base

Hasta 2019, Peppermint se basaba en Lubuntu (Ubuntu + LXDE). En 2022 migró a **Debian (Stable)** para mayor estabilidad y control sobre el ciclo de lanzamientos. Desde entonces ofrece también una edición con **Devuan** (Debian sin systemd) para usuarios que prefieren OpenRC o runit.

## Comparativa con alternativas ligeras

| Aspecto | Peppermint OS | Linux Lite | LXLE Linux | MX Linux |
|---|---|---|---|---|
| **Enfoque** | Híbrido web-local | Migración Windows | Revivir hardware viejo | Rendimiento + herramientas |
| **Entorno** | XFCE | XFCE | LXDE | XFCE |
| **Peso RAM** | ~300 MB | ~500 MB | ~350 MB | ~400 MB |
| **Base** | Debian | Ubuntu LTS | Ubuntu LTS | Debian |
| **Público** | Usuarios cloud | Migrantes Windows | Hardware muy antiguo | Usuarios avanzados |

Ver [[Linux Lite]], [[Debian]], [[XFCE]].

## Estado actual (2026)

El proyecto continúa activo aunque es mantenido principalmente por la comunidad. Tras el fallecimiento de su creador original (Mark Greaves, 2020), el equipo reorganizó el desarrollo y lanzó versiones basadas en Debian. Hoy sigue siendo una opción sólida para equipos con recursos limitados que dependen de aplicaciones web.

## Enlaces externos

- [Sitio oficial](https://peppermintos.com/)
- [Wikipedia — Peppermint OS](https://es.wikipedia.org/wiki/Peppermint_OS)
- [DistroWatch](http://distrowatch.com/table.php?distribution=peppermint)
- [GitHub — Peppermint OS](https://github.com/PeppermintOS)

## Ver también

- [[XFCE]] — escritorio por defecto
- [[Debian]] — distribución base
- [[Linux Lite]] — alternativa ligera
- [[apt]] — gestor de paquetes
- [[Gestores de Paquetes]] — comparativa general

#distro #ligera #hibrida
