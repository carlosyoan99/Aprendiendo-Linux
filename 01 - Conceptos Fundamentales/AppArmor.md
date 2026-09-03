---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: concepto
prioridad: alta
---

# AppArmor

> AppArmor (Application Armor) es un sistema de seguridad Mandatory Access Control (MAC) que confina programas individuales restringiendo qué archivos, capabilities y permisos pueden usar. Es el MAC por defecto en Ubuntu/SUSE/OpenSUSE, y alternativa a SELinux en otras distros.

## ¿Qué es AppArmor?

AppArmor limita lo que un programa puede hacer, incluso si es ejecutado como root. Usa **perfiles** de texto legible que definen qué archivos puede leer/escribir, qué capacidades puede usar, y qué operaciones de red puede realizar. A diferencia de SELinux (que etiqueta cada objeto del sistema), AppArmor se centra en el **programa** y usa **rutas de archivo** para las restricciones.

**Ventaja principal**: más fácil de configurar que SELinux, perfiles en texto plano, y funciona bien para la mayoría de servidores y escritorios.

---

## Estado actual en tu sistema

```bash
# ¿Está AppArmor instalado y activo?
aa-status                             # estado completo (requiere root)
# Si no está instalado:
sudo apt install apparmor apparmor-utils apparmor-profiles  # Debian/Ubuntu
sudo pacman -S apparmor               # Arch
sudo zypper install apparmor          # openSUSE

# Verificar modo (enforce / complain / disable)
cat /sys/kernel/security/apparmor/profiles | head -20
aa-status | head -10

# Verificar en kernel
dmesg | grep -i apparmor              # mensajes del kernel sobre AppArmor
```

---

## Conceptos clave

| Concepto | Descripción |
|---|---|
| **Profil** | Archivo de texto que define las reglas para un programa |
| **Enforce mode** | El perfil se aplica activamente — violaciones bloqueadas y logged |
| **Complain mode** | El perfil se aplica pero las violaciones solo se loguean (no bloquea) |
| **Unconfined** | El programa no tiene perfil — puede hacer todo |
| **Hat** | Sub-profil que un programa puede "usar" temporalmente (ej: `sudo`) |
| **Abstraction** | Reglas reutilizables incluidas en perfiles |

---

## Gestión básica

```bash
# Ver todos los perfiles instalados
ls /etc/apparmor.d/                   # perfiles del sistema
aa-status                             # resumen: enforce, complain, unconfined

# Cambiar modo de un perfil
sudo aa-enforce /usr/sbin/nginx       # forzar modo enforce
sudo aa-complain /usr/sbin/nginx      # cambiar a modo complain (testing)
sudo aa-disable /usr/sbin/nginx       # deshabilitar perfil

# Recargar todos los perfiles
sudo systemctl reload apparmor

# Verificar un perfil específico
sudo aa-status | grep nginx
cat /etc/apparmor.d/usr.sbin.nginx
```

---

## Crear un perfil desde cero

```bash
# Generar un perfil automáticamente
sudo aa-genprof /usr/bin/mi-programa

# El asistente te pedirá:
# 1. Ejecutar el programa y usarlo normalmente
# 2. Volver a aa-genprof para ver las violaciones
# 3. Aceptar o rechazar cada regla

# O generar un perfil manualmente:
sudo nano /etc/apparmor.d/usr.bin.mi-programa
```

### Estructura de un perfil

```
#include <tunables/global>

profile mi-programa /usr/bin/mi-programa {
  # Permisos básicos
  #include <abstractions/base>

  # Acceso a archivos
  /usr/bin/mi-programa   mr,              # el propio binario
  /etc/mi-programa/      r,               # lectura de config
  /etc/mi-programa.conf  r,               # archivo de config
  /var/lib/mi-programa/  rw,              # datos de la app
  /var/log/mi-programa/  w,               # logs
  /tmp/mi-programa-*     rw,              # archivos temporales

  # Capabilities
  capability net_bind_service,             # bind a puertos <1024
  # capability net_raw,                    # raw sockets (NO recomendar)
  # capability sys_admin,                  # administración del sistema (PELIGRO)

  # Red
  network inet stream,                     # TCP IPv4
  network inet6 stream,                    # TCP IPv6
  network dgram,                           # UDP

  # Denegar explícitamente
  deny /etc/shadow    r,
  deny /root/         rw,
  deny /home/*/.*     w,                   # no escribir dotfiles de otros

  # Unix sockets (para IPC)
  unix stream peer=(label=mi-programa),
}
```

---

## Perfiles comunes del sistema

```bash
# Ver perfiles ya instalados
ls /etc/apparmor.d/
# Ejemplos:
# usr.sbin.nginx
# usr.sbin.mysqld
# usr.sbin.cupsd
# sbin.dhclient
# docker-default

# Perfiles de abstractions (reglas reutilizables)
ls /etc/apparmor.d/abstractions/
# qos, apache-common, base, cron, etc.

# Incluir abstractions en tu perfil:
# #include <abstractions/apache>
# #include <abstractions/nameservice>
# #include <abstractions/ssl_certs>
```

---

## Casos prácticos

### Caso 1: endurecer Nginx

```
# /etc/apparmor.d/usr.sbin.nginx (simplificado)
#include <tunables/global>

profile nginx /usr/sbin/nginx {
  #include <abstractions/base>
  #include <abstractions/nameservice>
  #include <abstractions/ssl_certs>

  /usr/sbin/nginx          mr,
  /etc/nginx/              r,
  /var/www/                r,
  /var/www/*/              r,
  /var/log/nginx/          rw,
  /var/lib/nginx/          rw,
  /run/nginx.pid           rw,
  /tmp/nginx*              rw,

  # Solo TCP
  network inet stream,
  network inet6 stream,

  # Denegar acceso a sistema
  deny /etc/shadow         r,
  deny /proc/*/mem         r,
  deny /root/              rw,
}
```

### Caso 2: endurecer PostgreSQL

```
# /etc/apparmor.d/usr.lib.postgresql.bin.pg_ctl
#include <tunables/global>

profile pg_ctl /usr/lib/postgresql/*/bin/pg_ctl {
  #include <abstractions/base>
  #include <abstractions/nameservice>

  /usr/lib/postgresql/*/bin/pg_ctl  mr,
  /etc/postgresql/                  r,
  /var/lib/postgresql/              rw,
  /var/log/postgresql/              rw,
  /run/postgresql/                  rw,

  network inet stream,
  network inet6 stream,

  deny /etc/shadow  r,
  deny /root/       rw,
}
```

### Caso 3: endurecer Docker

```bash
# Docker ya incluye un perfil AppArmor por defecto:
cat /etc/apparmor.d/docker-default

# Para containers que necesitan más permisos:
sudo nano /etc/apparmor.d/docker-custom
# Crear perfil custom y usarlo:
# docker run --security-opt apparmor=docker-custom mi-imagen
```

---

## Modo complain (testing)

```bash
# Antes de activar un perfil en enforce, probarlo en complain:
sudo aa-complain /etc/apparmor.d/usr.bin.mi-programa

# Ejecutar el programa normalmente
mi-programa

# Ver violaciones registradas
sudo journalctl -k | grep -i apparmor
sudo dmesg | grep -i apparmor
# O:
sudo cat /var/log/syslog | grep -i apparmor

# Revisar y ajustar el perfil
sudo nano /etc/apparmor.d/usr.bin.mi-programa

# Cuando esté listo, activar enforce:
sudo aa-enforce /etc/apparmor.d/usr.bin.mi-programa
```

---

## Perfiles y containers

```bash
# Docker usa AppArmor por defecto
docker inspect --format='{{.AppArmorProfile}}' <container>

# Desactivar AppArmor para un container (⚠️ no recomendado)
docker run --security-opt apparmor=unconfined mi-imagen

# Crear perfil custom para un container
cat > /etc/apparmor.d/docker-miapp << 'EOF'
#include <tunables/global>
profile docker-miapp flags=(attach_disconnected) {
  #include <abstractions/base>
  /r/w/** rw,
  network inet stream,
}
EOF
sudo apparmor_parser -r /etc/apparmor.d/docker-miapp
docker run --security-opt apparmor=docker-miapp mi-imagen

# Podman: mismo mecanismo
podman run --security-opt apparmor=docker-miapp mi-imagen
```

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Programa no inicia con "permission denied" | Perfil en enforce bloquea algo | `sudo aa-complain` temporal, revisar logs |
| "AppArmor denied" en dmesg | Perfil restringe acceso | Añadir la ruta al perfil o cambiar a complain |
| Violaciones silenciosas | Perfil en complain | Verificar con `dmesg \| grep apparmor` |
| Perfil rompe otra app | Dependencia no contemplada | Añadir `#include <abstractions/nameservice>` u otros |
| Perfil no se carga | Sintaxis del perfil incorrecta | `sudo apparmor_parser -r /etc/apparmor.d/perfil` para test |
| Docker falla con perfil custom | Perfil demasiado restrictivo | Verificar `docker logs` para ver qué necesita |
| Actualización de app rompe perfil | Rutas cambiaron | Regenerar perfil: `sudo aa-genprof /usr/bin/app` |

### Verificación de estado

```bash
# Resumen completo
sudo aa-status

# Contadores de violaciones
sudo aa-status | grep -E "enforce|complain|kill|unconfined"

# Verificar que un perfil específico está activo
sudo aa-status | grep nginx
# Salida esperada: "1 profiles are in enforce mode"
```

---

## Comparativa AppArmor vs SELinux

| Aspecto | AppArmor | SELinux |
|---|---|---|
| **Complejidad** | Baja (texto, rutas) | Alta (etiquetas, contexts) |
| **Por defecto en** | Ubuntu, SUSE, Debian | Fedora, RHEL, CentOS, Arch |
| **Granularidad** | Por programa | Por proceso + objeto |
| **Perfiles** | Texto plano legible | Semántica binaria |
| **Containers** | Docker/Podman nativo | Docker con `--selinux-enabled` |
| **Curva de aprendizaje** | Horas | Días/semanas |
| **Documentación** | Buena | Excelente (pero vasta) |
| **Mantenimiento** | Bajo | Medio-Alto |

**¿Cuál usar?**
- **Servidor Ubuntu/Debian** → AppArmor (ya instalado)
- **Servidor Fedora/RHEL** → SELinux (ya instalado)
- **Container Docker** → AppArmor (más fácil)
- **Entorno de alta seguridad** → SELinux (más granular)

---

## Referencia rápida de permisos

| Permiso | Significado |
|---|---|
| `r` | Leer archivo |
| `w` | Escribir archivo |
| `a` | Añadir (append) a archivo |
| `l` | Enlazar (link) |
| `k` | Crear lockfiles |
| `m` | Mapear ejecutable (mmap) |
| `ix` | Ejecutar heredando el perfil actual |
| `Px` | Ejecutar con el perfil del programa |
| `Cx` | Ejecutar con el perfil del child |
| `Ux` | Ejecutar sin perfil (⚠️ peligroso) |

---

## Ver también

- [[Seguridad en Linux (Guía completa)]] — guía general de seguridad
- [[SELinux]] — MAC alternativo (Fedora/RHEL)
- [[SSH Hardening]] — endurecimiento SSH
- [[fail2ban]] — protección contra brute force
- [[Docker permiso denegado]] — permisos en contenedores
- [[Exec Shield]] — protección de memoria

#seguridad #apparmor #mac #sandboxing
