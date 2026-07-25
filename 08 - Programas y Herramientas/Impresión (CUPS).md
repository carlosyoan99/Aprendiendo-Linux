---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: programa
prioridad: media
---

# Impresión en Linux (CUPS)

## Qué es

CUPS (Common Unix Printing System) es el sistema de impresión estándar en Linux y macOS. Funciona como un servidor de impresión en segundo plano que recibe trabajos de impresión, los gestiona en cola, y los envía a la impresora. Soporta impresoras locales (USB) y de red (IP, Samba, AirPrint).

```
Arquitectura CUPS:

  ┌──────────────────┐     ┌──────────────────┐
  │   Aplicaciones   │     │   Configuración  │
  │  (Firefox,      │     │  (web UI :631)   │
  │   LibreOffice)   │     │  (lpadmin CLI)   │
  └────────┬─────────┘     └────────┬─────────┘
           │                        │
           ▼                        ▼
  ┌────────────────────────────────────────────┐
  │            CUPS Daemon (cupsd)             │
  │  ┌──────────┐  ┌──────────┐  ┌──────────┐ │
  │  │ Cola de  │  │  Backends│  │  Filtros │ │
  │  │ trabajos │  │  (USB,   │  │  (PDF →  │ │
  │  │          │  │  IPP,    │  │  PostScript│ │
  │  │          │  │  Samba)  │  │  → PCL)  │ │
  │  └──────────┘  └──────────┘  └──────────┘ │
  └────────────────────┬───────────────────────┘
                       ▼
                ┌──────────────┐
                │  Impresora   │
                │  (USB / red) │
                └──────────────┘
```

---

## Instalación

```bash
# Debian/Ubuntu
sudo apt install cups cups-client cups-filters ipp-usb  # ipp-usb para IPP-over-USB

# Arch
sudo pacman -S cups cups-pdf ipp-usb                  # cups-pdf para imprimir a PDF

# Fedora
sudo dnf install cups ipp-usb

# Activar el servicio
sudo systemctl enable --now cups

# Verificar que está funcionando
systemctl status cups
```

### Añadir tu usuario al grupo lpadmin (para administrar impresoras)

```bash
sudo usermod -a -G lpadmin $USER
# Cerrar sesión y volver a entrar, o ejecutar:
newgrp lpadmin
```

---

## Configuración

### Interfaz web (puerto 631)

CUPS incluye una interfaz web de administración accesible desde cualquier navegador:

```
http://localhost:631
```

Desde ahí puedes:
- **Añadir impresoras** → Administration → Add Printer
- **Ver colas** → Jobs
- **Gestionar clases** (grupos de impresoras)
- **Ver logs** → Access Log / Error Log

### CLI — Comandos principales

```bash
# ── Listar impresoras disponibles ──
lpstat -p -d                              # impresoras y su estado
lpstat -a                                 # si están aceptando trabajos
lpstat -t                                 # información completa

# ── Añadir impresora (requiere ser admin) ──
sudo lpadmin -p NombreImpresora -E -v usb://... -m everywhere
# -p : nombre descriptivo
# -E : habilitar
# -v : URI del dispositivo
# -m : modelo/driver ("everywhere" para IPP Everywhere / AirPrint)

# ── Establecer impresora por defecto ──
lpadmin -d NombreImpresora               # como usuario normal (lpadmin group)
# o
lpoptions -d NombreImpresora             # solo para tu usuario

# ── Ver URIs de dispositivos disponibles ──
/usr/lib/cups/backend/usb                # impresoras USB detectadas
lpinfo -v                                # todos los backends disponibles
lpinfo -m | grep -i "nombre-impresora"   # buscar drivers específicos
```

### URI de dispositivos comunes

| URI | Conexión |
|---|---|
| `usb://HP/DeskJet%204150?serial=ABC123` | USB |
| `ipp://192.168.1.50:631/printers/HP` | IPP (protocolo moderno) |
| `socket://192.168.1.50:9100` | Socket raw (HP JetDirect) |
| `lpd://192.168.1.50/queue` | LPD (legacy) |
| `smb://servidor/impresora` | Samba/Windows Shared |
| `ipps://192.168.1.50:443/ipp/print` | IPP sobre TLS (cifrado) |
| `parallel:/dev/lp0` | Puerto paralelo (obsoleto) |

### Ejemplo: añadir impresora de red IPP

```bash
# 1. Detectar impresoras en la red
avahi-browse -rt _ipp._tcp               # descubrimiento mDNS/IPP
# o
lpinfo -v | grep -i network

# 2. Añadir (ajustar URI según lo detectado)
sudo lpadmin -p "OficinaHP" -E -v ipp://192.168.1.50/ipp/print -m everywhere

# 3. Verificar
lpstat -p OficinaHP
```

---

## Imprimir

```bash
# ── Imprimir un archivo ──
lp documento.pdf                          # a la impresora por defecto
lp -d OficinaHP documento.pdf            # a una impresora específica
lp -n 3 documento.pdf                    # 3 copias
lp -o "media=A4" documento.pdf           # tamaño de papel
lp -o "sides=two-sided-long-edge" doc    # dúplex (encuadernación por lado largo)
lp -o "sides=two-sided-short-edge" doc   # dúplex (encuadernación por lado corto)
lp -o "orientation-requested=4" doc.pdf  # paisaje (4 = landscape)

# ── Ver cola de impresión ──
lpq                                       # trabajos en cola
lpq -a                                    # todas las colas
lpq -P OficinaHP                         # cola de una impresora específica

# ── Cancelar trabajos ──
cancel <job-id>                           # cancelar trabajo por ID
cancel -a                                 # cancelar todos los trabajos
lprm -                                    # alternativa (System V)

# ── Opciones de página comunes ──
lp -o "page-set=1-3" archivo.pdf          # solo páginas 1 a 3
lp -o "number-up=2" archivo.pdf           # 2 páginas por hoja
lp -o "fit-to-page" archivo.pdf           # ajustar al tamaño de página
lp -o "scaling=150" archivo.pdf           # escalar al 150%
lp -o "media=Custom.90x50mm" carta.pdf   # tamaño personalizado (mm)
```

---

## Drivers

Los drivers varían según la antigüedad de la impresora:

| Era | Sistema | Cómo funciona |
|---|---|---|
| **Moderna** (2015+) | **IPP Everywhere** | Sin driver. CUPS se comunica directamente con la impresora. `-m everywhere` |
| **Intermedia** (2005-2015) | **Gutenprint** / **HPLIP** | Drivers de código abierto. Gutenprint cubre Canon, Epson, etc. HPLIP para HP |
| **Antigua** (pre-2005) | **Foomatic** | Drivers propietarios envueltos en Foomatic. Usar `apt install printer-driver-*` |
| **PostScript** | **No necesita driver** | Las impresoras PostScript entienden PostScript directamente |

### Instalación de drivers

```bash
# HP (HPLIP) — incluye hp-setup para configuración guiada
sudo apt install hplip                    # Debian/Ubuntu
sudo pacman -S hplip                      # Arch
hp-setup                                  # asistente gráfico de HP

# Gutenprint (Canon, Epson, muchas otras)
sudo apt install printer-driver-gutenprint

# Drivers genéricos
sudo apt install printer-driver-all       # todos los drivers libres (Debian/Ubuntu)
sudo pacman -S gutenprint foomatic-db     # Arch

# PostScript y PDF
sudo apt install cups-filters             # convierte PDF a PostScript
```

### Escáner (si la impresora tiene escáner)

```bash
# HP (usan HPLIP + sane)
sudo apt install sane simple-scan         # simple-scan = GUI de escaneo
hp-scan                                   # herramienta HP

# Otras marcas
sudo apt install xsane sane-utils
scanimage -L                              # detectar escáneres
scanimage > imagen.pnm                    # escanear
```

---

## Solución de problemas

### La impresora no aparece

```bash
# 1. Verificar que CUPS está activo
systemctl status cups

# 2. Detectar la impresora (USB)
lsusb | grep -i -E "print|hp|canon|epson|brother"
dmesg | grep -i usb | tail -10

# 3. Ver backends disponibles
lpinfo -v | grep -i -E "usb|network|direct"

# 4. Probar re-descubrimiento (reconectar USB o reiniciar CUPS)
sudo systemctl restart cups
```

### La impresión no se completa

```bash
# 1. Ver estado del trabajo
lpstat -o -l                             # trabajos con detalles
lpq                                       # cola

# 2. Ver logs de CUPS
sudo journalctl -u cups --since "5 min ago"
sudo tail -f /var/log/cups/error_log

# 3. Errores comunes en logs:
#   "Filter failed" → driver incompatible, probar otro
#   "Unable to open device file" → permisos USB
#   "Connection refused" → impresora de red apagada

# 4. Reiniciar el sistema de impresión
sudo systemctl restart cups
sudo systemctl restart cups-browsed      # descubrimiento de red
```

### Impresora de red no se encuentra

```bash
# 1. ¿Responde a ping?
ping 192.168.1.50

# 2. ¿Puertos abiertos?
sudo nmap -p 631,9100,515 192.168.1.50  # IPP, JetDirect, LPD

# 3. Añadir manualmente si no se descubre sola
sudo lpadmin -p "ImpresoraRed" -E -v socket://192.168.1.50:9100 -m everywhere
```

### Problemas de permisos

```bash
# 1. Tu usuario debe estar en lpadmin
groups $USER                              # debe mostrar "lpadmin"

# 2. El dispositivo USB debe ser accesible
ls -l /dev/usb/lp*                       # debe ser legible por el grupo lp

# 3. Añadir al grupo lp (si es necesario)
sudo usermod -a -G lp $USER
```

---

## Impresión PDF virtual

Útil para generar PDFs desde cualquier aplicación sin instalar software extra:

```bash
# cups-pdf (Debian/Ubuntu)
sudo apt install cups-pdf
# Aparecerá una impresora llamada "PDF" — imprime a ella y genera un PDF en ~/PDF/

# Arch
sudo pacman -S cups-pdf
```

---

## Buenas prácticas

- **Impresoras modernas**: Usar IPP Everywhere (`-m everywhere`), no instalar drivers propietarios a menos que sea estrictamente necesario.
- **Descubrimiento**: Asegurarse de que `cups-browsed` esté activo para detectar impresoras en la red automáticamente.
- **Logs**: Si algo falla, lo primero es `tail -f /var/log/cups/error_log`.
- **Firewall**: CUPS usa puerto 631 (IPP). Si tienes firewall activo, puede bloquear la detección de impresoras de red.
- **Compatibilidad**: La mayoría de impresoras modernas (HP, Brother, Epson) funcionan bien con Linux. Las impresoras muy baratas (a menudo \"solo Windows\") pueden no tener soporte.

## Ver también

- [[Firewall]] — puerto 631 para IPP
- [[Redes Basicas]] — detección de impresoras en red
- [[SSH]] — reenvío de puertos para impresión remota
- [[Gestores de Paquetes]] — instalar drivers
- [[systemd]] — gestión del servicio cups

## Enlaces externos

- [Wikipedia — CUPS](https://en.wikipedia.org/wiki/CUPS)
- [Sitio oficial — OpenPrinting CUPS](https://openprinting.github.io/cups/)
- [GitHub — OpenPrinting/cups](https://github.com/OpenPrinting/cups)
- [Arch Wiki — CUPS](https://wiki.archlinux.org/title/CUPS)

#programa
