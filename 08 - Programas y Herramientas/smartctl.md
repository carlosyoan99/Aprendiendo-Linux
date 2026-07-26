---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: alta
---

# smartctl

## Qué es

Monitorea la salud de discos duros (HDD) y SSDs mediante **S.M.A.R.T.** (Self-Monitoring, Analysis and Reporting Technology). Detecta fallos inminentes antes de que ocurran. Forma parte del paquete `smartmontools`.

```bash
# Instalación
sudo apt install smartmontools            # Debian/Ubuntu
sudo pacman -S smartmontools              # Arch
sudo dnf install smartmontools            # Fedora
```

## Uso básico

```bash
sudo smartctl -i /dev/sda                 # info del disco + capacidades SMART
sudo smartctl -H /dev/sda                 # health status (PASSED/FAILED)
sudo smartctl -A /dev/sda                 # todos los atributos SMART
sudo smartctl -a /dev/sda                 # todo (info + atributos + logs)
sudo smartctl --scan                      # detectar todos los discos con SMART
```

## Pruebas de diagnóstico

```bash
sudo smartctl -t short /dev/sda           # test corto (~2 min)
sudo smartctl -t long /dev/sda            # test largo (~horas, según tamaño)
sudo smartctl -l selftest /dev/sda        # ver resultados de tests anteriores
sudo smartctl -l error /dev/sda           # logs de errores del disco
```

## Atributos SMART clave

| Atributo | ID | Qué mide | Valor saludable |
|---|---|---|---|
| **Reallocated_Sector_Ct** | 5 | Sectores reasignados por daño | 0. Si crece, el disco está fallando |
| **Power_On_Hours** | 9 | Horas de funcionamiento totales | Depende |
| **Temperature_Celsius** | 194 | Temperatura del disco | < 50°C ideal, > 60°C peligro |
| **Current_Pending_Sector** | 197 | Sectores inestables pendientes | 0. Si > 0, backup YA |
| **Offline_Uncorrectable** | 198 | Sectores que no se pudieron leer | 0 |
| **Media_Wearout_Indicator** | 233 | Desgaste de SSD | > 90% (SSD nuevo), < 10% (reemplazar) |
| **Wear_Leveling_Count** | 177 | Ciclos de desgaste en SSD | Depende del modelo |

## Script de monitoreo rápido

```bash
for disk in /dev/sd[a-z]; do
    echo "=== $disk ==="
    sudo smartctl -H $disk | grep -E "SMART overall-health|SMART Health Status"
    sudo smartctl -A $disk | grep -E "Reallocated_Sector_Ct|Current_Pending_Sector|Temperature_Celsius"
done
```

## Buenas prácticas

- Programa un **cron/systemd timer semanal** para monitorear la salud de los discos
- Si `Reallocated_Sector_Ct` o `Current_Pending_Sector` suben de 0: **backup inmediato**
- Activar SMART automático: `sudo smartctl -s on /dev/sda` (normalmente ya activado)

## NVMe

Los discos NVMe no usan SMART tradicional. Usa `nvme-cli`:

```bash
sudo apt install nvme-cli
sudo nvme list
sudo nvme smart-log /dev/nvme0n1         # temperatura, desgaste, errores
```

## Ver también

- [[Diagnóstico de hardware]] — índice + comparativa
- [[RAID (mdadm)]] — monitoreo de discos en RAID
- [[Monitorización (Prometheus node_exporter)]] — métricas SMART exportadas
- [[Particionado y Esquemas de Disco]]

## Enlaces externos

- [Wikipedia — S.M.A.R.T.](https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology)
- [Sitio oficial — smartmontools](https://www.smartmontools.org/)
- [man7.org — smartctl](https://man7.org/linux/man-pages/man8/smartctl.8.html)

#programa
