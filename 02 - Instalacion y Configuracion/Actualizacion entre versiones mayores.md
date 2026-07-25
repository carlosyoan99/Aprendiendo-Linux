---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: instalacion
prioridad: media
---

# Actualización entre versiones mayores (dist-upgrade)

> Actualizar Linux de una versión mayor a otra (ej. Ubuntu 22.04 → 24.04, Debian 11 → 12, Fedora 39 → 40) es diferente a las actualizaciones diarias de seguridad. Implica cambios en bibliotecas del sistema, versiones de kernel y posiblemente migración de configuraciones.

## Concepto: release upgrade vs rolling release

| Modelo | Distros | Filosofía |
|---|---|---|
| **Release (puntual)** | Ubuntu, Debian, Fedora, Linux Mint | Versiones fijas cada 6-24 meses. Actualización mayor = upgrade deliberado |
| **Rolling (continuo)** | Arch, openSUSE Tumbleweed, Void | Un solo `pacman -Syu` te mantiene siempre en la última versión. No hay "upgrade mayor" |
| **Semi-rolling** | Manjaro | Actualizaciones continuas pero con retardo de semanas para estabilidad |

## Por distro

### Debian (punto a punto, ej. 11 → 12)

```bash
# 1. Preparación
sudo apt update && sudo apt upgrade -y           # dejar el sistema al día
sudo apt full-upgrade -y                         # lo mismo con cambios de dependencias
sudo apt autoremove --purge                      # limpiar paquetes huérfanos

# 2. Respaldar configuración crítica
sudo cp -a /etc /etc.bak                         # toda la configuración del sistema
sudo tar -czf ~/dpkg-list-$(date +%F).tar.gz /var/lib/dpkg/  # respaldo de paquetes
dpkg --get-selections > ~/paquetes-instalados.txt

# 3. Cambiar sources.list (Debian 11 → 12)
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list.d/*.list 2>/dev/null

# 4. Actualizar repositorios e iniciar upgrade
sudo apt update
sudo apt upgrade --without-new-pkgs -y           # actualizar paquetes ya instalados
sudo apt full-upgrade -y                         # instalar nuevos paquetes requeridos
sudo apt autoremove --purge                      # limpiar paquetes obsoletos

# 5. Post-upgrade
sudo systemctl reboot
# Verificar: cat /etc/debian_version debe mostrar la nueva versión
```

> **⚠️ Debian**: el upgrade entre versiones mayores es conservador y bien probado. Los releases tienen un "freeze" de meses donde solo entran parches de seguridad. Seguir las [Release Notes](https://www.debian.org/releases/stable/releasenotes) oficiales.

### Ubuntu (LTS → LTS, ej. 22.04 → 24.04)

```bash
# 1. Preparación (como Debian)
sudo apt update && sudo apt upgrade -y
sudo apt autoremove --purge

# 2. Método recomendado: do-release-upgrade (herramienta oficial de Canonical)
sudo apt install update-manager-core

# Verificar que Permitir upgrades a LTS esté activo
sudo nano /etc/update-manager/release-upgrades
# Prompt=lts   (para LTS → LTS)
# Prompt=normal  (para versiones intermedias como 23.10 → 24.04)

# 3. Ejecutar el upgrade
sudo do-release-upgrade
# -d para versiones de desarrollo (no estables)
# Sin flags para LTS → LTS

# Alternativa: actualización manual editando /etc/apt/sources.list
# Cambiar: jammy (22.04) → noble (24.04)
# Luego: sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y
```

> **⚠️ Ubuntu LTS**: esperar al primer point release (24.04.1) antes de actualizar producción. El upgrade de LTS a LTS solo está disponible desde 22.04.1 → 24.04.1, no desde 22.04.0.

### Fedora (punto a punto, ej. 39 → 40)

```bash
# Fedora tiene su propia herramienta: dnf system-upgrade

# 1. Preparación
sudo dnf upgrade --refresh
sudo dnf autoremove

# 2. Instalar plugin de upgrade
sudo dnf install dnf-plugin-system-upgrade

# 3. Descargar paquetes de la nueva versión (sin aplicar)
sudo dnf system-upgrade download --releasever=40

# Verificar que no hay problemas
sudo dnf system-upgrade download --releasever=40 --allowerasing

# 4. Aplicar el upgrade (reinicie automáticamente)
sudo dnf system-upgrade reboot
```

> **⚠️ Fedora**: solo soporta upgrade de N → N+1 (no saltar versiones). Si usas Fedora 39, actualiza a 40, luego a 41.

### Arch Linux (rolling — no aplica)

```bash
# Arch no tiene "dist-upgrade" porque es rolling:
sudo pacman -Syu  # Esto es la actualización completa del sistema, siempre
```

**Excepción**: si tienel el sistema muy desactualizado (>6 meses), puede necesitar pasos extra según [pacman -Syu troubleshooting](https://wiki.archlinux.org/title/Pacman/Troubleshooting).

### Linux Mint (Ubuntu LTS base)

```bash
# Mint tiene su propia herramienta: mintupgrade (desde Mint 21+)
mintupgrade                                     # asistente gráfico
# O la interfaz: Menu → Administración → Actualización del sistema → Editar → Actualizar a...

# Nota: Mint sigue los releases LTS de Ubuntu, añadiendo sus propias capas (Cinnamon, XApps)
# Ver: https://linuxmint-user-guide.readthedocs.io/en/latest/upgrade-to-latest.html
```

## Pre-upgrade checklist

- [ ] Hacer **backup completo** de datos y configuración (`/etc`, `/home`, bases de datos)
- [ ] Revisar **Release Notes** de la nueva versión (cambios importantes, paquetes eliminados)
- [ ] Listar paquetes manuales/externos (PPA, AUR, COPR) que podrían no ser compatibles
- [ ] Verificar requisitos de hardware (ej. Ubuntu 24.04 requiere al menos 4GB RAM)
- [ ] Asegurar espacio en disco suficiente (>5GB libres en `/` y `/var`)
- [ ] Desactivar PPAs/COPRs de terceros temporalmente
- [ ] Conexión a internet estable (preferiblemente por cable, no WiFi)
- [ ] Tener un Live USB de la versión actual por si algo falla

## Post-upgrade checklist

- [ ] Verificar versión: `cat /etc/os-release`
- [ ] Revisar logs: `journalctl -p err -b` (errores del nuevo arranque)
- [ ] Comprobar que los servicios críticos arrancan (SSH, Docker, nginx, etc.)
- [ ] Probar que la red funciona (WiFi, Ethernet, DNS)
- [ ] Verificar drivers gráficos (especialmente NVIDIA — puede necesitar reinstalar)
- [ ] Limpiar paquetes obsoletos: `sudo apt autoremove --purge`
- [ ] Eliminar respaldo temporal: `sudo rm -rf /etc.bak` (solo tras confirmar que todo funciona)

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `do-release-upgrade` dice "No new release found" | No ha pasado suficiente tiempo desde el release | Esperar al primer point release, usar `-d` para desarrollo |
| Paquete incompatible bloquea el upgrade | Dependencias no satisfechas en la nueva versión | `sudo apt list --upgradable` para identificar, luego `apt remove` el paquete conflictivo |
| Sistema no arranca tras upgrade | Kernel nuevo incompatible con hardware | Arrancar con kernel anterior desde GRUB (Advanced options) |
| `Failed to connect to bus` | systemd no se actualizó correctamente | `sudo apt install --reinstall systemd` |
| Pantalla negra tras upgrade | Driver NVIDIA no se recompiló para nuevo kernel | Arrancar con `nomodeset`, reinstalar driver (ver [[Pantalla en negro tras actualizar drivers]]) |
| Aplicaciones Flatpak/Snap no abren | Entorno de ejecución desactualizado | `flatpak update` / `sudo snap refresh` |
| PPA desactivados tras el upgrade | No son compatibles con la nueva versión | Revisar y añadir PPA para la nueva versión o migrar a alternativas |

## Recomendaciones generales

- **No actualices el primer día** — espera al menos 2-4 semanas a que se reporten bugs (a menos que necesites una funcionalidad concreta)
- **En producción**: esperar al primer punto de actualización (Ubuntu 24.04.1, Debian 12.1)
- **Haz backup ANTES**, no durante — si algo falla, necesitas poder volver atrás
- **Ten un Live USB** por si el sistema no arranca
- **Lee las Release Notes** — a veces hay cambios importantes (ej. Debian 10→11 eliminó Python 2, Fedora 38 eliminó perfiles de Xfce)
- **Anota configuraciones personalizadas** — algunos archivos en `/etc` pueden sobrescribirse durante el upgrade

## Enlaces externos

- [Debian Release Notes](https://www.debian.org/releases/stable/releasenotes)
- [Ubuntu Upgrade Guide](https://ubuntu.com/server/docs/upgrade-introduction)
- [Fedora System Upgrade](https://docs.fedoraproject.org/en-US/quick-docs/dnf-system-upgrade/)
- [Arch Wiki — System Maintenance](https://wiki.archlinux.org/title/System_maintenance)
- [Linux Mint Upgrade](https://linuxmint-user-guide.readthedocs.io/en/latest/upgrade-to-latest.html)

## Ver también

- [[Gestores de Paquetes]] — apt, pacman, dnf en detalle
- [[Pantalla en negro tras actualizar drivers]] — troubleshooting post-upgrade gráfico
- [[Proceso de Instalacion General]] — instalación desde cero vs actualización
- [[Backups (borg restic duplicity rsync)]] — hacer backup antes del upgrade
- [[Dual Boot con Windows]] — cuidado con GRUB tras actualizar Ubuntu

#instalacion #actualizacion
