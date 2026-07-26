---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# Diagnóstico de hardware (lspci, lsusb, dmidecode, lshw, smartctl)

## Qué es

Conjunto de herramientas de terminal para inspeccionar el hardware del sistema sin abrir la carcasa ni instalar software gráfico. Permiten identificar componentes, verificar su estado, y diagnosticar fallos antes de que ocurran.

```
Herramientas y qué informan:

  ┌──────────────────────────────────────┐
  │           dmidecode                  │
  │  BIOS/UEFI, placa base, RAM,        │
  │  número de serie, fabricante         │
  └──────────────────────────────────────┘

  ┌──────────┐  ┌──────────┐  ┌──────────┐
  │  lspci   │  │  lsusb   │  │  lscpu   │
  │  PCIe:   │  │  USB:    │  │  CPU:    │
  │  GPU,    │  │  teclado │  │  núcleos,│
  │  NVMe,   │  │  mouse,  │  │  frec.,  │
  │  red     │  │  webcam  │  │  flags   │
  └──────────┘  └──────────┘  └──────────┘

  ┌──────────┐  ┌──────────┐  ┌──────────┐
  │ smartctl │  │  lshw    │  │   hdparm │
  │  discos: │  │  resumen │  │  disco:  │
  │  salud,  │  │  completo│  │  cache,  │
  │  S.M.A.R.│  │  en árbol│  │  DMA     │
  └──────────┘  └──────────┘  └──────────┘
```

## Tabla de herramientas

| Herramienta | Paquete | Para qué | Nota |
|---|---|---|---|
| **[[lspci]]** | pciutils | Dispositivos PCIe (GPU, NVMe, red) | [[lspci]] |
| **[[lsusb]]** | usbutils | Dispositivos USB | [[lsusb]] |
| **lscpu** | util-linux | CPU (núcleos, frecuencias, flags) | — |
| **[[dmidecode]]** | dmidecode | BIOS, placa base, RAM, serie | [[dmidecode]] |
| **[[lshw]]** | lshw | Resumen completo en árbol | [[lshw]] |
| **[[smartctl]]** | smartmontools | Salud de discos (S.M.A.R.T.) | [[smartctl]] |
| **hdparm** | hdparm | Rendimiento y configuración de discos | — |

## Buenas prácticas

- **smartctl semanal**: programa un cron/systemd timer para monitorear la salud de los discos. Si `Reallocated_Sector_Ct` o `Current_Pending_Sector` suben de 0, haz backup inmediato.
- **dmidecode para specs**: antes de comprar RAM o preguntar en foros, ejecuta `sudo dmidecode -t memory` y `sudo dmidecode -t baseboard`.
- **lspci antes de instalar drivers**: ejecuta `lspci -nnk | grep -A2 VGA` para saber qué GPU tienes y qué driver usa.
- **Reporte completo**: `sudo lshw -short` da una tabla completa y legible de todo el hardware.
- **lscpu para virtualización**: verifica que `svm` (AMD) o `vmx` (Intel) aparezcan en `lscpu | grep Flags` para saber si tu CPU soporta virtualización.

## Ver también

- [[Proc y Sys]] — /proc/cpuinfo, /proc/meminfo (/proc como fuente de datos crudos)
- [[Módulos del kernel (lsmod modprobe blacklist)]] — drivers que manejan el hardware
- [[RAID (mdadm)]] — monitoreo de discos en RAID
- [[Monitorización (Prometheus node_exporter)]] — node_exporter expone métricas SMART y de hardware
- [[Particionado y Esquemas de Disco]] — trabajar con discos detectados
- [[htop btop]] — monitoreo de recursos en tiempo real

## Enlaces externos

- [Wikipedia — Lspci](https://en.wikipedia.org/wiki/Lspci)
- [Wikipedia — Lsusb](https://en.wikipedia.org/wiki/Lsusb)
- [Wikipedia — Dmidecode](https://en.wikipedia.org/wiki/Dmidecode)
- [Wikipedia — S.M.A.R.T.](https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology)
- [Sitio oficial — smartmontools](https://www.smartmontools.org/)

#programa
