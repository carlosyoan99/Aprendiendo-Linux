---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: concepto
prioridad: media
---

# macOS

> Sistema operativo de Apple basado en UNIX. Su núcleo Darwin (Mach + BSD) lo convierte en un sistema certificado POSIX, más cercano a Linux de lo que la mayoría cree.

## Definición

macOS es el sistema operativo de Apple para Macintosh. Su arquitectura se apoya en:

| Componente | Qué es |
|---|---|
| **Darwin** | Núcleo open-source: microkernel Mach + userland BSD |
| **Cocoa** | Framework de interfaces gráficas (Objective-C / Swift) |
| **Metal** | API de gráficos (reemplazó OpenGL) |
| **APFS** | Sistema de archivos propio (copy-on-write, snapshots) |

**Evolución clave:**
- **Mac OS clásico** (1984–2001): monousuario, sin protección de memoria
- **Mac OS X** (2001): renacimiento sobre NeXTSTEP (UNIX certificado)
- **macOS 11+** (2020+): Big Sur abandona la numeración 10.x; Apple Silicon (ARM)

## Por qué importa para un usuario de Linux

- **UNIX certificado**: macOS cumple POSIX y Single UNIX Specification. Muchas herramientas de terminal funcionan igual que en Linux (pero con BSD, no GNU).
- **Diferencias clave con Linux**: Homebrew en vez de apt, LaunchAgents en vez de systemd, `/Applications` en vez de `/usr/bin`, `open` en vez de `xdg-open`.
- **Herramientas de desarrollo**: Muchos desarrolladores usan macOS. Conocer las diferencias evita frustraciones en scripts y entornos compartidos.
- **Apple Silicon**: Los Mac M1-M4 usan ARM64 — mismo架构 que Raspberry Pi y servidores ARM.

## Estructura del sistema vs Linux

| Concepto | macOS | Linux |
|---|---|---|
| **Kernel** | XNU (Mach + BSD) | Linux (monolítico) |
| **Shell por defecto** | zsh (desde Catalina) | bash |
| **Gestor de paquetes** | Homebrew (`brew install`) | apt, pacman, dnf |
| **Init system** | launchd | systemd, OpenRC |
| **Servicios** | LaunchAgents / LaunchDaemons | systemd units |
| **Firewall** | Application Firewall + pf | nftables, ufw, firewalld |
| **Filesystem** | APFS | ext4, Btrfs, XFS |
| **Configuración** | .plist (XML/binario) | Archivos de texto en /etc |

## Comandos asociados

| Comando | Para qué |
|---|---|
| `brew install` | Instalar paquetes con Homebrew |
| `brew update && brew upgrade` | Actualizar paquetes |
| `open .` | Abrir Finder en directorio actual |
| `say` | Sintetizar voz (diversión + accesibilidad) |
| `sw_vers` | Versión de macOS |
| `system_profiler` | Información del hardware |
| `diskutil` | Gestión de discos |
| `launchctl` | Gestionar LaunchAgents/Daemons |
| `defaults write` | Modificar preferencias del sistema |

## Casos prácticos

### Instalar herramientas de Linux en macOS
```bash
# Homebrew — el "apt" de macOS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git wget htop neovim ripgrep fd fzf
```

### Configurar SSH en macOS
```bash
# macOS ya viene con sshd, pero hay que activarlo
sudo systemsetup -setremotelogin on
# O desde Preferencias del Sistema → Compartir → Acceso remoto
```

### Comparación de shells
```bash
# macOS usa zsh por defecto desde 2019
echo $SHELL                       # /bin/zsh
cat ~/.zshrc                      # configuración de zsh
# Linux típicamente usa bash
echo $SHELL                       # /bin/bash
```

## Comparativa con Linux

| Aspecto | macOS | Linux |
|---|---|---|
| **Hardware** | Solo Apple (Macs) | Cualquier PC |
| **Costo** | Hardware premium ($999+) | Gratuito en cualquier hardware |
| **Código fuente** | Darwin abierto, SO cerrado | Totalmente abierto |
| **Terminal** | Terminal.app / iTerm2 | Muchas opciones |
| **Software** | App Store + Homebrew | Repos + Flatpak/Snap |
| **Gaming** | Limitado (sin Proton nativo) | Mejorando rápido |
| **Servidores** | Raro en producción | Dominante |

## Notas personales

- macOS es más parecido a Linux de lo que parece: `brew` es como `apt`, `launchd` es como systemd, y `/usr/local` funciona igual.
- Las diferencias reales están en el desktop ( Aqua vs Wayland/X11) y en la gestión de hardware (solo Apple).
- Homebrew en macOS es casi indispensable para desarrollo.

## Enlaces externos
- [Wikipedia — macOS](https://en.wikipedia.org/wiki/MacOS)
- [Apple Developer — macOS](https://developer.apple.com/macos/)
- [Homebrew](https://brew.sh/)
- [Darwin Kernel (open-source)](https://opensource.apple.com/)
- [Arch Wiki — Mac](https://wiki.archlinux.org/title/Mac)

## Ver también
- [[UNIX]] — ancestro común de macOS y Linux
- [[Que es Linux]] — fundamentos
- [[SSH]] — funciona igual en macOS y Linux
- [[Shells (bash zsh fish)]] — zsh es la shell por defecto de macOS

#concepto
