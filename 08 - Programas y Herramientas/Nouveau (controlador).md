---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# Nouveau (controlador)

## Definición

**Nouveau** es el controlador de **código abierto** para tarjetas gráficas NVIDIA en Linux. Es el resultado de un proyecto de ingeniería inversa sobre los controladores propietarios de NVIDIA y su hardware, desarrollado por la **X.Org Foundation** y **freedesktop.org**. El nombre significa "nuevo" en francés.

Nouveau es el **controlador por defecto** en la mayoría de distribuciones Linux para GPUs NVIDIA. Está incluido en el kernel Linux y en Mesa (drivers 3D), lo que significa que funciona "out of the box" sin instalar nada adicional.

## Nouveau vs NVIDIA Proprietario

| Aspecto | Nouveau (libre) | nvidia (propietario) |
|---|---|---|
| **Licencia** | MIT / GPL | Propietaria (EULA) |
| **Instalación** | Incluido en el kernel | Manual (o desde repositorio no-libre) |
| **Rendimiento 3D** | ⭐⭐ Bajo (5-30% del rendimiento propietario) | ⭐⭐⭐⭐⭐ Completo |
| **OpenGL/Vulkan** | OpenGL básico (Gallium), sin Vulkan | OpenGL completo, Vulkan completo |
| **CUDA/Optix** | ❌ No | ✅ Sí |
| **Wayland** | ⚠️ Limitado (sin aceleración) | ✅ Buen soporte (desde driver 470+) |
| **Ahorro energía (Powermizer)** | ❌ No gestiona bien | ✅ Completo (PowerMizer, optimus) |
| **Múltiples monitores** | ✅ Básico | ✅ Completo |
| **Soporte GPUs modernas** | ⚠️ Limitado (requiere firmware firmado) | ✅ Completo |
| **Instalación** | Automática (driver genérico en kernel) | Manual (nvidia-detect, nvidia-installer) |

## ¿Cuándo usar cada uno?

### Usa Nouveau cuando:
- Solo necesitas el escritorio básico (2D, interfaz gráfica)
- No juegas ni usas aplicaciones 3D/CUDA
- Quieres un sistema 100% libre (sin blobs propietarios)
- Tienes una GPU NVIDIA muy antigua (GeForce 8xxx a 7xx)
- Estás en un portátil y solo usas NVIDIA para el escritorio

### Usa el driver NVIDIA cuando:
- Juegas o usas Steam/Proton
- Necesitas CUDA (Machine Learning, minería, cómputo)
- Usas aplicaciones 3D profesionales (Blender, DaVinci Resolve)
- Tienes una GPU moderna (RTX 20xx/30xx/40xx/50xx)
- Quieres el máximo rendimiento gráfico

## Identificar qué driver está en uso

```bash
# Ver qué driver está cargado
lsmod | grep -E 'nvidia|nouveau'

# Si ves nouveau → driver libre activo
# Si ves nvidia → driver propietario activo

# Ver renderizador OpenGL
glxinfo | grep "OpenGL renderer"
# Nouveau: "Gallium 0.4 on NVxxx"
# NVIDIA: "NVIDIA Corporation GeForce RTX ..."

# Con DRI
lspci -k | grep -A 3 -i VGA
```

## Instalación

```bash
# Nouveau ya viene instalado en el kernel — no requiere acción

# Para instalar el driver NVIDIA propietario (reemplaza Nouveau):
# Debian/Ubuntu
sudo apt install nvidia-driver-550   # o 545, 535 según GPU

# Arch
sudo pacman -S nvidia nvidia-utils

# Fedora
sudo dnf install akmod-nvidia

# Tras instalar, reiniciar
sudo reboot
```

## Cambiar entre Nouveau y NVIDIA

```bash
# Blacklistear Nouveau (para usar NVIDIA)
echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u   # regenerar initramfs
sudo reboot

# Revertir: eliminar el blacklist y regenerar
sudo rm /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u
sudo reboot
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Pantalla negra al arrancar con Nouveau | GPU muy moderna, Nouveau no la soporta bien | `nomodeset` en parámetros del kernel, o instalar NVIDIA |
| Bajo rendimiento 3D | Nouveau no soporta reclocking (frecuencia fija mínima) | Solución: instalar driver NVIDIA |
| Artefactos gráficos | Nouveau + GPU moderna con firmware firmado | Intentar instalar firmware de GPU: `sudo apt install firmware-misc-nonfree` |
| Portátil: NVIDIA no se apaga | Nouveau no gestiona Optimus | Usar `bbswitch` o instalar NVIDIA + optimus-manager |

## Notas personales

- Nouveau es un proyecto admirable de ingeniería inversa, pero en la práctica el driver propietario de NVIDIA es necesario si quieres hacer algo más que el escritorio básico
- La brecha de rendimiento es enorme: Nouveau apenas alcanza un 5-30% del rendimiento 3D del driver propietario
- NVIDIA ha dificultado deliberadamente la ingeniería inversa con GPUs modernas (firmware firmado, GPU Boost cerrado)
- Si valoras el software libre, Nouveau es el camino — pero asume limitaciones importantes
- Para servidores headless (sin monitor), Nouveau funciona bien para tareas 2D y terminal

## Enlaces externos

- [Sitio oficial de Nouveau](https://nouveau.freedesktop.org/)
- [Wikipedia — Nouveau (controlador)](https://es.wikipedia.org/wiki/Nouveau_(controlador))
- [Arch Wiki — Nouveau](https://wiki.archlinux.org/title/Nouveau)
- [NVIDIA drivers en Arch Wiki](https://wiki.archlinux.org/title/NVIDIA)
- [Phoronix — Cobertura de Nouveau](https://www.phoronix.com/search/Nouveau)

## Ver también

- [[NVIDIA no detecta]] — troubleshooting de GPU NVIDIA
- [[Audio en Linux]] — otros subsistemas de hardware en Linux
- [[Wayland vs X11]] — qué controlador usar con cada uno
- [[Videojuegos en Linux]] — dependencia del driver gráfico

#concepto #graficos #nvidia #drivers
