---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: programa
prioridad: baja
---

# flatpak-builder

> Herramienta para compilar y empaquetar aplicaciones Flatpak a partir de un manifesto JSON/YAML. Es la forma oficial de crear Flatpaks para Flathub.

## Qué es

**flatpak-builder** compila aplicaciones Flatpak desde un **manifesto** (archivo JSON o YAML) que define las dependencias, el proceso de build y los permisos. Crea un `.flatpak` listo para instalar o subir a Flathub. Es la herramienta estándar para desarrolladores que quieren distribuir su software vía Flatpak.

## Instalación

```bash
sudo apt install flatpak-builder      # Debian / Ubuntu
sudo pacman -S flatpak-builder        # Arch / CachyOS
sudo dnf install flatpak-builder      # Fedora
```

> **Nota:** Requiere `flatpak` instalado y configurado.

## Sintaxis

```bash
flatpak-builder [opciones] directorio-build manifest.json
```

## Ejemplos prácticos

```bash
# Compilar una app desde un manifesto
flatpak-builder build-dir com.example.MyApp.json

# Instalar localmente tras compilar
flatpak-builder --user --install --force-clean build com.example.MyApp.json

# Exportar a un bundle .flatpak
flatpak-builder --repo=repo build com.example.MyApp.json
flatpak build-bundle repo com.example.MyApp.flatpak com.example.MyApp

# Compilar con SDK específico
flatpak-builder --sdk=org.freedesktop.Sdk//23.08 build com.example.MyApp.json

# Limpiar directorio de build
flatpak-builder --clean build com.example.MyApp.json
```

## Estructura de un manifesto

```json
{
  "app-id": "com.example.MyApp",
  "runtime": "org.freedesktop.Platform",
  "runtime-version": "23.08",
  "sdk": "org.freedesktop.Sdk",
  "command": "myapp",
  "modules": [
    {
      "name": "myapp",
      "buildsystem": "meson",
      "sources": [
        {
          "type": "git",
          "url": "https://github.com/example/myapp",
          "tag": "v1.0"
        }
      ]
    }
  ],
  "finish-args": [
    "--share=network",
    "--share=ipc",
    "--socket=x11",
    "--socket=wayland",
    "--device=dri"
  ]
}
```

## Permisos comunes (`finish-args`)

| Permiso | Efecto |
|---|---|
| `--share=network` | Acceso a red |
| `--share=ipc` | Compartir IPC (X11) |
| `--socket=x11` | Acceso a X11 |
| `--socket=wayland` | Acceso a Wayland |
| `--device=dri` | Acceso a GPU |
| `--filesystem=home` | Acceso a ~/ |
| `--talk-name=org.freedesktop.Notifications` | Notificaciones |

## flatpak-builder vs snapcraft

| Aspecto | flatpak-builder | snapcraft |
|---|---| Snap |
| Manifesto | JSON/YAML | snapcraft.yaml |
| Runtime | Shared runtimes | Bundled dependencies |
| Sandboxing | Portals (XDG) | AppArmor |
| Distribución | Flathub | Snap Store |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "Runtime not found" | Runtime no instalado | `flatpak install org.freedesktop.Platform//23.08` |
| Build falla en dependencias | Manifesto incompleto | Revisar sección `modules` del manifesto |
| "Permission denied" en /var | Falta sudo | Ejecutar con `sudo` o `--user` |
| SDK no disponible | Versión no instalada | `flatpak install org.freedesktop.Sdk//23.08` |

## Ver también

- [[Flatpak]] — gestor de paquetes Flatpak
- [[Snap]] — alternativa de empaquetado
- [[AppImage]] — otra alternativa
- [[Formatos de Paquetes en GNU Linux]] — comparativa

## Enlaces externos

- [flatpak-builder — Flatpak docs](https://docs.flatpak.org/en/latest/flatpak-builder.html)
- [Flathub](https://flathub.org/) — repositorio de Flatpaks

#programa #flatpak #desarrollo #empaquetado
