---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# lshw

## Qué es

Muestra una vista **jerárquica de todo el hardware** del sistema, combinando información de múltiples fuentes (PCI, USB, DMI, IDE, etc.) en un árbol legible.

```bash
# Instalación
sudo apt install lshw                     # Debian/Ubuntu
sudo pacman -S lshw                       # Arch
sudo dnf install lshw                     # Fedora
```

> **Importante**: requiere `sudo` para información precisa (detección de velocidades, cachés, etc.).

## Uso

```bash
sudo lshw                                 # todo el hardware
sudo lshw -short                          # resumen en tabla (muy útil)
sudo lshw -class display                  # solo GPU
sudo lshw -class network                  # solo interfaces de red
sudo lshw -class disk                     # solo discos
sudo lshw -class memory                   # solo RAM
```

## Exportar reporte

```bash
sudo lshw -html > hardware-report.html   # reporte HTML (para compartir)
sudo lshw -xml > hardware-report.xml     # formato XML (para parsear)
```

## Casos de uso

- **Reporte completo**: `sudo lshw -short` da una tabla legible de todo el hardware de un vistazo
- **Compartir specs**: exportar a HTML para enviar a soporte técnico
- **Diagnóstico rápido**: verificar que todos los componentes son detectados correctamente

## Ver también

- [[lspci]] — dispositivos PCIe
- [[lsusb]] — dispositivos USB
- [[dmidecode]] — BIOS, placa base, RAM
- [[Diagnóstico de hardware]] — índice + comparativa

## Enlaces externos

- [Wikipedia — lshw](https://en.wikipedia.org/wiki/Lshw)
- [Sitio oficial](https://ezix.org/project/wiki/HardwareLiSter)

#programa
