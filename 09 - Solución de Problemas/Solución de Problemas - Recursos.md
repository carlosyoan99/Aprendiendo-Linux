---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: troubleshooting
prioridad: alta
---

# Dónde y cómo buscar ayuda

## Metodología de troubleshooting

Antes de preguntar en internet, sigue este orden para resolver problemas por ti mismo:

```
1. Entender el síntoma exacto → ¿qué esperabas y qué pasó realmente?
2. Revisar logs → journalctl, dmesg, Xorg.log, logs de la app
3. Aislar variables → probar con otro usuario, otra terminal, otro equipo
4. Reproducir → ¿ocurre siempre? ¿solo en ciertas condiciones?
5. Buscar → ahora sí, con los datos concretos, ve a internet
6. Probar una solución → una cosa a la vez, no todo a la vez
7. Documentar → si lo resolviste, quédate con el comando o la nota
```

### El árbol de decisión

```
¿Hay un mensaje de error visible?
├── Sí → copia el mensaje TEXTUAL (no parafrasees)
│        Búscalo entre comillas: "error: failed to mount"
└── No → ¿qué cambió antes de que apareciera el problema?
         ├── Instalaste algo nuevo → revertir y probar
         ├── Actualizaste → revisar paquetes actualizados recientemente
         └── Nada cambió → probablemente hardware o config que se corrompió
```

## Documentación local (sin internet)

```bash
man <comando>                       # manual completo (navegar con / para buscar, q para salir)
<comando> --help                    # resumen rápido de opciones
tldr <comando>                      # ejemplos prácticos (requiere instalación: sudo apt install tldr)
info <comando>                      # manual GNU más detallado que man (para coreutils)
/usr/share/doc/<paquete>/           # documentación adicional de paquetes instalados
```

## Técnicas de búsqueda efectiva (Google / DuckDuckGo)

| Técnica | Ejemplo | Por qué funciona |
|---|---|---|
| **Entre comillas** | `"error: cannot open display"` | Busca la frase exacta, filtra resultados genéricos |
| **site: + distro** | `site:wiki.archlinux.org nvidia` | Limita a la Arch Wiki (útil aunque no uses Arch) |
| **site: + foro** | `site:reddit.com hyprland black screen` | Encuentra hilos de Reddit reales |
| **Añadir versión** | `grub rescue unknown filesystem ubuntu 24.04` | La solución puede cambiar entre versiones |
| **Negativo (-)** | `wifi -broadcom -bcm43xx` | Excluye controladores que no te aplican |
| **Incluir log** | Pegar 3-5 líneas del log en la búsqueda | Los logs suelen ser únicos y Google los encuentra |

## Comunidades y foros

| Sitio | Tipo | Cuándo preguntar |
|---|---|---|
| **Arch Wiki** | Documentación | La mejor fuente *antes* de preguntar, incluso si no usas Arch |
| **Unix & Linux Stack Exchange** | QA | Preguntas bien formuladas, comunidad exigente con la calidad |
| **r/linuxquestions** | Reddit | Respuesta rápida, menos formal, buen punto medio |
| **r/linux4noobs** | Reddit | Para preguntas de principiantes sin miedo al ridículo |
| **Discord / Telegram** | Chat | Respuesta inmediata, difícil de buscar después |
| **Libera.Chat (IRC)** | Chat | Tradicional, canales por proyecto (#archlinux, #gentoo, etc.) |
| **Stack Overflow** | QA | Más orientado a programación, no a problemas de escritorio |

## Dónde mirar primero: logs del sistema

```bash
# Kernel (hardware, drivers, USB, PCI)
dmesg | grep -i error                # errores del kernel
dmesg | grep -i nvidia               # filtrar por dispositivo específico

# Systemd y servicios
journalctl -p err                    # todos los errores del sistema
journalctl -xe                       # error + contexto extendido (último fallo)
journalctl -u nginx --since "1 hour ago"  # logs de un servicio específico
journalctl -f                        # seguir logs en tiempo real

# Sistema gráfico (Xorg)
cat /var/log/Xorg.0.log | grep EE    # errores del servidor X (solo X11)

# Aplicaciones
dconf watch /                         # monitorear cambios de config en GNOME/GTK
strace -p <PID>                       # ver llamadas al sistema de un proceso en ejecución

# Archivos de log comunes
ls /var/log/
# syslog, kern.log, auth.log, dpkg.log, boot.log, apt/
```

## Diagnóstico paso a paso

### Problema de red ("no tengo internet")

```bash
# 1. ¿La interfaz está activa?
ip link set wlan0 up                  # activar si está down
ip a                                    # ver dirección IP asignada

# 2. ¿Llegas al gateway?
ip route                                # cuál es tu gateway
ping -c 3 192.168.1.1                    # el gateway responde?

# 3. ¿Llegas a internet?
ping -c 3 8.8.8.8                        # conectividad IP básica (sin DNS)

# 4. ¿DNS resuelve?
dig google.com                           # o: host google.com
ping -c 3 google.com                     # prueba completa con DNS

# Si falla en el paso 2: problema de WiFi/ Ethernet
# Si falla en el paso 3: problema de gateway/router
# Si falla en el paso 4: problema de DNS
```

### Problema de sonido ("no se escucha nada")

```bash
# 1. ¿El hardware está detectado?
lspci | grep -i audio                    # tarjeta de sonido en PCI?

# 2. ¿El servidor de sonido está corriendo?
pactl info                               # info de PulseAudio/PipeWire
systemctl --user status pipewire         # PipeWire activo?

# 3. ¿Las salidas disponibles?
pactl list sinks short                   # listar dispositivos de salida

# 4. Probar sonido directo
aplay /usr/share/sounds/alsa/Front_Center.wav
speaker-test -t sine -f 440 -l 1         # tono de prueba
```

### Problema de permisos ("Permission denied")

```bash
# 1. ¿Quién es el dueño?
ls -la archivo                           # permisos y propietario

# 2. ¿Qué usuario eres?
id                                       # tu UID y grupos

# 3. Si es un directorio: ¿tienes permiso de ejecución?
ls -dl directorio                        # la x en directorios = poder entrar

# 4. ¿Es un mount con opciones restrictivas?
mount | grep /ruta                       # ver opciones (noexec, nosuid, ro)

# 5. ¿Es SELinux/AppArmor?
ausearch -m avc --just-one               # buscar denegaciones de SELinux
```

## Cómo pedir ayuda (para obtener respuestas útiles)

1. **Di qué distro y versión usas** — "Arch actualizado a fecha X" o "Ubuntu 24.04"
2. **Pega el comando exacto que ejecutaste y su salida** — no parafrasees
3. **Describe qué esperabas que pasara** — "quería que nginx sirviera en el puerto 8080"
4. **Muestra qué has probado ya** — así no te sugieren lo mismo
5. **Copia el log relevante** — 5 líneas alrededor del error, no 200 líneas

**Mal ejemplo:** "No me funciona el wifi"
**Buen ejemplo:** "Arch Linux, kernel 6.8. Mi WiFi Intel AX200 se conecta pero no obtiene IP. `ip a` muestra la interfaz `wlan0` con `NO-CARRIER`. Probé `dhcpcd wlan0` y dice 'no interfaces found'. `lspci -k` detecta el adaptador."

## Enlaces externos

- [Arch Wiki — System administration](https://wiki.archlinux.org/title/System_administration)
- [Unix & Linux Stack Exchange](https://unix.stackexchange.com/)
- [Reddit — r/linuxquestions](https://www.reddit.com/r/linuxquestions/)
- [Red Hat — Troubleshooting guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/troubleshooting/index)
- [Linux man pages online](https://man.archlinux.org/)
- [TLDR pages — ejemplos prácticos de comandos](https://tldr.sh/)

## Ver también

- [[journalctl]] — comando para consultar logs de systemd
- [[WiFi no conecta]] · [[Sin sonido]] · [[Error de permisos]] — troubleshooting específico
- [[Automatización y Scripts]] — automatizar diagnósticos

#troubleshooting #recursos
