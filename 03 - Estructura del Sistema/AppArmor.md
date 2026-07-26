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
sudo aa-genprof /usr/sbin/nginx        # asistente interactivo
sudo aa-logprof                        # analiza logs y sugiere reglas
```

## Troubleshooting

```bash
sudo grep -i denied /var/log/syslog | grep -i apparmor
sudo journalctl -f | grep -i apparmor  # en tiempo real
sudo aa-logprof                        # asistente para crear reglas
```

## Ver también

- [[SELinux]] — MAC basado en etiquetas
- [[Permisos y Propietarios]] — DAC
- [[Firewall]] — control de acceso a nivel de red

## Enlaces externos

- [Wikipedia — AppArmor](https://en.wikipedia.org/wiki/AppArmor)
- [Ubuntu — AppArmor wiki](https://wiki.ubuntu.com/AppArmor)

#sistema #seguridad
