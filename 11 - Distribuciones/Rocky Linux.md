---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: dnf (rpm)
base: RHEL (Red Hat Enterprise Linux) — binariamente compatible
---

# Rocky Linux

## Filosofía / público objetivo

Clon **1:1 binariamente compatible** de RHEL (Red Hat Enterprise Linux), gratuito y mantenido por la comunidad. Nació tras el cambio de modelo de CentOS (que pasó de ser un clon estable a CentOS Stream, un rolling release upstream de RHEL). Rocky Linux ocupa el nicho que CentOS dejó vacante: un RHEL gratuito y estable.

Orientado a **servidores empresariales** que necesitan estabilidad a largo plazo sin pagar licencia de RHEL. No recomendado como distro de escritorio (paquetes antiguos, enfocado en servidor).

## Gestor de paquetes

```bash
sudo dnf install <paquete>
sudo dnf upgrade
sudo dnf search <paquete>
sudo dnf remove <paquete>
# Rocky usa dnf (como Fedora/RHEL), todo lo que aplica a Fedora aplica aquí
```

## Rocky vs AlmaLinux

Ambos nacieron del mismo vacío (CentOS convertido en Stream). Son casi idénticos técnicamente:

| Característica | Rocky Linux | AlmaLinux |
|---|---|---|
| Detrás de | Comunidad + CIQ (Greg Kurtzer, co-fundador de CentOS) | CloudLinux Inc. |
| Compatibilidad RHEL | 1:1 | 1:1 |
| Ciclo de vida | ~10 años | ~10 años |
| Migración desde CentOS | Script `migrate2rocky` | Script `almalinux-deploy` |
| Soporte ARM/aarch64 | Sí | Sí |

Ambos son intercambiables para la mayoría de casos. Si no sabes cuál elegir, cualquiera de los dos sirve.

## ¿Para qué sirve Rocky Linux?

- **Servidores de producción** (web, bases de datos, correo)
- **Entornos corporativos** que requieren compatibilidad RHEL sin pagar.
- **Aprendizaje de RHEL** sin licencia (útli si te preparas para certificaciones RHCSA/RHCE).
- **No recomendado para escritorio**: los paquetes son viejos (estables pero atrasados).

## Diferencias clave con Fedora

```bash
# Fedora: paquetes recientes, ciclo de 6 meses, no LTS
# Rocky: paquetes congelados por ~3 años entre versiones mayores

# El gestor es el mismo (dnf), los paquetes y versiones son distintos
```

## SELinux

RHEL/Rocky vienen con **SELinux** en modo enforcing por defecto (mientras que la mayoría de distros de escritorio lo traen en permisive o lo omiten). Es común que al instalar un servicio web o base de datos aparezcan errores de `SELinux is preventing...`:

```bash
getenforce                               # muestra Enforcing / Permissive / Disabled
sudo setenforce 0                        # desactivar temporalmente (no recomendado en producción)
# Solución correcta: ajustar contextos SELinux en lugar de desactivarlo
sudo dnf install policycoreutils-python-utils
sudo ausearch -m avc | audit2allow -M mi-politica
sudo semodule -i mi-politica.pp
```

## Cockpit (panel web)

Viene instalado por defecto en Rocky: panel de administración web en el puerto 9090:

```bash
sudo systemctl enable --now cockpit.socket
# Abrir en navegador: https://tu-servidor:9090
# Desde ahí: ver recursos, logs, pods, actualizar sistema, crear VMs
```

## Ciclo de lanzamiento

Releases mayores cada ~3 años, con ~10 años de soporte completo (más 5 adicionales opcionales, ELS). Cada versión es estable durante casi una década. Ideal para sistemas que no se tocan una vez configurados.

## Notas de instalación propias

-

## Ver también

- [[Fedora]] — upstream de RHEL/Rocky
- [[Gestores de Paquetes]]
- [[Redes Basicas]]
- [[SSH]]

#distro
