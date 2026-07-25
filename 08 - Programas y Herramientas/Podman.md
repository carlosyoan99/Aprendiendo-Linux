---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
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

## Instalación

```bash
# Debian/Ubuntu
sudo apt install podman

# Arch
sudo pacman -S podman

# Fedora (viene preinstalado)
sudo dnf install podman
```

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
