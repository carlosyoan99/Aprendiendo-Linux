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

## Confinement (aislamiento)

| Nivel | Descripción |
|---|---|
| **strict** | Aislado completamente. Solo accede a recursos mediante interfaces explícitas |
| **classic** | Acceso total al sistema como un paquete tradicional (DEB/RPM). Sin sandbox |
| **devmode** | Strict pero sin bloqueos — solo log. Para desarrollo/pruebas |

```bash
snap install spotify                    # strict (default)
snap install --classic code             # classic (necesario para IDEs)
snap install --devmode mi-app           # devmode (solo log)
```

## Interfaces (plugs y slots)

Las interfaces definen qué recursos puede usar cada snap:

| Interface | Recurso |
|---|---|
| `network` | Acceso a red |
| `network-bind` | Escuchar en puertos |
| `home` | Acceso a /home/$USER |
| `removable-media` | Dispositivos extraíbles |
| `camera` | Cámara web |
| `audio-record` | Grabación de audio |
| `screen-inhibit-control` | Control de suspensión (reproductores) |
| `opengl` | Aceleración gráfica 3D |
| `x11` | Acceso al servidor X |
| `wayland` | Acceso a Wayland |

```bash
# Ver conexiones activas
snap connections spotify

# Conectar manualmente
snap connect spotify:audio-record :audio-record

# Desconectar
snap disconnect spotify:removable-media
```

## Snapshots (copias de seguridad)

Snap guarda automáticamente el estado de los datos al desinstalar y permite restaurarlo.

```bash
snap save spotify                          # crear snapshot manual
snap saved                                 # listar snapshots
snap restore 5                             # restaurar snapshot por ID
snap forget 5                              # eliminar snapshot
# Los snapshots se crean automáticamente al desinstalar un snap
```

## Aliases

Si un comando de snap entra en conflicto con otro, se puede crear un alias:

```bash
snap alias code.visual-studio-code vscode   # crear alias
snap aliases                                # listar aliases
snap unalias vscode                         # eliminar alias
```

## Instancias paralelas

Permite ejecutar múltiples versiones del mismo snap:

```bash
snap install spotify_work                   # instancia paralela
snap run spotify_work                       # ejecutar instancia específica
```

## snap run --shell (debugging)

Ejecuta un shell dentro del entorno exacto del snap para depuración:

```bash
snap run --shell spotify
# Dentro del shell se ven las variables de entorno, rutas, permisos reales
```

## snapctl (configuración interna)

Herramienta usada dentro de los hooks del snap para leer/escribir configuración:

```bash
# Desde un hook del snap
snapctl get config_key                       # leer valor
snapctl set config_key=valor                 # escribir valor
```

## Troubleshooting

| Problema | Solución |
|---|---|
| Snap no arranca | `snap run --shell <snap>` para ver errores |
| Falta permiso | `snap connect <snap>:<interface>` para conectar |
| Quiero classic pero no funciona | Verificar si el snap soporta classic: `snap info <snap>` |
| Operación atascada | `snap changes` → `snap abort <change-id>` |
| Espacio en disco | `snap list` para ver tamaños y `snap remove --revision <rev>` para versiones viejas |
| Revertir actualización rota | `snap revert <snap>` |
| Ver logs de un snap | `snap logs <snap>` |

## Ver también

- [[Flatpak]] — formato portable de freedesktop.org
- [[AppImage]] — formato portable sin instalación
- [[Gestores de Paquetes]] — índice + comparativa

## Enlaces externos

- [Sitio oficial](https://snapcraft.io/)
- [Snap Store](https://snapcraft.io/store)
- [Documentación Snapcraft](https://snapcraft.io/docs)
- [Snap confinement levels](https://snapcraft.io/docs/explanation/snap-development/install-modes/)
- [Snap interfaces](https://snapcraft.io/docs/supported-interfaces)

#instalacion #paquetes
