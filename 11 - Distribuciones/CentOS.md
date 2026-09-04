---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: dnf (yum legacy)
base: Red Hat Enterprise Linux (RHEL)
---

# CentOS

## Qué es

**CentOS** (Community ENTerprise Operating System) fue un clon binario de **Red Hat Enterprise Linux (RHEL)**. Su objetivo: ofrecer un sistema operativo empresarial gratuito, estable y compatible con RHEL, manteniendo el mismo nivel de seguridad y actualizaciones.

Fue una de las distribuciones más populares para servidores durante ~15 años. Sin embargo, Red Hat cambió su rumbo en **diciembre de 2020**, discontinuando CentOS Linux en favor de **CentOS Stream**, una versión rolling que sirve como "beta upstream" de RHEL.

## Historia

| Año | Evento |
|---|---|
| **2004** | CentOS 2 (primera versión, basada en RHEL 2.1) |
| **2005** | CentOS 3.1, primer lanzamiento ampliamente adoptado |
| **2007** | CentOS 5, gran popularidad en servidores |
| **2011** | CentOS 6 |
| **2014** | Red Hat patrocina oficialmente el proyecto CentOS |
| **2014** | CentOS 7 (el más usado, soporte hasta 2024) |
| **2019** | CentOS 8 |
| **2020** | Red Hat anuncia el fin de CentOS Linux → CentOS Stream |
| **2021** | Fundación de **Rocky Linux** y **AlmaLinux** como sucesores |
| **2024** | Fin de soporte de CentOS 7 (última versión CentOS Linux) |

## Características

| Aspecto | Detalle |
|---|---|
| **Gestor** | dnf (Fedora/RHEL moderno) / yum (legacy) |
| **Base** | RHEL (binario compatible) |
| **Formato** | .rpm |
| **Entorno** | Servidores (sin GUI por defecto) |
| **Ciclo** | ~3-5 años entre versiones, 10 años de soporte |
| **Estabilidad** | Máxima (paquetes congelados, solo parches de seguridad) |

```bash
# Comandos (comparte la mayoría con Fedora/RHEL)
sudo dnf update                         # actualizar
sudo dnf install nginx                  # instalar
sudo dnf remove nginx                   # eliminar
sudo systemctl enable --now nginx       # servicios con systemd

# Antiguo yum (aún usado en scripts legacy)
sudo yum update
sudo yum install nginx
```

## CentOS Stream

**CentOS Stream** no es un clon de RHEL, sino un **rolling release entre Fedora y RHEL**. Es la rama de desarrollo donde se prueban las futuras versiones de RHEL.

```bash
# CentOS Stream 9
sudo dnf install centos-stream-release
sudo dnf update
```

| Aspecto | CentOS Linux (legacy) | CentOS Stream |
|---|---|---|
| **Tipo** | Clon binario de RHEL | Rolling pre-RHEL |
| **Estabilidad** | Máxima | Media (entre Fedora y RHEL) |
| **Actualizaciones** | Solo seguridad | Features + seguridad |
| **Uso recomendado** | Producción (antes 2021) | Desarrollo, testing |
| **Fin de vida** | CentOS 7: 2024 | Activo |

## Sucesores de CentOS

Tras el anuncio de 2020, la comunidad creó dos forks principales:

| Distribución | Fundador | Estado | Compatibilidad RHEL |
|---|---|---|---|
| **[[Rocky Linux]]** | Gregory Kurtzer (fundador original de CentOS) | ✅ Activo | 100% binario |
| **AlmaLinux** | CloudLinux | ✅ Activo | 100% binario |
| **CentOS Stream** | Red Hat | ✅ Activo | Pre-RHEL (no clon) |

```bash
# Migrar de CentOS 7/8 a Rocky Linux o AlmaLinux
# Ambos tienen scripts de migración automática:
# Rocky: migrate2rocky.sh
# AlmaLinux: almalinux-deploy.sh
```

## Instalación

```bash
# CentOS Stream 9 (descargar ISO desde):
# https://centos.org/download/

# Requisitos mínimos:
# - RAM: 64 MB (sin GUI) / 1 GB (con GUI)
# - Disco: 2 GB (sin GUI) / 20 GB (con GUI)
# - Procesador: x86_64
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| CentOS 7/8 ya sin actualizaciones | EOL de la versión (CentOS 7 finalizó 2024) | Migrar a un clon RHEL: `sudo migrate2rocky` (Rocky) o `almalinux-deploy` (AlmaLinux) |
| Repositorio base vacío/400 | espejo old del EOL | Usar `vault.centos.org` o migrar; no insistir en `base/` de una versión muerta |
| `dnf` no encuentra paquete | firma GPG del repositorio cambiada | `sudo dnf clean all && sudo dnf makecache`; si persiste, actualizar la key del repo |
| Kernel independiente no firma para SecureBoot | módulos unsigned | Firmar los módulos DKMS con la MOK (Machine Owner Key) en shim |
| CentOS Stream adelanta paquetes | modelo rolling upstream de RHEL | Si necesitas estabilidad binaria, usar Rocky/AlmaLinux en lugar de Stream |

## Enlaces externos

- [Sitio oficial de CentOS](https://www.centos.org/)
- [CentOS Stream](https://www.centos.org/centos-stream/)
- [Wikipedia — CentOS](https://en.wikipedia.org/wiki/CentOS)
- [Arch Wiki — CentOS](https://wiki.archlinux.org/title/CentOS)

## Ver también

- [[Rocky Linux]] — sucesor directo de CentOS
- [[Fedora]] — base upstream de RHEL y CentOS Stream
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]] — otras distros notables

#distro
