---
fecha_creacion: 2026-07-23
estado: resuelto
categoria: troubleshooting
sistema: hora / RTC
prioridad: alta
---

# Reloj desincronizado en dual boot (Windows vs UTC)

> Cada vez que cambias de sistema operativo (Linux → Windows o viceversa), el reloj se desajusta por varias horas. Especialmente molesto si dependes de la hora exacta para trabajo, citas o sincronización.

## Síntoma

- Al arrancar Windows tras haber usado Linux, la hora está **atrasada** exactamente 5 horas (o la diferencia UTC/GMT de tu zona horaria)
- Al volver a Linux tras Windows, la hora está **adelantada** esas mismas horas
- La hora se corrige sola al conectarse a internet (NTP), pero vuelve a fallar al reiniciar sin conexión
- En la BIOS/UEFI la hora parece la correcta, pero al arrancar cada SO la cambia

## Diagnóstico

```bash
# En Linux: ver cómo trata el RTC (reloj hardware)
timedatectl                                  # RTC in local TZ? → yes / no
# Si dice "RTC in local TZ: yes" → Linux está usando hora local
# Si dice "RTC in local TZ: no" → Linux está usando UTC (estándar)

# Ver hora actual del sistema y del hardware
date                                         # hora del sistema (software)
sudo hwclock --show                          # hora del RTC (hardware/BIOS)

# Ver zona horaria configurada
timedatectl show --property=Timezone
ls -l /etc/localtime                         # symlink a la zona horaria

# En Windows: abrir CMD como administrador y ver
# reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal
```

## Causa

El conflicto es conceptual: **Windows espera que el RTC (reloj hardware de la BIOS) almacene la hora local**, mientras que **Linux espera que almacene UTC** (por defecto).

1. **Linux por defecto:** asume RTC en UTC → aplica la diferencia horaria para mostrar la hora local.
2. **Windows por defecto:** asume RTC en hora local → no aplica corrección.

El resultado:
- Arrancas Linux → escribe RTC en UTC (porque timedatectl lo configura así)
- Arrancas Windows → lee RTC y asume que es hora local → la muestra incorrecta (atrasada)
- Windows sincroniza con NTP y corrige → escribe hora LOCAL en el RTC
- Arrancas Linux → lee RTC y asume UTC → la muestra incorrecta (adelantada)

## Solución

Hay **dos soluciones posibles**. La recomendada y más limpia es la **Opción A**.

### Opción A (recomendada): Decirle a Windows que use UTC

```bash
# 1. En Linux, asegurar que el RTC está en UTC (modo estándar)
sudo timedatectl set-local-rtc 0            # 0 = UTC (predeterminado)
timedatectl                                  # verificar: "RTC in local TZ: no"
# La hora del sistema y del RTC deberían coincidir (salvo zona horaria)

# 2. Ahora arrancar Windows y ejecutar este comando en CMD como ADMINISTRADOR:
```

```powershell
# En Windows (CMD como Administrador):
Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1 /f
```

```bash
# 3. Reiniciar Windows y verificar
# La hora debe ser correcta. Si no, reiniciar dos veces.

# 4. Opcional: desactivar sincronización NTP de Windows para evitar que la sobreescriba
# En Windows: Configuración → Hora e idioma → Fecha y hora → Desactivar "Ajustar hora automáticamente"
# O mejor: mantener NTP activo pero asegurar que el registry key está bien
```

> **⚠️ Advertencia**: Antes de Windows 10 build 2019, este registro no era soportado oficialmente y podía causar problemas con el historial de archivos de Windows y la verificación de licencias. En Windows 10/11 modernos funciona sin problemas.

### Opción B: Decirle a Linux que use hora local

```bash
# Si no puedes modificar Windows (ej. equipo corporativo):
sudo timedatectl set-local-rtc 1 --adjust-system-clock

# Verificar
timedatectl                                  # "RTC in local TZ: yes"

# ⚠️ Desventajas de esta opción:
# - timedatectl mostrará una advertencia (RTC in local TZ is not fully supported)
# - NTP y daylight saving pueden dar problemas
# - No recomendado en servidores o sistemas con múltiples usuarios
```

### Opción C: Sincronización automática con NTP en ambos SO

Independientemente de la opción elegida, tener NTP activo en ambos sistemas es una capa extra de seguridad:

```bash
# En Linux: activar NTP automático
sudo timedatectl set-ntp true
timedatectl                                  # NTP service: active
```

```powershell
# En Windows: mantener sincronización automática
# Configuración → Hora e idioma → Fecha y hora → "Ajustar hora automáticamente" = ON
```

### Verificación

```bash
date                                         # hora correcta
sudo hwclock --show                          # debe coincidir (salvo zona horaria)
timedatectl                                  # RTC correcto, NTP activo
```

Prueba de fuego: apagar, arrancar Windows, esperar 1 minuto, apagar, arrancar Linux. La hora debe ser correcta en ambos.

## Prevención

- Aplicar la solución justo después de instalar el dual boot, antes de que aparezca el problema
- Mantener NTP activo en ambos SO como respaldo
- Si reinstalas Windows, el registro `RealTimeIsUniversal` se pierde — hay que volver a aplicarlo
- En laptops que viajan entre zonas horarias, UTC es más fiable que hora local

## Enlaces externos

- [Arch Wiki — System time#UTC in Windows](https://wiki.archlinux.org/title/System_time#UTC_in_Windows)
- [Microsoft Docs — RealTimeIsUniversal](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-time-zone)
- [Ubuntu Help — Dual boot time](https://help.ubuntu.com/community/UbuntuTime#Make_Windows_Use_UTC)

## Ver también

- [[Dual Boot con Windows]] — guía completa de dual boot
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — el RTC y el arranque
- [[date y timedatectl]] — comandos de fecha/hora y gestión del RTC

#troubleshooting
