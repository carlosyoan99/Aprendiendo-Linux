---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: borrador
categoria: distribucion
prioridad: media
gestor_paquetes: dnf (rpm)
base: Red Hat Enterprise Linux (RHEL) + Oracle Linux Premier/Ksplice
modelo_lanzamiento: Semi-rolling
init: systemd
arquitecturas:
  - x86_64
  - ARM (aarch64)
---
# Oracle Linux

> Distribución empresarial de **Oracle** basada en **RHEL**, 100% binariamente compatible, enfocada a servidores, bases de datos (Oracle DB) y despliegues cloud. Es la "nube de Red Hat" por excelencia en el ecosistema Oracle.

## Qué es

Oracle Linux es un sistema operativo servidor gratuito de código abierto, derivado 1:1 de **Red Hat Enterprise Linux** (RHEL), distribuido por Oracle Corporation. Se presenta como la alternativa más barata y de mayor rendimiento a RHEL dentro del ecosistema empresarial, con herramientas propias de soporte (OpenStack, Oracle Cloud Infrastructure, Ksplice).

Nació en **2006** (versión 4) como respuesta directa a RHEL, para dar a los clientes de Oracle una opción de SO gratuito de nivel corporativo. Es usado extensamente en **Oracle Cloud Infrastructure (OCI)** y por empresas que corren **Oracle Database**.

| Aspecto | Detalle |
|---|---|
| **Creador** | Oracle Corporation, 2006 |
| **Base** | RHEL (Red Hat Enterprise Linux) |
| **Compatibilidad** | Binaria 1:1 con RHEL |
| **Gestor de paquetes** | dnf / rpm (igual que RHEL, con repos propios) |
| **Ciclo** | 10 años por versión mayor + soporte Premier |
| **Diferenciador** | **Ksplice** (reinicio en caliente del kernel) |

## Filosofía / Público objetivo

- **Empresas con Oracle DB**: optimización y certificación para Oracle Database, exadata y stack Oracle.
- **Cloud / OCI**: SO preferido en Oracle Cloud Infrastructure, con imágenes optimizadas.
- **Servidores**: foco total en estabilidad de servidor, virtualización (KVM), contenedores (podman) y rendimiento de base de datos.
- **Compatibilidad RHEL**: ejecuta software certificado para RHEL sin modificaciones.

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Red Hat Enterprise Linux (RHEL) |
| **Gestor de paquetes** | dnf + rpm |
| **Init** | systemd |
| **Modelo** | Semi-rolling (releases mayores fijas, paquetes actualizados) |
| **Arquitecturas** | `x86_64`, `aarch64` (ARM) |
| **Entorno por defecto** | Servidor sin interfaz gráfica (opcional GNOME Server) |
| **Instalador** | Anaconda (el mismo de RHEL/Fedora) |
| **Repos de Oracle** | `ol`, `ol9`, `ol8`, `ol7` según versión |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 o aarch64 de 64 bits | Múltiples núcleos para DB/cloud |
| **RAM** | 1 GB | 4+ GB (más si Oracle DB) |
| **Disco** | 20 GB | 50+ GB con repos de paquetes |
| **GPU** | No requerida (servidor) | VGA básica para instalación |

## Gestor de paquetes

```bash
# Actualizar sistema
sudo dnf update

# Instalar paquete
sudo dnf install httpd

# Buscar paquete
dnf search oraclelinux

# Repositorios de Oracle (instalar repos por defecto)
sudo dnf config-manager --set-enabled ol9_baseos_latest

# Instalar EPEL (extra packages compatible)
sudo dnf install epel-release
```

### Repositorios adicionales (Oracle y RHEL)
- Repos oficiales: `ol9_baseos_latest`, `ol9_appstream`, `ol9_UEKR7`.
- **UEK** (Unbreakable Enterprise Kernel): kernel alternativo de Oracle optimizado para rendimiento.
- **EPEL** disponible para software extra de Red Hat.
- **Oracle Linux Cloud Developer Image** para OCI.

## Ciclo de lanzamiento

- Versiones fijas por cada release mayor de RHEL (Oracle Linux 7, 8, 9, 10).
- **~10 años de soporte** por versión mayor (soporte Premier + Extended).
- Nova mayor = derivada de cada RHEL cuándo Red Hat libera la suya, con retraso de semanas.

## Actualización entre versiones mayores

```bash
# Migrar de Oracle Linux 8 a 9 (herramienta de Oracle)
sudo dnf install oraclelinux-release-el9 -y
sudo dnf install osv-obsolete-cleanup -y
sudo dnf --releasever=9 distro-sync
```

Ver [[Actualización entre versiones mayores]].

> Consejo: Oracle ofrece herramientas de migración (similares a ELevate de AlmaLinux) vía `oraclelinux-e2e`.

## Instalación (resumen)

1. Descargar ISO desde la web de Oracle (o usar scripts de OCI).
2. Arrancar el instalador Anaconda; elegir zona, idioma, disco y paquetes (configuración centralizada).
3. Configurar red y usuario root; seleccionar tipo de instalación (Server, Minimal, Workstation).
4. Reiniciar y aplicar `dnf update` inicial.

### Post-instalación recomendada
- [ ] Actualizar sistema (`dnf update`)
- [ ] Configurar zona horaria y locale
- [ ] Instalar drivers de red/storage
- [ ] Configurar firewall (`firewalld`)
- [ ] Activar servicios (Apache, Oracle DB)
- [ ] Habilitar Ksplice (soporte inicial Oracle)

## Comandos asociados

| Comando | Para qué |
|---|---|
| `sudo dnf update` | Actualizar todo el sistema |
| `sudo dnf install <paquete>` | Instalar paquete |
| `sudo dnf config-manager --set-enabled <repo>` | Habilitar repositorio Oracle |
| `systemctl status firewalld` | Gestionar firewall |
| `sudo dnf groupinstall "Development Tools"` | Grupo de herramientas |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Kernel UEK no arranca en HW nuevo | UEK demasiado reciente | Usar kernel base RHEL (`ol7`), `sudo yum install kernel` |
| Repos sin actualizar | Repo deshabilitado hasta que se habilite | `sudo dnf config-manager --set-enabled ol9_*` |
| Oracle DB no ve recursos | Falta configurar shared memory | Configurar RLIMIT y kernel params oracle |
| Red LAN no resuelve | firewalld por defecto | Abrir puertos con `firewall-cmd --add-service` |

## Comparativa con otras distros

| Aspecto | Oracle Linux | AlmaLinux | Rocky Linux | RHEL (pago) |
|---|---|---|---|---|
| **Compatibilidad** | 1:1 RHEL | 1:1 RHEL | 1:1 RHEL | Oficial |
| **Costo** | Gratis | Gratis | Gratis | Suscripción |
| **Soporte comercial** | Oracle Premier/Premier Pay | CloudLinux | CIQ | Red Hat |
| **Diferenciador** | Ksplice + Oracle DB | ELevate | Community | Certificaciones Red Hat |
| **Gobernanza** | Oracle (corporativo) | Fundación independiente | Fundación independiente | Red Hat |
| **Ciclo** | ~10 años | ~10 años | ~10 años | ~10 años |

## Notas de instalación propias

- Oracle Linux es la opción natural de SO para **bases de datos Oracle** por su certificación y soporte de Ksplice (actualiza el kernel sin reiniciar, ideal en producción).
- Su panel de **Ksplice** es único: permite aplicar parches de seguridad en caliente, algo que no ofrecen gratis Alma/Rocky.
- En OCI (nube de Oracle) siempre se elige Oracle Linux por imágenes optimizadas y coste cero de licencia de SO.

## Enlaces externos

- [Sitio oficial Oracle Linux](https://www.oracle.com/linux/)
- [Wiki/Foros de Oracle Linux](https://docs.oracle.com/en/operating-systems/oracle-linux/)
- [Documentación UEK](https://docs.oracle.com/en/operating-systems/uek/)
- [Repositorio GitHub Oracle Linux](https://github.com/oracle/oraclelinux)
- [DistroWatch — Oracle Linux](https://distrowatch.com/table.php?distribution=oracle)

## Ver también

- [[AlmaLinux]] — alternativa RHEL comunidad, con ELevate
- [[Rocky Linux]] — alternativa RHEL comunidad
- [[CentOS]] — predecesor en el ecosistema RHEL
- [[Fedora]] — base upstream de RHEL
- [[Actualización entre versiones mayores]] — upgrade de versión mayor

#distro
