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
```

## Gestión de remotes

```bash
flatpak remote-list                              # listar remotes
flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-delete flathub
flatpak remote-info flathub org.gimp.GIMP         # info del remote
```

## Permisos (sandboxing)

Flatpak aísla aplicaciones con **Bubblewrap**. Por defecto tienen acceso mínimo al sistema.

```bash
# Override de permisos por aplicación
flatpak override --user --filesystem=home org.gimp.GIMP          # acceso a /home
flatpak override --user --filesystem=xdg-music org.spotify.Spotify  # solo música
flatpak override --user --nosocket=wayland org.gimp.GIMP         # deshabilitar Wayland
flatpak override --user --socket=x11 org.gimp.GIMP               # forzar X11
flatpak override --user --device=dri org.gimp.GIMP               # aceleración gráfica

# Ver permisos actuales
flatpak permissions
flatpak permission-show org.gimp.GIMP

# Resetear permisos a valores por defecto
flatpak permission-reset org.gimp.GIMP
```

### Permisos comunes

| Permiso | Descripción | Flag |
|---|---|---|
| Red | Acceso a internet | `--share=network` |
| Wayland | Socket gráfico Wayland | `--socket=wayland` |
| X11 | Socket gráfico X11 | `--socket=x11` |
| DRI | Aceleración gráfica 3D | `--device=dri` |
| Webcam | Cámara | `--device=webcam` |
| Home | Acceso a /home | `--filesystem=home` |
| Host | Acceso a todo el sistema | `--filesystem=host` |

> 🖥️ **Flatseal**: Interfaz gráfica para gestionar permisos: `flatpak install flathub com.github.tchx84.Flatseal`

## Runtimes

Los **runtimes** son colecciones de librerías base compartidas (GNOME Platform, KDE Platform, Freedesktop). Sin ellos, cada app empaquetaría sus propias dependencias.

```bash
flatpak list --runtime                  # ver runtimes instalados
flatpak list --app                      # solo aplicaciones (sin runtimes)
flatpak uninstall --unused              # limpiar runtimes no usados
flatpak info org.gnome.Platform//47     # info de runtime específico
```

## Portales (xdg-desktop-portal)

Los portales permiten a las apps en sandbox acceder a recursos del sistema de forma segura:

| Portal | Función |
|---|---|
| **File Chooser** | Seleccionar archivos mediante diálogo nativo |
| **Print** | Enviar a impresora |
| **Screenshot** | Capturar pantalla |
| **Notifications** | Notificaciones del sistema |
| **Open URI** | Abrir URLs en el navegador por defecto |
| **Camera** | Acceder a la cámara |

En lugar de dar acceso completo a `/home`, la app negocia permisos específicos mediante estos portales.

## flatpak-builder (construir apps)

Para empaquetar una aplicación en Flatpak:

```bash
# Estructura del proyecto
# └── org.ejemplo.App/
#     └── org.ejemplo.App.yml
```

```yaml
# org.ejemplo.App.yml
app-id: org.ejemplo.App
runtime: org.gnome.Platform
runtime-version: '47'
sdk: org.gnome.Sdk
command: mi-app
finish-args:
  - --socket=wayland
  - --share=network
modules:
  - name: mi-app
    sources:
      - type: git
        url: https://example.com/mi-app.git
```

```bash
flatpak-builder --user --install --force-clean build-dir org.ejemplo.App.yml
```

## Troubleshooting

| Problema | Solución |
|---|---|
| App no ve archivos | Verificar permisos: `flatpak override --filesystem=home org.app` |
| App falla al iniciar | Ejecutar con `flatpak run --log-session-bus org.app` para logs D-Bus |
| No abre Wayland | Forzar X11: `flatpak override --socket=x11 --nosocket=wayland org.app` |
| Espacio en disco | `flatpak uninstall --unused` para limpiar runtimes huérfanos |
| Repositorio dañado | `flatpak repair` |
| App home no coincide | Las apps ven `~/.var/app/org.app/` como persistente, no `/home/` directamente |

## Ver también

- [[Snap]] — formato portable de Canonical
- [[AppImage]] — formato portable sin instalación
- [[Gestores de Paquetes]] — índice + comparativa

## Enlaces externos

- [Sitio oficial](https://flatpak.org/)
- [Flathub](https://flathub.org/)
- [Documentación Flatpak](https://docs.flatpak.org/en/latest/)
- [Sandbox Permissions Guide](https://docs.flatpak.org/en/latest/sandbox-permissions.html)
- [Flatseal](https://github.com/tchx84/Flatseal)

#instalacion #paquetes
