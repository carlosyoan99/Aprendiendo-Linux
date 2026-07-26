---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
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
sudo apt search printer-driver
# O usar Generic PostScript/PCL
sudo lpadmin -p mi-impresora -m "Generic/PostScript Printer" -E
```

### 4. Permisos
```bash
# Añadir usuario al grupo lpadmin
sudo usermod -aG lpadmin $USER
```

### 5. Impresora de red
```bash
# Descubrir impresora de red
avahi-browse -t -r _ipp._tcp
# Añadir
sudo lpadmin -p red-printer -v ipp://192.168.1.50/ipp/print -E
```

## Ver también

- [[Impresión (CUPS)]], [[Firewall]], [[NetworkManager]]

#troubleshooting #hardware
