---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: PET (gestor propio) + compatibilidad .deb/.rpm
base: Independiente (varias ramas: Ubuntu, Debian, Slackware)
modelo_lanzamiento: Rolling (actualizaciones continuas)
init: BusyBox init
arquitecturas:
  - x86
  - x86_64
---

# Puppy Linux

> Minidistribución Linux portátil y ultraligera diseñada para ejecutarse completamente en RAM desde un LiveCD/USB. Ocupa entre **50 y 300 MB** y funciona en hardware de los años 90.

## Qué es

Puppy Linux es una distribución única que se carga y ejecuta completamente en **memoria RAM**, lo que la hace extremadamente rápida incluso en hardware muy antiguo. Creada por **Barry Kauler** en 2003, está diseñada para ser portátil, fácil de usar y capaz de dar nueva vida a computadoras descatalogadas.

A diferencia de otras distribuciones, **no es una distro basada en otra**. Aunque existen versiones derivadas de Ubuntu/Debian ("Puppy Precise", "BionicPup"), Puppy tiene su propio sistema de paquetes (PET) y su propia infraestructura.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Creador** | Barry Kauler (2003) |
| **Gestor de paquetes** | Puppy Package Manager (PET + .deb/.rpm/.txz) |
| **Init** | BusyBox init (propio) |
| **WM por defecto** | JWM + ROX-Filer (actual), Openbox (versiones antiguas) |
| **RAM mínima** | 256 MB (recomendado 512 MB+) |
| **Tamaño ISO** | 50 - 300 MB según versión |
| **Escritorio** | JWM (Joe's Window Manager) + ROX-Filer |

## Filosofía única

### Ejecución en RAM

Puppy se carga COMPLETO en RAM al arrancar. Esto significa:

- **Velocidad**: todo va a velocidad de RAM, no de disco
- **Portabilidad**: te llevas el sistema en un USB de 256 MB
- **Persistencia**: los cambios se guardan en un archivo `.2fs`, `.3fs` o `.4fs`
- **Sin instalación**: puedes usarlo sin tocar el disco duro

### Modo Frugal vs Full

| Modo | Descripción | Cuándo usarlo |
|---|---|---|
| **Frugal** | Los archivos del sistema permanecen comprimidos en un SFS. Los cambios se guardan en un archivo aparte (2fs/3fs/4fs). Se puede instalar en una partición Windows sin formatear. | Recomendado (típico) |
| **Full** | El sistema se extrae y ocupa toda la partición como un Linux normal. | Hardware muy limitado |

### Usuario root por defecto

Puppy ejecuta todo como **root** por defecto. Aunque criticado por seguridad, Barry Kauler argumenta que en un sistema que vive en RAM y se usa en hardware aislado, es práctico. Versiones recientes ofrecen usuario no-root (`fido`) como opción.

## Gestor de paquetes

```bash
# Puppy Package Manager (PPM) — interfaz gráfica
# Soporta formatos:
# - PET (Puppy Enhanced Tarball) — nativo
# - .deb (Debian/Ubuntu)
# - .rpm (Fedora/RHEL)
# - .txz (Slackware)

# Convertir paquetes
pet2tgz paquete.pet    # convertir a tar.gz
tgz2pet paquete.tar.gz # convertir a PET
```

## Versiones principales

| Versión (Pupplet) | Base | Escritorio | Tamaño |
|---|---|---|---|
| **BionicPup** | Ubuntu 18.04 | JWM | ~300 MB |
| **FossaPup** | Ubuntu 20.04 | JWM | ~300 MB |
| **BionicPup64** | Ubuntu 18.04 (64-bit) | JWM | ~300 MB |
| **Slacko** | Slackware | JWM | ~200 MB |
| **TahrPup** | Ubuntu 14.04 | JWM | ~200 MB |
| **Macpup** | Puppy + Enlightenment | E17/E18 | ~250 MB |
| **Racy** | Para hardware nuevo | JWM | ~150 MB |
| **Wary** | Para hardware viejo (Pentium III) | JWM | ~120 MB |
| **Fat Free** | Mínimo, sin extras | JWM | ~50 MB |

## Cuándo usar Puppy Linux

| Situación | Por qué Puppy |
|---|---|
| **Rescatar datos de un PC roto** | Arranca desde USB en segundos, sin instalar nada |
| **Hardware muy antiguo (Pentium III, 256 MB RAM)** | La única distro moderna que funciona |
| **USB live persistente** | Los cambios se guardan en un archivo en la misma USB |
| **Recuperar archivos de Windows** | Puppy puede montar NTFS y extraer datos |
| **Laboratorio de pruebas** | Sistema limpio cada vez que arrancas |
| **Niños o personas mayores** | Interfaz simple, pocas distracciones |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No guarda cambios al apagar | Archivo 2fs no creado | En el primer apagado, el asistente pregunta el tamaño |
| Pantalla negra al arrancar | Fallo en detección de video | Arrancar con `puppy pfix=nox` y configurar X manualmente |
| No encuentra WiFi | Falta firmware | Usar `frisbee` (gestor de red de Puppy) para detectar |
| Se queda sin espacio en RAM | Poca RAM, archivo 2fs pequeño | Aumentar tamaño o usar más swap |

---

> **Dato curioso**: El creador Barry Kauler se retiró en 2015, pero la comunidad sigue manteniendo Puppy activamente con nuevas versiones (BionicPup, FossaPup). Hay más de 50 "pupplets" (derivados) con diferentes escritorios y propósitos.

## Comparativa con otras distribuciones

| Aspecto | [[Puppy Linux]] | [[Alpine Linux]] | [[Lubuntu]] | [[MX Linux]] |
|---|---|---|---|---|
| **RAM mínima** | ~300 MB (en RAM) | ~200 MB | ~800 MB | ~800 MB |
| **Ejecución en RAM** | ✅ (frugal/full) | Parcial | ✗ | ✗ |
| **Persistencia** | Save-file (personal) | Persistente | Persistente | Persistente |
| **Público** | Ultra-ligera/portable | Contenedores/edge | Linux liviano | Ligereza + herramientas |

**En resumen**: Puppy es singular: corre casi entero desde RAM y guarda cambios en un save-file portable; Alpine es minimalista para contenedores/edge; Lubuntu y MX son ligeras pero persistentes al uso tradicional.

## Ver también

- [[Busybox]] — herramientas base de Puppy
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]] — otras distros ligeras
- Portabilidad de Linux — concepto de live USBs persistentes

## Enlaces externos

- [Puppy Linux (comunidad)](https://puppylinux.com/)
- [Foro internacional](https://forum.puppylinux.com/)
- [Foro en español](https://www.murga-linux.com/puppy/index.php?f=24)
- [DistroWatch — Puppy](https://distrowatch.com/table.php?distribution=puppy)
- [Wikipedia — Puppy Linux](https://en.wikipedia.org/wiki/Puppy_Linux)

#distro
