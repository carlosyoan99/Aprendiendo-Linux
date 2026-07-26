---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: instalacion
prioridad: alta
---

# Gestores de Paquetes

Cada distro tiene su propio gestor de paquetes. Los formatos portables (Flatpak, Snap, AppImage) funcionan en cualquier distro.

## Gestores nativos por distro

| Distro | Gestor | Bajo nivel | Formato |
|---|---|---|---|
| Debian/Ubuntu | [[apt]] | `dpkg` | .deb |
| Arch | [[pacman]] | — | .pkg.tar.zst |
| Fedora/RHEL | [[dnf]] | `rpm` | .rpm |
| openSUSE | `zypper` | `rpm` | .rpm |
| Alpine | `apk` | — | .apk |

## Formatos portables

- [[Flatpak]] — formato portable de freedesktop.org (sandboxing, Flathub)
- [[Snap]] — formato portable de Canonical (Snap Store)
- [[AppImage]] — formato portable sin instalación (descargar y ejecutar)

## AUR — Arch User Repository

Repositorio comunitario con PKGBUILDs para compilar desde fuente en Arch y derivados.

```bash
# yay — helper popular
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
yay <paquete>     # buscar e instalar desde AUR
```

## Gestores del lenguaje

| Herramienta | Para |
|---|---|
| [[pip]] | Python |
| `npm` | Node.js |
| `cargo` | Rust |
| `gem` | Ruby |
| `go install` | Go |

## Árbol de decisión

¿Es componente del sistema (kernel, driver)? → **Gestor nativo**
¿Es app de escritorio? → **Flatpak** (o Snap en Ubuntu)
¿Es portable, sin instalar? → **AppImage**
¿Es desarrollo? → **Gestor del lenguaje**

## Ver también

- [[Snap y Flatpak]] — historia, comandos avanzados, permisos
- [[Formatos de Paquetes en GNU Linux]] — anatomía de paquetes
- [[AUR]] — repositorio comunitario de Arch

## Enlaces externos

- [Wikipedia — Gestor de paquetes](https://en.wikipedia.org/wiki/Package_manager)

#instalacion #paquetes
