---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: borrador
categoria: distribucion
prioridad: media
gestor_paquetes: apt (Debian) + capa propia (PET/PL)
base: Debian (con layer propia derivada de Puppy)
modelo_lanzamiento: Rolling (continuo, con packs)
init: s6 (por defecto)
arquitecturas:
  - x86_64
---

# EasyOS

> Distribución **ligera y portable** derivada de **Puppy Linux** (pero con base Debian) que añade una capa de **contenedores tipo Docker** (`Easy Containers`) y características de escritorio cómodas, diseñada para arrancar desde USB, vivir en RAM y mantenerse actualizada con un sistema de capas y rollback.

## Filosofía / público objetivo

EasyOS, del creador de Puppy (Barry Kauler), está pensada para:

- **Usuarios que viven en USB**: arranca y funciona desde un stick, con datos y sistema en capas
- **Rendimiento en RAM** (comprime y carga en memoria)
- **Seguridad/aislamiento**: `Easy Containers` (qubell) para apps
- **Rollback y capas** (modelo de imágenes similar a Docker)
- **Base Debian** (a diferencia de Puppy que usa otros cimientos)

Es una distro exploratoria: combina scripts propios (REMS, ydrv) con lo que haga falta. Va dirigida a aficionados y experimentadores más que al gran público.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Debian (layer propia inspirada en Puppy) |
| **Gestor de paquetes** | `apt` envuelto en capas propias (`pkgs`) |
| **Init** | s6 |
| **Modelo** | Rolling con paquetes/capas y versiones de distribución |
| **Arquitecturas** | `x86_64` |
| **Entorno por defecto** | JWM/Linux con scripts de capas propias (`/" easy` ) |
| **Instalador** | Script propio; boot desde USB/live sin instalación en disco |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 1 núcleo | 2 núcleos |
| **RAM** | 1 GB | 2 GB+ (arranca en RAM) |
| **Disco** | USB 8 GB | 16 GB+ |
| **GPU** | Básica | Compatible |

## Gestor de paquetes

```bash
# Actualizar repos
pkgs update  (//)

# Actualizar sistema
pkgs upgrade

# Instalar paquete (layer)
pkgs install nombre
```

### Repositorios adicionales (AUR, COPR, PPAs...)
- Capas propias (`ydrv`) + repo Debian a bajo nivel
- Sistema de `eas-arch` para paquetes de Arch

## Ciclo de lanzamiento

**Rolling/continuo** con "paquetes" tipo imagen (capas) y actualizaciones frecuentes. El creador publica versiones puntuales, pero el modelo es de actualización incremental.

## Actualización entre versiones mayores

Se hace por cambios de capa/paquetes y de la base. El propio sistema ofrece tooling para actualizar (meejo con `pkgs`, redownload de capas).

```bash
pkgs update-all
```

Ver [[Actualización entre versiones mayores]].

## Instalación (resumen)

1. Descargar la imagen desde easyos.org
2. Grabar a USB con `dd` o herramienta propia
3. Arrancar en modo live; crear capa de usuario
4. Usar sin instalación en disco, o persistir en partición

### Post-instalación recomendada
- [ ] Crear capa de superusuario
- [ ] Configurar red
- [ ] Activ. Easy Containers para apps
- [ ] Configurar actualizaciones

## Comandos asociados

| Comando | Para qué |
|---|---|
| `pkgs` | Gestor de paquetes por capas |
| `easy-version` | Ver versión y capas |
| `landfill` | Limpiar |
| `pkgs update` | Actualizar repos |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| USB lento | Usb 2.0/escritura | Usar USB3; activar capa en RAM |
| Capas corruptas | Apagado durante cambio | Recrear capas desde backup |

## Comparativa con otras distros

| Aspecto | EasyOS | Puppy Linux | Debian |
|---|---|---|---|
| **Facilidad** | Media | Media | Media |
| **Rendimiento** | Muy alto (RAM) | Muy alto | Alto |
| **Paquetes** | pkgs/capas | PET | apt |
| **Comunidad** | Nicho | Grand | Gigante |
| **Estabilidad** | Buena | Buena | Muy buena |

## Notas de instalación propias
- Diseño experimental: contenedores propios y boot en RAM la hacen única.
- Más para curiosos/técnicos que para el escritorio principal.

## Enlaces externos
- [Sitio oficial](https://easyos.org/)
- [Blog de Barry Kauler](https://barryk.org/news/)
- [Wikipedia — EasyOS](https://en.wikipedia.org/wiki/EasyOS)
- [DistroWatch](https://distrowatch.com/table.php?distribution=easy)

## Ver también
- [[Puppy Linux]] — antecesor y familia
- [[Debian]] — base de paquetes
- [[Actualización entre versiones mayores]] — upgrade de versión mayor

#distro