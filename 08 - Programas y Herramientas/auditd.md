---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# auditd — Linux Audit Daemon

## Definición

`auditd` es el **daemon de auditoría de Linux** que registra eventos de seguridad: accesos a archivos, ejecución de comandos, cambios de permisos, conexiones de red, y llamadas al sistema. Es parte del **Linux Auditing System** (audit), que permite rastrear qué proceso hizo qué y cuándo.

```
auditd architecture:

  ┌──────────┐   ┌───────────┐   ┌──────────────┐
  │  Kernel  │──►│ auditd    │──►│ /var/log/    │
  │ (netlink)│   │ (daemon)  │   │ audit/       │
  └──────────┘   └─────┬─────┘   │ audit.log    │
                       │          └──────────────┘
              ┌────────┴────────┐
              │                 │
         ┌──────────┐   ┌──────────┐
         │ ausearch │   │ aureport │
         │ (buscar) │   │(reportes)│
         └──────────┘   └──────────┘
```

**auditd vs syslog/journald:** mientras syslog registra lo que las aplicaciones deciden loguear, auditd registra lo que **el kernel ve** — no depende de que la aplicación coopere.

---

## Instalación

```bash
# Debian/Ubuntu
sudo apt install auditd audispd-plugins

# Arch
sudo pacman -S audit

# Fedora/RHEL
sudo dnf install audit

# Verificar que está corriendo
sudo systemctl status auditd
sudo systemctl enable --now auditd
```

---

## Reglas de auditoría: auditctl

Las reglas definen **qué eventos registrar**. Se configuran con `auditctl` (en caliente) o en `/etc/audit/rules.d/`.

### Reglas básicas

```bash
# ── Reglas de archivo ──
# -w: watch (archivo/directorio)
# -p: permisos (r=read, w=write, x=exec, a=attr change)
# -k: key (etiqueta para filtrar después)

# Monitorear /etc/passwd (lectura y escritura)
sudo auditctl -w /etc/passwd -p rwa -k passwd_changes

# Monitorear /etc/shadow
sudo auditctl -w /etc/shadow -p rwa -k shadow_changes

# Monitorear /etc/ssh/sshd_config
sudo auditctl -w /etc/ssh/sshd_config -p rwa -k sshd_config

# Monitorear todo /etc (¡puede generar muchos logs!)
sudo auditctl -w /etc/ -p wa -k etc_changes
```

```bash
# ── Reglas de llamadas al sistema ──
# -a: añadir regla a una lista
# always,exit: siempre registrar al salir de la syscall
# -S: syscall a monitorear
# -F: filtro (uid, arch, etc.)

# Registrar ejecución de cualquier comando como root
sudo auditctl -a always,exit -S execve -F uid=0 -k root_exec

# Registrar cambios de hora (sospechoso en auditoría forense)
sudo auditctl -a always,exit -S settimeofday,adjtimex -k time_changes

# Registrar cambios de permisos (chmod, chown, setxattr)
sudo auditctl -a always,exit -S chmod,fchmod,chown,fchown -k perm_changes
```

```bash
# ── Gestión de reglas ──
# Listar todas las reglas activas
sudo auditctl -l

# Eliminar una regla (usar la línea exacta de auditctl -l)
sudo auditctl -W /etc/passwd -p rwa -k passwd_changes

# Eliminar TODAS las reglas (cuidado — reinicia service para restaurar)
sudo auditctl -D
sudo systemctl restart auditd
```

### Reglas persistentes

Para que las reglas sobrevivan al reinicio, escribirlas en `/etc/audit/rules.d/`:

```bash
# /etc/audit/rules.d/99-mis-reglas.rules
# Monitorear archivos críticos
-w /etc/passwd -p rwa -k passwd_changes
-w /etc/shadow -p rwa -k shadow_changes
-w /etc/ssh/sshd_config -p rwa -k sshd_config
-w /var/log/auth.log -p wa -k auth_log

# Monitorear ejecución de comandos importantes
-a always,exit -S execve -F uid=0 -k root_exec
-a always,exit -S execve -F euid=0 -k root_exec

# Monitorear cambios de archivos de www
-w /var/www/ -p wa -k www_changes

# Monitorear cambios de red
-a always,exit -S bind -k network_bind
-a always,exit -S connect -k network_connect

# Monitorear instalación de módulos del kernel
-w /sbin/insmod -p x -k kernel_module
-w /sbin/modprobe -p x -k kernel_module
-w /sbin/rmmod -p x -k kernel_module
```

```bash
# Aplicar reglas persistentes
sudo systemctl restart auditd   # o
sudo augenrules --load          # cargar reglas desde /etc/audit/rules.d/

# Verificar que se cargaron
sudo auditctl -l
```

---

## Buscar eventos: ausearch

`ausearch` busca eventos en los logs de auditd usando múltiples filtros.

```bash
# ── Por clave (key) ──
sudo ausearch -k passwd_changes            # eventos con key "passwd_changes"
sudo ausearch -k root_exec                 # ejecuciones como root

# ── Por tipo de evento ──
sudo ausearch -m EXECVE                    # ejecuciones de comandos
sudo ausearch -m PATH                      # accesos a archivos
sudo ausearch -m USER_CMD                  # comandos ejecutados por usuario
sudo ausearch -m AVC                       # denegaciones de SELinux

# ── Por tiempo ──
sudo ausearch -ts today                    # desde hoy a las 00:00
sudo ausearch -ts 09:00:00                 # desde las 9am de hoy
sudo ausearch -ts 07/15/2026              # desde fecha específica
sudo ausearch -te now                      # hasta ahora
sudo ausearch -ts 09:00 -te 18:00          # rango de tiempo

# ── Por usuario / proceso ──
sudo ausearch -ua root                     # eventos del usuario root (UID/auid)
sudo ausearch -p 1234                      # eventos del PID 1234
sudo ausearch -c bash                      # comandos ejecutados por bash

# ── Por archivo ──
sudo ausearch -f /etc/passwd              # eventos relacionados con el archivo
sudo ausearch -f /etc/ssh/sshd_config

# ── Por resultado ──
sudo ausearch --success yes                # solo operaciones exitosas
sudo ausearch --success no                 # solo operaciones denegadas/fallidas

# ── Formato legible ──
sudo ausearch -k passwd_changes -i         # -i = interpretar (UIDs → nombres, timestamps legibles)
sudo ausearch -k root_exec -i --line       # formato de una línea
```

### Ejemplo de salida de ausearch

```
----
time->Sun Jul 19 14:23:45 2026
type=PROCTITLE msg=audit(1721405025.123:456): proctitle=2F746F7563682F... (leído como "/usr/bin/vim /etc/passwd")
type=PATH msg=audit(1721405025.123:456): item=0 name="/etc/passwd" inode=123456 dev=08:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
type=CWD msg=audit(1721405025.123:456): cwd="/root"
type=SYSCALL msg=audit(1721405025.123:456): arch=c000003e syscall=2 success=no exit=-13 a0=7ffe8c1f a1=80000 a2=7ffe8c1f a3=0 items=1 ppid=1234 pid=5678 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="vim" exe="/usr/bin/vim.nox" key="passwd_changes"
```

**Campos clave:**
- `time`: timestamp del evento
- `success=no` / `exit=-13`: operación denegada (EACCES) o fallida
- `proctitle`: qué comando se ejecutó
- `auid=1000`: ID de auditoría (usuario original que inició sesión)
- `uid=0 euid=0`: el comando se ejecutó como root
- `comm="vim"`: comando abreviado
- `exe="/usr/bin/vim.nox"`: binario exacto
- `key="passwd_changes"`: la etiqueta que pusiste en la regla

---

## Reportes: aureport

`aureport` genera resúmenes estadísticos de los logs de auditoría.

```bash
# ── Reportes generales ──
sudo aureport                        # resumen de todos los tipos de eventos
sudo aureport --summary              # resumen compacto

# ── Eventos por tipo ──
sudo aureport -x                     # reporte de ejecuciones de comandos
sudo aureport -f                     # reporte de accesos a archivos
sudo aureport -l                     # reporte de inicios de sesión (logins)
sudo aureport -u                     # reporte por usuario

# ── Por tiempo ──
sudo aureport -ts today              # desde hoy
sudo aureport -ts last-week          # la semana pasada
sudo aureport -ts 07/15/2026 -te 07/19/2026  # rango de fechas

# ── Eventos fallidos (anomalías) ──
sudo aureport --failed               # solo eventos fallidos
sudo aureport -x --failed            # ejecuciones fallidas
sudo aureport -f --failed            # accesos a archivos fallidos

# ── Integridad ──
sudo aureport --event                # cambios de configuración
```

### Ejemplo de reporte

```bash
$ sudo aureport -x --summary

Executable Report
============================================
# Total Executables: 42
# Total Events: 1567

# Exe                 # Events  # PID range
/usr/bin/bash         876        [root]
/usr/bin/vim.nox      234        [root]
/usr/bin/systemctl    112        [root]
/usr/bin/apt-get      89         [root]
/usr/bin/rm           45         [root]
```

---

## Configuración del daemon: /etc/audit/auditd.conf

```bash
# /etc/audit/auditd.conf

# Archivo de log (por defecto)
log_file = /var/log/audit/audit.log

# Formato de log (ENRICHED añade interpretación de UIDs, timestamps, etc.)
log_format = ENRICHED

# Rotación de logs (frequency: número de logs, max_log_file: tamaño en MB)
max_log_file = 50                        # 50 MB máximo por archivo
num_logs = 10                            # mantener 10 archivos rotados
max_log_file_action = ROTATE             # ROTATE o IGNORE o SYSLOG o SUSPEND

# Tamaño del buffer de evento (valores altos = mejor rendimiento en servidores cargados)
# Medir uso actual con: sudo auditctl -s | grep backlog
backlog_limit = 8192                     # eventos en cola antes de descartar
rate_limit = 0                           # 0 = sin límite (o poner un máximo por segundo)

# Acción si se llena la cola
# IGNORE → descartar eventos; SYSLOG → loguear en syslog; SUSPEND → pausar auditd
overflow_action = SYSLOG

# Espacio en disco (acción si se llena el disco)
space_left = 75                         # % de espacio libre antes de alertar
space_left_action = SYSLOG              # SYSLOG, EMAIL, SUSPEND
admin_space_left = 50                   # % crítico
admin_space_left_action = SUSPEND       # pausar auditd si queda poco espacio

disk_full_action = SUSPEND              # qué hacer si el disco se llena
disk_error_action = SYSLOG              # qué hacer ante error de disco
```

---

## Troubleshooting

```bash
# ── auditd no arranca ──
sudo journalctl -u auditd -n 50 --no-pager

# ── Ver estado y estadísticas ──
sudo auditctl -s
# enabled 1         → auditd está activo
# failure 0         → sin fallos
# pid 1234          → PID del daemon
# rate_limit 0      → sin límite de eventos/segundo
# backlog_limit 8192 → capacidad de la cola
# lost 0            → eventos perdidos (si > 0, aumentar backlog_limit)
# backlog 0         → eventos en cola actualmente

# ── Eventos perdidos ──
# Si "lost" es > 0, aumentar en /etc/audit/auditd.conf:
# backlog_limit = 65536
# rate_limit = 5000  (máximo 5000 eventos/segundo)

# ── Demasiados eventos en el log ──
# Revisar reglas con auditctl -l y eliminar reglas demasiado amplias
# Especialmente -w /etc/ -p wa (monitorear /etc entero puede generar millones de eventos)
# Usar -k para etiquetar y poder filtrar después

# ── No veo eventos esperados ──
# Verificar que la regla está cargada:
sudo auditctl -l | grep passwd
# Verificar que el archivo existe y es accesible:
sudo ausearch -k passwd_changes -ts today
```

---

## Integración con SELinux

auditd es el sistema de log de SELinux — todas las denegaciones de SELinux se registran aquí.

```bash
# Ver denegaciones de SELinux
sudo ausearch -m AVC -ts today           # denegaciones de SELinux
sudo ausearch -m AVC -ts recent           # últimas
sudo ausearch -m AVC --success no -i      # solo denegaciones (no permisos)

# Generar reglas SELinux a partir de logs de audit
sudo audit2allow -w -a                    # mostrar sugerencias legibles
sudo audit2allow -a -M mi_modulo          # generar módulo .pp
sudo semodule -i mi_modulo.pp             # instalar módulo
```

> Ver [[SELinux y AppArmor]] para más contexto sobre denegaciones MAC.

---

## Ejemplos prácticos

### Investigar quién modificó /etc/passwd

```bash
sudo ausearch -f /etc/passwd -ts last-week
# Identificar: qué comando, qué usuario (auid), qué PID
```

### Detectar ejecución de comandos peligrosos

```bash
# Configurar regla:
sudo auditctl -a always,exit -S execve -F path=/usr/bin/rm -k rm_exec

# Buscar después:
sudo ausearch -k rm_exec -ts today -i
```

### Monitorear accesos SSH fallidos

```bash
# auditd no monitorea SSH directamente (eso lo hace sshd/auth.log)
# Pero puede monitorear lectura de /etc/shadow:
sudo auditctl -w /etc/shadow -p r -k shadow_read

# Buscar quién leyó /etc/shadow (pista: nadie debería hacerlo)
sudo ausearch -k shadow_read -ts today
```

## Ver también

- [[SELinux y AppArmor]] — sistemas MAC que dependen de auditd para logging
- [[Logging del sistema (rsyslog journald logrotate)]] — sistema de logs general
- [[Procesos y Senales]] — strace/ltrace complementan auditd para debugging
- [[Desarrollo en Linux (gcc make gdb strace)]] — strace para syscalls en desarrollo
- [[Solucion de Problemas - Recursos]] — guía general de troubleshooting

## Enlaces externos

- [Wikipedia — Auditd](https://en.wikipedia.org/wiki/Auditd)
- [Sitio oficial — Linux Audit](https://linux-audit.com/)
- [GitHub — linux-audit/audit-userspace](https://github.com/linux-audit/audit-userspace)
- [Red Hat — Audit System Reference](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/auditing-the-system_security-hardening)

#programa #seguridad #auditoria
