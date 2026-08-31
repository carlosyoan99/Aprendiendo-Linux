---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-30
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

## Capa de alto y bajo nivel

Muchos gestores son una interfaz sobre un gestor de **bajo nivel** que hace el trabajo real (resolver, instalar, desempaquetar). El bajo nivel permite operar sin resolución de dependencias.

| Distro | Alto nivel | Bajo nivel | Formato |
|---|---|---|---|
| Debian/Ubuntu | `apt` | `dpkg` | .deb |
| Fedora/RHEL | `dnf` | `rpm` | .rpm |
| Arch | `pacman` | — | .pkg.tar.zst |

```bash
# Bajo nivel: no resuelve dependencias, solo manipula el paquete
dpkg -i paquete.deb          # instalar (sin dependencias)
rpm -ivh paquete.rpm         # instalar (sin dependencias)
dpkg -l | grep firefox       # consultar si está instalado
rpm -qa | grep firefox
```

## Comandos equivalentes entre gestores

Misma acción, distinto comando. Tabla de referencia rápida día a día:

| Acción | apt (Debian) | dnf (Fedora) | pacman (Arch) |
|---|---|---|---|
| **Buscar** | `apt search X` | `dnf search X` | `pacman -Ss X` |
| **Instalar** | `apt install X` | `dnf install X` | `pacman -S X` |
| **Información** | `apt show X` | `dnf info X` | `pacman -Si X` |
| **Actualizar índice** | `apt update` | `dnf check-update` | `pacman -Sy` |
| **Actualizar sistema** | `apt upgrade` | `dnf upgrade` | `pacman -Syu` |
| **Eliminar** | `apt remove X` | `dnf remove X` | `pacman -R X` |
| **Eliminar + dep.** | `apt autoremove` | `dnf autoremove` | `pacman -Rs X` |
| **Listar instalados** | `apt list --installed` | `dnf list installed` | `pacman -Q` |
| **Qué paquete dio un archivo** | `dpkg -S /ruta` | `dnf provides /ruta` | `pacman -Qo /ruta` |
| **Limpiar caché** | `apt clean` | `dnf clean all` | `pacman -Sc` |

> Regla mental: **apt** usa subcomandos verbales (`search/install/remove`), **pacman** usa flags cortos (`-S/-R/-Q`), **dnf** mezcla subcomandos (`search/install`) + `upgrade` (nunca `update` para describir cambios del sistema).

## Gestión de repositorios

Los repositorios definen de dónde se descargan los paquetes. Su configuración vive en archivos de texto:

| Distro | Ubicación |
|---|---|
| Debian/Ubuntu | `/etc/apt/sources.list` + `/etc/apt/sources.list.d/` |
| Fedora/RHEL | `/etc/yum.repos.d/*.repo` |
| Arch | `/etc/pacman.conf` + `/etc/pacman.d/mirrorlist` |

```bash
# Añadir un repositorio (Debian/Ubuntu, formato "deb")
echo "deb [signed-by=/usr/share/keyrings/foo.gpg] https://repo.example.com/stable ./" \
  | sudo tee /etc/apt/sources.list.d/foo.list
sudo apt update
```

Antes de agregar repositorios externos: verifica que sea la fuente oficial del proyecto y firma con la clave correcta. Repos de terceros sin firma son una vía habitual de malware (`apt`/`pacman` avalan los paquetes con las claves de los repos configurados).

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

## Troubleshooting rápido

| Síntoma | Causa posible | Solución |
|---|---|---|
| `E: Unable to locate package` | Índice desactualizado | `sudo apt update` primero |
| Paquete a medias / dependencias rotas | Transacción interrumpida | `sudo apt --fix-broken install` / `dnf check` |
| `pacman: error: could not lock database` | Otro proceso usando pacman | Esperar o `rm /var/lib/pacman/db.lck` |
| Falta espacio al actualizar | Caché llena | `apt clean` / `dnf clean all` / `pacman -Sc` |
| Paquete no disponible en el repo | No existe o repos no activos | Revisar qué repos ofrecen el paquete |

Ver [[Paquete roto]] para diagnóstico en profundidad.

## Ver también

- [[Snap y Flatpak]] — historia, comandos avanzados, permisos
- [[Formatos de Paquetes en GNU Linux]] — anatomía de paquetes
- AUR — repositorio comunitario de Arch

## Enlaces externos

- [Wikipedia — Gestor de paquetes](https://en.wikipedia.org/wiki/Package_manager)

#instalacion #paquetes
