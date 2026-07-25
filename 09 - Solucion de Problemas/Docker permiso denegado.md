---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: troubleshooting
sistema: Docker
prioridad: baja
---

# Docker permission denied (grupo docker)

> Al ejecutar comandos Docker aparece `permission denied` al conectar con el socket de Docker, incluso después de haberse agregado al grupo docker.

## Síntoma

```bash
docker ps
# Got permission denied while trying to connect to the Docker daemon socket at
# unix:///var/run/docker.sock: dial unix /var/run/docker.sock: connect: permission denied

# O alternativamente:
# Cannot connect to the Docker daemon. Is the docker daemon running?

docker run hello-world
# permission denied
```

## Diagnóstico

```bash
# 1. ¿Perteneces al grupo docker?
groups                                    # ver tus grupos actuales
# Si no aparece "docker" → no estás en el grupo

# 2. ¿El grupo docker existe?
getent group docker                        # gid del grupo docker

# 3. ¿El socket de Docker tiene permisos correctos?
ls -l /var/run/docker.sock                 # debe ser srw-rw---- (660) con grupo docker
# Si el grupo no es docker o los permisos son incorrectos → problema

# 4. ¿El daemon de Docker está corriendo?
sudo systemctl status docker               # debe mostrar "active (running)"
sudo docker info                           # si esto funciona, el problema es de usuario
```

## Causa

1. **Usuario no agregado al grupo docker** — solo root puede usar Docker por defecto.
2. **No reiniciaste sesión tras agregarte al grupo** — los grupos se actualizan al iniciar sesión, no inmediatamente.
3. **El socket tiene permisos incorrectos** — `docker.sock` no pertenece al grupo docker o tiene permisos demasiado restrictivos.
4. **El daemon de Docker no está corriendo** — `dockerd` no se inició.
5. **SELinux/AppArmor bloqueando el acceso** — políticas de seguridad restringen el socket.
6. **Rootless Docker** — si instalaste Docker en modo rootless, el socket está en otro lado.

## Solución

### 1. Agregar usuario al grupo docker

```bash
sudo usermod -aG docker $USER

# Verificar que se agregó correctamente
sudo groups $USER                          # debe mostrar "docker"
```

### 2. Cerrar sesión y volver a entrar (necesario)

```bash
# La forma más segura: cerrar sesión completa (logout y login)
# O usar newgrp para iniciar una subshell con el grupo:
newgrp docker
docker ps                                  # ahora debería funcionar

# O reiniciar la sesión de usuario sin cerrar apps:
# Ejecutar en la terminal:
exec su -l $USER
```

> **⚠️ No es suficiente con** `source ~/.bashrc` o abrir una nueva terminal. Los grupos de usuario se asignan al iniciar sesión, no al abrir un terminal. Necesitas logout+login o `newgrp`.

### 3. Verificar que Docker esté corriendo

```bash
sudo systemctl enable --now docker
sudo systemctl status docker
```

### 4. Si el socket tiene permisos incorrectos

```bash
# Ver permisos actuales
ls -la /var/run/docker.sock

# Reparar permisos (si el grupo no es docker)
sudo chown root:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock

# Persistente: editar /etc/docker/daemon.json
# {
#   "group": "docker"
# }
sudo systemctl restart docker
```

### 5. Rootless Docker (socket en otro lugar)

```bash
# Si instalaste Docker en modo rootless, el socket está en:
ls -la $XDG_RUNTIME_DIR/docker.sock
# Normalmente: /run/user/1000/docker.sock

# Configurar DOCKER_HOST para apuntar al socket correcto:
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
# Añadir a ~/.bashrc para que sea permanente
```

### 6. SELinux/AppArmor bloqueando

```bash
# Verificar si SELinux está bloqueando
sudo ausearch -m avc -ts recent | grep docker

# Solución temporal (no recomendada en producción):
sudo setenforce 0                           # desactivar SELinux temporalmente

# Solución permanente: contexto SELinux correcto
sudo semanage permissive -a docker_t

# AppArmor (Ubuntu/Debian):
sudo aa-status | grep docker
# Generalmente AppArmor no bloquea el socket de Docker, pero sí los contenedores
```

## Verificación

```bash
# Probar acceso sin sudo
docker ps                                   # debe listar contenedores
docker run --rm hello-world                 # descargar y ejecutar hello-world
docker info                                 # info del motor Docker
```

## Prevención

- Agregar el usuario al grupo docker justo después de instalar Docker
- Hacer logout+login inmediatamente después (no esperar)
- En servidores, **no agregar usuarios al grupo docker** si no es necesario — equivale a acceso root sin contraseña (el grupo docker permite montar volúmenes y escalar privilegios). Usar sudo en su lugar.
- Para desarrollo local, el grupo docker es seguro y conveniente

## Notas adicionales

> **⚠️ Seguridad**: el grupo docker otorga acceso equivalente a root sin contraseña. Cualquier proceso con acceso al socket de Docker puede:
> - Montar cualquier directorio del host dentro de un contenedor (incluyendo `/etc/shadow`, `/root/.ssh/`)
> - Escalar privilegios ejecutando `docker run -v /:/host --privileged`
> - Leer secretos de otros contenedores
> En servidores compartidos, no agregues usuarios al grupo docker — usa sudo o Podman (rootless nativo).

## Enlaces externos

- [Docker Docs — Post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/)
- [Arch Wiki — Docker](https://wiki.archlinux.org/title/Docker)
- [Stack Overflow — Docker permission denied](https://stackoverflow.com/questions/48957195)

## Ver también

- [[Docker]] — instalación y uso de Docker
- [[Contenedores]] — concepto de contenedores
- [[Permisos y Propietarios]] — grupos de usuario y permisos
- [[SELinux y AppArmor]] — políticas de seguridad

#troubleshooting
