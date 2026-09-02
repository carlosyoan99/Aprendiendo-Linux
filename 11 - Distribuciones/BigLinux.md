---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: borrador
categoria: distribucion
prioridad: media
gestor_paquetes: pacman (Arch) + AUR
base: Arch Linux (con base KDE Plasma)
modelo_lanzamiento: Rolling
init: systemd
arquitecturas:
  - x86_64
---

# BigLinux

> Distribución brasileña **rolling** basada en **Arch Linux** con escritorio **KDE Plasma** preconfigurado, un tema visual pulido, y soporte para iniciar desde USB/live y persistir, enfocada al usuario de escritorio de habla portuguesa.

## Filosofía / público objetivo

BigLinux está pensada para usuarios que quieren la actualidad de **Arch** con la comodidad de un escritorio **KDE ya configurado**:

- **KDE Plasma** con un tema unificado y estético desde el primer arranque
- **Rolling release** con pacman + AUR, actualizaciones frecuentes
- **Soporte installable y live/USB** (persistencia)
- **Comunidad brasileña/portuguesa** con foro y soporte activos
- **Herramientas propias**: `biglinux` (theming, drivers), utilidades de asistencia

Es una distro para el escritorio común: elegante, al día y con base Arch, sin la frialdad de Arch por defecto.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Arch Linux |
| **Gestor de paquetes** | `pacman` + AUR (yay/paru) |
| **Init** | systemd |
| **Modelo** | Rolling |
| **Arquitecturas** | `x86_64` |
| **Entorno por defecto** | KDE Plasma (theming propio) |
| **Instalador** | Calamares (instalador gráfico) |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 | Quad-core |
| **RAM** | 2 GB | 8 GB |
| **Disco** | 20 GB | 60 GB+ |
| **GPU** | Básica Intel | NVIDIA/AMD con drivers |

## Gestor de paquetes

```bash
# Actualizar repos
sudo pacman -Syy

# Actualizar sistema
sudo pacman -Syu

# Instalar paquete
sudo pacman -S paquete

# Buscar paquete
pacman -Ss termino

# Eliminar paquete
sudo pacman -Rs paquete
```

### Repositorios adicionales (AUR, COPR, PPAs...)
- AUR completo (yay/paru)
- Repos de BigLinux (theming/drivers)

## Ciclo de lanzamiento

**Rolling release** al día con Arch; BigLinux publica versiones de imagen periódicas pero el sistema se actualiza continuamente con pacman.

## Actualización entre versiones mayores

No hay versiones mayores: se actualiza con `pacman -Syu` de manera continua.

```bash
sudo pacman -Syu
```

Ver [[Actualización entre versiones mayores]].

## Instalación (resumen)

1. Descargar ISO de biglinux.com.br
2. Grabar a USB y arrancar (live o instalación)
3. Usar **Calamares** para instalar
4. Al terminar, el KDE ya viene tematizado y configurado

### Post-instalación recomendada
- [ ] Actualizar sistema
- [ ] Confirmar drivers gráficos
- [ ] Configurar firewall
- [ ] Instalar extras de software desde el gestor propio

## Comandos asociados

| Comando | Para qué |
|---|---|
| `sudo pacman -Syu` | Actualizar |
| `biglinux-theme` | Aplicar tema |
| `yay -S` | Instalar AUR |
| `sudo pacman -S` | Instalar |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Tema roto tras actualización | Actualización de Plasma/theme | Reaplicar `biglinux-theme` |
| Sin audio | PipeWire no iniciado | `systemctl --user enable pipewire` |
| AUR falla | Falta base-devel | Instalar `base-devel` |

## Comparativa con otras distros

| Aspecto | BigLinux | Arch Linux | EndeavourOS |
|---|---|---|---|
| **Facilidad** | Alta | Baja | Media |
| **Rendimiento** | Alto | Muy alto | Alto |
| **Paquetes** | pacman/AUR | pacman/AUR | pacman/AUR |
| **Comunidad** | Local (PT-BR) | Global | Global |
| **Estabilidad** | Buena (rolling) | Buena | Buena |

## Notas de instalación propias
- Buena opción para el escritorio diario en portugués sobre base Arch con KDE.
- Menos reconocida fuera de Brasil, pero con soporte activo.

## Enlaces externos
- [Sitio oficial](https://biglinux.com.br/)
- [Wiki oficial](https://biglinux.com.br/blog/)
- [GitHub](https://github.com/BigLinux-Package-Build)
- [DistroWatch](https://distrowatch.com/table.php?distribution=biglinux)

## Ver también
- [[Arch Linux]] — distribución base
- [[KDE Plasma]] — entorno de escritorio principal
- [[AUR]] — repositorio de usuarios
- [[Actualización entre versiones mayores]] — upgrade de versión mayor

#distro