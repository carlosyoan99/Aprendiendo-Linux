---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: borrador
categoria: distribucion
prioridad: media
gestor_paquetes: dnf (Fedora) + RPM Fusion + COPR
base: Fedora
modelo_lanzamiento: Semi-rolling (versiones puntuales con actualizaciones continuas)
init: systemd
arquitecturas:
  - x86_64
---

# Nobara Linux

> Distribución gaming basada en **Fedora** creada por **GloriousEggroll** (GE, mantenedor de Proton-GE), que ajusta y parchea paquetes para ofrecer la mejor experiencia de juego fuera de caja sin sacrificar la estabilidad de Fedora.

## Filosofía / público objetivo

Nobara está pensada para **jugadores y usuarios de escritorio** que quieren Fedora con mejor soporte para gaming y multimedia sin tener que configurar manualmente:

- **Drivers propietarios** NVIDIA/AMD preinstalados y configurados
- **Proton-GE** y `lutris` listos para usar
- **Codecs multimedia** (H.264, H.265, AAC) sin pasos extra
- **Alivio de la curva**: corrige puntos débiles de Fedora (codecs, firmware, juegos)

Se diferencia de Fedora en que **patchea** paquetes upstream (kernel, mesa, gnome, etc.) en el repositorio de Nobara en lugar de depender solo de la cadena oficial de Red Hat. Está dirigida a quien quiere todo funcionando sin tocar RPM Fusion a mano.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Fedora (actualmente basada en las versiones más recientes de Fedora Workstation) |
| **Gestor de paquetes** | `dnf` (con repos oficiales Fedora, RPM Fusion y repos propios de Nobara) |
| **Init** | systemd |
| **Modelo** | Semi-rolling: una base por versión puntual de Fedora + actualizaciones continuas |
| **Arquitecturas** | `x86_64` |
| **Entorno por defecto** | KDE Plasma (edición principal), también GNOME |
| **Instalador** | Anaconda (el de Fedora) |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Dual-core x86_64 | Quad-core o superior |
| **RAM** | 4 GB | 8 GB o más |
| **Disco** | 25 GB | 50 GB+ (para juegos) |
| **GPU** | Cualquiera con driver open/Propietario | NVIDIA o AMD reciente |

## Gestor de paquetes

```bash
# Actualizar repos y sistema
sudo dnf upgrade --refresh

# Instalar paquete
sudo dnf install paquete

# Buscar paquete
dnf search termino

# Eliminar paquete
sudo dnf remove paquete
```

### Repositorios adicionales (AUR, COPR, PPAs...)
- RPM Fusion (incluido por defecto en Nobara)
- Repositorios propios de Nobara (`rpmfusion`, `nobara`)
- COPR de Fedora para software de terceros

## Ciclo de lanzamiento

Nobara sigue el calendario de **Fedora** (una versión puntual por año, ~mayo) pero la mantiene con **actualizaciones continuas** entre versiones. Cuando Fedora publica una nueva versión, Nobara adapta su base y lanza una nueva edición. GloriousEggroll publica notas del release cubriendo los cambios (kernel, mesa, drivers, parches).

## Actualización entre versiones mayores

La mayoría de actualizaciones se instalan vía `dnf upgrade` normal. Para saltar a la siguiente versión puntual de Fedora se sigue el proceso de release upgrade de Fedora adaptado al repositorio de Nobara.

```bash
sudo dnf system-upgrade download --refresh --releasever=NN
sudo dnf system-upgrade reboot
```

Ver [[Actualización entre versiones mayores]].

## Instalación (resumen)

1. Descargar el ISO desde nobaraproject.org
2. Grabar la ISO a un USB (por ejemplo con `dd` o Ventoy)
3. Arrancar desde el USB y seguir **Anaconda** (instalador gráfico)
4. Elegir particionado y acceder al sistema; los drivers y codecs ya están preconfigurados

### Post-instalación recomendada
- [ ] Actualizar sistema (**Nobara Update** es una utilidad propia)
- [ ] Verificar drivers NVIDIA/AMD activos
- [ ] Instalar Flatpak desde Flathub si se quiere
- [ ] Configurar Steam y activar Proton

## Comandos asociados

| Comando | Para qué |
|---|---|
| `nobara-sync` | Sincronizar/parchear el sistema a la versión de Nobara |
| `dnf upgrade` | Actualizar paquetes |
| `dnf install` | Instalar paquete |
| `sudo dnf system-upgrade` | Actualización de versión mayor |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Los juegos no usan la NVIDIA | Driver no configurado como PRIME | Usar las herramientas de Nobara o `nvidia-smi`, activar `MODE_PROFILE` |
| Faltan codecs | Repos RPM Fusion ausentes | Instalar `rpmfusion-release` y `dnf install ffmpeg` |
| Sistema se rompe tras upgrade de Fedora | Mezcla de repos externos | Reinstalar Nobara-sync y re-sincronizar |

## Comparativa con otras distros

| Aspecto | Nobara Linux | Fedora | Pop OS |
|---|---|---|---|
| **Facilidad** | Alta (preconfigurada) | Media | Alta |
| **Rendimiento** | Muy alto (parches gaming) | Alto | Alto |
| **Paquetes** | dnf + Ubuntu/APT | dnf | apt + ppa |
| **Comunidad** | Nicho (gaming) | Grande | Media |
| **Estabilidad** | Buena | Muy buena | Buena |

## Notas de instalación propias
- Ideal para usuarios que quieren Fedora con soporte gaming sin configurar RPM Fusion ni Proton a mano.
- No es un fork grande: solo patchea paquetes, por lo que la compatibilidad con la documentación de Fedora es alta.

## Enlaces externos
- [Sitio oficial](https://nobaraproject.org/)
- [Wiki oficial](https://wiki.nobaraproject.org/)
- [Wikipedia — Nobara Linux](https://en.wikipedia.org/wiki/Nobara_Linux)
- [Repositorio GitHub](https://github.com/GloriousEggroll)
- [DistroWatch](https://distrowatch.com/table.php?distribution=nobara)

## Ver también
- [[Fedora]] — distribución base
- [[Proceso de Instalación General]] — instalación desde cero
- [[Actualización entre versiones mayores]] — upgrade de versión mayor
- [[Proton]] — capa de compatibilidad de juegos incluida

#distro