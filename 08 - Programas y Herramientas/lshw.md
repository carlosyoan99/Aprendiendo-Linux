---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: media
---

# lshw

> Herramienta CLI que muestra una vista **jerárquica completa de todo el hardware** del sistema. Combina información de PCI, USB, DMI, IDE, SCSI y otras fuentes en un único árbol de hardware legible. Es la navaja suiza para inspeccionar qué hay dentro de una máquina Linux.

## Qué es

`lshw` (Hardware Lister) escanea el sistema y muestra una vista detallada de **cada componente de hardware**: CPU, RAM, discos, tarjetas de red, GPUs, buses, sensores, baterías, etc. Requiere `sudo` para información completa (velocidades, cachés, voltajes).

- **Fuentes de datos**: `/sys`, `/proc`, DMI/SMBIOS, PCI, USB, SCSI, IDE
- **Formatos de salida**: texto, tabla resumida, HTML, XML, JSON
- **Precisión**: mejor que `lspci`/`lsusb` aislados porque cruza datos de múltiples fuentes

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install lshw` |
| Arch | `sudo pacman -S lshw` |
| Fedora | `sudo dnf install lshw` |
| openSUSE | `sudo zypper install lshw` |
| Void | `sudo xbps-install -S lshw` |
| Alpine | `sudo apk add lshw` |

> **Importante**: la información más detallada (velocidades, cachés, voltajes) requiere `sudo`. Sin sudo, muchos campos aparecen vacíos o incompletos.

## Sintaxis

```bash
lshw [opciones]
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-short` | Resumen en tabla (clase, dirección, dispositivo, descripción) |
| `-C <clase>` | Filtrar por clase: `cpu`, `memory`, `disk`, `network`, `display`, `bus` |
| `-html` | Salida en formato HTML (ideal para compartir) |
| `-xml` | Salida en formato XML (para parseo programático) |
| `-json` | Salida en formato JSON |
| `-sanitize` | Ocultar números de serie, UUIDs y datos sensibles |
| `-numeric` | Mostrar IDs numéricos PCI/USB en vez de nombres |
| `-businfo` | Mostrar información de bus (PCI, USB, SCSI) |
| `-disable <etiqueta>` | Deshabilitar una fuente de datos específica |
| `-version` | Mostrar versión |

## Ejemplos

```bash
# Resumen completo de hardware (tabla)
sudo lshw -short

# Solo GPU
sudo lshw -C display

# Solo interfaces de red
sudo lshw -C network

# Solo discos
sudo lshw -C disk

# Solo RAM
sudo lshw -C memory

# Información de bus PCI
sudo lshw -businfo

# Exportar reporte HTML (para enviar a soporte)
sudo lshw -html > hardware-report.html

# Exportar a JSON (para procesamiento)
sudo lshw -json > hardware.json

# Ocultar datos sensibles (seriales, UUIDs)
sudo lshw -sanitize -html > report-safe.html

# IDs numéricos (para diagnóstico PCI)
sudo lshw -numeric -C network
```

## Formato de salida

### Texto (por defecto)

```
*-core
   *-memory
      *-memory:0
         description: System memory
         size: 16GiB
      *-memory:1
         description: Bidirectional memory
   *-cpu
      product: 13th Gen Intel(R) Core(TM) i7-13700K
      vendor: Intel Corp.
      physical id: 1
      bus info: cpu@0
      width: 64 bits
      capabilities: fpu fpu_exception wp de pae tsc msr mce cx8 apic ...
```

### Tabla (-short)

```
HCL          ID       DEVICE     DESCRIPTION
-            -        memory     System memory
-            -        memory     Bidirectional memory
-            -        processor  13th Gen Intel(R) Core(TM) i7-13700K
00:00.0      -        bridge     Device 7a27
00:02.0      -        display    Device 56c0
01:00.0      -        network    Device 2666
```

## Casos de uso

- **Reporte completo**: `sudo lshw -short` da una tabla legible de todo el hardware de un vistazo
- **Compartir specs**: exportar a HTML para enviar a soporte técnico
- **Diagnóstico rápido**: verificar que todos los componentes son detectados correctamente
- **Comprar upgrade**: ver tipo de RAM soportada antes de comprar módulos
- **Auditoría hardware**: generar inventario de máquinas en producción
- **Detectar hardware fantasma**: identificar dispositivos que el kernel no carga

## Comparativa con alternativas

| Herramienta | Alcance | Salida | Requiere sudo |
|---|---|---|---|
| **lshw** | Todo el hardware (jerárquico) | Texto/HTML/XML/JSON | Sí (para detalle) |
| **lspci** | Solo dispositivos PCI | Texto | No |
| **lsusb** | Solo dispositivos USB | Texto | No |
| **dmidecode** | BIOS, placa, RAM (vía SMBIOS) | Texto | Sí |
| **inxi** | Hardware + sistema + procesos | Texto (bonito) | No |
| **neofetch/fastfetch** | Hardware resumido + distro | Texto (decorativo) | No |
| **hwinfo** | Similar a lshw, más detallado | Texto | Sí |

> **Regla práctica**: usa `lshw` para un reporte completo y exportable, `inxi -Fxz` para un resumen bonito en terminal, y `lspci`/`lsusb` para inspeccionar una categoría específica.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Muchos campos vacíos | Ejecutado sin sudo | `sudo lshw` (requiere root para DMI/PCI completo) |
| `lshw: command not found` | No instalado | `sudo apt install lshw` (Debian/Ubuntu) |
| Errores de permisos en DMI | `/dev/mem` no accesible | Verificar que `/dev/mem` existe y tiene permisos correctos |
| Salida incompleta en VM | VM no expone DMI/PCI completo | Normal en VMs; usar herramientas del hypervisor |
| No detecta GPU reciente | Kernel sin driver o sin soporte PCI | Verificar `lspci -k` y módulos del kernel |
| Reporte HTML no se abre | Navegador bloquea file:// | Usar `python3 -m http.server` para servir el archivo |

## Ver también

- [[lspci]] — dispositivos PCIe en detalle
- [[lsusb]] — dispositivos USB en detalle
- [[dmidecode]] — BIOS, placa base, RAM
- [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — índice + comparativa completa

## Enlaces externos

- [Wikipedia — lshw](https://en.wikipedia.org/wiki/Lshw)
- [Sitio oficial](https://ezix.org/project/wiki/HardwareLiSter)
- [Man page — lshw](https://man7.org/linux/man-pages/man1/lshw.1.html)
- [Arch Wiki — lshw](https://wiki.archlinux.org/title/Lshw)

#programa #hardware
