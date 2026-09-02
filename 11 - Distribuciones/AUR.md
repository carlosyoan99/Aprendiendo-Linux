---
fecha_creacion: 2026-08-31
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: distribucion
prioridad: media
---

# AUR (Arch User Repository)

> El **Arch User Repository** (AUR) es el repositorio comunitario de Arch Linux, gestionado por los propios usuarios. Contiene cientos de miles de *PKGBUILD* (recetas de compilación) que cualquiera puede contribuir, y es la principal vía para instalar software que no está en los repositorios oficiales.

## Qué es

A diferencia de los repositorios oficiales (mantenidos por los desarrolladores de Arch), el AUR está **dirigido por la comunidad**: cualquier usuario puede publicar un `PKGBUILD`, un script que describe cómo obtener el código fuente, aplicar parches y empaquetarlo.

No se distribuyen binarios: el AUR entrega **recetas** (`PKGBUILD`) que compilan o empaquetan el paquete localmente vía `makepkg`. Por eso los paquetes del AUR **no cuentan con soporte oficial** — el riesgo de paquetes mal mantenidos o maliciosos es real. Siempre revisa el `PKGBUILD` antes de compilar.

## Cómo se usa

Dos caminos:

1. **Manual** (con git + makepkg):
   ```bash
   git clone https://aur.archlinux.org/<paquete>.git
   cd <paquete>
   makepkg -si
   ```

2. **Asistentes AUR** (`yay` es el más popular, otros: `paru`, `pikaur`):
   ```bash
   # buscar e instalar del AUR
   yay -S <paquete>
   # actualizar todo el sistema (repos + AUR)
   yay -Syu
   # buscar
   yay -Ss <texto>
   ```
   Los asistentes resuelven las dependencias del AUR automáticamente, buscando en los repos oficiales donde falten.

## Asistentes AUR comparados

| Aspecto | yay | paru | pikaur |
|---|---|---|---|
| Lenguaje | Go | Rust | Python |
| Velocidad | Rápida | Rápida | Media |
| Interfaz | CLI | CLI | CLI |
| Popularidad | La más alta | Creciente | Menor |
| Ordenar por votes | `-Ss --sort votes` | `-Ss --sort votes` | `-Ss` (por defecto) |

## Estructura de un PKGBUILD

```bash
# pkgname, pkgver, pkgrel, pkgdesc, arch, url, license, depends, makedepends
pkgname=mi-paquete
pkgver=1.0.0
pkgrel=1
pkgdesc="Descripcion del paquete"
arch=('x86_64')
url="https://github.com/usuario/proyecto"
license=('MIT')
depends=('openssl' 'zlib')
makedepends=('cmake' 'gcc')

source=("$url/archive/v$pkgver.tar.gz")
sha256sums=('SKIP')

build() {
  cd "$pkgname-$pkgver"
  mkdir build && cd build
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr
  make
}

package() {
  cd "$pkgname-$pkgver/build"
  make DESTDIR="$pkgdir" install
}
```

## En mi sistema (CachyOS)

En CachyOS (basada en Arch) el AUR es la misma infraestructura que en Arch Linux. Trabajo con `yay` para instalar software del AUR, por ejemplo:

```bash
yay -S google-chrome      # navegador que solo está en el AUR
sudo pacman -S snapper    # tools oficiales aparte
```

Ejemplo real de esta vault: [[google-chrome]] se instala en CachyOS desde el AUR.

## Seguridad

- Los PKGBUILD del AUR no están auditados por Arch. Revisa siempre `/pkgbuild`, las fuentes y el mantenedor.
- Prefiere los repos oficiales cuando el paquete exista allí.
- Para software propietario (Chrome, Slack, Spotify) el AUR es el único canal en sistemas Arch; asume el riesgo de confiar en el mantenedor.
- Verifica la fecha de actualización del PKGBUILD y el número de votos.

## AUR vs repositorios oficiales

| Aspecto | Repos oficiales | AUR |
|---|---|---|
| Mantenimiento | Equipo de Arch | Comunidad |
| Binarios | Sí | Solo fuente/recetas |
| Soporte | Oficial | Ninguno |
| Canales | núcleo, extra, multilib | Un solo repo |
| Acceso | `pacman -S` | `yay`/`makepkg` |

## Ver también

- [[Arch Linux]] — la distribución que creó el AUR
- [[CachyOS]] — distro Arch-based de esta máquina, usa el mismo AUR
- [[pacman]] — gestor de paquetes oficial

## Enlaces externos

- [Arch User Repository — sitio oficial](https://aur.archlinux.org/)
- [AUR — Arch Wiki](https://wiki.archlinux.org/title/Arch_User_Repository)
- [yay (Yet Another Yaourt) — GitHub](https://github.com/Jguer/yay)
#distribucion #arch #aur
