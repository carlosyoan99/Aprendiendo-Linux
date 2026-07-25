---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt + Flatpak (AppCenter)
base: Ubuntu LTS
---

# elementary OS

## Qué es

**elementary OS** es una distribución basada en **Ubuntu LTS** que se destaca por su **diseño cuidado y coherente**. Usa el escritorio **Pantheon** (propio) y sigue una filosofía de diseño similar a macOS: minimalista, elegante y centrado en la experiencia de usuario.

Creada por **Danielle Foré** y el equipo de **elementary, Inc.** en 2011. Originalmente un set de temas para Ubuntu, evolucionó hasta convertirse en una distribución independiente con su propio ecosistema de aplicaciones.

## Filosofía

- **Diseño primero**: cada detalle está cuidado — tipografía, espaciado, colores, animaciones
- **Coherencia**: todas las apps nativas siguen el **elementary HIG** (Human Interface Guidelines)
- **Pay What You Want**: el sistema se descarga gratis, se sugiere un pago voluntario
- **Privacidad**: sin publicidad, sin recolección de datos, sin bloatware
- **Curated experience**: el AppCenter solo incluye apps que siguen los HIG

## Características clave

### Escritorio Pantheon

Pantheon es un escritorio completo con personalidad propia:

- **Panel superior**: similar a macOS, con menú de aplicaciones, indicadores de fecha/red/batería
- **Dock inferior**: lanzador de aplicaciones favoritas + apps abiertas
- **Centro de notificaciones**: panel deslizante desde la derecha
- **Multitasking View**: vista de escritorios virtuales con gestos y atajos
- **Workspaces**: escritorios virtuales con animaciones fluidas

### Apps nativas diseñadas para Pantheon

| App | Propósito |
|---|---|
| **Files** (Pantheon Files) | Gestor de archivos con vista de fotos, integración cloud |
| **Music** (Noise) | Reproductor de música minimalista |
| **Videos** | Reproductor de video integrado |
| **Photos** | Visor y organizador de fotos |
| **Calendar** | Calendario con integración de calendarios online |
| **Mail** | Cliente de correo elegante |
| **Epiphany (Web)** | Navegador web GNOME Web |
| **Code** (Scratch) | Editor de texto/IDE ligero |
| **AppCenter** | Tienda de aplicaciones curada |
| **Sideload** | Instalador de Flatpaks externos |

### AppCenter

Tienda de aplicaciones con **pago sugerido** (pay what you want):

```bash
# Las apps del AppCenter se pagan si quieres
# También puedes instalarlas gratis desde la misma página
# Las apps siguen los HIG de elementary → interfaz coherente

# Sideload (instalar .flatpakref externos)
# Arrastrar archivo .flatpakref a Sideload para instalar
```

## Gestor de paquetes

```bash
# Basada en Ubuntu, usa apt
sudo apt update
sudo apt install paquete

# AppCenter (Flatpak) es el método recomendado para apps
# Terminal queda para desarrollo y utilidades del sistema

# Muchas apps de escritorio se instalan mejor vía AppCenter/Flatpak
# que vía apt, para mantener la coherencia visual
```

## Instalación

```bash
# 1. Descargar ISO desde https://elementary.io/ (pago sugerido)
# 2. Grabar en USB:
sudo dd if=elementaryos-*.iso of=/dev/sdX bs=4M status=progress
# 3. Arrancar e instalar
# 4. Post-instalación:
#    - Abrir AppCenter → instalar apps
#    - Configurar servicios online: Calendar, Mail, Online Accounts
#    - Ajustar dock y preferencias del sistema
```

## Ver también

- [[Ubuntu]] — base de elementary OS
- [[GNOME]] — Pantheon usa GTK y Mutter como base
- [[Snap y Flatpak]] — AppCenter usa Flatpak como backend
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]

## Enlaces externos

- [elementary OS — Página oficial](https://elementary.io/)
- [elementary Blog](https://blog.elementary.io/)
- [elementary Developer Docs (HIG)](https://docs.elementary.io/develop/)
- [AppCenter](https://appcenter.elementary.io/)
- [Wikipedia — elementary OS](https://en.wikipedia.org/wiki/Elementary_OS)

#distro
