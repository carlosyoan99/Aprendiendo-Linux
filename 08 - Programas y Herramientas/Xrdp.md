---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: alta
licencia: GPLv2+
alternativas: VNC, NoMachine, X2Go, RDP (Windows nativo)
---

# Xrdp

> Servidor de escritorio remoto para Linux que usa el protocolo RDP (Remote Desktop Protocol), permitiendo conectarse desde clientes Windows, Linux o Android sin instalar software adicional.

## Qué es

**Xrdp** es un servidor RDP (Remote Desktop Protocol) de código abierto para sistemas Linux. Proporciona una experiencia de escritorio remoto completa: te conectas desde un cliente RDP (como el "Conexión a Escritorio Remoto" de Windows, Remmina en Linux, o Microsoft Remote Desktop en Android/iOS) y obtienes una sesión gráfica en la máquina Linux.

A diferencia de VNC, Xrdp usa el protocolo RDP nativo de Microsoft, lo que significa:
- **Mejor integración con Windows** (cliente incluido, sin instalar nada)
- **Compresión y ancho de banda** más eficiente que VNC tradicional
- **Redirección de recursos** (portapapeles, audio, discos, impresoras)

## Características

| Característica | Soporte |
|---|---|
| Sesiones remotas RDP | ✅ |
| Reconexión a sesión existente | ✅ |
| Redimensionado dinámico de resolución | ✅ |
| Proxy RDP/VNC | ✅ |
| Portapapeles compartido (bidireccional) | ✅ |
| Redirección de audio (servidor → cliente) | ✅ |
| Redirección de micrófono (cliente → servidor) | ✅ |
| Montar discos del cliente en la máquina remota | ✅ |
| Autenticación PAM | ✅ |
| Sesiones con múltiples monitores | ✅ (desde v0.10) |
| TLS/SSL (cifrado de conexión) | ✅ |

## Instalación

```bash
# Debian/Ubuntu
sudo apt update
sudo apt install xrdp

# Arch Linux
sudo pacman -S xrdp

# Fedora
sudo dnf install xrdp

# Verificar que está corriendo
sudo systemctl status xrdp
sudo systemctl enable --now xrdp
```

## Configuración básica

### Archivo de configuración principal

`/etc/xrdp/xrdp.ini` — configura el servidor (puertos, seguridad, sesiones):

```ini
[Globals]
port=3389                      # Puerto RDP (por defecto)
crypt_level=high               # Cifrado: low, medium, high
max_bpp=32                     # Bits por píxel (calidad)
fork=yes                       # Procesos hijos para cada conexión
tcp_nodelay=yes
use_vsock=no                   # vsock para máquinas virtuales
```

### Seleccionar el gestor de sesión

Xrdp necesita un gestor de ventanas/sesión para mostrar el escritorio. Las opciones típicas:

```bash
# Usar el escritorio actual (Xorg)
sudo sed -i 's/startxfce4/startplasma-x11/' /etc/xrdp/startwm.sh

# O configurar manualmente en /etc/xrdp/startwm.sh
echo "startplasma-x11" > ~/.xsession   # KDE Plasma
echo "gnome-session" > ~/.xsession     # GNOME
echo "startxfce4" > ~/.xsession        # XFCE
echo "cinnamon-session" > ~/.xsession  # Cinnamon
```

### Sesiones gráficas (Xorg vs Xvnc)

Xrdp puede funcionar de dos formas:

| Modo | Descripción | Cuándo usar |
|---|---|---|
| **Xorg** | Usa el servidor X directamente (mejor rendimiento) | Escritorios modernos, aceleración gráfica |
| **Xvnc** | Crea una sesión VNC independiente (más compatibilidad) | Sesiones múltiples, aislamiento |

Por defecto, Xrdp usa **Xvnc**. Para usar Xorg directamente:

```bash
sudo apt install xorgxrdp          # paquete adicional (Debian/Ubuntu)
```

## Comandos útiles

```bash
# Ver servicio
sudo systemctl status xrdp
sudo systemctl restart xrdp

# Ver conexiones activas
sudo netstat -tlnp | grep 3389

# Logs
sudo journalctl -u xrdp -f          # seguir logs en tiempo real
sudo tail -f /var/log/xrdp.log

# Probar conexión local
xfreerdp /v:localhost /u:tu_usuario
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| **Conexión rechazada** | Puerto 3389 no abierto o firewall | `sudo ufw allow 3389` o `sudo firewall-cmd --add-port=3389/tcp` |
| **Pantalla negra al conectar** | El gestor de sesión no arranca bien | Verificar `startwm.sh`, probar con `xfce4-session` |
| **Solo cursor, sin escritorio** | Sesión Xvnc sin gestor de ventanas | Asegurar que `startwm.sh` ejecuta el DE correcto |
| **Audio no se escucha** | Redirección de audio no configurada | Verificar `pulseaudio` en el servidor, `rdpdr` en cliente |
| **Portapapeles no funciona** | Módulo cliprd no cargado | Verificar `use_vsock=no` y reiniciar xrdp |
| **Error de autenticación** | PAM mal configurado | `sudo journalctl -u xrdp -n 50`, revisar `/etc/pam.d/xrdp` |

## Redirección de discos (montar discos del cliente)

El servidor puede montar discos y carpetas del cliente remotamente:

```bash
# En el cliente Windows: al conectar, expandir "Mostrar opciones" → "Más" → seleccionar unidades
# En el servidor Linux aparecerán montadas en /media/
```

## Alternativas

| Programa | Protocolo | Ventaja principal |
|---|---|---|
| **Xrdp** | RDP | Compatible con cliente Windows nativo |
| **VNC (TightVNC/TigerVNC)** | RFB | Simple, funciona sin sistema de ventanas |
| **NoMachine** | NX | Muy rápido, códec propio optimizado |
| **X2Go** | NX | Sesiones reanudables, mejor en conexiones lentas |
| **Remmina** | RDP/VNC/SPICE | Cliente todo-en-uno (no servidor) |

## Notas personales

- En el escritorio doméstico, Xrdp es muy útil para acceder a tu PC Linux desde el trabajo o desde el móvil
- Para servidores, considera X2Go si necesitas sesiones persistentes que se reanuden al reconectar
- Si usas Wayland, Xrdp tiene soporte experimental — puede que necesites XWayland

## Enlaces externos

- [Repositorio GitHub de Xrdp](https://github.com/neutrinolabs/xrdp)
- [Documentación oficial](https://github.com/neutrinolabs/xrdp/wiki)
- [Wikipedia — Xrdp](https://es.wikipedia.org/wiki/Xrdp)
- [Arch Wiki — Xrdp](https://wiki.archlinux.org/title/Xrdp)

## Ver también

- [[SSH]] — acceso remoto por terminal
- [[scrcpy]] — acceso remoto a dispositivos Android
- [[Wayland vs X11]] — implicaciones para escritorio remoto
- [[Firewall]] — abrir puertos seguros

#programa #remoto
