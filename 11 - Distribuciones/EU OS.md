---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: rpm-ostree (inmutable)
base: Fedora
modelo_lanzamiento: Immutable (prueba de concepto)
init: systemd
arquitecturas:
  - x86_64
---

# EU OS

> Prueba de concepto de sistema operativo basado en **Fedora** + **KDE Plasma**, diseñado para instituciones del sector público europeo. Promueve la **soberanía digital europea** y el lema *"dinero público, código público"*.

## Filosofía / público objetivo

EU OS es un proyecto voluntario (no oficial de la UE) que busca crear un sistema operativo de referencia para administraciones públicas europeas. Apuesta por:
- **Independencia tecnológica**: reducir dependencia de proveedores externos
- **Código abierto**: auditorías de seguridad y transparencia
- **Modularidad**: capas personalizables por entidad (nacional/regional)
- **Hardware legacy**: funciona en equipos diseñados para Windows 7+

## Arquitectura por capas

| Capa | Descripción |
|---|---|
| **Base (Kinoite)** | Fedora inmutable con rpm-ostree. Capa compartida por todas las entidades. |
| **Capa nacional** | Personalizaciones legales y lingüísticas de cada país miembro. |
| **Capa regional/sectorial** | Adaptaciones para gobiernos regionales o sectores específicos (sanidad, educación). |
| **Capa de entidad** | Configuración local: políticas de grupo, aplicaciones, impresoras, Active Directory. |

Este diseño por capas permite que un ayuntamiento en España y uno en Polonia compartan la misma base inmutable, pero tengan distintas aplicaciones, idioma y políticas de seguridad.

## Filosofía: dinero público, código público

| Principio | Implicación |
|---|---|
| **Independencia tecnológica** | Reducir dependencia de Microsoft y otros proveedores externos. |
| **Código abierto** | Auditorías de seguridad públicas y transparencia total. |
| **Modularidad** | Capas personalizables por entidad (nacional/regional/local). |
| **Hardware legacy** | Funciona en equipos diseñados para Windows 7+ (renovación más barata). |
| **Soberanía digital** | Los datos de los ciudadanos no pasan por servidores de terceros países. |

> El lema «dinero público, código público» encarna la idea de que la inversión con fondos públicos debe repercutir en beneficios para toda la sociedad.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Fedora (Kinoite/immutable) |
| **Entorno** | KDE Plasma |
| **Modelo** | Inmutable por capas |
| **Estado** | ⚠️ Prueba de concepto (voluntarios) |
| **Objetivo** | Uso en sector público europeo |
| **Hardware** | Optimizado para equipos Windows 7+ |

## Enlaces externos

- [Sitio oficial](https://eu-os.eu/)
- [Repositorio GitLab](https://eu-os.gitlab.io/)
- [Especificaciones técnicas](https://eu-os.gitlab.io/spec)
- [Casos de uso](https://eu-os.gitlab.io/use-cases)
- [Wikipedia — EU OS](https://es.wikipedia.org/wiki/EU_OS)

## Ver también

- [[Fedora]] — distribución base
- [[KDE Plasma]] — escritorio por defecto
- [[Vanilla OS]] — otro sistema inmutable
- [[GNOME]] — DE de Vanilla OS (contraste de entornos)

#distro #europa #inmutable
