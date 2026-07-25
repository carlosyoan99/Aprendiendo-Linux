---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: dnf (rpm)
base: Red Hat Enterprise Linux (RHEL)
modelo_lanzamiento: Fixed (LTS-like)
init: systemd
arquitecturas:
  - x86_64
  - ARM
  - ppc64le
  - s390x
---

# AlmaLinux

> Distribución Linux gratuita y de código abierto, **100% compatible con RHEL** (Red Hat Enterprise Linux), creada como reemplazo directo de CentOS tras su cambio a CentOS Stream. Mantenida por la comunidad con el respaldo inicial de CloudLinux.

## Qué es

AlmaLinux nació en **2021** como respuesta al anuncio de Red Hat de que CentOS 8 dejaría de tener soporte en 2021 (en lugar de 2029), reemplazándolo por **CentOS Stream** (una versión rolling upstream de RHEL en lugar de downstream).

Creado por **CloudLinux**, AlmaLinux (del latín *alma* = "alma") busca ser "el alma de la comunidad Linux empresarial". La fundación AlmaLinux OS Foundation, independiente de CloudLinux, gobierna el proyecto desde 2022. Es utilizado por el **CERN** y **Fermilab** como sistema operativo estándar para sus experimentos.

| Aspecto | Detalle |
|---|---|
| **Creador** | CloudLinux (Igor Seletskiy), 2021 |
| **Fundación** | AlmaLinux OS Foundation (2022, gobernanza comunitaria) |
| **Modelo** | Compatibilidad binaria 1:1 con RHEL |
| **Gestor de paquetes** | dnf / rpm (mismo que RHEL) |
| **Ciclo** | ~10 años de soporte por versión mayor |
| **Soporte hasta** | 2029 (AlmaLinux 8), 2032 (AlmaLinux 9) |

## Gestor de paquetes

```bash
# Actualizar sistema
sudo dnf update

# Instalar paquetes
sudo dnf install nginx

# Buscar paquetes
dnf search nginx

# Grupo de paquetes
sudo dnf groupinstall "Development Tools"

# Agregar repositorio EPEL (Extra Packages for Enterprise Linux)
sudo dnf install epel-release
```

## Ciclo de lanzamiento

| Versión | RHEL base | Lanzamiento | Soporte hasta |
|---|---|---|---|
| **AlmaLinux 8** | RHEL 8 | Marzo 2021 | 2029 |
| **AlmaLinux 9** | RHEL 9 | Mayo 2022 | 2032 |
| **AlmaLinux 10** | RHEL 10 | 2025 (estimado) | ~2035 |

## Proyecto ELevate

Herramienta que permite migrar entre versiones mayores de RHEL y derivados (CentOS 7 → AlmaLinux 8 → AlmaLinux 9):

```bash
# Migrar de CentOS 7 a AlmaLinux 8
sudo dnf install -y http://repo.almalinux.org/elevate/elevate-release-latest-el7.noarch.rpm
sudo elevate
```

También soporta migración **entre distribuciones** compatibles con RHEL (CentOS, Rocky, Oracle Linux).

## Comparativa con alternativas

| Aspecto | AlmaLinux | Rocky Linux | CentOS Stream | RHEL (pago) |
|---|---|---|---|---|
| **Compatibilidad** | 1:1 con RHEL | 1:1 con RHEL | Upstream de RHEL | Oficial Red Hat |
| **Costo** | Gratuito | Gratuito | Gratuito | Suscripción |
| **Soporte comercial** | CloudLinux | CIQ | Red Hat (comunitario) | Red Hat oficial |
| **Gobernanza** | Fundación independiente | Fundación independiente | Red Hat | Red Hat |
| **Ciclo** | ~10 años | ~10 años | Continuo | ~10 años |
| **Actualizaciones** | Atrasa a RHEL | Atrasa a RHEL | Adelanta a RHEL | Oficial |

## ¿Por qué elegir AlmaLinux?

| Situación | Recomendación |
|---|---|
| **Reemplazar CentOS 7/8** | AlmaLinux (migración directa y probada) |
| **Entorno empresarial** | AlmaLinux o RHEL (soporte a largo plazo) |
| **Servidor web / hosting** | Cualquier RHEL-compatible |
| **Desarrollo de software** | AlmaLinux (testing en entorno RHEL sin costo) |
| **High-performance computing** | AlmaLinux (CERN/Fermilab lo validan) |
| **Kubernetes / cloud** | Rocky Linux (mayor integración con cloud) |

## Instalación

```bash
# Descargar ISO desde https://almalinux.org/get-almalinux/
# Opciones: DVD (completa), Minimal, Boot, Live GNOME/KDE/XFCE

# Crear USB booteable
sudo dd if=AlmaLinux-9-latest-x86_64-dvd.iso of=/dev/sdX bs=4M status=progress

# Instalador Anaconda (el mismo de RHEL/Fedora)
# Soporta: particionado manual, LVM, LUKS, RAID, Btrfs
```

## Ver también

- [[CentOS]] — predecesor (también RHEL clone, ahora CentOS Stream)
- [[Rocky Linux]] — alternativa directa creada por el fundador original de CentOS
- [[Fedora]] — base upstream de RHEL
- [[Gestores de Paquetes]] — dnf/rpm

## Enlaces externos

- [Sitio oficial AlmaLinux](https://almalinux.org/)
- [Wiki de AlmaLinux](https://wiki.almalinux.org/)
- [Repositorio GitHub](https://github.com/AlmaLinux)
- [Blog oficial](https://blog.almalinux.org/)
- [Lista de mirrors](https://mirrors.almalinux.org/)
- [Proyecto ELevate](https://almalinux.org/elevate/)
- [Wikipedia — AlmaLinux](https://en.wikipedia.org/wiki/AlmaLinux)

#distro
