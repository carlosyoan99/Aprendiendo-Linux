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
/etc/yum.repos.d/*.repo        # repositorios (formato .repo)
```

## Ver también

- [[apt]] — gestor de Debian/Ubuntu
- [[pacman]] — gestor de Arch
- [[rpm]] — bajo nivel de RPM
- [[Gestores de Paquetes]] — índice + comparativa

## Enlaces externos

- [Documentación oficial de DNF](https://dnf.readthedocs.io/)
- [Wikipedia — DNF](https://en.wikipedia.org/wiki/DNF_(software))

#comando #paquetes
