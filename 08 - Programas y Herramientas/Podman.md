---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# Podman

> Motor de contenedores sin daemon (rootless por defecto). Alternativa directa a Docker con la misma sintaxis de comandos.

## Qué es

`podman` (Pod Manager) es un motor de contenedores sin daemon central — cada contenedor es un proceso hijo de Podman en vez de un hijo del daemon Docker. Es compatible con imágenes Docker (OCI) y su CLI es casi idéntica (`alias docker=podman`).

**Ventajas sobre Docker:**
- **Sin daemon**: no corre un proceso en background como root
- **Rootless**: ejecutar contenedores sin `sudo` por defecto
- **Systemd integrado**: `podman generate systemd` crea units para contenedores
- **Pods**: grupos de contenedores que comparten red y namespaces (como Kubernetes)

## Instalación multi-distro

| Distro | Comando |
|---|---|
| Debian/Ubuntu | `sudo apt install podman` |
| Arch/Manjaro | `sudo pacman -S podman` |
| Fedora | `sudo dnf install podman` |
| openSUSE | `sudo zypper install podman` |
| Alpine | `sudo apk add podman` |

```bash
# Verificar instalación
podman --version
podman info | head -20

# Rootless: configurar subuids para tu usuario
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER
```

## Comandos avanzados

```bash
# Crear y gestionar pods (agrupar contenedores)
podman pod create --name myapp -p 8080:80
podman run -d --pod myapp --name web nginx
podman run -d --pod myapp --name db postgres
podman pod ps

# Generar systemd units para contenedores
podman generate systemd --name mi-contenedor --new
podman generate systemd --name mi-contenedor --files --restart-policy=always

# Buildah: construir imágenes sin daemon
buildah bud -t mi-app:latest ./
buildah from alpine
buildah run alpine-working-container apk add nginx
buildah commit alpine-working-container mi-nginx:latest

# Podman con Docker Compose
podman-compose up -d
# O con el plugin nativo de podman
podman compose up -d

# Inspección y debug
podman inspect mi-contenedor
podman logs -f mi-contenedor
top mi-contenedor
podman stats --no-stream
```

## Rootless vs Rootful

| Aspecto | Rootless | Rootful |
|---|---|---|
| Permisos | Sin sudo | Requiere root |
| Seguridad | Mayor (menor superficie) | Menor |
| Puertos | >1024 (unprivileged) | 1-65535 |
| Storage | ~/.local/share/containers | /var/lib/containers |
| Red | slirp4netns/pasta | bridge |

```bash
# Forzar rootful si es necesario
sudo podman run -d -p 80:80 nginx

# Verificar modo
podman info | grep -A5 rootless
```

## Comparativa con Docker

| Característica | Podman | Docker |
|---|---|---|
| Daemon | ❌ Sin daemon | ✅ Docker daemon |
| Rootless | ✅ Por defecto | ⚠️ Necesita config |
| Pods | ✅ Nativo | ❌ No nativo |
| systemd | ✅ Integrado | ⚠️ Vía plugin |
| Compatibilidad OCI | ✅ | ✅ |
| Docker Compose | ✅ podman-compose | ✅ Nativo |
| Seguridad | Mayor (sin daemon root) | Menor |
| Curva aprendizaje | Baja (alias docker=podman) | Baja |

```bash
# Alias para usar docker → podman
alias docker=podman
alias docker-compose=podman-compose
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `unable to find user: not found` | Rootless sin subuids configurados | `sudo usermod --add-subuids 100000-165535 $USER` |
| `Error: cannot set up namespace` | Kernel sin soporte user namespaces | `sysctl user.max_user_namespaces=28633` |
| `ERRO[0000] could not find runtime` | Falta crun/runc | `sudo apt install crun` |
| Contenedor no arranca con `-p 80:80` | Rootless no puede usar puertos <1024 | Usar puerto >1024 o `sysctl net.ipv4.ip_unprivileged_port_start=80` |
| `Error: slirp4netns failed` | Falta slirp4netns rootless | `sudo apt install slirp4netns` |
| `podman compose` no funciona | Falta el plugin | `sudo apt install podman-compose` |

## Enlaces externos

- [Sitio oficial de Podman](https://podman.io/)
- [GitHub — containers/podman](https://github.com/containers/podman)
- [Documentación](https://docs.podman.io/)
- [Arch Wiki — Podman](https://wiki.archlinux.org/title/Podman)
- [Podman Desktop (GUI)](https://podman-desktop.io/)

## Ver también

- [[Docker]] — motor de contenedores con daemon
- [[Contenedores]] — conceptos generales
- [[Contenedores orquestación]] — Docker Compose, Swarm, K8s
- [[LXC y Contenedores del Sistema]] — contenedores a nivel de sistema

#programa #contenedores
