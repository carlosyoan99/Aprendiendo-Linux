---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: sistema
prioridad: media
---

# s6 — Init alternativo

> Sistema de init minimalista, modular y basado en supervisión de procesos, diseñado como alternativa a systemd y SysV init. Utilizado en distribuciones como **Artix Linux**, **Obarun** y **Adelie Linux**.

## Qué es

**s6** es un conjunto de herramientas de gestión del sistema diseñado por Laurent Bercot (skarnet.org) que funciona como **init** (primer proceso en espacio de usuario). Su filosofía se basa en:

- **Simplicidad**: cada herramienta hace una cosa bien
- **Supervisión**: los procesos se supervisan y reinician automáticamente si fallan
- **Modularidad**: no depende de un binario monolítico como systemd
- **Sin D-Bus**: no requiere D-Bus para la gestión de servicios

A diferencia de systemd (que integra init, logind, journald, timesyncd, resolved, etc.), s6 es un conjunto de herramientas pequeñas que se combinan según se necesiten.

## s6 en el ecosistema de inits

```
Unix System V (1980s) → sysvinit (rc)
                   ↓
        BSD rc.d / OpenRC
                   ↓
    ┌──────────────┼──────────────┐
    ↓              ↓              ↓
 systemd       OpenRC         s6 / s6-rc
  (2010+)     (Gentoo)      (minimalista)
```

## Comparativa con otros inits

| Aspecto | systemd | OpenRC | s6 | SysV init |
|---|---|---|---|---|
| **PID 1** | systemd | init de referencia | s6-svscan | init |
| **Supervisión** | Integrada | Opcional | Nativa | No |
| **Paralelismo** | Completo | Sí | Completo | No |
| **Dependencias** | Nativo | Manual | s6-rc | Manual |
| **Logging** | journald | syslog-ng/rsyslog | s6-log | syslog |
| **Tamaño** | Grande (~50 MB) | Medio (~10 MB) | Pequeño (~500 KB) | Pequeño |
| **Complejidad** | Alta | Media | Media | Baja |
| **D-Bus** | Requerido | No | No | No |
| **binfmt** | Integrado | No | No | No |
| **Timers** | systemd-timer | cron | cron/s6-timer | cron |

## Componentes de s6

s6 no es solo un init — es una suite de herramientas:

| Componente | Función |
|---|---|
| **s6-svscan** | Supervisa procesos (PID 1) |
| **s6-supervise** | Supervisa un servicio individual |
| **s6-svc** | Controla servicios (start/stop/restart) |
| **s6-rc** | Gestión de dependencias entre servicios |
| **s6-log** | Logging (alternativa a syslog/journald) |
| **s6-timer** | Equivalente a cron |
| **execline** | Shell scripting minimalista (alternativa a bash) |

## Estructura de un servicio en s6

Cada servicio es un directorio con archivos de configuración:

```
/etc/s6/sv/sshd/
├── run          # script ejecutable para iniciar el servicio
├── finish       # script ejecutable al detener (opcional)
├── notification-fd  # pipe para notificaciones
├── timeout-kill     # tiempo antes de SIGKILL
└── down         # si existe, no arranca automáticamente
```

Ejemplo de `run` para SSH:

```bash
#!/bin/execlineb -P
# /etc/s6/sv/sshd/run

fdmove -c 1 2
s6-setuidgid root
/usr/sbin/sshd -D
```

## Instalación

```bash
# Arch Linux (AUR)
yay -S s6 s6-rc

# Gentoo
emerge -av s6 s6-rc

# Artix Linux (repos oficiales)
sudo pacman -S s6 s6-rc

# Compilar desde fuente
git clone https://skarnet.org/software/s6/s6.git
cd s6
./configure
make
sudo make install
```

## Iniciar servicios con s6

```bash
# Iniciar un servicio supervisado
s6-svc -u /etc/s6/sv/sshd

# Detener un servicio
s6-svc -d /etc/s6/sv/sshd

# Reiniciar un servicio
s6-svc -r /etc/s6/sv/sshd

# Ver estado de servicios
s6-svstat /etc/s6/sv/*
```

## Distribuciones que usan s6

| Distribución | Init por defecto | Alternativas |
|---|---|---|
| **Artix Linux** | OpenRC | s6, runit, dinit |
| **Obarun** | s6 | — |
| **Adelie Linux** | OpenRC | s6 |
| **Void Linux** | runit | s6 (experimental) |
| **Gentoo** | OpenRC | s6 (perfil ~amd64-s6) |

## s6 vs runit

s6 es muy similar en filosofía a **runit** (usado por Void Linux). De hecho, s6 es considerado el sucesor espiritual de runit con mejoras:

| Aspecto | runit | s6 |
|---|---|---|
| **Desarrollo** | Estancado (última versión 2014) | Activo |
| **Parallelización** | Limitada | Completa |
| **Dependencias** | Manual | Automática (s6-rc) |
| **Logging** | runsvchdir | s6-log (más flexible) |
| **Timers** | No | s6-timer |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Servicio no arranca | Script `run` no ejecutable | `chmod +x /etc/s6/sv/sshd/run` |
| Servicio se reinicia en bucle | `finish` reinicia automáticamente | Verificar `finish`, usar `s6-svc -d` |
| No hay logs | s6-log no configurado | Añadir pipeline de logging en `run` |
| Dependencia no resuelta | s6-rc no configurado correctamente | Verificar `dependencies` en directorio del servicio |

## Ver también

- [[systemd]] — el init por defecto en la mayoría de distros
- [[Daemon]] — servicios en segundo plano
- [[Proceso de Arranque (GRUB initramfs kernel params)]] — boot del sistema
- [[Cron y Systemd Timers]] — tareas programadas
- [[Busybox]] — init mínimo para sistemas embebidos

## Enlaces externos

- [Sitio oficial de s6](https://skarnet.org/software/s6/)
- [s6-rc documentation](https://skarnet.org/software/s6-rc/)
- [Execline scripting](https://skarnet.org/software/execline/)
- [Artix Linux — s6](https://wiki.artixlinux.org/Main/S6)

#sistema
