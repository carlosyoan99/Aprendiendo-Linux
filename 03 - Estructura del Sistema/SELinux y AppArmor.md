---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: sistema
prioridad: alta
---

# SELinux y AppArmor — Control de Acceso Obligatorio (MAC)

Los sistemas MAC (Mandatory Access Control) restringen qué puede hacer cada programa, incluso cuando el usuario que lo ejecuta tiene permisos. Complementan el modelo DAC (permisos tradicionales) añadiendo una capa de seguridad adicional.

```
DAC (Permisos): usuario → archivo (rwx)
DAC + MAC:      usuario → archivo → ¿Política MAC lo permite?
```

## Componentes

- [[SELinux]] — MAC basado en etiquetas (contextos). Default en Fedora/RHEL
- [[AppArmor]] — MAC basado en perfiles por programa. Default en Ubuntu/Debian

## Comparativa rápida

| Característica | SELinux | AppArmor |
|---|---|---|
| **Modelo** | Etiquetas (label-based) | Perfiles por ruta (path-based) |
| **Facilidad** | ⭐ | ⭐⭐⭐⭐ |
| **Control fino** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Default en** | Fedora, RHEL, Rocky | openSUSE, Debian, Ubuntu |
| **Desactivar** | Requiere reinicio | `aa-disable` inmediato |

## ¿Cuál usa tu distro?

```bash
if command -v getenforce &>/dev/null; then
    echo "SELinux: $(getenforce)"
elif command -v aa-status &>/dev/null; then
    echo "AppArmor: perfiles cargados"
    sudo aa-status --brief
else
    echo "No se detecta SELinux ni AppArmor activo"
fi
```

## Ver también

- [[Permisos y Propietarios]] — DAC, la capa base de permisos
- [[ACLs]] — extensión de permisos tradicionales
- [[Firewall]] — control de acceso a nivel de red

## Enlaces externos

- [Wikipedia — SELinux](https://en.wikipedia.org/wiki/SELinux)
- [Wikipedia — AppArmor](https://en.wikipedia.org/wiki/AppArmor)

#sistema #seguridad
