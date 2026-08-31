---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: troubleshooting
prioridad: baja
---

# Impresora no funciona

> Troubleshooting de impresoras en Linux: CUPS, drivers, permisos de red, cola de trabajos.

## Síntoma

La impresora no imprime, queda en cola, o no aparece en la lista de dispositivos.

## Diagnóstico

```bash
# Ver estado de CUPS
systemctl status cups

# Ver impresoras configuradas
lpstat -p -d

# Ver cola de trabajos
lpq

# Ver logs
journalctl -u cups --since "10 min ago"

# Verificar que el puerto USB está detectado
lsusb | grep -i printer

# Test de impresión directo
echo "Test" | lp -
```

## Causas y soluciones

### 1. CUPS no está corriendo

```bash
sudo systemctl enable --now cups
```

### 2. Impresora no detectada

```bash
lpinfo -v                           # ver dispositivos disponibles
sudo lpadmin -p mi-impresora -v usb://HP/LaserJet -E -m everywhere
```

### 3. Driver no disponible

```bash
# Buscar driver
sudo apt search printer-driver     # Debian/Ubuntu
sudo pacman -Ss printer            # Arch

# O usar Generic PostScript/PCL (funciona con la mayoría)
sudo lpadmin -p mi-impresora -m "Generic/PostScript Printer" -E
```

### 4. Permisos

```bash
# Añadir usuario al grupo lpadmin
sudo usermod -aG lpadmin $USER
# Cerrar sesión y volver a entrar
```

### 5. Impresora de red

```bash
# Descubrir impresora de red (mDNS/Avahi)
avahi-browse -t -r _ipp._tcp

# Añadir por IPP
sudo lpadmin -p red-printer -v ipp://192.168.1.50/ipp/print -E

# Añadir por socket (HP JetDirect)
sudo lpadmin -p hp-red -v socket://192.168.1.51 -E -m "HP/LaserJet"
```

### 6. Cola de trabajos atascada

```bash
# Cancelar todos los trabajos en cola
cancel -a mi-impresora

# Reiniciar CUPS
sudo systemctl restart cups

# Limpiar cola específica
lpq -P mi-impresora
cancel <job-id>
```

### 7. Impresora en modo sleep/no responde

```bash
# Verificar estado de la impresora
lpstat -p mi-impresora -l

# Si dice "disabled", reactivar
sudo cupsenable mi-impresora

# Si dice "stopped", reiniciar
sudo cupsrestart mi-impresora
```

## AirPrint (impresión desde móvil)

CUPS soporta AirPrint automáticamente si avahi-daemon está corriendo:

```bash
# Habilitar Avahi (descubrimiento de red)
sudo systemctl enable --now avahi-daemon

# Verificar que la impresora anuncia AirPrint
avahi-browse -t -r _ipp._tcp | grep -A5 "Printer"
```

> Si la impresora no soporta AirPrint nativamente, CUPS puede emularlo con la cola compartida.

## Solución de problemas por impresora

| Marca | Driver recomendado | Paquete |
|---|---|---|
| **HP** | HPLIP | `printer-driver-hpcups` |
| **Epson** | escp2 o generic | `printer-driver-escpr` |
| **Canon** | captcaercupscapt | `printer-driver-capt` |
| **Brother** | HL-L2350DW (ejemplo) | `brother-brgenml1` |
| **Samsung** | Unified Driver | `printer-driver-splix` |
| **Genérica** | PostScript/PCL | `Generic/PostScript Printer` |

## Buenas prácticas

- CUPS escucha en `localhost:631` — acceder al panel web para configuración avanzada
- Usar `lpoptions -p mi-impresora -o media=A4` para establecer tamaño de papel por defecto
- Para servidores de impresión compartida, configurar `BrowseLocalProtocols` en `/etc/cups/cupsd.conf`
- Mantener `cups-browsed` activo para descubrimiento automático de impresoras de red

## Prevención

- Verificar compatibilidad de la impresora antes de comprar (sitio [OpenPrinting](https://www.openprinting.org/))
- Preferir impresoras con soporte PostScript o PCL nativo (evitan dependencia de drivers propietarios)
- Para entornos domésticos, HP y Epson tienen mejor soporte en Linux que Canon

## Tabla de troubleshooting rápido

| Síntoma | Verificar | Solución |
|---|---|---|
| No aparece en `lpstat -p` | `lsusb` / `lpinfo -v` | Reconectar USB o añadir manualmente |
| En cola pero no imprime | `journalctl -u cups` | Reiniciar CUPS, verificar driver |
| Imprime en blanco | Nivel de tinta/tóner | Verificar cartuchos |
| Imprime caracteres basura | Driver incorrecto | Cambiar a Generic PostScript |
| Error "offline" | `lpstat -p -l` | `cupsenable`, verificar conexión |
| No aparece en móvil | avahi-daemon | `sudo systemctl enable --now avahi-daemon` |
| Lento al imprimir | Cola saturada | Cancelar trabajos viejos, reiniciar CUPS |

## Ver también

- [[Impresión (CUPS)]] — guía completa de CUPS
- [[Firewall]] — puertos de impresión (631, 9100)
- [[NetworkManager]] — configuración de red

## Enlaces externos

- [OpenPrinting — compatibilidad de impresoras](https://www.openprinting.org/)
- [Arch Wiki — CUPS](https://wiki.archlinux.org/title/CUPS)
- [CUPS — documentación oficial](https://openprinting.github.io/cups/)
- [HPLIP — soporte HP](https://developers.hp.com/hp-linux-imaging-and-printing)

#troubleshooting #hardware #impresora
