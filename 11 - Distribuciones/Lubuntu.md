---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-08-31
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

## Filosofía / público objetivo

Lubuntu ofrece una experiencia Ubuntu **ligera y funcional** usando LXQt (el sucesor de LXDE). Desde 2018 cambió su enfoque:

> **Antes**: «más ligera, con menos recursos, más eficiente energéticamente» — orientada a PCs muy antiguos (10+ años).

> **Ahora**: «una distribución funcional y modular que no estorbe y deje al usuario usar su computadora» — ligera por defecto, pero no exclusivamente para hardware antiguo.

- **Público**: usuarios con hardware limitado o que quieren un sistema rápido
- **Enfoque**: ligereza + funcionalidad Ubuntu + LTS estable
- **Ventaja sobre Ubuntu standard**: ~350 MB RAM idle vs ~1 GB

## Historia

| Hito | Fecha |
|---|---|
| Primer paquete LXDE para Ubuntu | Octubre 2008 |
| Proyecto Lubuntu creado en Launchpad | Marzo 2009 |
| Reconocimiento oficial como sabor Ubuntu | Mayo 2011 |
| Primera LTS (14.04) | Abril 2014 |
| Transición a LXQt | 2017–2018 |
| Lubuntu 18.10 — primera versión LXQt | Octubre 2018 |
| Lubuntu 24.04 LTS | Abril 2024 |

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Ubuntu (LTS + intermedias) |
| **Gestor de paquetes** | APT + dpkg |
| **Init** | systemd |
| **Entorno** | LXQt (Qt-based, sucesor de LXDE) |
| **RAM idle** | ~350 MB |
| **Ideal para** | Hardware con 1-4 GB RAM |

### Aplicaciones incluidas (LXQt)

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
| **Notas** | Featherpad (editor), Noblenote |
| **Tienda** | Discover (KDE) |
| **Bluetooth** | Bluedevil |

## Requisitos

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Pentium 4 / AMD K8 | Dual-core 1 GHz+ |
| **RAM** | 512 MB | 1-2 GB |
| **Disco** | 5 GB | 10 GB (SSD) |
| **PAE** | Necesario (CPU de 2008+) | — |

## Instalación

```bash
# Descargar ISO desde lubuntu.me
# Hay dos ediciones:
# 1. Lubuntu (recomendada) — con Firefox, LibreOffice, etc.
# 2. Lubuntu Minimal — solo escritorio base, el usuario instala lo que necesite

# Grabar ISO:
sudo dd if=lubuntu.iso of=/dev/sdX bs=4M status=progress

# Requisitos de instalación:
# - Conexión a internet (para actualizaciones)
# - EFI/UEFI o Legacy BIOS (soporta ambos)
```

## Configuración post-instalación

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar codecs multimedia
sudo apt install ubuntu-restricted-extras

# Habilitar Flatpak
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Cambiar tema LXQt
# Panel inferior → Preferences → LXQt Settings → Appearance

# Optimizar para hardware muy viejo
sudo apt remove --purge libreoffice-* thunderbird   # ahorrar ~500 MB
sudo apt autoremove --purge
```

## Comparativa con alternativas ligeras

| Aspecto | Lubuntu | Linux Lite | MX Linux | Peppermint | Bodhi |
|---|---|---|---|---|---|
| **Base** | Ubuntu | Ubuntu LTS | Debian | Debian | Ubuntu LTS |
| **Entorno** | LXQt | XFCE | XFCE | XFCE | Moksha (E17) |
| **RAM idle** | ~350 MB | ~500 MB | ~400 MB | ~300 MB | ~300 MB |
| **Oficina incluida** | LibreOffice | LibreOffice | LibreOffice | Opcional | ❌ |
| **LTS** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Curva aprendizaje** | Baja | Baja (GUI Windows) | Media | Baja | Baja |
| **Hardware viejo (2 GB RAM)** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Pantalla negra al arrancar | NVIDIA driver incompatible con LXQt | Cambiar a X11 en lightdm: `sudo lightdm-defaults` |
| LXQt muy lento en 512 MB RAM | Demasiadas apps en autostart | Desactivar apps innecesarias en LXQt Settings → Autostart |
| Firefox consume mucha RAM | Firefox usa ~500 MB+ | Usar navegador más ligero (Falkon) o añadir swap |
| No detecta WiFi | Firmware no incluido | `sudo apt install firmware-iwlwifi` (Intel) o usar Ethernet |
| Panel inferior no aparece | lxqt-panel crash | Ejecutar `lxqt-panel` manualmente o reinstalar: `sudo apt install --reinstall lxqt-panel` |
| Actualización a nueva LTS falla | Upgrade entre versiones | Hacer `sudo do-release-upgrade -d` o ISO limpia |

## Ver también

- [[Ubuntu]] — distribución base
- [[LXQt]] — escritorio por defecto
- [[XFCE]] — alternativa ligera similar
- [[Linux Lite]] — otra distro ligera para Windows refugees
- [[MX Linux]] — distro ligera basada en Debian
- [[PCManFM-Qt]] — gestor de archivos de LXQt

## Enlaces externos

- [Sitio oficial](https://lubuntu.me/)
- [Wikipedia — Lubuntu](https://es.wikipedia.org/wiki/Lubuntu)
- [Lubuntu en Launchpad](https://launchpad.net/lubuntu)
- [Lubuntu Documentation](https://manual.lubuntu.me/)
- [DistroWatch](https://distrowatch.com/table.php?distribution=lubuntu)

#distribucion #ubuntu #ligera #lxqt
