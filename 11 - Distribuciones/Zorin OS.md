---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt
base: Ubuntu LTS
---

# Zorin OS

## Qué es

**Zorin OS** es una distribución basada en **Ubuntu LTS** diseñada específicamente para **migrar usuarios de Windows**. Su interfaz se asemeja intencionalmente a Windows 10/11, facilitando la transición. Incluye herramientas de familiarización y layouts intercambiables.

Creada por el equipo de **Zorin Group** (Irlanda) en 2009. Desde 2021 ofrece una versión **Core** (gratuita) y **Pro** (pago, ~40€, con más layouts y software preinstalado).

## Filosofía

- **Windows sin los problemas de Windows**: la experiencia y familiaridad de Windows, pero con la seguridad, privacidad y libertad de Linux
- **Migración sin fricción**: un usuario de Windows debe sentirse como en casa desde el primer minuto
- **Accesibilidad**: diseñado para usuarios no técnicos, incluyendo herramientas de asistencia

## Características clave

### Layouts intercambiables

Zorin OS permite cambiar la disposición del escritorio al instante:

```bash
# Cambiar layout desde Zorin Appearance
# Windows-like (por defecto) → similar a Windows 10/11
# GNOME-like                 → estilo GNOME estándar
# macOS-like                 → dock inferior + panel superior

# Desde terminal:
zorin-layout-core windows     # cambiar a layout Windows (Core)
zorin-layout-pro macos        # cambiar a layout macOS (Pro)
zorin-layout-pro gnome        # cambiar a layout GNOME (Pro)
zorin-layout-pro ubuntu       # cambiar a layout Ubuntu (Pro)
```

### Zorin Appearance

Centro de control gráfico para personalizar:

- **Themes**: cambiar tema global (oscuro, claro, acentos de color)
- **Layouts**: cambiar disposición del escritorio
- **Fonts**: tamaño y fuente del sistema
- **Desktop icons**: mostrar/ocultar iconos del escritorio
- **Transparency**: nivel de transparencia de ventanas y panel

## Ediciones

| Edición | Precio | Ideal para |
|---|---|---|
| **Zorin OS Core** | Gratis | Usuarios domésticos |
| **Zorin OS Pro** | ~40€ | Profesionales, más layouts y software |
| **Zorin OS Lite** | Gratis | Hardware antiguo (XFCE, Windows 7-like) |
| **Zorin OS Education** | Pro | Escuelas y aulas |
| **Zorin OS Enterprise** | Pro | Empresas |

## Gestor de paquetes

```bash
# Basada en Ubuntu, usa apt y Snap
sudo apt update
sudo apt install paquete

# Zorin también soporta:
# - Snap (incluido por defecto)
# - Flatpak (Flathub, añadible)
# - AppImage
```

## Instalación

```bash
# 1. Descargar ISO desde https://zorin.com/os/download/
# 2. Grabar en USB:
sudo dd if=zorin-17-core-*.iso of=/dev/sdX bs=4M status=progress
# 3. Arrancar e instalar con Ubiquity (instalador de Ubuntu)
# 4. Post-instalación:
#    - Zorin Appearance → elegir layout
#    - Zorin Connect → integración con Android (KDE Connect)
```

## Ver también

- [[Ubuntu]] — base de Zorin OS
- [[Linux Mint]] — alternativa para migrar desde Windows
- [[GNOME]] — escritorio base
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]

## Enlaces externos

- [Zorin OS — Página oficial](https://zorin.com/os/)
- [Zorin OS Help](https://help.zorin.com/)
- [Zorin Forum](https://forum.zorin.com/)
- [DistroWatch — Zorin OS](https://distrowatch.com/table.php?distribution=zorin)

#distro
