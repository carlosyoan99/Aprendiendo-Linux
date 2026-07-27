---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: concepto
prioridad: alta
---

# Daemon — Servicios y procesos en segundo plano

> Un **daemon** (demonio) es un programa que se ejecuta en **segundo plano**, sin intervención directa del usuario, y suele iniciarse durante el arranque del sistema para proveer servicios. Ejemplos: `sshd` (SSH), `httpd` (Apache), `systemd-journald`, `cron`.

## Qué es

En sistemas Unix/Linux, los daemons son procesos que:
- No tienen terminal asociada (se ejecutan en background)
- No interactúan directamente con el usuario (sin GUI ni TUI)
- Se inician automáticamente al arrancar el sistema
- Proveen servicios o realizan tareas periódicas

El nombre "daemon" proviene del **demonio de Maxwell** (James Clerk Maxwell), un ser imaginario que vigilaba moléculas. En informática, el término fue usado por primera vez en 1963 en el proyecto MAC del MIT para un proceso que realizaba backups. Fernando J. Corbató, líder del proyecto, eligió el nombre basándose en el demonio de Maxwell.

## Por qué importa

Entender los daemons es fundamental para:
- **Administrar el sistema**: saber qué servicios están corriendo y por qué.
- **Diagnosticar problemas**: identificar qué daemon falla al revisar logs.
- **Hardanizar la seguridad**: minimizar daemons activos reduce la superficie de ataque.
- **Automatizar tareas**: un script que corre como daemon puede monitorear, responder y mantenerse vivo.

Sin daemons, Linux sería un sistema sin red, sin cron, sin servidores, sin impresoras, sin escritorio gráfico — cada servicio tendría que iniciarse manualmente en una terminal y morir al cerrarla.

## Características

| Característica | Explicación |
|---|---|
| **Segundo plano** | Sin terminal, sin interacción directa |
| **Persistencia** | Se ejecutan mientras el sistema está activo |
| **Inicio automático** | systemd, SysV init o rc.d los gestionan |
| **Logging** | Usan syslog/journald para registrar eventos (no stdout) |
| **PID file** | Suelen crear `/var/run/daemon.pid` para tracking |
| **Usuario** | Suelen ejecutarse como `root` o usuario específico (`www-data`, `nobody`) |

## Identificar daemons

```bash
# Listar procesos con daemons (sin terminal asociada)
ps aux | grep ?

# Más preciso: ver procesos cuyo TTY es '?'
ps aux | awk '$7 == "?"'

# Listar servicios de systemd (todos los daemons gestionados)
systemctl list-units --type=service --state=running

# Ver PID 1 (primer proceso, systemd)
ps -p 1

# Ver puertos en escucha (servicios de red)
sudo ss -tlnp
sudo netstat -tlnp
```

## Tipos de daemons

### Daemons del sistema

| Daemon | Función | Init |
|---|---|---|
| **systemd** | PID 1, gestiona servicios | systemd |
| **journald** | Sistema de logs | systemd |
| **sshd** | Servidor SSH | systemd |
| **cron** / **systemd-timer** | Tareas programadas | systemd |
| **NetworkManager** | Gestión de redes | systemd |
| **ufw** / **nftables** | Firewall | systemd |
| **cupsd** | Servicio de impresión | systemd |
| **bluetoothd** | Bluetooth | systemd |

### Daemons de aplicaciones

| Daemon | Aplicación | Función |
|---|---|---|
| **httpd** / **nginx** | Servidor web | Servir páginas web |
| **mysqld** / **postgresql** | Base de datos | Gestión de datos |
| **dockerd** | Docker | Gestión de contenedores |
| **Xorg** / **Wayland compositor** | Servidor gráfico | Gestión de pantalla |
| **pipewire** | Audio | Gestión de audio y video |

## Diagrama del ciclo de daemonización

```
┌─────────────────────────────────────────────────────────────┐
│                    CICLO DE DAEMONIZACIÓN                    │
└─────────────────────────────────────────────────────────────┘

       ┌─────────┐
       │  fork() │
       └────┬────┘
            │
      ┌─────┴──────┐
      ▼            ▼
┌─────────┐  ┌──────────┐
│ Padre   │  │ Hijo     │
│ (PID A) │  │ (PID B)  │
│ exit(0) │  │          │
└─────────┘  └────┬─────┘
                  │
            ┌─────▼──────┐
            │  setsid()  │
            │ (nueva     │
            │  sesión)   │
            └─────┬──────┘
                  │
            ┌─────▼──────┐
            │  chdir("/")│
            └─────┬──────┘
                  │
            ┌─────▼──────┐
            │ close(0)   │← STDIN
            │ close(1)   │← STDOUT
            │ close(2)   │← STDERR
            └─────┬──────┘
                  │
            ┌─────▼──────────┐
            │ open("/dev/null")│
            │ como STDIN/OUT/ERR│
            └─────┬──────────┘
                  │
            ┌─────▼──────┐
            │ Código del │
            │ daemon     │
            │ (bucle     │
            │  infinito) │
            └────────────┘
```

## Cómo funciona internamente

Cuando un programa se convierte en daemon, sigue este proceso:

1. **`fork()`** — crea un proceso hijo
2. El **proceso padre termina** (el hijo hereda el grupo de procesos)
3. **`setsid()`** — crea una nueva sesión, se desvincula de la terminal
4. **`chdir("/")`** — cambia el directorio de trabajo a `/` (para no bloquear montajes)
5. **Cierra STDIN, STDOUT, STDERR** — se desvincula de los file descriptors de la terminal
6. **Abre `/dev/null`** como nueva entrada/salida estándar

```c
// Ejemplo simplificado de daemonización en C
#include <unistd.h>
#include <stdlib.h>

void daemonizar() {
    pid_t pid = fork();
    if (pid < 0) exit(EXIT_FAILURE);
    if (pid > 0) exit(EXIT_SUCCESS);  // padre termina

    setsid();               // nueva sesión
    chdir("/");             // cambiar a /
    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);
    // ... código del daemon
}
```

## Gestión con systemd

Hoy en día la mayoría de los daemons se gestionan mediante **systemd**:

```bash
# Ver estado de un servicio/daemon
systemctl status sshd

# Iniciar/Detener
sudo systemctl start sshd
sudo systemctl stop sshd

# Habilitar/Deshabilitar en arranque
sudo systemctl enable sshd
sudo systemctl disable sshd

# Ver logs de un daemon
journalctl -u sshd
journalctl -u sshd --since "1 hour ago"
```

### Crear un servicio systemd (ejemplo)

```bash
# /etc/systemd/system/mi-daemon.service
[Unit]
Description=Mi Daemon de ejemplo
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/mi-daemon
Restart=on-failure
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target
```

## Señales comunes para daemons

Los daemons responden a señales específicas para recargar configuraciones, rotar logs o terminar gracefulmente:

| Señal | Número | Uso típico en daemons |
|---|---|---|
| **SIGHUP** | 1 | Recargar configuración sin reiniciar (nginx -s reload, sshd, cron) |
| **SIGTERM** | 15 | Terminación graceful — el daemon limpia recursos y sale |
| **SIGKILL** | 9 | Terminación forzada — no se puede capturar ni ignorar |
| **SIGUSR1** | 10 | Señal definida por la app — ej. rotar logs, dump stats |
| **SIGUSR2** | 12 | Señal definida por la app — ej. activar/desactivar debug |
| **SIGINT** | 2 | Interrupción manual (Ctrl+C) — algunos daemons la capturan |
| **SIGCHLD** | 17 | Hijo terminó — útil para daemons que lanzan procesos hijos |
| **SIGPIPE** | 13 | Escritura en pipe roto — daemons de red la capturan para no caerse |

```bash
# Enviar SIGHUP para recargar configuración
sudo kill -HUP $(cat /var/run/sshd.pid)

# Enviar SIGUSR1 para rotar logs (ej. rsyslog)
sudo kill -USR1 $(pidof rsyslogd)

# Ver qué señales captura un proceso
kill -l               # lista de señales disponibles
```

> Ver [[Procesos y Senales]] para la referencia completa de señales en Linux.

## Hardening de servicios systemd

systemd permite restringir qué puede hacer un daemon mediante opciones de hardening en el `.service`. Esto reduce drásticamente la superficie de ataque:

```ini
# /etc/systemd/system/mi-daemon-hardened.service
[Unit]
Description=Daemon con hardening
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/mi-daemon

# === Hardening ===
ProtectSystem=strict          # Solo lectura en /usr y /etc (excepto /etc writable)
ProtectHome=true              # /home, /root y /run/user no accesibles
PrivateTmp=true               # /tmp aislado (no comparte con otros procesos)
NoNewPrivileges=true          # Impide escalar privilegios (su, sudo)
CapabilityBoundingSet=        # Vacío = sin capacidades especiales
RestrictAddressFamilies=      # Solo ciertas familias de red (~AF_UNIX AF_INET)
MemoryMax=100M                # Límite de memoria
TasksMax=10                   # Límite de tareas/procesos
ReadWritePaths=/var/lib/mi-app # Solo estas rutas son editables

[Install]
WantedBy=multi-user.target
```

```bash
# Ver qué nivel de hardening tiene un servicio
systemd-analyze security sshd
systemd-analyze security nginx
```

**Niveles de exposición** (según `systemd-analyze security`):
- ✅ 0.0-3.0 SAFE — excelente hardening
- 🟡 3.0-7.0 MEDIUM — moderado
- 🔴 7.0-10.0 UNSAFE — expuesto, necesita revisión

## Buenas prácticas de logging

Los daemons no deben escribir a stdout/stderr (no hay terminal). En su lugar:

| Método | Mecanismo | Ejemplo |
|---|---|---|
| **syslog()** | Llamada a syslog del sistema | `openlog("mi-daemon", LOG_PID, LOG_DAEMON)` |
| **journald** | Logging nativo systemd | `systemd-cat echo "mensaje"` |
| **Archivo propio** | Escribir a `/var/log/` | `echo "error" >> /var/log/mi-daemon.log` |

```bash
# Ver logs de un daemon específico con journald
journalctl -u mi-daemon -f                        # seguir en tiempo real
journalctl -u mi-daemon --since "2 hours ago"       # últimas 2 horas
journalctl -u mi-daemon -p err                     # solo errores
journalctl -u mi-daemon -o json-pretty             # en formato JSON
```

**Recomendaciones:**
- Usar `journald` cuando el servicio es gestionado por systemd (es automático con `journalctl -u`)
- Usar `syslog()` para daemons tradicionales o portables entre inits
- Nunca escribir a `/tmp/` — usar `/var/log/mi-app/` con logrotate configurado
- Rotar logs con `logrotate`:

```bash
# /etc/logrotate.d/mi-daemon
/var/log/mi-daemon/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    postrotate
        systemctl kill -s USR1 mi-daemon
    endscript
}
```

## Daemons en diferentes sistemas

| Sistema | Cómo llama a los daemons |
|---|---|
| **Unix/Linux** | Daemon, demonio |
| **Windows** | Servicios (Services.msc) |
| **macOS** | Launch Daemons (`/Library/LaunchDaemons/`) |
| **MS-DOS** | TSR (Terminate and Stay Resident) |

## Notas personales

- No confundir "daemon" con "demonio" (demon) en el sentido maléfico — el término viene del demonio de Maxwell de la termodinámica, un agente que trabaja silenciosamente en segundo plano.
- La regla de oro de seguridad: **menos daemons = menos superficie de ataque**. En un sistema minimalista, desactiva todo lo que no necesites (`systemctl disable`).
- Los daemons de red son los más críticos: cada puerto abierto es un vector potencial.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Daemon no arranca | Error de configuración | `journalctl -u nombre-servicio` |
| Daemon se cae constantemente | Bug o falta de recursos | `Restart=on-failure` en .service + `ulimit` |
| Puerto en uso (Address already in use) | Daemon ya corriendo | `sudo ss -tlnp | grep :puerto`, `sudo systemctl restart servicio` |
| No se puede detener | Proceso zombi | `kill -9 PID` o matar proceso padre |
| Daemon no responde | Deadlock o loop infinito | `strace -p PID` para ver syscalls, `gdb -p PID` para debug |

## Comandos asociados

| Comando | Para qué |
|---|---|
| `systemctl status <servicio>` | Ver estado de un daemon systemd |
| `systemctl start/stop/restart <servicio>` | Gestionar un daemon (iniciar, detener, reiniciar) |
| `systemctl enable/disable <servicio>` | Activar/desactivar inicio automático |
| `journalctl -u <servicio>` | Ver logs de un daemon específico |
| `ps aux | grep ?` | Listar procesos sin terminal (daemons) |
| `ss -tlnp` | Ver puertos en escucha (servicios de red) |
| `kill -1 <PID>` | Enviar SIGHUP para recargar configuración |

## Ver también

- [[Procesos y Senales]] — gestión de procesos en Linux
- [[systemd]] — sistema de init y gestión de servicios
- [[Cron]] · [[systemd timers]] — tareas programadas
- [[SSH]] — conexión remota con sshd
- [[journalctl]] — ver logs de daemons

## Enlaces externos

- [Wikipedia — Daemon (informática)](https://es.wikipedia.org/wiki/Daemon_(inform%C3%A1tica))
- [Arch Wiki — systemd](https://wiki.archlinux.org/title/Systemd)
- [How to write a Linux daemon](https://www.enderunix.org/docs/eng/daemon.php)
- [Daemonize — herramienta para convertir procesos en daemons](http://software.clapper.org/daemonize/)

#concepto
