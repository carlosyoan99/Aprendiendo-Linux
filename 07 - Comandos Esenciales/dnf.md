---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: alta
---

# dnf — Gestor de paquetes de Fedora/RHEL

Frontal de alto nivel para sistemas basados en RPM (Fedora, RHEL, CentOS, Rocky Linux). Sucesor de `yum`.

## Sintaxis

```
dnf [opciones] <comando> [argumentos]
```

## Comandos principales

| Comando | Descripción |
|---|---|
| `dnf install <pkg>` | Instalar paquete(s) |
| `dnf remove <pkg>` | Eliminar paquete |
| `dnf upgrade` | Actualizar todos los paquetes |
| `dnf update` | Actualizar (alias de upgrade) |
| `dnf search <termino>` | Buscar paquetes |
| `dnf info <pkg>` | Información del paquete |
| `dnf list installed` | Listar paquetes instalados |
| `dnf provides </ruta/archivo>` | Qué paquete instaló ese archivo |
| `dnf autoremove` | Eliminar dependencias huérfanas |
| `dnf clean all` | Limpiar caché |
| `dnf groupinstall "<grupo>"` | Instalar grupo de paquetes |
| `dnf history` | Historial de operaciones |

## Ejemplos

```bash
sudo dnf install nginx                    # instalar
sudo dnf remove nginx                     # eliminar
sudo dnf upgrade                          # actualizar todo
sudo dnf search web server                # buscar
sudo dnf info nginx                       # info del paquete
sudo dnf provides /usr/sbin/nginx         # qué paquete da ese archivo
sudo dnf groupinstall "Development Tools" # grupo de herramientas
sudo dnf autoremove                       # limpiar
```

## Archivos de configuración

```bash
/etc/dnf/dnf.conf              # configuración global
/etc/dnf/plugins/              # plugins (versionlock, etc.)
/etc/yum.repos.d/*.repo        # repositorios (formato .repo)
/var/log/dnf.log               # log de operaciones
/var/log/dnf.rpm.log           # log de transacciones RPM
```

### dnf.conf

```ini
# /etc/dnf/dnf.conf
[main]
gpgcheck=True                  # verificar firmas GPG
installonly_limit=3            # kernels a conservar
clean_requirements_on_remove=True  # eliminar dependencias huérfanas
best=True                      # instalar la versión más reciente
fastestmirror=True             # usar el mirror más rápido
max_parallel_downloads=10      # descargas paralelas (Fedora 38+)
```

## Gestión de repositorios

```bash
# Listar repos activos
dnf repolist
dnf repolist --all              # incluye desactivados

# Añadir repositorio manual
sudo dnf config-manager --add-repo https://example.com/repo.repo

# Activar/desactivar repositorio
dnf config-manager --set-enabled epel
dnf config-manager --set-disabled epel

# Ver info de un repo
dnf repoinfo epel
```

### COPR (Community Projects)

COPR es un sistema de builds comunitario para Fedora/RHEL. Equivalente a AUR + PPAs:

```bash
sudo dnf copr enable atim/lazygit      # habilitar repo COPR
sudo dnf copr disable atim/lazygit     # deshabilitar
sudo dnf copr remove atim/lazygit      # eliminar
sudo dnf copr list                      # listar COPRs activos
```

## Versionlock (congelar versiones)

```bash
sudo dnf install 'dnf-command(versionlock)'

sudo dnf versionlock add nginx          # congelar versión
dnf versionlock list                    # listar paquetes congelados
sudo dnf versionlock clear              # eliminar todos los locks
sudo dnf versionlock delete nginx       # eliminar lock específico
```

## dnf history (transacciones)

```bash
dnf history                            # mostrar historial
dnf history info 15                    # detalle de transacción
dnf history undo 15                    # revertir transacción
dnf history redo 15                    # reaplicar transacción
```

## System Upgrade (cambio de versión mayor)

```bash
sudo dnf install dnf-plugin-system-upgrade
sudo dnf system-upgrade download --releasever=41    # Fedora 40→41
sudo dnf system-upgrade reboot                      # reiniciar para aplicar
```

## dnf download (descargar sin instalar)

```bash
dnf download nginx                     # descargar RPM sin instalar
dnf download --source nginx            # descargar SRPM
dnf download --destdir=/tmp/rpms nginx # directorio específico
```

## Grupos y módulos

### Grupos
```bash
dnf group list                         # listar grupos
dnf group list --installed             # grupos instalados
dnf group install "Development Tools"  # instalar grupo
dnf group remove "Development Tools"   # eliminar grupo
```

### Módulos (streams)
Permiten elegir entre versiones del mismo paquete:
```bash
dnf module list                        # listar módulos disponibles
dnf module list nodejs                 # buscar módulo específico
dnf module enable nodejs:20            # habilitar stream
dnf module install nodejs:20           # instalar módulo
dnf module reset nodejs                # resetear (para cambiar de stream)
```

## Troubleshooting

| Problema | Solución |
|---|---|
| `Could not resolve host` | `dnf clean all` + `dnf makecache` |
| Paquete no encontrado | Buscar con `dnf search`, verificar COPR o EPEL |
| Error GPG | `rpm --import <clave-gpg>` o desactivar temporalmente `gpgcheck=0` |
| Transacción fallida | `dnf history undo <id>` para revertir |
| Dependencia rota | `dnf distro-sync --nobest` para sincronizar |
| Spins al actualizar | `dnf clean all` + `dnf upgrade --refresh` |

## Ver también

- [[apt]] — gestor de Debian/Ubuntu
- [[pacman]] — gestor de Arch
- rpm — bajo nivel de RPM
- [[Gestores de Paquetes]] — índice + comparativa

## Enlaces externos

- [Documentación oficial de DNF](https://dnf.readthedocs.io/)
- [Wikipedia — DNF](https://en.wikipedia.org/wiki/DNF_(software))
- [Fedora — Upgrading](https://docs.fedoraproject.org/en-US/quick-docs/upgrading-fedora-offline/)
- [COPR](https://copr.fedorainfracloud.org/)

#comando #paquetes
