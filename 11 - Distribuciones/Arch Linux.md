---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: pacman
base: independiente
---

# Arch Linux

## Filosofía / público objetivo

Minimalismo y control total: la instalación base no trae casi nada preconfigurado, y el usuario construye el sistema pieza por pieza (kernel, drivers, DE/WM, aplicaciones). Rolling release: siempre en la última versión de cada paquete. Documentación de referencia: **Arch Wiki**, considerada la mejor documentación de Linux existente (útil incluso fuera de Arch).

Principio KISS (Keep It Simple, Stupid): el diseño es simple y transparente, no "fácil de usar" sino "fácil de entender". No hay herramientas gráficas de configuración que oculten lo que pasa.

## Gestor de paquetes

### pacman

```bash
# Instalación y gestión
sudo pacman -S <paquete>              # instalar
sudo pacman -Syu                      # actualizar TODO el sistema (siempre hacer esto antes de instalar algo)
sudo pacman -Ss <termino>             # buscar en repos
sudo pacman -R <paquete>              # eliminar (deja config)
sudo pacman -Rs <paquete>             # eliminar + dependencias no usadas por otros
sudo pacman -Rn <paquete>             # eliminar + archivos de config (como purge)
sudo pacman -Q                        # listar paquetes instalados
sudo pacman -Qo <archivo>             # ¿a qué paquete pertenece este archivo?
sudo pacman -Qi <paquete>             # info detallada
```

**Sincronizar siempre antes de instalar**: `sudo pacman -Syu` actualiza la base de datos y los paquetes. Arch es rolling release, así que actualizar antes de instalar evita conflictos de versiones.

### AUR (Arch User Repository)

Repositorio comunitario gigantesco: si un programa no está en los repos oficiales, casi seguro está en el AUR. No se instala con `pacman` directo — se necesita un **helper**:

| Helper | Lenguaje | Instalación | Notas |
|---|---|---|---|
| **yay** | Go | `sudo pacman -S yay` | El más popular, reemplaza a pacman (`yay -S paquete`) |
| **paru** | Rust | `sudo pacman -S paru` | Moderno, más rápido, con bundles (se pueden instalar grupos de dependencias juntos) |
| **pamac** | Vala | `sudo pacman -S pamac` | GUI + CLI, usado en Manjaro |

```bash
# Cualquiera de estos helpers funciona como pacman + AUR
yay -S google-chrome                  # busca en repos oficiales y luego en AUR
yay -Syu                              # actualiza todo (oficial + AUR)
yay google-chrome                     # busca sin -S también funciona
```

## Instalación

Arch tiene dos caminos de instalación:

### 1. Manual (tradicional)

La instalación clásica paso a paso desde terminal, siguiendo la [Arch Wiki Installation Guide](https://wiki.archlinux.org/title/Installation_guide):
1. Bootear la ISO → verificar boot mode (UEFI)
2. Conectarse a internet (`iwctl` para WiFi)
3. Particionar (`fdisk` o `cfdisk`)
4. Formatear y montar particiones
5. `pacstrap /mnt base linux linux-firmware`
6. Generar fstab, chroot, configurar zona horaria, locale, hostname
7. Instalar bootloader (GRUB o systemd-boot)
8. Crear usuario, configurar red, reiniciar

### 2. archinstall (automated, oficial)

Desde 2021, Arch incluye `archinstall`, un script guiado que automatiza la instalación:

```bash
# En el live ISO:
archinstall                              # menú interactivo (teclado, disco, DE, kernel, etc.)
```

Recomendado para la 2da o 3ra instalación en adelante. Para la primera, hacer la manual al menos una vez para entender cómo funciona el sistema por dentro.

## Arch Wiki: cómo usarla

La [Arch Wiki](https://wiki.archlinux.org/) es el recurso más valioso. Tips de navegación:

- Buscar "[topic] Arch Wiki" en Google (ej. "nginx Arch Wiki", "Hyprland Arch Wiki").
- Cada página suele tener: instalación → configuración → troubleshooting → ver también.
- Incluso si usas Ubuntu/Debian/Fedora, la Arch Wiki suele tener la explicación más clara y completa de cualquier software o concepto — solo adapta los comandos de `pacman` a tu gestor.

```bash
# Ver paquetes huérfanos (instalados como dependencia que ya no necesita nada)
pacman -Qdt                             # para revisar y limpiar
sudo pacman -Rs $(pacman -Qdtq)         # borrar todos los huérfanos

# Resolver conflictos de base de datos
sudo rm /var/lib/pacman/db.lck          # si pacman se queja de que está bloqueado (tras un crash)
```

## Ciclo de lanzamiento

Rolling release — no hay "versiones" discretas. Se instala una vez y se actualiza continuamente. Requiere mantenimiento: conviene actualizar cada ~semana o dos (dejar meses puede causar problemas por la acumulación de cambios grandes).

## Notas de instalación propias

-

## Enlaces externos

- [Sitio oficial de Arch Linux](https://archlinux.org/)
- [Arch Wiki](https://wiki.archlinux.org/) — la mejor documentación de Linux
- [Wikipedia — Arch Linux](https://en.wikipedia.org/wiki/Arch_Linux)
- [Arch User Repository (AUR)](https://aur.archlinux.org/)
- [Arch Linux Package Search](https://archlinux.org/packages/)
- [Guía de instalación](https://wiki.archlinux.org/title/Installation_guide)

## Comparativa con otras distribuciones

| Aspecto | [[Arch Linux]] | [[Manjaro]] | [[EndeavourOS]] | [[Debian]] |
|---|---|---|---|---|
| **Gestor de paquetes** | pacman (+AUR) | pacman (+AUR) | pacman (+AUR) | apt |
| **Modelo** | Rolling (DIY total) | Rolling curado | Rolling | Fixed (stable) |
| **Instalador** | Manual / archinstall | Gráfico (Calamares) | GUI (Welcomer) | Gráfico (Calamares/clásico) |
| **Estabilidad** | Media-Alta (DIY) | Alta (curado) | Media | Máxima |
| **Filosofía** | KISS, control total | Amigable | Arch fácil | Conservadora/estable |
| **Público** | Avanzados | Usuarios varios | Migrantes de Arch | Servidores/estables |

**En resumen**: Arch es la base "pura" de control total; Manjaro la endulza con repos curados, EndeavourOS la empaqueta fácil sin adulterar, y Debian prioriza la estabilidad por encima de la novedad.

## Ver también

- [[CachyOS]] — Arch optimizado para rendimiento con instalador gráfico
- [[Manjaro]] — Arch con paquetes "curados" y más estable
- [[Particionado y Esquemas de Disco]]
- [[systemd]]

#distro
