---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: media
---

# Namespaces (Linux)

> Los namespaces son la **columna vertebral del aislamiento en contenedores**. Cada tipo de namespace aísla un aspecto global del sistema (PID, red, montajes, etc.) para que un grupo de procesos tenga su propia vista independiente. Sin namespaces, no habría Docker, Podman ni LXC.

## Definición

Un namespace envuelve un recurso global del sistema (como la tabla de procesos, la tabla de montajes, o la pila de red) y lo **virtualiza** para un grupo de procesos. Los procesos dentro de un namespace ven **su propia instancia** del recurso, aislada del host y de otros namespaces.

```
┌─────────────────────────────────────────────┐
│              Host (default ns)               │
│  PID 1: systemd                             │
│  PID 100: sshd                              │
│  PID 200: dockerd                           │
│                                              │
│  ┌──────────┐    ┌──────────────────┐        │
│  │ Contenedor│    │  Contenedor     │        │
│  │ ns A      │    │  ns B           │        │
│  │ PID 1     │    │  PID 1          │   ← cada contenedor ve su propio PID 1
│  │ bash      │    │  nginx          │        │
│  │ PID 2     │    │  PID 2          │        │
│  │ sleep     │    │  node           │        │
│  └──────────┘    └──────────────────┘        │
└─────────────────────────────────────────────┘
```

## Tipos de namespaces

Linux 5.6+ ofrece **8 tipos** de namespaces:

| Namespace | Aísla | syscall flag | Separado desde |
|---|---|---|---|
| **PID** (`pid`) | IDs de proceso y /proc | `CLONE_NEWPID` | 2.6.24 |
| **Red** (`net`) | Interfaces de red, IP Tables, sockets | `CLONE_NEWNET` | 2.6.29 |
| **Montajes** (`mnt`) | Puntos de montaje, sistema de archivos | `CLONE_NEWNS` | 2.4.19 |
| **UTS** (`uts`) | Hostname, dominio NIS | `CLONE_NEWUTS` | 2.6.19 |
| **IPC** (`ipc`) | Colas de mensajes POSIX/SysV, memoria compartida | `CLONE_NEWIPC` | 2.6.19 |
| **Usuario** (`user`) | UIDs y GIDs (mapeo de IDs privilegiados) | `CLONE_NEWUSER` | 3.8 |
| **cgroup** (`cgroup`) | Vista del árbol de cgroups | `CLONE_NEWCGROUP` | 4.6 |
| **Tiempo** (`time`) | Tiempo de sistema (boot time, monotonic clock) | `CLONE_NEWTIME` | 5.6 |

## Namespace PID — aislar IDs de proceso

El namespace PID es el más fácil de entender: un proceso dentro de un namespace PID ve **su propia numeración**, empezando en PID 1.

```bash
# Crear un namespace PID y ejecutar un shell dentro
sudo unshare --fork --pid --mount-proc bash
# (--mount-proc es necesario para que /proc refleje el nuevo namespace)
# Dentro: ps aux solo muestra los procesos del namespace

# Desde fuera del namespace, todos los procesos siguen visibles con sus PIDs reales
```

**Importante**: el PID 1 en un namespace tiene responsabilidades especiales (recoger señales de huérfanos, manejar SIGTERM/SIGINT), igual que el PID 1 del host.

## Namespace de red — interfaces virtuales

Cada namespace de red tiene su **pila de red independiente**: interfaces, rutas, iptables, sockets.

```bash
# Ver namespaces de red existentes (Docker/Podman crean uno por contenedor)
ip netns list
# Ejemplo: ns-eth0, ns-docker-abc123

# Crear un namespace de red y ejecutar un comando dentro
sudo ip netns add mi-red
sudo ip netns exec mi-red ip a
# Muestra solo: lo (loopback), sin interfaces de red reales

# Comunicar dos namespaces con un veth pair
sudo ip link add veth0 type veth peer name veth1
sudo ip link set veth1 netns mi-red
sudo ip addr add 10.0.0.1/24 dev veth0
sudo ip link set veth0 up
sudo ip netns exec mi-red ip addr add 10.0.0.2/24 dev veth1
sudo ip netns exec mi-red ip link set veth1 up
# Ahora host ↔ namespace pueden pinguearse
ping -c 2 10.0.0.2
```

Docker/Podman crean un namespace de red por contenedor, conectado al host mediante bridges virtuales (docker0, podman) y veth pairs.

## Namespace de montaje — sistema de archivos aislado

Cada proceso puede tener su propia vista del sistema de archivos — qué está montado, dónde, y con qué opciones.

```bash
# Ver montajes desde un namespace de contenedor Docker
# (no hay comando directo, pero dentro del contenedor mount muestra solo su vista)
docker exec mi-contenedor mount

# Crear un namespace de montaje y aislar /tmp
sudo unshare --mount bash
mount --bind /ruta/temporal /tmp
# Dentro del namespace, /tmp apunta a /ruta/temporal
# Fuera del namespace, /tmp sigue siendo el original
```

**bind mount** vs **mount namespace**: bind mount cambia la vista para todos; un mount namespace la cambia solo para los procesos dentro de él.

## Namespace UTS — hostname independiente

```bash
sudo unshare --uts bash
hostname contenedor-test
# hostname dentro del namespace: contenedor-test
# hostname fuera: el original (ej. carlos-laptop)
```

Cada contenedor Docker tiene su propio UTS namespace, por eso puedes ponerle `--hostname` a cada uno.

## Namespace de usuario — privilegios mapeados

El más importante para **rootless containers**. Mapea UIDs/GIDs del namespace al host:

```bash
# Mapear: UID 0 dentro del namespace = UID 1000 fuera
# Así un proceso parece "root" dentro del contenedor pero es un usuario sin privilegios en el host
```

| Dentro del ns | Fuera del ns | Efecto |
|---|---|---|
| UID 0 (root) | UID 1000 (usuario normal) | Puede instalar paquetes dentro, pero no escalar en el host |
| UID 1000 | UID 1001 | No hay escape de privilegios |

**Ventaja crítica**: si un atacante escapa del contenedor, solo tiene permisos de usuario normal en el host.

## Namespace IPC — comunicación entre procesos

Aísla colas de mensajes SysV/POSIX, memoria compartida y semáforos. Los procesos en diferentes namespaces IPC no pueden comunicarse por estos mecanismos — tienen que usar sockets o pipes.

## Namespace cgroup — vista del árbol de cgroups

Aísla la vista del sistema de cgroups. Cada contenedor ve su propia jerarquía de cgroups sin ver la del host ni la de otros contenedores.

## Namespace de tiempo — tiempo independiente (Linux 5.6+)

Permite que un contenedor tenga **su propia línea de tiempo** (boot time, monotonic clock), independiente del host. Útil para sistemas que dependen de `CLOCK_BOOTTIME`.

## Namespaces y contenedores

Cuando ejecutas un contenedor, se crean **todos los namespaces a la vez**:

```bash
# Lo que Docker/Podman hacen internamente para un contenedor típico:
# 1. CLONE_NEWNS   → sistema de archivos aislado
# 2. CLONE_NEWUTS  → hostname propio
# 3. CLONE_NEWIPC  → IPC aislado
# 4. CLONE_NEWPID  → PID 1 propio
# 5. CLONE_NEWNET  → pila de red propia
# 6. CLONE_NEWUSER → mapeo de UIDs (en rootless)
# 7. CLONE_NEWCGROUP → vista propia de cgroups
# 8. CLONE_NEWTIME  → tiempo propio (si se requiere)
```

### Comprobar namespaces de un proceso

```bash
# Ver los namespaces a los que pertenece un proceso
ls -l /proc/$$/ns/
# total 0
# lrwxrwxrwx 1 carlos carlos 0 jul 23 12:00 cgroup → 'cgroup:[4026531835]'
# lrwxrwxrwx 1 carlos carlos 0 jul 23 12:00 ipc → 'ipc:[4026531839]'
# lrwxrwxrwx 1 carlos carlos 0 jul 23 12:00 mnt → 'mnt:[4026531841]'
# lrwxrwxrwx 1 carlos carlos 0 jul 23 12:00 net → 'net:[4026531992]'
# lrwxrwxrwx 1 carlos carlos 0 jul 23 12:00 pid → 'pid:[4026531836]'
# lrwxrwxrwx 1 carlos carlos 0 jul 23 12:00 user → 'user:[4026531837]'
# lrwxrwxrwx 1 carlos carlos 0 jul 23 12:00 uts → 'uts:[4026531838]'

# El número entre [] es el inodo del namespace.
# Dos procesos con el mismo inodo → comparten el namespace.
# Diferente inodo → están aislados.

# Comparar namespaces de dos procesos
sudo ls -l /proc/1234/ns/pid              # PID del contenedor
sudo ls -l /proc/5678/ns/pid              # PID del host (distinto = aislados)
```

### Unshare vs nsenter

```bash
# unshare → crear un NUEVO namespace (desde el host)
sudo unshare --pid --fork bash            # proceso hijo en nuevo namespace PID
sudo unshare --net bash                   # proceso en nuevo namespace de red

# nsenter → ENTRAR a un namespace existente (como Docker exec)
# Útil para diagnosticar un contenedor desde el host
sudo nsenter -t <PID-del-proceso> --mount --uts bash

# Ejemplo práctico: entrar al namespace de red de un contenedor
sudo nsenter -t $(docker inspect -f '{{.State.Pid}}' mi-contenedor) --net ip a
```

## Namespaces vs cgroups

| | Namespaces | cgroups |
|---|---|---|
| **Qué hacen** | Aíslan recursos (cada proceso ve su propia vista) | Limitan recursos (CPU, RAM, IO) |
| **Analogía** | Paredes entre habitaciones | Grifo que limita el caudal de cada habitación |
| **Ejemplo** | Proceso A no ve los procesos de B | Proceso A no puede usar más de 512 MB RAM |
| **Dependencia** | Independientes | Independientes |
| **Uso en contenedores** | Aislamiento del sistema | Límite de recursos del contenedor |

## Por qué importa

Los namespaces son lo que hace que los contenedores **parezcan máquinas virtuales** sin serlo. Entenderlos explica por qué:
- `kill 1` dentro de un contenedor no mata el sistema
- Los contenedores tienen su propia interfaz de red
- rootless containers no dan privilegios reales en el host
- Docker in Docker necesita montar `/var/run/docker.sock`

## Enlaces externos

- [Arch Wiki — Network namespace](https://wiki.archlinux.org/title/Network_namespace)
- [Wikipedia — Linux namespaces](https://en.wikipedia.org/wiki/Linux_namespaces)
- [man 7 namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html)
- [man 7 user_namespaces](https://man7.org/linux/man-pages/man7/user_namespaces.7.html)
- [man 7 pid_namespaces](https://man7.org/linux/man-pages/man7/pid_namespaces.7.html)

## Ver también

- [[Contenedores]] — los contenedores usan namespaces para aislar
- [[cgroups (control de recursos)]] — cgroups limitan recursos, namespaces aíslan vistas
- [[Docker]] — Docker/Podman usan todos los namespaces
- [[LXC y Contenedores del Sistema]] — contenedores a nivel de sistema
- [[Procesos y Senales]] — el PID 1 en namespaces tiene responsabilidades especiales

#concepto #kernel #contenedores
