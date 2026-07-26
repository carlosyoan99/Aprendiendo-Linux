---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# SELinux - Security-Enhanced Linux

Desarrollado por la NSA y Red Hat. Integrado en el kernel desde la versión 2.6. Asigna una **etiqueta de contexto** a cada archivo, proceso, puerto y recurso, definiendo reglas que permiten o niegan interacciones entre ellos. También presente en Android desde la versión 4.3.

## Modos de SELinux

```bash
getenforce                              # Enforcing, Permissive, Disabled
sestatus                                # información detallada

sudo setenforce 0                       # Permissive (solo log)
sudo setenforce 1                       # Enforcing (bloquea)

# Cambio permanente: editar /etc/selinux/config
# SELINUX=enforcing | permissive | disabled
```

## Contextos de seguridad

```
Formato: usuario:rol:tipo:nivel
Ejemplo: system_u:object_r:httpd_sys_content_t:s0
```

| Campo | Significado |
|---|---|
| `usuario` | Identidad SELinux del usuario |
| `rol` | Rol del proceso o recurso |
| `tipo` | **El más importante** — define qué accede a qué |
| `nivel` | Nivel de sensibilidad (MLS) |

## Políticas

| Política | Descripción |
|---|---|
| **Targeted** | Solo protege procesos específicos (default en Fedora/RHEL) |
| **MLS** | Etiquetado jerárquico (militar/gubernamental) |
| **MCS** | Etiquetado por categorías (contenedores) |

## Comandos esenciales

```bash
# ── Ver contextos ──
ls -Z /var/www/html/index.html            # contexto del archivo
ps auxZ | grep httpd                      # contexto del proceso
id -Z                                     # contexto del usuario

# ── Cambiar contexto ──
sudo chcon -t httpd_sys_content_t /ruta/archivo.html    # temporal
sudo restorecon -Rv /var/www/                            # restaurar por defecto

# ── Booleanos ──
sudo semanage boolean -l | grep httpd
sudo semanage boolean --modify --on httpd_enable_homedirs

# ── Auditoría ──
sudo ausearch -m avc -ts recent            # últimas denegaciones
sudo grep -i denied /var/log/audit/audit.log | tail -20
```

## Troubleshooting

```bash
# 1. Verificar que SELinux está bloqueando
sudo ausearch -m avc -ts recent | grep -i denied

# 2. Modo permisivo para confirmar
sudo setenforce 0

# 3. Solucionar:
sudo chcon -t httpd_sys_content_t /ruta/que-falla       # contexto
sudo semanage boolean --modify --on httpd_enable_homedirs # booleano
sudo audit2allow -a -M mi_regla                          # regla personalizada
sudo semodule -i mi_regla.pp

# 4. Volver a enforcing
sudo setenforce 1
```

## Ver también

- [[AppArmor]] — MAC basado en perfiles por programa
- [[Permisos y Propietarios]] — DAC, la capa base
- [[Firewall]] — control de acceso a nivel de red
- [[auditd]] — auditoría del sistema

## Enlaces externos

- [Wikipedia — SELinux](https://en.wikipedia.org/wiki/SELinux)
- [Red Hat — SELinux manual](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/index)

#sistema #seguridad
