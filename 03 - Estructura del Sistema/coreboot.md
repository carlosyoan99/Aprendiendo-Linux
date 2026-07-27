---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: media
---

# coreboot

> Proyecto de firmware libre que reemplaza el BIOS/UEFI propietario de las placas base con un BIOS mínimo, rápido y de código abierto. Originalmente llamado **LinuxBIOS**.

## Qué es

coreboot es un proyecto iniciado en 1999 en el **Los Alamos National Laboratory** que busca reemplazar el firmware propietario (BIOS/UEFI) con una alternativa **libre y ligera**. A diferencia de un BIOS tradicional que incluye miles de líneas de código propietario, coreboot solo realiza las tareas mínimas necesarias para inicializar el hardware y cargar un sistema operativo moderno de 32 o 64 bits.

Es respaldado por la **Free Software Foundation** (FSF) y está licenciado bajo **GNU GPL**. Contribuyentes principales han sido AMD, LANL, Google y fabricantes de placas como MSI, Gigabyte y Tyan.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Creador** | Los Alamos National Laboratory (1999) |
| **Licencia** | GNU GPL |
| **Patrocinadores** | Google, AMD, LANL, MSI, Gigabyte |
| **Arranque** | Modo 32 bits tras tan solo 16 instrucciones en x86 |
| **Récord** | 3 segundos de arranque en frío hasta la línea de comandos |
| **Sistemas soportados** | Linux, FreeBSD, Plan 9, Windows (vía ADLO) |
| **Arquitecturas** | x86, x86_64, ARM, RISC-V, MIPS |

## Cómo funciona

A diferencia del BIOS/UEFI propietario, coreboot:

1. Inicializa el hardware mínimo (CPU, chipset, RAM, puerto serie)
2. Carga una **carga útil** (payload) — puede ser un gestor de arranque (GRUB), un kernel Linux directamente, o un firmware adicional (SeaBIOS para compatibilidad UEFI)
3. Pasa el control al payload

```
┌──────────────────────────────────────────┐
│          coreboot (firmware mínimo)       │
├──────────────────────────────────────────┤
│  Inicializa: CPU, chipset, RAM, puertos   │
│  Modo protegido 32 bits desde el inicio   │
└──────────────────┬───────────────────────┘
                   ▼
┌──────────────────────────────────────────┐
│           Payload (carga útil)            │
├──────────────────────────────────────────┤
│  Opciones: GRUB, SeaBIOS, Linux kernel,   │
│  Tianocore (UEFI), OpenFirmware, FILO     │
└──────────────────┬───────────────────────┘
                   ▼
┌──────────────────────────────────────────┐
│           Sistema operativo               │
└──────────────────────────────────────────┘
```

### Payloads soportados

| Payload | Para qué |
|---|---|
| **SeaBIOS** | Compatibilidad con BIOS legacy (carga GRUB, Windows) |
| **Tianocore** | Implementación UEFI completa sobre coreboot |
| **GRUB** | Gestor de arranque tradicional |
| **Linux kernel** | Arranque directo del kernel (sin gestor intermedio) |
| **FILO** | Cargador de arranque mínimo |
| **OpenBIOS / Open Firmware** | Firmware abierto para SPARC/PowerPC |
| **Memtest86+** | Test de memoria |

## Ventajas

| Ventaja | Explicación |
|---|---|
| **Velocidad** | Arranque en 3-10 segundos (vs 15-30 de UEFI moderno) |
| **Libertad** | Código 100% abierto, sin backdoors propietarios |
| **Seguridad** | Menos superficie de ataque, código auditable |
| **Control** | Sabes exactamente qué hace el firmware en tu hardware |
| **Eficiencia** | Modo 32 bits nativo (no 16 bits como BIOS clásico) |

## Limitaciones

- **Soporte de hardware limitado**: no todas las placas base tienen soporte (requiere documentación del chipset, a menudo protegida por NDA)
- **Configuración compleja**: requiere compilar desde fuente y flashear manualmente
- **Sin soporte UEFI nativo**: necesita Tianocore como payload para UEFI
- **Riesgo de brick**: si el flasheo falla, la placa puede quedar inservible

## coreboot vs Libreboot

| Aspecto | coreboot | Libreboot |
|---|---|---|
| **Filosofía** | Práctico (incluye blobs si es necesario) | Purista (solo código 100% libre) |
| **Blobs** | Acepta microcódigo y blobs propietarios | Sin blobs de ningún tipo (menos hardware soportado) |
| **Instalación** | Manual, requiere compilación | Precompilado, más fácil de instalar |
| **Base** | coreboot | coreboot |
| **Hardware** | Amplio | Limitado (sin microcódigo CPU) |

## Instalación y uso

coreboot **no se instala como un paquete**, sino que se compila desde fuente y se flashea al chip de firmware de la placa base:

```bash
# Este es un proceso altamente específico para cada placa
# 1. Identificar el chip de firmware
flashrom -p internal --flash-name

# 2. Hacer backup del firmware actual
sudo flashrom -p internal -r backup.bin

# 3. Compilar coreboot para tu placa
git clone https://review.coreboot.org/coreboot
cd coreboot
make menuconfig  # seleccionar placa, payload, etc.
make

# 4. Flashear coreboot
sudo flashrom -p internal -w build/coreboot.rom
```

> **Advertencia**: Flashear coreboot incorrectamente puede **inutilizar la placa base** (brick). Asegúrate de tener un programador externo (CH341A, Raspberry Pi) para recuperación.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Placa no arranca tras flashear | Configuración incorrecta | Usar programador externo (CH341A) para reflashear |
| Sin salida de video | GPU no inicializada | Usar puerto serie para debugging |
| No arranca Windows | Sin compatibilidad UEFI | Usar Tianocore como payload |
| RAM no detectada | SPD no legible | Verificar módulos de RAM compatibles |

## Enlaces externos

- [Sitio oficial coreboot](https://www.coreboot.org/)
- [Lista de placas soportadas](https://coreboot.org/status/board-status.html)
- [Wikipedia — coreboot](https://en.wikipedia.org/wiki/Coreboot)
- [Libreboot](https://libreboot.org/) — distribución de coreboot sin blobs
- [FSF — Campaña por BIOS libre](https://www.fsf.org/campaigns/free-bios.html)
- [flashrom](https://www.flashrom.org/) — herramienta para flashear firmware

## Ver también

- [[Proceso de Arranque (GRUB initramfs kernel params)]] — boot process overview
- [[Bootloaders (GRUB Limine systemd-boot)]] — gestores de arranque
- [[Módulos del kernel (lsmod modprobe blacklist)]] — kernel modules
- [[Linux embebido]] — sistemas embebidos con Linux

#sistema
