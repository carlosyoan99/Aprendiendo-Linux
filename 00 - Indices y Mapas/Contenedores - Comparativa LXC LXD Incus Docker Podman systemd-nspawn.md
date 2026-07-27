---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: indice
prioridad: alta
---

# Contenedores — Comparativa técnica

## Mapa de tecnologías

El ecosistema de contenedores en Linux se divide en dos grandes familias: **contenedores de sistema** (ejecutan un sistema completo con init) y **contenedores de aplicación** (ejecutan un solo proceso). Esta nota compara las 6 tecnologías principales.

```ascii
┌─────────────────────────────────────────────────────────────────────┐
│               CONTENEDORES EN LINUX — FAMILIAS                       │
├─────────────────────────────┬───────────────────────────────────────┤
│  SISTEMA (con init propio)   │  APLICACIÓN (proceso único)          │
├─────────────────────────────┼───────────────────────────────────────┤
│                              │                                       │
│  ┌──────────────────────┐   │   ┌─────────────────────────────┐    │
│  │  LXC (bajo nivel)    │   │   │  Docker (dockerd)           │    │
│  │  └─ LXD (gestor API) │   │   │  Podman (daemonless)        │    │
│  │  └─ Incus (fork LXD) │   │   │                             │    │
│  └──────────────────────┘   │   └─────────────────────────────┘    │
│                              │                                       │
│  ┌──────────────────────┐   │                                       │
│  │  systemd-nspawn       │   │                                       │
│  │  (nativo en systemd)  │   │                                       │
│  └──────────────────────┘   │                                       │
└─────────────────────────────┴───────────────────────────────────────┘
```

---

## Tabla comparativa general

| Aspecto | LXC | LXD | Incus | Docker | Podman | systemd-nspawn |
|---|---|---|---|---|---|---|
| **Tipo** | Sistema | Sistema | Sistema + VM | App | App | Sistema |
| **Daemon** | ❌ No | ✅ Sí (lxd) | ✅ Sí (incusd) | ✅ Sí (dockerd) | ❌ No (fork/exec) | ❌ No |
| **Rootless** | ❌ No | ⚠️ Parcial | ✅ Sí (parcial) | ⚠️ Limitado | ✅ Nativo | ✅ Sí |
| **Init requerido** | ✅ Sí | ✅ Sí | ✅ Sí | ❌ No | ❌ No | ⚠️ Opcional |
| **API REST** | ❌ No | ✅ Sí | ✅ Sí | ✅ Sí | ✅ Sí (vía socket) | ❌ No |
| **Clustering** | ❌ No | ✅ Sí | ✅ Sí | ⚠️ Swarm/K8s | ⚠️ Podman farm | ❌ No |
| **Snapshots** | ❌ No (externo) | ✅ Sí | ✅ Sí | ✅ Sí (vía filesystem) | ✅ Sí | ❌ No |
| **Imágenes OCI** | ❌ No | ❌ No | ❌ No | ✅ Sí | ✅ Sí | ❌ No |
| **Múltiples procesos** | ✅ Sí | ✅ Sí | ✅ Sí | ❌ No (1 proceso) | ❌ No (1 proceso) | ✅ Sí |
| **VM (QEMU)** | ❌ No | ⚠️ Desde v5.19 | ✅ Sí | ❌ No | ❌ No | ❌ No |
| **Estándar abierto** | — | — | ✅ Comunidad | ✅ OCI + Hub | ✅ OCI | — |
| **Estado 2026** | Mantenimiento | Activo (Canonical) | ✅ Activo (comunidad) | ✅ Activo | ✅ Activo | ✅ Activo |

---

## Contenedores de sistema

### LXC — Linux Containers (bajo nivel)

**Tipo**: Sistema. Proporciona el aislamiento base sobre el que construyen LXD e Incus.

```bash
# Instalación
sudo apt install lxc                    # Debian/Ubuntu
sudo pacman -S lxc                      # Arch

# Uso básico
sudo lxc-create -n contenedor -t download -- -d ubuntu -r jammy -a amd64
sudo lxc-start -n contenedor -d
sudo lxc-attach -n contenedor
sudo lxc-ls -f
```

| Aspecto | Detalle |
|---|---|
| **Init** | systemd, openrc (lo que traiga la imagen) |
| **Aislamiento** | namespaces + cgroups |
| **Red** | bridge NAT (lxc-net) |
| **Imágenes** | Descarga de plantillas (images.linuxcontainers.org) |
| **Persistencia** | Directorio en `/var/lib/lxc/` |
| **Ideal para** | Base tecnológica, contenedores manuales |

**⚠️ Limitaciones**: Sin API, sin snapshots nativos, gestión manual de redes. Para uso diario, usar LXD o Incus.

---

### LXD — Gestor de contenedores (Canonical)

**Tipo**: Sistema. Capa de gestión sobre LXC con API REST, perfiles y snapshots.

```bash
# Inicializar
sudo lxd init

# Uso básico
lxc launch ubuntu:22.04 mi-servidor
lxc list
lxc exec mi-servidor -- apt update
lxc snapshot mi-servidor backup
lxc file pull mi-servidor/etc/hosts .
```

| Aspecto | Detalle |
|---|---|
| **Daemon** | `lxd` (socket local + remoto) |
| **API REST** | ✅ Puerto 8443 (con certificado) |
| **Clustering** | ✅ Múltiples servidores en cluster |
| **Almacenamiento** | dir, btrfs, zfs, lvm, ceph |
| **Snapshots** | ✅ Con `lxc snapshot` |
| **Migración en vivo** | ✅ Entre hosts del cluster |
| **Propietario** | Canonical (desde 2015) |
| **Ideal para** | Hosting, VPS, entornos multi-servidor |

**⚠️ Historia**: Originalmente de linuxcontainers.org, Canonical tomó el control en 2023. Esto llevó a la comunidad a crear **Incus** como fork (ver sección abajo).

---

### Incus — Fork comunitario de LXD

**Tipo**: Sistema + VM. Fork de LXD mantenido por los desarrolladores originales de linuxcontainers.org, con gobernanza comunitaria.

```bash
# Instalación
sudo apt install incus                  # Debian/Ubuntu (desde repos)
sudo pacman -S incus                    # Arch

# Uso (casi idéntico a LXD)
incus admin init
incus launch ubuntu:22.04 mi-serv
incus list
incus exec mi-serv -- apt update
incus snapshot mi-serv backup

# VMs (nuevo: ejecuta sistema completo con kernel propio)
incus launch images:alpine/3.20 mi-vm --vm
```

| Aspecto | Detalle |
|---|---|
| **Daemon** | `incusd` |
| **API REST** | ✅ (compatible con cliente LXD) |
| **VMs** | ✅ Vía QEMU (misma API que contenedores) |
| **Clustering** | ✅ |
| **Rootless** | ⚠️ Parcial |
| **Gobernanza** | Comunitaria (linuxcontainers.org) |
| **Licencia** | Apache 2.0 |
| **Ideal para** | Usuarios de LXD que quieren independencia de Canonical, gestión unificada contenedores + VMs |

**⬆️ Migrar de LXD a Incus**: Los comandos son casi idénticos (`lxc` → `incus`). Incus puede importar configuraciones de LXD.

---

### systemd-nspawn — Contenedor nativo de systemd

**Tipo**: Sistema. Contenedor ligero integrado en systemd, sin demonios externos.

```bash
# Crear contenedor desde una instalación de distro
sudo debootstrap stable /var/lib/machines/debian

# Iniciar
sudo systemd-nspawn -D /var/lib/machines/debian --boot

# Gestión con machinectl
machinectl list
sudo machinectl start debian
sudo machinectl login debian
sudo machinectl poweroff debian
```

| Aspecto | Detalle |
|---|---|
| **Daemon** | ❌ No (usa systemd directamente) |
| **Init** | ❌ No es necesario (`--boot` usa el del contenedor) |
| **Imágenes** | Árboles de directorios (debootstrap, pacstrap, etc.) |
| **Red** | Por defecto aislada (`--private-network`); bridge con `--network-bridge` |
| **Integración systemd** | ✅ Máxima ( unidades .nspawn, machinectl) |
| **Persistencia** | Directorios en `/var/lib/machines/` |
| **Ideal para** | Probar distros, aislamiento rápido sin instalar nada extra |

**⬆️ Ventaja frente a LXC/Incus**: No requiere instalar ningún paquete adicional si ya tienes systemd. Configurable con archivos `.nspawn`.

```ini
# /etc/systemd/nspawn/debian.nspawn
[Exec]
Boot=yes

[Network]
VirtualEthernet=yes
Bridge=br0

[Files]
Bind=/home/user/compartido:/mnt/compartido
```

---

## Contenedores de aplicación

### Docker — El estándar de la industria

**Tipo**: Aplicación. El ecosistema más grande de contenedores para microservicios, CI/CD y desarrollo.

```bash
# Ejecutar contenedor
docker run -d --name web -p 80:80 nginx:alpine

# Construir imagen
docker build -t mi-app .

# Gestionar
docker ps
docker exec -it web bash
docker compose up -d
```

| Aspecto | Detalle |
|---|---|
| **Daemon** | `dockerd` (requiere root) |
| **Estándar** | OCI (Open Container Initiative) |
| **Imágenes** | Docker Hub (público) + registries privados |
| **Orquestación** | Docker Compose, Kubernetes |
| **Rootless** | ⚠️ Modo experimental, limitaciones |
| **Init en contenedor** | ❌ No (un solo proceso, uso de tini/s6 opcional) |
| **Ecosistema** | El más grande: millones de imágenes, herramientas, CI/CD |
| **Ideal para** | Microservicios, desarrollo, despliegue cloud |

**⚠️ Limitaciones**: Daemon con privilegios, imágenes efímeras (no diseñado para entornos persistente tipo servidor).

---

### Podman — Daemonless, rootless, OCI

**Tipo**: Aplicación. Alternativa a Docker sin daemon central, rootless nativo, con integración systemd.

```bash
# CLI idéntica a Docker
podman run -d --name web -p 80:80 nginx:alpine
podman ps
podman exec -it web bash

# Pods (agrupar contenedores como en Kubernetes)
podman pod create --name mi-pod -p 8080:80
podman run -dt --pod mi-pod nginx:alpine

# Quadlets: contenedor como servicio systemd
# ~/.config/containers/systemd/web.container
[Container]
Image=docker.io/nginx:alpine
PublishPort=80:80

systemctl --user daemon-reload
systemctl --user start web
```

| Aspecto | Detalle |
|---|---|
| **Daemon** | ❌ No (fork/exec directo) |
| **Rootless** | ✅ Nativo (sin permisos especiales) |
| **Pods** | ✅ Grupos de contenedores que comparten red/recursos |
| **Quadlets** | ✅ Integración nativa con systemd |
| **Compatible Docker** | ✅ `alias docker=podman`, Docker Compose compatible |
| **Orquestación** | Podman farm, Kubernetes (via Podman->Kube YAML) |
| **Ecosistema** | Creciente (Red Hat/Fedora, Enterprise) |
| **Ideal para** | Seguridad, entornos rootless, servers con systemd, Kubernetes locales |

**⬆️ Ventaja sobre Docker**: Sin daemon = menos superficie de ataque, rootless = sin permisos de root, quadlets = integración systemd.

---

## Árbol de decisión

```ascii
¿Qué necesitas?
│
├─ ¿Un sistema completo con init (servidor)?
│  ├─ ¿Necesitas API REST + snapshots + clustering?
│  │  ├─ ¿Quieres independencia de Canonical?    → Incus
│  │  └─ ¿Usas Ubuntu/Canonical?                → LXD
│  ├─ ¿Solo algo rápido sin instalar nada?       → systemd-nspawn
│  └─ ¿Máxima flexibilidad a bajo nivel?          → LXC
│
├─ ¿Una aplicación o microservicio?
│  ├─ ¿Quieres rootless + integración systemd?   → Podman
│  └─ ¿Necesitas el ecosistema más grande?        → Docker
│
└─ ¿No sabes?
   └─ Docker (es el más común, fácil de aprender)
```

---

## Comparativa de comandos

| Acción | Docker | Podman | LXC/Incus | systemd-nspawn |
|---|---|---|---|---|
| **Ejecutar** | `docker run nginx` | `podman run nginx` | `incus launch images:nginx` | `systemd-nspawn -D dir` |
| **Listar** | `docker ps` | `podman ps` | `incus list` | `machinectl list` |
| **Shell** | `docker exec -it c bash` | `podman exec -it c bash` | `incus exec c -- bash` | `machinectl login c` |
| **Detener** | `docker stop c` | `podman stop c` | `incus stop c` | `machinectl poweroff c` |
| **Eliminar** | `docker rm c` | `podman rm c` | `incus delete c` | `rm -rf dir` |
| **Imágenes** | `docker images` | `podman images` | `incus image list` | — |
| **Logs** | `docker logs c` | `podman logs c` | `incus info c --show-log` | `journalctl -M c` |
| **Build** | `docker build -t app .` | `podman build -t app .` | `incus publish c --alias app` | — |
| **Red** | `docker network ls` | `podman network ls` | `incus network list` | Config .nspawn |

---

## Tabla de recursos

| Tecnología | RAM base | Tamaño imagen típica | Tiempo arranque | Uso disco (base) |
|---|---|---|---|---|
| **LXC/Incus (contenedor)** | ~50-100 MB | 200 MB - 2 GB | ~2-5 seg | ~500 MB |
| **Incus (VM)** | ~200-500 MB | 2-10 GB | ~10-30 seg | ~2 GB |
| **systemd-nspawn** | ~30-80 MB | 200 MB - 1 GB | ~1-3 seg | ~300 MB |
| **Docker** | ~5-50 MB | 5-500 MB | ~0.1-1 seg | ~50 MB |
| **Podman** | ~5-50 MB | 5-500 MB | ~0.1-1 seg | ~50 MB |

---

## Cuándo usar cada uno

| Escenario | Recomendación |
|---|---|
| **Microservicios en producción** | Docker o Podman (+ Kubernetes) |
| **Entorno de desarrollo local** | Docker (ecosistema) o Podman (rootless) |
| **Hosting / VPS / contenedores persistentes** | Incus o LXD |
| **Probar otra distro rápidamente** | systemd-nspawn |
| **Aislar un servicio legacy con init** | Incus o LXC |
| **Seguridad máxima (sin root)** | Podman (rootless) |
| **CI/CD con imágenes OCI** | Docker (estándar) o Podman |
| **Unificar VMs + contenedores en mismo host** | Incus (soporta QEMU nativo) |
| **Servidor personal / homelab** | Incus o Docker (según el caso) |
| **Sin instalar nada extra (solo systemd)** | systemd-nspawn |

---

## Notas específicas

### LXD vs Incus — La bifurcación

```
2023 — Canonical mueve LXD a su equipo empresarial
     → Los desarrolladores originales de linuxcontainers.org
       crean Incus como fork comunitario
     → Incus mantiene la visión original: open source,
       gobernanza comunitaria, integración upstream

Diferencias clave:
- LXD: desarrollado por Canonical, integración Snap, Ubuntu-first
- Incus: desarrollado por linuxcontainers.org, paquetes nativos
  en todas las distros, soporte para VMs (QEMU) añadido
```

### Podman vs Docker — La elección moderna

```
Docker:           dockerd (daemon) → containerd → runc
Podman:           podman (CLI) → runc/crun (directo, sin daemon)
                  └── Quadlets → sistema systemd nativo

Podman ventajas:
- Sin daemon = menos procesos, menos superficie de ataque
- Rootless nativo = contenedor no puede escalar a root
- Quadlets = contenedor como servicio systemd (reinicio automático)
- Kube YAML = exportar/importar pods a Kubernetes

Docker ventajas:
- Ecosistema más grande (tutoriales, herramientas, CI/CD)
- Docker Compose estándar (Podman lo soporta pero no es nativo)
- Docker Desktop (macOS/Windows)
```

---

## Ver también

- [[LXC y Contenedores del Sistema]] — LXC en detalle
- [[Contenedores]] — concepto general
- [[Docker]] — instalación, uso, Dockerfile
- [[systemd-nspawn]] — contenedores nativos de systemd
- [[Virtualización (KVM QEMU libvirt)]] — VMs tradicionales vs contenedores
- [[Proxmox VE]] — plataforma que integra LXC + KVM
- [[cgroups (control de recursos)]] — base técnica
- [[systemd]] — base de systemd-nspawn
- Incus — fork comunitario de LXD (ver sección en esta nota)

## Enlaces externos

- [Linux Containers — Proyecto LXC/LXD/Incus](https://linuxcontainers.org/)
- [Incus — Documentación](https://linuxcontainers.org/incus/docs/main/)
- [Docker — Documentación](https://docs.docker.com/)
- [Podman — Documentación](https://podman.io/docs)
- [systemd-nspawn — ArchWiki](https://wiki.archlinux.org/title/Systemd-nspawn)
- [LXC vs LXD vs Incus — Comparativa linuxcontainers](https://linuxcontainers.org/incus/)
- [Podman vs Docker — Red Hat Blog](https://www.redhat.com/en/topics/containers/what-is-podman)
- [OCI — Open Container Initiative](https://opencontainers.org/)

#indice #contenedores
