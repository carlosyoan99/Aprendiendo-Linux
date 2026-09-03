---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: zypper (rpm)
base: independiente
---

# openSUSE

> Distro alemana con tradición desde 1994. Destaca por sus **dos ediciones** (Leap estable y Tumbleweed rolling), la herramienta de administración **YaST**, y el sistema de rollback con **Snapper + Btrfs**.

## Ediciones

| Edición | Tipo | Base | Ideal para |
|---|---|---|---|
| **Leap** | Release fija (~anual) | SUSE Linux Enterprise (SLE) | Escritorio estable, servidores, producción |
| **Leap 16** | Release fija (2025-2031) | SLE 16 | Nuevo ciclo con minor releases (16.0, 16.1...) |
| **Tumbleweed** | Rolling continuo | Independiente | Entusiastas, developers, lo último en paquetes |
| **Aeon** | Inmutable (GNOME) | MicroOS | Escritorio moderno con atomic updates |
| **Kalpa** | Inmutable (KDE) | MicroOS | Lo mismo pero con KDE Plasma |

### Leap vs Tumbleweed: ¿cuál elegir?

| Aspecto | Leap (16.x) | Tumbleweed |
|---|---|---|
| **Modelo** | Fixed, minor releases anuales | Rolling, snapshots semanales |
| **Paquetes** | Estables, testeados contra SLE | Últimas versiones upstream |
| **Seguridad** | Parches backportados | Parches inmediatos upstream |
| **OpenQA** | Tests previo a minor release | Tests automatizados en cada snapshot |
| **Frecuencia updates** | Semanal/mensual | Múltiples por semana |
| **Riesgo de rotura** | Muy bajo | Bajo (openQA detecta regresiones) |
| **Soporte** | ~2 años por minor release | Rolling (último snapshot = soporte) |

> Tumbleweed es más seguro que Arch porque cada snapshot pasa por **openQA** (pruebas automáticas de instalación, GUI y actualizaciones) antes de publicarse. Si un paquete introduce una regresión, no llega al usuario.

## Zypper — Gestor de paquetes

```bash
# Búsqueda e instalación
zypper search <termino>                  # buscar paquetes
zypper info <paquete>                    # información detallada
zypper install <paquete>                 # instalar (con dependencias)
zypper install --no-recommends <paquete> # sin recomendados
zypper remove <paquete>                  # eliminar
zypper remove --clean-deps <paquete>     # eliminar + dependencias huérfanas

# Actualizaciones
zypper refresh                           # actualizar índices de repos
zypper update                            # actualizar todos los paquetes
zypper patch                             # solo parches de seguridad
zypper list-patches                      # ver parches disponibles

# Repositorios
zypper lr                                # listar repos (lr = list repos)
zypper lr -u                             # listar con URLs
zypper addrepo <url> <nombre>            # añadir repositorio
zypper removerepo <nombre>               # eliminar repositorio
zypper mr -e <nombre>                    # habilitar repositorio
zypper mr -d <nombre>                    # deshabilitar repositorio

# Diagnóstico
zypper ps                                # procesos con libs actualizadas (pedir reinicio)
zypper ve                                # verificar dependencias
zypper pkg <ruta/al/binario>            # ¿qué paquete instaló este archivo?
zypper what-provides <ruta>              # ¿qué paquete provee este archivo?
```

## YaST (Yet another Setup Tool)

YaST es el centro de control de openSUSE — permite configurar casi todo con GUI o desde terminal:

```bash
sudo yast                                # modo gráfico (Qt)
sudo yast2                               # modo GTK (alternativa)
sudo yast                                # modo terminal si no hay DE
```

### Módulos principales de YaST

| Módulo | Función |
|---|---|
| **Software** | Gestión de repositorios, instalación/eliminación de paquetes |
| **Hardware** | Impresoras, escáneres, tarjetas gráficas, sonido |
| **Sistema** | Particionado (storage-ng), arranque (GRUB), fecha/hora, idioma |
| **Red** | Interfaces (NetworkManager/Wicked), DNS, firewall, SSH |
| **Seguridad** | AppArmor, certificados, política de usuarios |
| **Servicios** | Activar/desactivar systemd, configurar servidores (DHCP, DNS, Samba) |
| **Virtualización** | KVM, Docker, Podman (gestión integrada) |

## Snapper + Btrfs (rollback automático)

openSUSE configura **snapshots automáticos de Btrfs** antes de cada operación con zypper:

```bash
snapper list                             # ver snapshots disponibles
sudo snapper -c root create -d "antes de experimento"  # snapshot manual
snapper status XX..YY                    # diferencias entre snapshots
snapper diff XX..YY                      # diff de archivos concretos
sudo snapper rollback XX                 # restaurar snapshot

# En el arranque: GRUB muestra los snapshots disponibles
# → Arrancar un snapshot anterior = rollback instantáneo
```

## OBS (Open Build Service)

Plataforma para compilar paquetes para múltiples distribuciones desde un solo archivo de especificaciones:

```bash
# OBS público: https://build.opensuse.org
# Permite compilar para: openSUSE, Fedora, Debian, Ubuntu, Arch, RHEL...

# Estructura de un proyecto OBS:
# mi-proyecto/
# ├── mi-app.spec        # archivo de especificaciones RPM
# ├── mi-app.tar.gz      # código fuente
# └── _service           # (opcional) servicio para descargar fuente automáticamente

# Usar OBS CLI (osc):
sudo zypper install osc
osc checkout home:usuario/mi-proyecto   # clonar proyecto
osc build openSUSE_Tumbleweed x86_64    # compilar localmente
osc commit                               # subir cambios
```

## Ciclo de lanzamiento

| Edición | Ciclo | Soportes |
|---|---|---|
| **Leap 16.x** | Minor release anual | 24 meses por minor release |
| **Tumbleweed** | Rolling (snapshots semanales) | Siempre actual |
| **Aeon/Kalpa** | Rolling (atomic updates) | Siempre actual |

## Enlaces externos

- [Sitio oficial de openSUSE](https://www.opensuse.org/)
- [Wikipedia — openSUSE](https://en.wikipedia.org/wiki/OpenSUSE)
- [openSUSE Wiki — YaST](https://en.opensuse.org/Portal:YaST)
- [openSUSE Wiki — Tumbleweed](https://en.opensuse.org/Portal:Tumbleweed)
- [Open Build Service](https://build.opensuse.org/)
- [Snapper — Documentación](https://snapper.io/)
- [openSUSE Aeon](https://aeon.opensuse.org/)

## Comparativa con otras distribuciones

| Aspecto | [[openSUSE]] | [[Fedora]] | [[Rocky Linux]] | [[Debian]] |
|---|---|---|---|---|
| **Base** | Independiente (SUSE) | RHEL upstream | RHEL | Independiente |
| **Modelo** | Leap (fixed) + Tumbleweed (rolling) | Fixed | Fixed (LTS) | Fixed (stable) |
| **Gestor** | zypper (rpm) | dnf (rpm) | dnf (rpm) | apt (deb) |
| **Diferenciador** | YaST + Snapper/Btrfs | Tecnología nueva | Empresarial estable | Máxima estabilidad |
| **Software comercial** | SLE (SUSE) | Red Hat | — | — |

**En resumen**: openSUSE es único por ofrecer a la vez Leap (estable) y Tumbleweed (rolling) con la potente herramienta YaST y Snapper/Btrfs para rollback; Fedora lidera en novedades; Rocky es el RHEL-compatible estable; Debian es la estabilidad pura.

## Ver también

- [[Fedora]] — otra distro con adopción temprana de tecnologías
- [[Rocky Linux]] — distro empresarial RHEL-based (SLE alternative)
- [[Gestores de Paquetes]] — comparativa zypper vs apt vs dnf vs pacman
- [[Btrfs]] — sistema de archivos usado por Snapper
- [[Cron]] · [[systemd timers]] — automatización con openSUSE
- SUSE Linux Enterprise (SLE) — base empresarial de Leap

#distro
