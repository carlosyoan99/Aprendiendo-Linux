---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: concepto
prioridad: media
---

# Windows

> Sistema operativo propietario de Microsoft, dominante en escritorio desde los años 90. Conocerlo es clave para entender por qué la gente migra a Linux y qué diferencias encontrará.

## Definición

Windows es un sistema operativo desarrollado por Microsoft que domina el mercado de escritorio con ~72% de cuota (2026). Existen dos familias arquitectónicas:

| Familia | Versiones | Arquitectura |
|---|---|---|
| **Windows 9x** (legacy) | 95, 98, Me | Híbrida,kernel monolítico inestable |
| **Windows NT** (moderna) | NT 3.1 → 10/11 | Kernel protegido, multiusuario real |

La convergencia ocurrió con **Windows XP (2001)**, que unificó las líneas consumer y business bajo NT.

## Por qué importa para un usuario de Linux

- **Migración**: La mayoría de usuarios vienen de Windows. Conocer sus convenciones ayuda a explicar las diferencias (permisos, ruta de archivos, gestor de paquetes).
- **Dual boot**: Muchos usuarios mantienen Windows junto a Linux. Entender NTFS, BitLocker, Secure Boot y el boot process de Windows es esencial.
- **Compatibilidad**: Herramientas como Wine, Bottles y Proton existen precisamente para ejecutar software Windows en Linux.
- **Comandos**: Windows tiene su propio ecosistema de terminal (CMD, PowerShell, WSL) que es útil conocer por contraste.

## Estructura del sistema vs Linux

| Concepto | Windows | Linux |
|---|---|---|
| **Raíz del filesystem** | `C:\` (unidad por partición) | `/` (único árbol) |
| **Archivos de sistema** | `C:\Windows\System32` | `/usr/bin`, `/lib`, `/etc` |
| **Usuarios** | `C:\Users\` | `/home/` |
| **Configuración** | Registro (regedit) | Archivos de texto (`/etc/`) |
| **Gestor de paquetes** | .exe/.msi, winget, Chocolatey | apt, pacman, dnf, etc. |
| **Permisos** | ACLs (heredados) | POSIX (user/group/other) |
| **Shell por defecto** | PowerShell / CMD | bash, zsh, fish |
| **Init system** | Services (services.msc) | systemd, OpenRC, runit |

## Comandos asociados

| Comando | Para qué |
|---|---|
| `winget` | Gestor de paquetes oficial (Windows 11) |
| `choco install` | Chocolatey — gestor de paquetes community |
| `powershell` | Shell moderno de Windows |
| `wsl` | Windows Subsystem for Linux |
| `diskpart` | Gestión de discos desde terminal |
| `sfc /scannow` | Verificar integridad de archivos del sistema |

## Casos prácticos

### Acceder a Linux desde Windows
```powershell
# WSL2 — ejecutar Linux dentro de Windows
wsl --install -d Ubuntu
wsl --list --verbose          # ver distribuciones instaladas
```

### Compartir archivos entre Windows y Linux (dual boot)
```bash
# En Linux, montar la partición NTFS de Windows
sudo mount -t ntfs3 /dev/sda1 /mnt/windows
# o con ntfs-3g (legacy)
sudo mount -t ntfs-3g /dev/sda1 /mnt/windows
```

Ver [[NTFS-3G]] para el controlador NTFS.

### Recuperar espacio: Limpiar Windows
```powershell
cleanmgr /d C:                # Liberador de espacio en disco
Dism /Online /Cleanup-Image /RestoreHealth  # Reparar imagen
```

## Comparativa con Linux

| Aspecto | Windows | Linux |
|---|---|---|
| **Costo** | Licencia paga (~$139 Home) | Gratuito |
| **Código fuente** | Cerrado (parcialmente abierto) | Abierto (GPL) |
| **Personalización** | Limitada | Ilimitada |
| **Actualizaciones** | Forzadas, reinicios frecuentes | Usuario controla |
| **Seguridad** | Target principal de malware | Menos afectado |
| **Servidores** | ~20% del mercado | ~80% del mercado |
| **Gaming** | Nativo, mejor compatibilidad | Mejorando (Proton, Steam Deck) |

## Notas personales

- Windows 11 exige TPM 2.0 y Secure Boot — esto complica el dual boot con Linux.
- WSL2 es la mejor forma de tener ambos mundos sin reboot.
- PowerShell es sorprendentemente potente; su sintaxis se parece más a Bash que CMD.

## Enlaces externos
- [Wikipedia — Microsoft Windows](https://en.wikipedia.org/wiki/Microsoft_Windows)
- [Microsoft Learn — PowerShell](https://learn.microsoft.com/powershell/)
- [WSL2 Documentation](https://learn.microsoft.com/windows/wsl/)
- [WineHQ — ejecutar software Windows en Linux](https://www.winehq.org/)

## Ver también
- [[De Windows a Linux]] — guía completa de migración
- [[Dual Boot con Windows]] — instalar Linux junto a Windows
- [[NTFS-3G]] — controlador NTFS para Linux
- [[Wine]] — compatibilidad de software Windows
- [[Bottles]] — frontend gráfico para Wine
- [[Que es Linux]] — conceptos fundamentales

#concepto
