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

### Gestión de contextos con semanage fcontext

```bash
# Añadir contexto persistente (sobrevive a restorecon)
sudo semanage fcontext -a -t httpd_sys_content_t '/srv/www(/.*)?'
sudo restorecon -Rv /srv/www

# Eliminar contexto personalizado
sudo semanage fcontext -d '/srv/www(/.*)?'

# Listar contextos personalizados
sudo semanage fcontext -l
```

## Políticas

| Política | Descripción |
|---|---|
| **Targeted** | Solo protege procesos específicos (default en Fedora/RHEL) |
| **MLS** | Etiquetado jerárquico (militar/gubernamental) |
| **MCS** | Etiquetado por categorías (contenedores) |

## Booleanos

Los booleanos activan/desactivan funcionalidades sin crear reglas nuevas.

```bash
# Listar booleanos
sudo semanage boolean -l | head -20
sudo semanage boolean -l | grep httpd

# Activar/desactivar
sudo semanage boolean --modify --on httpd_enable_homedirs
sudo setsebool -P httpd_enable_homedirs on     # -P persistente
```

### Booleanos comunes para servidores

| Booleano | Propósito |
|---|---|
| `httpd_enable_homedirs` | Apache accede a /home/*/public_html |
| `httpd_can_network_connect` | Apache conecta a red externa |
| `httpd_can_sendmail` | Apache envía correo |
| `ftp_home_dir` | FTP accede a directorios home |
| `samba_export_all_rw` | Samba acceso de escritura |
| `virt_use_nfs` | KVM usa almacenamiento NFS |

## semanage avanzado

### Etiquetado de puertos

```bash
# Listar puertos etiquetados
sudo semanage port -l | head -20
sudo semanage port -l | grep http

# Asignar puerto personalizado a un tipo
sudo semanage port -a -t http_port_t -p tcp 8080
sudo semanage port -d -t http_port_t -p tcp 8080   # eliminar
```

### Mapeo de usuarios

```bash
# Ver mapeo de usuarios Linux a usuarios SELinux
sudo semanage login -l

# Mapear usuario Linux a rol SELinux
sudo semanage login -a -s user_u mi_usuario
```

## audit2allow (reglas personalizadas)

Cuando SELinux bloquea algo legítimo, puedes generar un módulo de política personalizado:

```bash
# Ver denegaciones recientes
sudo ausearch -m avc -ts recent | grep denied

# Generar regla a partir de los logs
sudo ausearch -m avc -ts recent | sudo audit2allow -M mi_regla

# Cargar el módulo
sudo semodule -i mi_regla.pp

# Ver módulos cargados
sudo semodule -l | grep mi_regla

# Eliminar módulo
sudo semodule -r mi_regla
```

## SELinux para contenedores (udica)

`udica` genera políticas SELinux para contenedores Podman/Docker automáticamente:

```bash
# Ejecutar contenedor y generar política
sudo podman run -d --name web --security-opt label=type:container_t nginx

# Generar política personalizada para este contenedor
sudo udica web_container --caps 'NET_BIND_SERVICE' --volumes /var/www

# Cargar política
sudo semodule -i web_container.cil /usr/share/udica/templates/base_container.cil
```

## Troubleshooting

```bash
# 1. Verificar que SELinux está bloqueando
sudo ausearch -m avc -ts recent | grep -i denied

# 2. Modo permisivo para confirmar
sudo setenforce 0

# 3. Solucionar:
sudo chcon -t httpd_sys_content_t /ruta/que-falla       # contexto temporal
sudo semanage fcontext -a -t httpd_sys_content_t '/ruta(/.*)?'
sudo restorecon -Rv /ruta                               # contexto persistente
sudo semanage boolean --modify --on httpd_enable_homedirs # booleano
sudo audit2allow -a -M mi_regla                          # regla personalizada
sudo semodule -i mi_regla.pp

# 4. Volver a enforcing
sudo setenforce 1
```

### Escenarios comunes

| Problema | SELinux command | Causa |
|---|---|---|
| Apache 403 Forbidden | `semanage fcontext -a -t httpd_sys_content_t '/srv(/.*)?'` | Contexto incorrecto en document root |
| Nginx no puede conectar a backend | `setsebool -P httpd_can_network_connect on` | Booleano httpd_can_network_connect |
| Samba no permite escritura | `setsebool -P samba_export_all_rw on` | Booleano de Samba |
| Script custom bloqueado | `audit2allow -a -M script_policy` | Sin regla para dominio no estándar |
| SSH con custom port | `semanage port -a -t ssh_port_t -p tcp 2222` | Puerto no etiquetado |
| Postfix no puede enviar | `setsebool -P httpd_can_sendmail on` | Dependiendo del contexto del proceso |

## Ver también

- [[AppArmor]] — MAC basado en perfiles por programa
- [[Permisos y Propietarios]] — DAC, la capa base
- [[Firewall]] — control de acceso a nivel de red
- [[auditd]] — auditoría del sistema

## Enlaces externos

- [Wikipedia — SELinux](https://en.wikipedia.org/wiki/SELinux)
- [Red Hat — SELinux manual](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/index)
- [udica — políticas SELinux para contenedores](https://github.com/containers/udica)

#sistema #seguridad
