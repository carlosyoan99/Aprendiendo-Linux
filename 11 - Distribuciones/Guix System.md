---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: borrador
categoria: distribucion
prioridad: media
gestor_paquetes: guix (propio, declarativo)
base: independiente (packaging libre, kernel Linux o GNU Hurd)
modelo_lanzamiento: Rolling
init: shepherd (GNU)
arquitecturas:
  - x86_64
  - ARM
---

# Guix System

> Distribución **transaccional y declarativa** de **GNU**, donde todo el sistema — paquetes, servicios, configuraciones — se describe en una única especificación **GNU Guile (Scheme)** y se despliega de forma reproducible y atómica, permitiendo **rollback** de cualquier cambio.

## Filosofía / público objetivo

Guix System (GNU Guix System Distribution) va mucho más allá de un gestor de paquetes: es un **sistema declarativo** al estilo de **NixOS**, pero con una diferencia clave: está **100% libre** (solo software libre) y escrito en **Scheme (Guile)**.

- **Declarativo**: el sistema se define en `/etc/config.scm` y se genera con `guix system reconfigure`
- **Reproducible**: builds deterministas e idempotentes con **hash de cierre** (store `/gnu/store`)
- **Transaccional**: cada generación es atómica y reversible con rollback
- **Funcional**: paquetes definidos como funciones puras en Scheme
- **Libre de defensa**: solo software libre por defecto (de GNU, con repos `nonguix` para drivers y firmware)

Va dirigida a hackers, estudiantes y quienes buscan control total y reproducibilidad sobre su escritorio o servidor, sacrificando compatibilidad de binarios con el resto del ecosistema.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Independiente (GNU; maneja su propio store/empaquetado) |
| **Gestor de paquetes** | `guix` (declarativo, funcional, transaccional) |
| **Init** | **Shepherd** (GNU), gestor de servicios en Scheme |
| **Modelo** | Rolling release |
| **Arquitecturas** | `x86_64`, `ARM` (también soporta GNU Hurd como kernel alternativo) |
| **Entorno por defecto** | Ninguno (se declara en `config.scm`; GNOME, XFCE, etc. opcionales) |
| **Instalador** | Instalador gráfico (Calamares-style) y manual con `guix` |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | Cualquier x86_64 | Dual-core |
| **RAM** | 2 GB | 4 GB+ |
| **Disco** | 10 GB | 30 GB+ (store crece) |
| **GPU** | Básica | Con repos `nonguix` si se quiere firmware |

## Gestor de paquetes

```bash
# Actualizar repos (pull de la rama de paquetes)
guix pull

# Instalar paquete a nivel de usuario
guix install paquete

# Buscar paquete
guix search termino

# Eliminar paquete
guix remove paquete

# Conocer generaciones y rollback
guix package --list-generations
```

### Repositorios adicionales (AUR, COPR, PPAs...)
- `nonguix` (channel comunitario): drivers, firmware y software no libre
- Channels/canales personalizados definidos en Scheme

## Ciclo de lanzamiento

**Rolling release** con canal `master`/`cuirass` como fuente de paquetes. No hay versiones puntuales; se actualiza con `guix pull` (actualiza el software de Guix) y `guix system reconfigure`.

## Actualización entre versiones mayores

No hay versiones mayores — se actualiza continuamente. El cambio de base se hace regenerando el sistema:

```bash
guix pull
guix system reconfigure /etc/config.scm
```

Ver [[Actualización entre versiones mayores]].

## Instalación (resumen)

1. Descargar la ISO desde guix.gnu.org
2. Arrancar el instalador gráfico (o el manual)
3. Elegir idioma, particionado, kernel y entorno de escritorio
4. Al terminar se genera `config.scm`; reconfigurar y arrancar

### Post-instalación recomendada
- [ ] Crear user y habilitar el servicio gráfico en `config.scm`
- [ ] Configurar locale y teclado
- [ ] Añadir channel `nonguix` si se necesitan drivers/firmware
- [ ] Configurar red (NetworkManager o dnsmasq)
- [ ] Reiniciar tras `guix system reconfigure`

## Comandos asociados

| Comando | Para qué |
|---|---|
| `guix system reconfigure /etc/config.scm` | Aplicar la configuración declarada |
| `guix system roll-back` | Volver a la generación anterior |
| `guix package -i` | Instalar usuario |
| `guix shell` | Entorno de desarrollo sin instalar nada |
| `guix home` | Configurar ~ totalmente declarativa |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Sistema no arranca tras reconfigure | Falta servicio crítico en `config.scm` | Entrar en generación anterior desde GRUB y corregir módulos |
| Sin aceleración gráfica | Firmware no libre ausente | Usar channel `nonguix` |
| Store llena | Demasiadas generaciones | `guix gc --delete-generations=NN` para recoger basura |

## Comparativa con otras distros

| Aspecto | Guix System | NixOS | Arch Linux |
|---|---|---|---|
| **Facilidad** | Baja (Scheme) | Baja (Nix) | Baja |
| **Rendimiento** | Alto | Alto | Alto |
| **Paquetes** | guix (channel) | nixpkgs | pacman/AUR |
| **Comunidad** | Nicho técnico | Grande | Grande |
| **Estabilidad** | Muy buena (transaccional) | Muy buena | Buena |
| **Licencia** | 100% libre | Otras | Otras |

## Notas de instalación propias
- La más potente para reproducibilidad y rollback, pero la curva de aprendizaje (Scheme) es alta.
- GNU Hurd es experimental; el Linux kernel es la opción práctica.

## Enlaces externos
- [Sitio oficial](https://guix.gnu.org/)
- [Wiki oficial (manual)](https://guix.gnu.org/manual/)
- [Wikipedia — GNU Guix System](https://en.wikipedia.org/wiki/GNU_Guix_System)
- [Repositorio GitHub](https://github.com/SystemCrafters) / [Savannah](https://savannah.gnu.org/projects/guix/)
- [DistroWatch](https://distrowatch.com/table.php?distribution=guix%20system)

## Ver también
- [[NixOS]] — sistema declarativo similar (Nix)
- [[Proceso de Instalación General]] — instalación desde cero
- [[Actualización entre versiones mayores]] — upgrade de versión mayor

#distro