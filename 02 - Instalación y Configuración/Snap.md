---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: instalacion
prioridad: alta
---

# Snap

Formato portable de aplicaciones, creado por Canonical. Repositorio principal: Snap Store. Usa AppArmor para sandboxing y SquashFS para empaquetado. Viene preinstalado en Ubuntu.

## Instalación

```bash
sudo apt install snapd                     # Debian
sudo pacman -S snapd                       # Arch
sudo dnf install snapd                     # Fedora
sudo ln -s /var/lib/snapd/snap /snap       # Fedora (necesario)
sudo systemctl enable --now snapd.socket
```

## Comandos principales

```bash
snap install spotify                       # instalar
snap refresh                               # actualizar todo
snap refresh spotify                       # actualizar app específica
snap list                                  # listar instalados
snap remove spotify                        # eliminar
snap find spotify                          # buscar
snap info spotify                          # información
snap revert spotify                        # revertir a versión anterior
snap connections spotify                   # ver permisos
snap changes                               # historial de cambios
snap saved                                 # ver snapshots
```

## Canales

| Canal | Descripción |
|---|---|
| `stable` | Versión estable (default) |
| `candidate` | Candidato a estable |
| `beta` | Beta |
| `edge` | Desarrollo (diario) |

```bash
snap install spotify --channel=beta        # instalar desde beta
snap switch spotify --channel=stable       # cambiar a estable
```

## Ver también

- [[Flatpak]] — formato portable de freedesktop.org
- [[AppImage]] — formato portable sin instalación
- [[Snap y Flatpak]] — comparativa detallada
- [[Gestores de Paquetes]] — índice + comparativa

## Enlaces externos

- [Sitio oficial](https://snapcraft.io/)
- [Snap Store](https://snapcraft.io/store)

#instalacion #paquetes
