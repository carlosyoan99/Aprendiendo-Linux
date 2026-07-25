---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: sistema
prioridad: alta
---

# SELinux y AppArmor — Control de Acceso Obligatorio (MAC)

## Definición

SELinux (Security-Enhanced Linux) y AppArmor son sistemas de **Control de Acceso Obligatorio (MAC)** que restringen qué puede hacer cada programa, incluso cuando el usuario que lo ejecuta tiene permisos. Complementan el modelo tradicional de permisos de Linux (DAC — Discretionary Access Control) añadiendo una capa de seguridad adicional.

```
Diferencia entre DAC y MAC:

  DAC (Permisos tradicionales):
  ┌─────────┐       ┌───────────┐
  │ Usuario │──────►│  Archivo  │
  │  (root) │       │  (rwx...) │
  └─────────┘       └───────────┘
  root puede hacer lo que quiera — sin restricciones.

  DAC + MAC (SELinux / AppArmor):
  ┌─────────┐       ┌───────────┐       ┌──────────────────┐
  │ Usuario │──────►│  Archivo  │───?──►│  ¿Política MAC   │
  │  (root) │       │  (rwx...) │       │  lo permite?     │
  └─────────┘       └───────────┘       └────────┬─────────┘
                                                  │
                           Sí ───────────────────┤
                                                  │ No
                                           ┌──────▼──────┐
                                           │  PERMISO     │
                                           │  DENEGADO    │
                                           └─────────────┘
```

| Sistema | Default en | Enfoque | Configuración |
|---|---|---|---|
| **SELinux** | Fedora, RHEL, CentOS, Rocky Linux | Etiquetas (contextos) en cada archivo/proceso | Políticas complejas, basado en reglas de tipo |
| **AppArmor** | openSUSE, Debian, Ubuntu | Perfiles por programa (paths) | Perfiles en texto plano, más fáciles de leer |

---

## SELinux — Security-Enhanced Linux

Desarrollado por la **NSA (Agencia de Seguridad Nacional de EE.UU.)** y Red Hat. Integrado en el kernel Linux desde la versión **2.6** (agosto 2003). Funciona asignando una **etiqueta de contexto** a cada archivo, proceso, puerto y recurso del sistema, y definiendo reglas que permiten o niegan interacciones entre ellos.

Además de Linux, SELinux también está presente en **Android** desde la versión 4.3 (Jelly Bean) en modo permisivo, y en modo enforcing completo desde **Android 5.0** (Lollipop).

### Tipos de política

| Política | Descripción | Uso |
|---|---|---|
| **Targeted** | Solo protege procesos específicos (Apache, Nginx, Samba, DNS...) | Default en Fedora/RHEL. Balance seguridad-facilidad |
| **MLS** (Multi-Level Security) | Etiquetado jerárquico por niveles de sensibilidad | Entornos militares, gubernamentales, clasificados |
| **MCS** (Multi-Category Security) | Etiquetado por categorías no jerárquicas | Contenedores, entornos multiinquilino |

### Modos de SELinux

```bash
# Ver estado actual
getenforce                                # Enforcing, Permissive, Disabled
sestatus                                  # información detallada

# Cambiar modo temporalmente (hasta reinicio)
sudo setenforce 0                         # Permissive (solo loguea, no bloquea)
sudo setenforce 1                         # Enforcing (bloquea)

# Cambiar modo permanentemente
# Editar /etc/selinux/config:
# SELINUX=enforcing    # Forzar cumplimiento (default)
# SELINUX=permissive   # Solo loguear violaciones
# SELINUX=disabled     # Desactivar SELinux completamente (requiere reinicio)
```

### Contextos de seguridad

```
Formato: usuario:rol:tipo:nivel
Ejemplo: system_u:object_r:httpd_sys_content_t:s0
```

| Campo | Significado | Ejemplo |
|---|---|---|
| `usuario` | Identidad SELinux del usuario | `system_u` (sistema), `unconfined_u` (usuario normal) |
| `rol` | Rol del proceso o recurso | `object_r` (archivo), `system_r` (proceso del sistema) |
| `tipo` | **El campo más importante** — define qué puede acceder a qué | `httpd_t` (proceso Apache), `httpd_sys_content_t` (archivos web) |

### Comandos esenciales

```bash
# ── Ver contextos ──
ls -Z /var/www/html/index.html            # contexto del archivo
ps auxZ | grep httpd                      # contexto del proceso
id -Z                                     # contexto del usuario actual

# ── Cambiar contexto de un archivo ──
sudo chcon -t httpd_sys_content_t /ruta/archivo.html    # cambio temporal
sudo restorecon -Rv /var/www/                            # restaurar contexto por defecto

# ── Ver y gestionar políticas ──
sudo semanage boolean -l | grep httpd                    # listar booleanos (interruptores)
sudo semanage boolean --modify --on httpd_enable_homedirs  # activar booleano
sudo semanage fcontext -l | grep /var/www                # contextos por defecto
sudo semanage fcontext -a -t httpd_sys_content_t '/ruta(/.*)?'  # añadir contexto
sudo restorecon -Rv /ruta/                               # aplicar cambio

# ── Auditoría ──
sudo ausearch -m avc -ts recent                         # últimas denegaciones
sudo aureport -a -ts this-week                           # reporte semanal de denegaciones
sudo grep -i denied /var/log/audit/audit.log | tail -20 # ver denegaciones en bruto
```

### Troubleshooting: cuando SELinux bloquea algo

Síntoma típico: "Permission denied" en `/var/log/audit/audit.log` cuando los permisos normales (DAC) están bien.

```bash
# 1. Verificar que SELinux está bloqueando
sudo ausearch -m avc -ts recent | grep -i denied

# 2. Poner SELinux en modo permisivo para confirmar
sudo setenforce 0
# Probar la acción que fallaba — si funciona, SELinux es el culpable

# 3. Solucionar (elegir una):
#   a) Cambiar el contexto del archivo:
sudo chcon -t httpd_sys_content_t /ruta/que-falla
#   b) Activar un booleano:
sudo semanage boolean --modify --on httpd_enable_homedirs
#   c) Crear regla personalizada a partir del log:
sudo audit2allow -w -a                          # ver sugerencia legible
sudo audit2allow -a -M mi_regla                 # generar módulo .pp
sudo semodule -i mi_regla.pp                    # cargar regla

# 4. Volver a enforcing
sudo setenforce 1
```

### Booleanos comunes

```bash
# Ver todos los booleanos
getsebool -a

# Algunos útiles:
httpd_enable_homedirs          # Apache lee /home/*/public_html (OFF por defecto)
httpd_can_network_connect      # Apache hace conexiones de red (OFF)
httpd_can_sendmail             # Apache envía correo (OFF)
httpd_use_nfs                  # Apache accede a archivos en NFS (OFF)
virt_use_nfs                   # KVM/VirtualBox accede a NFS (OFF)
ftp_home_dir                   # vsftpd accede a /home (OFF)
samba_export_all_rw            # Samba escribe a cualquier archivo (OFF)
```

---

## AppArmor — Perfiles por programa

AppArmor (Application Armor) usa **perfiles** que describen qué archivos, redes y capacidades puede usar cada programa. Cada perfil es un archivo de texto en `/etc/apparmor.d/`.

### Modos de AppArmor

```bash
# Ver estado
sudo aa-status                              # perfiles cargados, procesos, modos
sudo apparmor_status                        # igual (comando alternativo)

# Modos por perfil:
#   enforce  → bloquea lo que no está permitido
#   complain → registra infracciones pero no bloquea (modo aprendizaje)
```

### Estructura de un perfil

```bash
# /etc/apparmor.d/usr.sbin.nginx
#include <tunables/global>

/usr/sbin/nginx {
    #include <abstractions/base>
    #include <abstractions/nameservice>

    # Archivos de configuración
    /etc/nginx/** r,

    # Archivos de log
    /var/log/nginx/** rw,

    # Archivos web
    /usr/share/nginx/html/** r,
    /var/www/** r,

    # Socket de red (escuchar en puertos)
    network inet tcp,

    # Denegar todo lo demás implícitamente
}
```

Cada línea especifica una **ruta** y **permisos**:

| Permiso | Significado |
|---|---|
| `r` | Read (leer) |
| `w` | Write (escribir) |
| `x` | Execute (ejecutar) |
| `m` | Memory map (mmap) |
| `l` | Link (crear enlaces) |
| `k` | Lock (bloquear archivos) |
| `ix` | Ejecutar inhérit (el hijo hereda el perfil) |
| `px` | Ejecutar perfil secundario (el hijo tiene otro perfil) |

### Comandos esenciales

```bash
# ── Estado ──
sudo aa-status                              # listar perfiles y procesos
sudo apparmor_status                        # alternativa

# ── Cambiar modo de un perfil ──
sudo aa-complain /usr/sbin/nginx            # modo complain (solo log)
sudo aa-enforce /usr/sbin/nginx             # modo enforcing (bloquea)
sudo aa-disable /usr/sbin/nginx             # desactivar perfil

# ── Recargar perfil tras editarlo ──
sudo apparmor_parser -r /etc/apparmor.d/usr.sbin.nginx

# ── Generar perfil desde logs ──
sudo aa-genprof /usr/sbin/nginx             # asistente interactivo
# Ejecutas la app, aa-genprof detecta qué necesita y lo pregunta

# ── Modo aprendizaje automático ──
sudo aa-logprof                             # analiza logs y sugiere reglas
```

### Troubleshooting con AppArmor

```bash
# Ver denegaciones
sudo grep -i denied /var/log/syslog | grep -i apparmor
sudo journalctl -f | grep -i apparmor       # en tiempo real
sudo aa-logprof                             # asistente para crear reglas

# Ver archivo de log de AppArmor (algunas distros)
cat /var/log/apparmor/denied
```

---

## Tabla comparativa

| Característica | SELinux | AppArmor |
|---|---|---|
| **Modelo** | Etiquetas (label-based) | Perfiles por ruta (path-based) |
| **Facilidad inicial** | ⭐ | ⭐⭐⭐⭐ |
| **Control fino** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Rendimiento** | ~1-3% overhead | Mínimo |
| **Default en** | Fedora, RHEL, Rocky, CentOS | openSUSE, Debian, Ubuntu |
| **Documentación** | Abundante pero densa | Clara, ejemplos prácticos |
| **Desactivar completamente** | Reinicio necesario | `aa-disable` inmediato |
| **Auditoría** | audit.log, ausearch, aureport | syslog, journalctl, aa-logprof |
| **Ideal para** | Servidores empresariales, alto aseguramiento | Escritorios, servidores pequeños, principiantes |

---

## Cuándo intervienen

Los sistemas MAC bloquean operaciones que los permisos normales permitirían. Ejemplos típicos:

| Situación | SELinux (Fedora/RHEL) | AppArmor (Ubuntu/Debian) |
|---|---|---|
| Apache no puede leer archivos en `/home/user/public_html/` | Booleano `httpd_enable_homedirs` | Añadir `/home/*/public_html/** r` al perfil |
| Nginx no puede escribir logs en `/var/log/nginx/` | Contexto `httpd_log_t` en `/var/log/nginx` | El perfil ya suele incluir `rw` en esa ruta |
| Servicio no puede escuchar en un puerto no estándar | `semanage port -a -t http_port_t -p tcp 8080` | Añadir `network inet tcp` al perfil |
| Script personal no puede ejecutarse desde `/srv/` | `semanage fcontext -a -t httpd_sys_script_exec_t` | `px` para ejecución con perfil |

---

## Buenas prácticas

### No desactivar la seguridad

```bash
# ❌ Lo que nunca debes hacer:
sudo setenforce 0                           # parche temporal, no solución
sudo systemctl stop apparmor                # igual

# ✅ Lo correcto:
# 1. Identificar qué deniega
# 2. Ajustar contexto, booleano o perfil
# 3. Volver a enforcing/enforce
```

### Modo permisivo/complain para aprendizaje

Cuando instalas un servicio nuevo y no sabes qué necesita:

```bash
# SELinux: modo permisivo temporal
sudo setenforce 0
# ... usar el servicio ...
sudo ausearch -m avc -ts recent | audit2allow -M mi_servicio
sudo semodule -i mi_servicio.pp
sudo setenforce 1

# AppArmor: perfil en modo complain
sudo aa-complain /usr/sbin/mi-servicio
# ... usar el servicio ...
sudo aa-logprof                           # genera reglas automáticamente
sudo aa-enforce /usr/sbin/mi-servicio
```

### Verificar antes de tocar

```bash
# ¿Qué sistema MAC usa tu distro?
if command -v getenforce &>/dev/null; then
    echo "SELinux: $(getenforce)"
elif command -v aa-status &>/dev/null; then
    echo "AppArmor: perfiles cargados"
    sudo aa-status --brief
else
    echo "No se detecta SELinux ni AppArmor activo"
fi
```

---

## Ver también

- [[Permisos y Propietarios]] — DAC, la capa base de permisos
- [[ACLs]] — extensión de permisos tradicionales
- [[Firewall]] — control de acceso a nivel de red
- [[Procesos y Senales]] — cómo los procesos interactúan con los sistemas MAC
- [[Contenedores]] — los contenedores usan MAC como capa de seguridad adicional

## Enlaces externos

- [Wikipedia — SELinux](https://en.wikipedia.org/wiki/SELinux)
- [Wikipedia — AppArmor](https://en.wikipedia.org/wiki/AppArmor)
- [Red Hat — SELinux manual](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/index)
- [Ubuntu — AppArmor wiki](https://wiki.ubuntu.com/AppArmor)

#sistema
#seguridad
