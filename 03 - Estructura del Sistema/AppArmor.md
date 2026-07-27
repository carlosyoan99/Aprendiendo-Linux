---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# AppArmor — Perfiles por programa

AppArmor (Application Armor) usa **perfiles** que describen qué archivos, redes y capacidades puede usar cada programa. Default en openSUSE, Debian y Ubuntu.

## Modos

```bash
sudo aa-status                    # perfiles cargados, procesos, modos
# enforce  → bloquea lo que no está permitido
# complain → registra infracciones pero no bloquea (modo aprendizaje)
```

## Estructura de un perfil

```bash
# /etc/apparmor.d/usr.sbin.nginx
#include <tunables/global>

/usr/sbin/nginx {
    #include <abstractions/base>
    #include <abstractions/nameservice>

    /etc/nginx/** r,
    /var/log/nginx/** rw,
    /usr/share/nginx/html/** r,
    /var/www/** r,
    network inet tcp,
}
```

### Permisos

| Permiso | Significado |
|---|---|
| `r` | Read |
| `w` | Write |
| `x` | Execute |
| `m` | Memory map (mmap) |
| `ix` | Ejecutar inherit (hereda el perfil) |
| `px` | Ejecutar perfil secundario |

## Comandos esenciales

```bash
sudo aa-complain /usr/sbin/nginx       # modo complain (solo log)
sudo aa-enforce /usr/sbin/nginx        # modo enforcing (bloquea)
sudo aa-disable /usr/sbin/nginx        # desactivar perfil
sudo apparmor_parser -r /etc/apparmor.d/usr.sbin.nginx  # recargar
```

## aa-genprof (perfil interactivo)

El asistente interactivo para crear perfiles desde cero:

```bash
sudo aa-genprof /usr/sbin/nginx
# 1. Se pone en modo complain y marca el log
# 2. En OTRA terminal, ejercitar nginx
# 3. Volver a aa-genprof → (S)can para analizar logs
# 4. Aprobar o denegar cada acceso que detecte
# 5. (F)inish → modo enforcing
```

## aa-logprof (reparar denegaciones)

Cuando AppArmor bloquea algo legítimo, `aa-logprof` analiza los logs y sugiere reglas interactivamente:

```bash
# 1. Poner en modo complain
sudo aa-complain /usr/sbin/mi-app
# 2. Ejecutar la operación que falla
# 3. Ejecutar el asistente
sudo aa-logprof
# 4. Aceptar/rechazar las reglas sugeridas
# 5. Volver a enforcing
sudo aa-enforce /usr/sbin/mi-app
```

## Abstracciones (reutilización de reglas)

Las abstracciones son fragmentos de reglas reutilizables que cubren necesidades comunes:

| Abstracción | Propósito |
|---|---|
| `abstractions/base` | Accesos básicos de cualquier proceso (librerías, /proc, /dev) |
| `abstractions/nameservice` | DNS, hostname, /etc/hosts, /etc/resolv.conf |
| `abstractions/authentication` | Archivos de autenticación (PAM, shadow) |
| `abstractions/fonts` | Acceso a fuentes del sistema |
| `abstractions/gnome` | Integración con GNOME |
| `abstractions/X` | Acceso al servidor X |

```bash
# Uso en un perfil
#include <abstractions/base>
#include <abstractions/nameservice>
```

## aa-easyprof (perfiles rápidos con plantillas)

Genera perfiles básicos usando plantillas predefinidas:

```bash
sudo aa-easyprof /usr/bin/mi-app
# Crea un perfil con reglas genéricas
```

## aa-notify (notificaciones en vivo)

Muestra notificaciones de escritorio cada vez que AppArmor deniega algo:

```bash
aa-notify -p          # modo polling continuo
aa-notify --display   # mostrar últimas denegaciones
```

## AppArmor para contenedores (Docker/Podman)

Docker aplica automáticamente el perfil `docker-default` a todos los contenedores.

```bash
# Aplicar perfil personalizado a un contenedor
docker run --security-opt "apparmor=custom-profile" nginx

# Deshabilitar AppArmor para un contenedor
docker run --security-opt "apparmor=unconfined" nginx

# Ver perfil activo de un contenedor en ejecución
docker inspect --format '{{.AppArmorProfile}}' container_name
```

```bash
# Podman (sintaxis similar)
podman run --security-opt "apparmor=custom-profile" nginx
```

## Troubleshooting

| Tarea | Comando |
|---|---|
| Ver denegaciones en syslog | `sudo grep -i denied /var/log/syslog \| grep -i apparmor` |
| Ver denegaciones en journald | `journalctl -f \| grep -i apparmor` |
| Notificaciones en vivo | `aa-notify -p` |
| Reparar denegaciones | `sudo aa-logprof` |
| Crear perfil desde cero | `sudo aa-genprof /usr/bin/mi-app` |
| Ver estado general | `sudo aa-status` |
| Modo permisivo (solo log) | `sudo aa-complain /usr/sbin/mi-app` |
| Desactivar global (drástico) | `sudo systemctl stop apparmor` — detiene todo AppArmor |

## Ver también

- [[SELinux]] — MAC basado en etiquetas
- [[Permisos y Propietarios]] — DAC
- [[Firewall]] — control de acceso a nivel de red
- [[auditd]] — logs de auditoría

## Enlaces externos

- [Wikipedia — AppArmor](https://en.wikipedia.org/wiki/AppArmor)
- [Ubuntu — AppArmor wiki](https://wiki.ubuntu.com/AppArmor)
- [AppArmor man page](https://man7.org/linux/man-pages/man7/apparmor.7.html)
- [Docker — AppArmor security profiles](https://docs.docker.com/engine/security/apparmor/)

#sistema #seguridad
