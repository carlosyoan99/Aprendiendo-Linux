---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# Genkernel

## Definición

**Genkernel** es una herramienta de **Gentoo Linux** que automatiza la configuración y compilación del kernel Linux. Está diseñada para usuarios que no quieren (o no saben) configurar manualmente las opciones del kernel (`make menuconfig`), ofreciendo un kernel genérico que funciona en la mayoría del hardware mediante módulos cargables.

Genkernel compila el kernel con **todos los controladores como módulos** (no compilados estáticamente) y genera un **initramfs** que detecta automáticamente el hardware al arrancar. Esto hace que el kernel resultante sea muy compatible, aunque más grande y ligeramente más lento que uno afinado a mano.

## Cuándo usar genkernel

| Situación | Recomendación |
|---|---|
| **Primera instalación de Gentoo** | ✅ Genkernel — simplifica el proceso enormemente |
| **Quieres aprender a configurar kernels** | ⚠️ Genkernel como paso intermedio, luego `make menuconfig` |
| **Mismo kernel en varios equipos diferentes** | ✅ Genkernel genera un kernel genérico portátil |
| **Rendimiento máximo / kernel mínimo** | ❌ Mejor configuración manual (`make menuconfig`) |
| **Servidor con hardware conocido** | ❌ Preferible kernel manual sin initramfs |

## Modos de operación

| Modo | Qué hace |
|---|---|
| `all` | Compila kernel, módulos y genera initramfs (el más usado) |
| `kernel` | Solo compila kernel y módulos (sin initramfs) |
| `bzImage` | Solo compila la imagen del kernel |
| `initramfs` | Solo genera el initrd/initramfs |
| `ramdisk` | Solo genera el initrd en formato ramdisk |

## Uso básico

```bash
# Uso más común: compilar todo (kernel + módulos + initramfs)
genkernel all

# Compilar solo kernel y módulos (sin initramfs)
genkernel kernel

# Usar una configuración de kernel existente
genkernel --kernel-config=/ruta/a/.config all

# Compilar con opciones personalizadas
genkernel --menuconfig all    # abre menuconfig antes de compilar

# Compilar solo el initramfs
genkernel initramfs
```

## Opciones frecuentes

| Flag | Efecto |
|---|---|
| `--menuconfig` | Abre el menú interactivo de configuración antes de compilar |
| `--no-clean` | No limpiar fuentes antes de compilar (ahorra tiempo en recompilaciones) |
| `--no-mrproper` | No ejecutar `make mrproper` (útil para recompilar sin reiniciar) |
| `--kernel-config=ARCHIVO` | Usar un archivo .config específico |
| `--udev` | Incluir soporte para udev en el initramfs |
| `--lvm` | Incluir soporte LVM en el initramfs |
| `--mdadm` | Incluir soporte RAID (mdadm) en el initramfs |
| `--luks` | Incluir soporte para cifrado LUKS en el initramfs |
| `--firmware` | Incluir firmware adicional en el initramfs |
| `--save-config` | Guardar la configuración generada para usarla después |

## Plataformas soportadas

| Arquitectura | Soporte |
|---|---|
| Alpha | ✅ |
| Amd64 (x86_64) | ✅ (la más usada) |
| ARM | ⚠️ Experimental |
| HPPA (Parisc / Parisc64) | ✅ |
| PPC / PPC64 | ✅ |
| SPARC / Sparc64 | ✅ |
| x86 (32-bit) | ✅ |

## Ejemplo completo

```bash
# 1. Emerge genkernel
sudo emerge --ask sys-kernel/genkernel

# 2. Compilar kernel con initramfs y soporte LUKS+LVM
sudo genkernel --lvm --luks --menuconfig all

# 3. Los archivos generados están en /boot/
ls /boot/kernel-* /boot/initramfs-*

# 4. Configurar el bootloader para usar el nuevo kernel
# (GRUB: sudo grub-mkconfig -o /boot/grub/grub.cfg)
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `Could not find the kernel sources` | No están instalados | `sudo emerge --ask sys-kernel/gentoo-sources` |
| Kernel compilado pero no arranca | Falta un módulo esencial en initramfs | Usar `--lvm --luks --mdadm --firmware` según necesidades |
| Espacio en /boot insuficiente | Muchos kernels acumulados | Limpiar kernels viejos: `sudo emerge --depclean` |
| Compilación muy lenta | CPUs limitados | Usar `MAKEOPTS="-j$(nproc)"` en `/etc/portage/make.conf` |

## Notas personales

- Genkernel es el equivalente a usar la opción "default" del kernel en Ubuntu/Debian — funciona, pero no está optimizado
- Para un sistema Gentoo de escritorio con discos NVMe/LUKS/LVM, usa: `genkernel --lvm --luks --firmware --menuconfig all`
- Tras dominar genkernel, el siguiente paso natural es aprender a configurar el kernel a mano (distro-kernel, manual, o usando `git-sources`)
- Genkernel no se usa fuera de Gentoo — otras distros tienen sus propias herramientas (mkinitcpio, dracut, update-initramfs)

## Enlaces externos

- [Documentación oficial de Genkernel (Gentoo)](https://wiki.gentoo.org/wiki/Genkernel)
- [Genkernel en español](https://wiki.gentoo.org/wiki/Genkernel/es)
- [Wikipedia — Genkernel](https://es.wikipedia.org/wiki/Genkernel)
- [Gentoo Wiki: Configuración manual del kernel](https://wiki.gentoo.org/wiki/Kernel/Configuration)

## Ver también

- [[Compilación desde Código Fuente]] — compilar software en Linux
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — qué hace el initramfs
- [[Módulos del kernel (lsmod modprobe blacklist)]] — gestión de módulos

#programa #gentoo #kernel
