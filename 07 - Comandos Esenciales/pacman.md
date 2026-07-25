---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: comando
prioridad: baja
---

# pacman

## Sintaxis
```
pacman <operación> [opciones] [paquete...]
```

## Descripción

Gestor de paquetes de **Arch Linux** y derivadas (Manjaro, EndeavourOS). Combina un formato binario simple con un sistema de compilación (makepkg/ABS). Resuelve dependencias automáticamente — el usuario solo necesita un comando para actualizar todo el sistema.

Desarrollado por **Judd Vinet** (creador de Arch), escrito en C. Usa el formato `tar` comprimido con `gzip`/`xz` para los paquetes.

## Operaciones principales

| Operación | Descripción |
|---|---|
| `-S` | Instalar paquete(s) |
| `-Syu` | Sincronizar BD + actualizar sistema |
| `-Ss` | Buscar paquete en repositorios |
| `-Si` | Info detallada de paquete remoto |
| `-R` | Eliminar paquete |
| `-Rs` | Eliminar paquete + dependencias no usadas |
| `-Rsc` | Eliminar paquete + dependencias + dependientes |
| `-Q` | Listar paquetes instalados |
| `-Qs` | Buscar entre paquetes instalados |
| `-Qi` | Info detallada de paquete instalado |
| `-Ql` | Listar archivos instalados por un paquete |
| `-Qo` | Saber a qué paquete pertenece un archivo |
| `-Qdt` | Listar paquetes huérfanos (no dependencias) |
| `-Qet` | Listar paquetes explícitamente instalados |
| `-U` | Instalar paquete local o remoto (`.pkg.tar.xz`) |
| `-Fy` | Sincronizar BD de archivos |
| `-Fs` | Buscar qué paquete contiene un archivo |
| `-Sc` | Limpiar caché (paquetes no instalados) |
| `-Scc` | Limpiar caché + repositorios no usados |

## Ejemplos

```bash
# Instalar y actualizar
pacman -S firefox                      # instalar Firefox
pacman -Syu                            # actualizar TODO el sistema
pacman -Ss firefox                     # buscar Firefox en repos
pacman -Si firefox                     # info detallada de Firefox

# Eliminar
pacman -R firefox                      # eliminar Firefox
pacman -Rs firefox                     # eliminar + dependencias no usadas

# Consultas
pacman -Q                              # listar todos los paquetes instalados
pacman -Qdt                            # paquetes huérfanos
pacman -Qo /usr/bin/firefox            # ¿quién puso ese archivo?
pacman -Ql firefox                     # archivos que instaló Firefox

# Paquetes locales y remotos
pacman -U ~/firefox-120.0.pkg.tar.xz   # instalar desde archivo local
pacman -U https://ejemplo.com/pkg.pkg.tar.xz  # desde URL

# Caché
paccache -r                            # limpiar caché (deja 3 versiones)
paccache -rk1                          # dejar solo 1 versión anterior
```

## Configuración

`/etc/pacman.conf` — repositorios, opciones globales, `IgnorePkg`, `NoUpgrade`, `NoExtract`.

```ini
# /etc/pacman.conf
[options]
# Ignorar paquete al actualizar
IgnorePkg = linux

# No sobrescribir archivos específicos
NoUpgrade = etc/conf.d/myservice

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist
```

## Frontends gráficos

- **Octopi** — Qt, para Arch/Manjaro
- **Pamac** — GTK, simple, con soporte AUR
- **AppSet** — avanzado
- **pacman-notifier** — icono en bandeja

## Notas

- Los paquetes usan extensión `.pkg.tar.zst` (antes `.pkg.tar.xz`)
- AUR no es un repositorio oficial de pacman — se necesita un helper (yay, paru, pamac)
- La base de datos de pacman está en `/var/lib/pacman/sync/`
- `pacman -Syu` siempre debe ejecutarse completo — las actualizaciones parciales NO están soportadas en Arch

## Ver también

- [[Arch Linux]] — distribución que usa pacman
- [[Gestores de Paquetes]] — comparativa con apt, dnf, emerge
- [[Manjaro]] — derivada de Arch que usa pacman
- [[EndeavourOS]] — otra derivada de Arch

## Enlaces externos

- [Wikipedia - Pacman](https://en.wikipedia.org/wiki/Pacman_(package_manager))
- [Arch Wiki - Pacman](https://wiki.archlinux.org/title/Pacman)
- [Sitio oficial - Arch Linux](https://archlinux.org/pacman/)

#comando #paquetes #arch
