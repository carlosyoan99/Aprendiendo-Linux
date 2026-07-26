---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: instalacion
prioridad: alta
---

# Flatpak

Formato portable de aplicaciones de escritorio. Creado por freedesktop.org (Red Hat). Repositorio principal: Flathub. Usa Bubblewrap para sandboxing y OSTree para gestión de runtimes compartidos.

## Instalación

```bash
sudo apt install flatpak                  # Debian/Ubuntu
sudo pacman -S flatpak                    # Arch
sudo dnf install flatpak                  # Fedora
flatpak remote-add --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo
```

## Comandos principales

```bash
flatpak install flathub org.gimp.GIMP     # instalar
flatpak run org.gimp.GIMP                 # ejecutar
flatpak update                            # actualizar todo
flatpak list                              # listar instalados
flatpak uninstall org.gimp.GIMP           # eliminar
flatpak search gimp                       # buscar
flatpak info org.gimp.GIMP                # información
flatpak uninstall --unused                # limpiar runtimes no usados
flatpak repair                            # reparar instalación
flatpak override --user org.gimp.GIMP --filesystem=home  # permisos
```

## Instalación sin root

```bash
flatpak install --user flathub org.gimp.GIMP   # instalar como usuario
```

## Canales

| Canal | Descripción |
|---|---|
| `stable` | Versión estable (default) |
| `beta` | Versión beta del desarrollador |

```bash
flatpak install flathub org.gimp.GIMP//beta
```

## Ver también

- [[Snap]] — formato portable de Canonical
- [[AppImage]] — formato portable sin instalación
- [[Gestores de Paquetes]] — índice + comparativa

## Enlaces externos

- [Sitio oficial](https://flatpak.org/)
- [Flathub](https://flathub.org/)

#instalacion #paquetes
