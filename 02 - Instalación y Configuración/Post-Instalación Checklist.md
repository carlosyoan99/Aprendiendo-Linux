---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: instalacion
prioridad: media
---

# Checklist Post-Instalación

> Lista de verificación para dejar el sistema listo tras instalar una distro Linux. Marca lo que aplica según tu caso.

## 1. 🔄 Actualizar el sistema

Siempre empezar con una actualización completa, ya que la ISO puede estar desactualizada:

```bash
# Debian / Ubuntu / Mint
sudo apt update && sudo apt upgrade -y

# Arch / derivados
sudo pacman -Syu

# Fedora
sudo dnf upgrade --refresh

# openSUSE
sudo zypper update
```

- [ ] Sistema actualizado a la última versión de paquetes

## 2. 👤 Configurar usuario y privilegios

- [ ] Agregar usuario al grupo `sudo` (o `wheel` en Arch/Fedora):
  ```bash
  sudo usermod -aG sudo $USER    # Debian/Ubuntu
  sudo usermod -aG wheel $USER   # Arch/Fedora
  ```
- [ ] Verificar que sudo funciona: `sudo -v`
- [ ] Configurar contraseña de root si aplica: `sudo passwd root`

## 3. 🌐 Conectividad y red

- [ ] Verificar conexión: `ping -c 3 google.com`
- [ ] Configurar NetworkManager si no viene por defecto:
  ```bash
  sudo systemctl enable --now NetworkManager
  ```
- [ ] Conectar WiFi si aplica: `nmtui` (interfaz TUI de NetworkManager)
- [ ] Configurar hostname: `sudo hostnamectl set-hostname mi-equipo`
- [ ] Probar navegador web instalado por defecto

## 4. 🎮 Drivers gráficos

- [ ] Identificar GPU: `lspci -k | grep -A 3 -E "VGA|3D"`
- [ ] **NVIDIA** (si aplica):
  ```bash
  # Ubuntu/Debian
  sudo ubuntu-drivers autoinstall
  # Arch
  sudo pacman -S nvidia nvidia-utils
  # Fedora
  sudo dnf install akmod-nvidia
  ```
- [ ] **AMD** (normalmente viene en el kernel, verificar):
  ```bash
  sudo apt install mesa mesa-utils   # Debian/Ubuntu
  ```
- [ ] **Intel** (driver integrado en kernel):
  ```bash
  sudo apt install intel-media-utils # solo para debugging
  ```
- [ ] Verificar aceleración 3D: `glxinfo | grep "OpenGL renderer"`
- [ ] Verificar decode de video: `vainfo` (VA-API) / `vdpauinfo`

## 5. 🖥️ Entorno gráfico

Si la distro no incluye DE/WM o quieres cambiarlo:

- [ ] Instalar DE/WM elegido (ver [[GNOME]], [[KDE Plasma]], [[XFCE]], [[Cinnamon]], [[Hyprland]], [[i3]] y otras en el MoC)
- [ ] Configurar Display Manager (GDM, SDDM, LightDM):
  ```bash
  sudo systemctl enable --now gdm
  ```
- [ ] Instalar gestor de paquetes portable: Flatpak + Flathub:
  ```bash
  sudo apt install flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  ```
- [ ] Instalar temas y fuentes básicas si aplica
- [ ] Configurar fondo de pantalla y panel

## 6. 🖥️ Shell y dotfiles

- [ ] Configurar shell preferida: [[Shells (bash zsh fish)]]
  ```bash
  chsh -s /usr/bin/zsh   # cambiar a zsh
  ```
- [ ] Copiar/restaurar dotfiles (bashrc, zshrc, configs):
  ```bash
  # Si usas chezmoi
  chezmoi init --apply https://github.com/tu-usuario/dotfiles.git
  ```
- [ ] Instalar fuente Nerd Font para la terminal:
  ```bash
  # Ej: FiraCode Nerd Font
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
  ```
- [ ] Ver [[XDG Base Directory y dotfiles modernos]] y [[Symlinks y Dotfiles]]

## 7. 📦 Software esencial

- [ ] Navegador web: Firefox, Chromium, Brave
- [ ] Terminal alternativa: Alacritty, Kitty, WezTerm
- [ ] Editor de texto: VS Code, Micro, Neovim
- [ ] Gestor de archivos: Thunar, Nautilus, Dolphin
- [ ] Multimedia: VLC, MPV, GIMP
- [ ] Compresión: `sudo apt install unrar p7zip`
- [ ] Codecs multimedia:
  ```bash
  sudo apt install ubuntu-restricted-extras   # Ubuntu/Mint
  sudo dnf groupinstall multimedia            # Fedora
  ```

## 8. 💾 Backups y snapshots

- [ ] Configurar snapshots del sistema (si usas Btrfs + Snapper/Timeshift):
  ```bash
  sudo timeshift --create --comments "Post-instalacion"
  ```
- [ ] Configurar backup periódico (borg, restic, rsync)
- [ ] Verificar que `/home` tiene backup externo si es crítico

## 9. ⚙️ Ajustes del sistema

- [ ] Configurar zona horaria: `sudo timedatectl set-timezone America/Argentina/Buenos_Aires`
- [ ] Configurar locales: `sudo locale-gen` o `sudo dpkg-reconfigure locales`
- [ ] Configurar teclado: `sudo localectl set-x11-keymap es`
- [ ] Silenciar mensajes de login (`touch ~/.hushlogin`)
- [ ] Ajustar swappiness (si usas poco swap):
  ```bash
  echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/99-swappiness.conf
  ```

## 10. 🔐 Seguridad básica

- [ ] Configurar firewall:
  ```bash
  sudo ufw enable
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  ```
- [ ] Activar el firewall automáticamente: `sudo systemctl enable ufw`
- [ ] Ver [[Firewall]] para más opciones (nftables, iptables)
- [ ] Configurar SSH si aplica: ver [[SSH]]

## 11. 🧪 Verificación final

- [ ] `neofetch` o `fastfetch` — muestra resumen del sistema
- [ ] `df -h` — verificar particiones y espacio disponible
- [ ] `free -h` — verificar RAM detectada
- [ ] `lscpu` — verificar CPU y núcleos
- [ ] Reiniciar y confirmar que todo funciona

```bash
# Comando único de verificación rápida
neofetch && df -h && free -h && echo "✅ Sistema listo"
```

## Ver también

- [[Proceso de Instalación General]]
- [[Particionado y Esquemas de Disco]]
- [[Firewall]]
- [[Backups (borg restic duplicity rsync)]]
- [[Utilidades Base del Sistema]]

#instalacion #checklist
