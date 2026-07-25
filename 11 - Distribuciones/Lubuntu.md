---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: apt (dpkg)
base: Ubuntu
entorno_grafico: LXQt (antes LXDE)
modelo_lanzamiento: LTS + versiones intermedias
init: systemd
arquitecturas:
  - amd64
  - i386 (descontinuado)
---

# Lubuntu

> Distribución ligera basada en **Ubuntu** que usa **LXQt** como escritorio. Reconocida oficialmente como sabor de Ubuntu en 2011. Ideal para equipos con recursos limitados o usuarios que buscan un escritorio rápido y moderno.

## Historia

| Hito | Fecha |
|---|---|
| Primer paquete LXDE para Ubuntu | Octubre 2008 |
| Proyecto Lubuntu creado en Launchpad | Marzo 2009 |
| Primer ISO de prueba | Agosto 2009 |
| Reconocimiento oficial como sabor Ubuntu | Mayo 2011 |
| Primera LTS (14.04) | Abril 2014 |
| Transición a LXQt | 2017–2018 |
| Lubuntu 18.10 — primera versión LXQt | Octubre 2018 |
| Lubuntu 24.04 LTS | Abril 2024 |

Originalmente usaba **LXDE** (basado en GTK2). Con la fusión de LXDE y Razor-qt, el escritorio migró a **LXQt** (basado en Qt). La transición se completó con Lubuntu 18.10.

## Filosofía

A partir de 2018, Lubuntu cambió su enfoque:

> **Antes**: «más ligera, con menos recursos, más eficiente energéticamente» — orientada a PCs muy antiguos (10+ años).

> **Ahora**: «una distribución funcional y modular que no estorbe y deje al usuario usar su computadora» — ligera por defecto, pero no exclusivamente para hardware antiguo.

## Aplicaciones incluidas (LXQt)

| Categoría | Aplicaciones |
|---|---|
| **Navegación** | Firefox |
| **Oficina** | LibreOffice (Writer, Calc, Impress, Math) |
| **Archivos** | PCManFM-Qt (gestor de archivos) |
| **Terminal** | QTerminal |
| **PDF** | qpdfview |
| **Multimedia** | VLC, K3b, control volumen PulseAudio |
| **Imagen** | lximage-qt, Skanlite (escáner) |
| **Correo** | Trojitá |
| **IRC** | Quassel |
| **Notas** | Featherpad (editor), Noblenote |
| **Tienda** | Discover (KDE) |
| **Bluetooth** | Bluedevil |

## Instalación

```bash
# Requisitos mínimos recomendados:
# - RAM: 1 GB (512 MB mínimo)
# - CPU: Pentium 4 / AMD K8 o superior
# - PAE necesario (CPU de 2008+)

# Descargar ISO desde lubuntu.me
# Grabar con:
sudo dd if=lubuntu.iso of=/dev/sdX bs=4M status=progress
```

## Enlaces externos

- [Sitio oficial](https://lubuntu.me/)
- [Wikipedia — Lubuntu](https://es.wikipedia.org/wiki/Lubuntu)
- [Lubuntu en Launchpad](https://launchpad.net/lubuntu)

## Ver también

- [[Ubuntu]] — distribución base
- [[DEs adicionales (Budgie Deepin Enlightenment LXQt MATE Pantheon Sugar Trinity)|LXQt]] — escritorio por defecto
- [[XFCE]] — alternativa ligera similar
- [[Linux Lite]] — otra distro ligera para Windows refugees
- [[MX Linux]] — distro ligera basada en Debian

#distro #ubuntu #ligera #lxqt
