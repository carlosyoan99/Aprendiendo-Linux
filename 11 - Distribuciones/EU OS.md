---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-08-31
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

- **Independencia tecnológica**: reducir dependencia de Microsoft y otros proveedores externos
- **Código abierto**: auditorías de seguridad públicas y transparencia total
- **Modularidad**: capas personalizables por entidad (nacional/regional)
- **Hardware legacy**: funciona en equipos diseñados para Windows 7+ (renovación más barata)
- **Soberanía digital**: los datos de los ciudadanos no pasan por servidores de terceros países

> El lema «dinero público, código público» encarna la idea de que la inversión con fondos públicos debe repercutir en beneficios para toda la sociedad.

## Arquitectura por capas

| Capa | Descripción |
|---|---|
| **Base (Kinoite)** | Fedora inmutable con rpm-ostree. Capa compartida por todas las entidades. |
| **Capa nacional** | Personalizaciones legales y lingüísticas de cada país miembro. |
| **Capa regional/sectorial** | Adaptaciones para gobiernos regionales o sectores específicos (sanidad, educación). |
| **Capa de entidad** | Configuración local: políticas de grupo, aplicaciones, impresoras, Active Directory. |

Este diseño por capas permite que un ayuntamiento en España y uno en Polonia compartan la misma base inmutable, pero tengan distintas aplicaciones, idioma y políticas de seguridad.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Fedora (Kinoite/immutable) |
| **Entorno** | KDE Plasma |
| **Modelo** | Inmutable por capas |
| **Estado** | ⚠️ Prueba de concepto (voluntarios) |
| **Objetivo** | Uso en sector público europeo |
| **Hardware** | Optimizado para equipos Windows 7+ |
| **Gestión** | Fleet management centralizado (opcional) |

### Diferencias con Fedora Silverblue/Kinoite

- **Capas adicionales**: capa nacional, regional y de entidad
- **Fleet management**: gestión centralizada de miles de equipos
- **Hardening específico**: políticas de seguridad para sector público
- **Soporte Active Directory**: integración con dominios existentes
- **Configuración por defecto**: impresoras, VPN, certificados digitales preconfigurados

## Instalación

```bash
# Descargar ISO desde eu-os.eu (fase de prueba)
# El instalador es Anaconda (mismo que Fedora)

# Requisitos:
# - CPU: 64-bit x86_64 (equipos Windows 7+)
# - RAM: 4 GB mínimo
# - Disco: 25 GB mínimo
# - EFI/UEFI (recomendado)

# Tras instalar:
# El sistema se actualiza como Fedora Kinoite:
rpm-ostree upgrade
# Reiniciar tras cada actualización (inmutable)

# Instalar apps adicionales:
rpm-ostree install vim htop git
# O usar Flatpak:
flatpak install flathub org.mozilla.firefox
```

## Comparativa con alternativas

| Aspecto | EU OS | Fedora Kinoite | Windows 10/11 LTSC | Ubuntu LTS |
|---|---|---|---|---|
| **Coste** | Gratis | Gratis | $50-200+/año | Gratis |
| **Modelo** | Inmutable por capas | Inmutable | Tradicional | Tradicional |
| **Compatibilidad AD** | ✅ | Parcial | ✅ (nativo) | ✅ (Samba) |
| **Fleet management** | ✅ (diseñado para ello) | ❌ | ✅ (SCCM/Intune) | ❌ |
| **Soberanía datos** | ✅ (europeo) | ❌ (US) | ❌ (US) | ❌ (UK/US) |
| **Hardware viejo** | ✅ (Windows 7+) | Parcial | ✅ | Parcial |
| **Madurez** | ⭐ (PoC) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

## Estado del proyecto (2026)

EU OS se encuentra en **fase de prueba/prototipo**:
- ✅ Arquitectura definida y documentada
- ✅ Primera ISO de prueba disponible
- ⚠️ Sin despliegues en producción
- ⚠️ Mantenido por voluntarios, no por la UE oficialmente
- ❌ Sin soporte comercial ni SLA

No se recomienda para producción — es un proyecto de referencia y experimentación.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `rpm-ostree upgrade` falla | Conflicto entre capas | Verificar capas instaladas: `rpm-ostree status` |
| No detecta impresora de red | Configuración de entidad no aplicada | Configurar manualmente vía CUPS o fleet management |
| No conecta a dominio AD | Samba/SSSD no configurado | Instalar realmd: `rpm-ostree install realmd sssd` |
| Flatpak apps no abren | Portal debus no configurado | `systemctl --user restart xdg-desktop-portal` |
| Hardware no reconocido (old PC) | Firmware/hardware muy viejo | Probar con kernel más reciente o Euro Linux (otro proyecto europeo) |

## Ver también

- [[Fedora]] — distribución base
- [[KDE Plasma]] — escritorio por defecto
- [[Vanilla OS]] — otro sistema inmutable
- [[NixOS]] — sistema inmutable declarativo
- [[GNOME]] — DE alternativo

## Enlaces externos

- [Sitio oficial](https://eu-os.eu/)
- [Repositorio GitLab](https://eu-os.gitlab.io/)
- [Especificaciones técnicas](https://eu-os.gitlab.io/spec)
- [Casos de uso](https://eu-os.gitlab.io/use-cases)
- [Wikipedia — EU OS](https://es.wikipedia.org/wiki/EU_OS)

#distribucion #europa #inmutable #sector-publico
