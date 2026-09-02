---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-09-02
estado: en progreso
categoria: indice
---

# Mapa de Contenidos: Aprendiendo Linux

## Dashboard
- [[Dashboard]] — vistas automáticas vía Dataview (pendientes, en progreso, todo por categoría)
- [[Dia a Dia en CLI]] — guía priorizada de comandos esenciales para el día a día (Prioridad 1)
- [[Administración y Diagnóstico]] — guía de administración del sistema y troubleshooting (Prioridad 2)
- [[Arsenal Power User]] — especialización, automatización y alto rendimiento (Prioridad 3)
- [[Mis Dotfiles]] — plantillas descargables y gestión de dotfiles
- [[Rutas de Aprendizaje]] — qué priorizar en cada categoría y por qué
- [[TODO]] — plan de trabajo, completado y roadmap
- [[Prompts de Trabajo]] — prompts reutilizables para IA, guías y workflow
- [[Contenedores - Comparativa LXC LXD Incus Docker Podman systemd-nspawn]] — índice comparativo de tecnologías de contenedores
- [[Comparativa editores Linux]] — guía para elegir editor según caso de uso

## Fundamentos
- [[Que es Linux]] · [[GNU y Linux]] · [[Kernel Linux]]
- [[UNIX]] — ancestro de Linux, filosofía POSIX, System V vs BSD
- [[MS-DOS]] — antecedente de Windows, origen de los comandos CMD
- [[Windows]] — SO dominante en escritorio, NT vs 9x, comparativa con Linux
- [[macOS]] — basado en UNIX (Darwin/BSD), Homebrew, comparativa con Linux
- [[Distribuciones de Linux]] — qué son, familias, modelos, tabla comparativa
- [[Regular Expressions]] — patrones de búsqueda en texto (grep, sed, awk, vim) — referencia central de BRE, ERE, PCRE, lookaround, patrones prácticos
- [[Variables de Entorno y PATH]] · [[Symlinks y Dotfiles]] · [[Compilación desde Código Fuente]] · [[Linux From Scratch (LFS)]] — construye tu propio Linux desde cero
- [[Personalización en Linux]] · [[Contenedores]] · [[Contenedores orquestación]] — Docker Compose, Swarm, Kubernetes · [[LXC y Contenedores del Sistema]] · [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — índice · [[PAM]] · [[chage]] · [[chsh]] · [[skel]] · [[XDG Base Directory y dotfiles modernos]] · [[Canonical y su ecosistema]] · [[Seguridad en Linux (Guía completa)]] — ebook de ciberseguridad para newcomers
- [[Docker]] — contenedores, build, ship, run
- [[Exec Shield]] — protección NX · [[Graphics Execution Manager (GEM)]] — memoria GPU · [[Int 80h]] — syscalls x86 · [[RTAI (Tiempo Real)]] — tiempo real en Linux
- [[Namespaces (Linux)]] — aislamiento de recursos, base de contenedores
- [[Linux en servidores cloud IoT]] · [[Linux embebido]] · [[Android (sistema basado en Linux)]]
- [[Linux en Moviles (Ubuntu Touch postmarketOS)]] — sistemas Linux para teléfonos
- [[Firefox OS]] — SO móvil de Mozilla (basado en Linux, descontinuado)
- [[Daemon]] · [[Rust for Linux]] · [[Malware en Linux]] · [[Debate Tanenbaum-Torvalds]] · [[Historia de Linux]] · [[Historial de versiones del kernel de Linux]]
- [[Locale y configuracion de idioma]] — locale-gen, LC_*, teclado
- [[NTP y chrony]] — sincronización de hora, NTP, timesyncd
- [[DevOps]] — cultura DevOps, CI/CD, pipelines, infraestructura como código
- [[CI-CD]] — integración continua, despliegue continuo, GitHub Actions, GitLab CI, Jenkins

## Sistema
- [[Filesystem Hierarchy Standard]] · [[Proc y Sys]] · [[Sistemas de Archivos]] · [[fstab (montaje de discos)]] — montaje automático de discos en el arranque · [[Btrfs]] · [[LUKS2 y Btrfs]] — cifrado de bloque + Btrfs · [[snapper]] — snapshots Btrfs y rollback · [[Mi equipo (hardware CachyOS-Laptop)]] — el equipo real donde corre este vault
- [[Proceso de Arranque (GRUB initramfs kernel params)]] · [[Bootloaders (GRUB Limine systemd-boot)]] — índice · [[GRUB]] · [[Limine]] · [[systemd-boot]] · [[initramfs]] — sistema de archivos en RAM · [[Firmware y BIOS-UEFI]] — firmware, Secure Boot, ESP · [[Logging del sistema (rsyslog journald logrotate)]] — índice · [[journald]] · [[rsyslog]] · [[logrotate]]
- [[RAID (mdadm)]] · [[Módulos del kernel (lsmod modprobe blacklist)]]
- [[cgroups (control de recursos)]]
- [[systemd]] · [[systemctl]] — gestión de servicios/units · [[systemd unidades personalizadas]] — templates, timers, sockets, paths, drop-ins · [[Permisos y Propietarios]] · [[Procesos y Senales]] · [[Redes Basicas]]
- [[Audio en Linux]] · [[Firewall]] · [[iptables]] — firewall clásico (legacy) · [[LVM]] · [[ACLs]] · [[SELinux y AppArmor]] — índice · [[SELinux]] · [[AppArmor]] · [[D-Bus]]
- [[systemd-networkd]] · [[NetworkManager]] — gestión de redes gráfica y CLI · [[systemd-resolved]] — resolución DNS integrada · [[Wayland vs X11]]
- [[Device nodes y udev]] — nodos de dispositivo en /dev, reglas udev
- [[systemd-nspawn]] — contenedores ligeros nativos de systemd
- [[zram]] · [[Tmpfs y ramfs]] — filesystems en memoria, /dev/shm · [[coreboot]] · [[s6 init]] · [[Linux Standard Base (LSB)]]

## Instalación
- [[Creación de USB Booteable]] · [[Proceso de Instalación General]] · [[Particionado y Esquemas de Disco]] · [[Dual Boot con Windows]] · [[Post-Instalación Checklist]]
- [[Cifrado (LUKS dm-crypt GPG)]] — índice · [[LUKS]] — cifrado de disco completo · [[GPG]] — cifrado de archivos y firmas
- [[Actualización entre versiones mayores]] — dist-upgrade, release upgrade
- [[De Windows a Linux]] — guía completa de migración con instalación, post-instalación y troubleshooting
- [[Gestores de Paquetes]] — índice · [[apt]] · [[pacman]] · [[dnf]] · [[Flatpak]] · [[Snap]] · [[AppImage]]

## Distribuciones
- [[Ubuntu]] · [[Ubuntu (tipo de letra)]] — la tipografía Ubuntu · [[Sabores de Ubuntu]] · [[Debian]] · [[Versiones de Debian]] — timeline de releases · [[Arch Linux]] · [[Fedora]] · [[Linux Mint]] · [[CachyOS]]
- [[openSUSE]] · [[Pop OS]] · [[Manjaro]] · [[NixOS]] · [[Alpine Linux]] · [[Rocky Linux]]
- [[CentOS]] · [[SteamOS]] · [[EndeavourOS]] · [[Bazzite]] · [[AlmaLinux]] · [[Raspberry Pi OS]] · [[Puppy Linux]]
- [[Gentoo]] · [[Kali Linux]] · [[Void Linux]] · [[Tails]]
- [[MX Linux]] · [[Zorin OS]] · [[elementary OS]]
- [[Linux Lite]] — para migrantes de Windows · [[Peppermint OS]] — híbrido web-local · [[Vanilla OS]] — inmutable · [[Xero Linux]] — Arch + KDE
- [[LXLE Linux]] — ligera (descontinuada) · [[EU OS]] — para sector público europeo · [[Zentyal]] — servidor tipo Windows
- [[Lubuntu]] — sabor Ubuntu ligero con LXQt
- [[Slackware]] · [[Solus]] · [[Parrot OS]]
- [[Clear Linux]] — distro Intel optimizada para rendimiento
- [[Drauger OS]] — distro gaming basada en Ubuntu
- [[Garuda Linux]] — Arch-based, Btrfs, Dracut, gaming
- [[AUR]] — Arch User Repository: repositorio comunitario de Arch
- [[ChimeraOS]] — distro gaming inmutable para living room · [[HoloISO]] — fork abandonado de SteamOS
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]] — resto de distros menores + comparativas SteamOS

## Entornos gráficos
- [[GNOME]] · [[KDE Plasma]] · [[XFCE]] · [[Cinnamon]]
- [[MATE]] · [[Budgie]] · [[LXDE]] · [[LXQt]] · [[Deepin]] · [[Pantheon]] · [[Enlightenment]]
- [[Sugar]] · [[Trinity]]
- [[Common Desktop Environment (CDE)]] — escritorio Unix clásico · [[Motif]] — toolkit gráfico usado por CDE
- [[Desktop Shells (Noctalia Caelestia)]]
- [[Tema Material You en el escritorio]] — del wallpaper a las apps vía Noctalia
- [[COSMIC Desktop]] — DE en Rust por System76, alpha
- [[CutefishOS]] — DE Wayland con estética macOS (descontinuado)
- [[Comparativa entornos de escritorio]] — guía para elegir DE según perfil y caso de uso
- [[i3]] · [[Awesome WM]] · [[DWM]] · [[Hyprland]] · [[Niri]] · [[River]]
- [[bspwm]] · [[Sway]] · [[qtile]] · [[Openbox]] · [[Fluxbox]] · [[spectrwm]]
- [[herbstluftwm]]
- [[Labwc]] — compositor Wayland minimalista tipo Openbox
- [[Wayfire]] — compositor Wayland con efectos 3D (tipo Compiz)
- [[Comparativa gestores de ventanas]] — guía para elegir WM según perfil y caso de uso

## Programas comunes
- [[Navegadores Web]] — índice + comparativa · [[Firefox]] · [[Chromium]] · [[Brave]] · [[LibreWolf]] · [[Vivaldi]] · [[Ungoogled Chromium]] · [[GNOME Web (Epiphany)]] · [[Falkon]] · [[Konqueror]] · [[google-chrome]] — Chrome de Google (con VAAPI en CachyOS) · [[Atajos de teclado - Firefox]] — accesos rápidos del navegador
- [[Suite de Oficina]] — índice + comparativa · [[LibreOffice]] · [[OnlyOffice]] · [[WPS Office]] · [[FreeOffice]] · [[Calligra Suite]] · [[AbiWord]] · [[Gnumeric]] · [[Gestores de Archivos]] — índice + comparativa · [[Nautilus]] · [[Dolphin]] · [[Thunar]] · [[Nemo]] · [[PCManFM]] · [[Double Commander]] · [[SpaceFM]] · [[Atajos de teclado - Nautilus Thunar Dolphin]] — accesos rápidos por defecto · [[Emuladores de Terminal]] — índice + comparativa · [[GNOME Terminal]] · [[Konsole]] · [[Xfce Terminal]] · [[Alacritty]] · [[Kitty]] · [[Foot]] · [[st]] · [[wezterm]] · [[Atajos de teclado - GNOME Terminal y Kitty]] — accesos rápidos por defecto · [[Utilidades Base del Sistema]] — índice de paquetes base · [[binutils]] · [[procps-ng]] · [[Editores de Texto]] — índice + comparativa · [[Nano]] · [[Micro]] · [[Helix]] · [[Lapce]] · [[Zed]] · [[Antigravity]] · [[Geany]] · [[Kate]] · [[Gedit]] · [[Atajos de teclado - Editores Kate y Gedit]] — accesos rápidos por defecto
- [[WireGuard VPN]] · [[Nouveau (controlador)]] — driver libre NVIDIA · [[NTFS-3G]] — controlador NTFS · [[GNOME VFS]] — sistema archivos virtual GNOME (histórico) · [[Genkernel]] — compilación del kernel (Gentoo)
- [[Kubernetes]] — orquestación de contenedores (pods, deployments, services) · [[Virtualización (KVM QEMU libvirt)]] — índice del stack · [[KVM]] · [[QEMU]] · [[libvirt]] · [[LXC y Contenedores del Sistema]] · [[Incus]] · [[Proxmox VE]] · [[ffmpeg]] · [[Android Debug Bridge]] — ADB · [[scrcpy]] · [[Xrdp]] — escritorio remoto · [[timeshift]] · [[Git]] · [[htop btop]] · [[Neofetch Fastfetch]]
- [[Backups (borg restic duplicity rsync)]] — índice + comparativa + estrategia 3-2-1 · [[borg]] · [[restic]] · [[duplicity]]
- [[Nginx]] — servidor web, proxy inverso, balanceador de carga
- [[DNS y BIND]] — servidor DNS, zonas, resolución local
- [[Nmap]] — descubrimiento de red, escaneo de puertos
- [[Samba]] — compartición de archivos con Windows (SMB/CIFS) · [[sshfs]] — montar sistemas de archivos remotos vía SSH
- [[PostgreSQL y MySQL]] — índice · [[PostgreSQL]] · [[MySQL]] — bases de datos relacionales · [[PostgreSQL vs MongoDB]] — SQL vs NoSQL, cuándo usar cada uno, migraciones · [[SQLite]] — la base de datos embebida más usada del mundo · [[Redis]] — estructura de datos en memoria, caching, colas, pub/sub · [[MongoDB y NoSQL]] — documentos, clave-valor, columnar y grafos
- [[Desarrollo en Linux (gcc make gdb strace)]] — índice del toolchain · [[gcc]] · [[make]] · [[gdb]] · [[strace]]
- [[GitHub CLI (gh)]] — terminal para GitHub (PRs, issues, Actions, codespaces) · [[Monitorización (Prometheus node_exporter)]] — índice del stack · [[Prometheus]] · [[node_exporter]] · [[Grafana]]
- [[lazygit]] — Git TUI interactivo · [[gitui]] — Git TUI en Rust · [[tig]] — visor de commits Git · [[delta]] — visor de diff con syntax highlighting · [[meld]] — comparador y fusionador visual (git difftool/mergetool)
- [[Docker Compose]] — orquestación multi-contenedor (YAML, profiles, watch)
- [[lazydocker]] — Docker TUI interactivo · [[dive]] — explorador capas Docker · [[ctop]] — top para contenedores
- [[k9s]] — Kubernetes TUI | [[zellij]] — multiplexor de terminal moderno · [[yazi]] — gestor de archivos TUI rápido
- [[bat]] — cat con syntax highlighting · [[glow]] — visor Markdown bonito | [[trippy]] — traceroute + ping visual
- [[duf]] — df moderno con colores · [[dust]] — du moderno con barras · [[btop]] — monitor de recursos con gráficos · [[iftop]] — monitor de ancho de banda por conexión · [[bmon]] — monitor de ancho de banda · [[nethogs]] — monitor de ancho de banda por proceso · [[nvtop]] — monitor de GPU (NVIDIA/AMD) · [[glances]] — monitor del sistema en Python (TUI + web)
- [[Impresión (CUPS)]] · [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]] — índice + herramientas · [[lspci]] · [[lsusb]] · [[dmidecode]] · [[lshw]] · [[smartctl]] · [[ethtool]] — diagnóstico de red · [[gdebi]] — instalador de .deb con dependencias
- [[Busybox]] · [[Ncurses]] · [[Stratis]] · [[suckless]] — comunidad de software minimalista (DWM, st, dmenu)
- [[ranger]] — gestor de archivos TUI (Python) · [[lf]] — gestor de archivos TUI rápido (Go) · [[nnn]] — gestor TUI ultra-ligero en C
- [[Formatos de Paquetes en GNU Linux]] — anatomía de .deb, .rpm, .pkg.tar.zst y otros formatos
- [[PipeWire]] · [[Cava]] · [[Python en Linux]] · [[Editores de código (VSCode Codium Zed Helix Antigravity)]] · [[Atajos de teclado - VSCode]] — accesos rápidos del editor
- [[Lenguajes y gestores (Node.js Cargo PIP Go Gem)]] — índice + comparativa de gestores · [[Node.js]] · [[Cargo]] · [[pip]] · [[Go]] · [[Gem]]
- [[just]] — ejecutor de tareas tipo make · [[mise]] — gestor de versiones universal · [[hyperfine]] — benchmark CLI con análisis estadístico · [[eza]] — ls moderno en Rust (colores, iconos, árbol) · [[zoxide]] — cd inteligente que aprende frecuencia · [[starship]] — prompt cross-platform en Rust · [[sd]] — sed moderno y simple · [[hexyl]] — visor hexadecimal con colores · [[rclone]] — sincronización cloud (S3, Drive, 70+ backends) · [[yt-dlp]] — descargador de vídeos multi-sitio
- [[fx]] — visor JSON interactivo · [[bandwhich]] — monitor de ancho de banda TUI
- [[Podman]] — contenedores sin daemon · [[auditd]] · [[fail2ban]]
- [[atuin]] — historial de shell con sincronización
- [[obsidian]] — notas en Markdown con grafo de conocimiento · [[telegram-desktop]] — mensajería de Telegram · [[pavucontrol]] — mezclador y control de dispositivos de audio
- [[Multimedia (GStreamer HandBrake VLC MPV)]] — índice + comparativa · [[gstreamer]] · [[vlc]] · [[mpv]] · [[handbrake]] · [[kew]] — reproductor de música TUI con MPRIS
- [[Nextcloud]] — nube privada self-hosted · [[Video4Linux (V4L2)]] · [[ffmpeg]]
- [[Videojuegos en Linux]] · [[Wine]] · [[Proton]] — capa de compatibilidad de juegos de Valve · [[Bottles]] · [[Gamescope]] · [[Snap y Flatpak]] · [[AppImage]] · [[linuxdeploy y AppImageKit]] · [[flatpak-builder]] — herramienta para compilar Flatpaks
- [[Parted Magic]] — Live CD de particionado y rescate · [[gparted]] — editor de particiones gráfico
- [[GNUstep]] — framework Cocoa libre
- [[GTK]] · [[Qt]] — toolkits de interfaces gráficas (GNOME y KDE respectivamente)
- [[Heartbeat (Linux-HA)]] — alta disponibilidad · [[Linux Virtual Server]] — balanceo de carga · [[Open-Xchange]] — suite colaborativa · [[SONiC]] — SO redes Microsoft · [[FRRouting]] — suite de routing (BGP/OSPF)
- [[Ansible]] — gestión de configuración, playbooks, roles
- [[Entorno de desarrollo Linux]] — toolchain completo por lenguaje, contenedores para desarrollo
- [[TUI tools]] — guía de Terminal User Interfaces (monitores, editores, git, docker, multimedia, redes)

## Terminal y comandos
- [[La Shell]] · [[Shells (bash zsh fish)]] · [[Fish]] — shell con autosugerencias y syntax highlighting · [[Nushell]] — shell estructurada con datos tipados · [[tmux]] · [[screen]]
- [[sed]] — editor de flujo · [[awk]] — procesamiento por columnas · [[sed y awk]] — índice
- [[Cheat Sheet - Comandos Esenciales]] · [[SSH]] · [[grep]] · [[find]] · [[fd-find]] — búsqueda rápida · [[fzf]] — filtro difuso interactivo
- [[Vim comandos avanzados]] — macros, registros, quickfix, plegados, vimdiff, personalización Lua
- [[stat]] · [[file]] · [[sudo]] · [[Man]] · [[Nano]] · [[Vim Neovim]] — índice · [[Vim]] — editor clásico · [[Neovim]] — fork moderno · [[Vim comandos avanzados]]
- [[touch]] — crear archivos y timestamps · [[history]] — historial de comandos · [[Touch y History]] — índice
- [[cp]] · [[mv]] · [[rm]] · [[chmod]] · [[chown]] · [[chgrp]] — cambiar grupo · [[ps]] · [[kill]] · [[top]] · [[groups]] — mostrar grupos del usuario
- [[ping]] · [[mtr]] — diagnóstico de red (ping + traceroute) · [[curl]] · [[httpie]] · [[xh]] — clientes HTTP amigables · [[cat]] · [[less]] · [[journalctl]]
- [[jq]] — procesador JSON · [[yq]] — procesador YAML/JSON/XML
- [[head]] · [[tail]] · [[wc]] · [[sort]] · [[uniq]] · [[cut]] — extraer columnas · [[tr]] — traducir/eliminar caracteres · [[nl]] — numerar líneas · [[paste]] — unir líneas · [[comm]] — comparar archivos ordenados · [[tar]] · [[zip]] · [[7z]] — máxima compresión · [[diff]] · [[cmp]] — comparación byte a byte · [[patch]] — aplicar parches
- [[sha256sum]] — verificar integridad con SHA-256 · [[md5sum]] — verificar integridad con MD5
- [[env]] — ejecutar con entorno modificado · [[source]] · [[export]] · [[alias]] · [[type]] · [[which]] · [[basename dirname]] — extraer nombre/ruta de path · [[expr]] — calculadora de expresiones
- [[xargs]] · [[tee]] · [[rsync]] · [[watch]] · [[dd]] · [[pv]] — monitor de progreso en pipes · [[nc]] · [[kubectl]] — Kubernetes CLI · [[adduser]] — creación de usuarios
- [[nohup]] · [[timeout]] · [[at]] · [[nohup-timeout-at]] — índice
- [[seq]] · [[yes]] · [[sleep]] · [[seq yes sleep]] — índice
- [[tree]] — mostrar árbol de directorios · [[procs]] — ps moderno con colores · [[ripgrep]] — grep moderno en Rust · [[doggo]] — dig moderno con colores
- [[pacman]] — gestor de paquetes de Arch Linux
- [[octopi]] — frontend gráfico para pacman (con asistente AUR)
- [[dpkg]] — gestor de paquetes Debian de bajo nivel (.deb)
- [[apt]] · [[nala]] — frontend moderno APT · [[pwd]] — mostrar directorio actual · [[cd]] · [[ls]] · [[mkdir]] · [[ln]] · [[locate]] · [[mount]] · [[lsblk]] — listar dispositivos de bloque · [[ip]] · [[ss]] · [[dig]] · [[traceroute]] · [[wget]] · [[sysctl]] · [[perf]] · [[strace]] — depuración de syscalls · [[gdb]] — depurador GNU, breakpoints, core dumps · [[ltrace]] — trazar llamadas a librerías · [[bash-avanzado]]
- [[Optimización de rendimiento]] — ciclo de diagnóstico, kernel tuning, ulimit, perfiles por uso
- [[df]] · [[du]] · [[ncdu]] — analizador de disco interactivo · [[df y du]] — índice
- [[free]] — memoria RAM/swap · [[uname]] — información del kernel · [[uptime]] — tiempo de actividad y carga media
- [[date]] · [[timedatectl]] · [[date y timedatectl]] — índice
- [[Coreutils y util-linux]] — GNU Coreutils, util-linux, procps-ng

## Operativa
- [[Solución de Problemas - Recursos]]
- [[netstat]] — estadísticas de red (legacy) · [[nmcli]] — gestión con NetworkManager · [[nftables]] — firewall moderno · [[ufw]] — firewall simplificado (Ubuntu)
- [[WiFi no conecta]] · [[Error de permisos]] · [[Sin sonido]]
- [[Paquete roto]] · [[GRUB no arranca]] · [[NVIDIA no detecta]]
- [[Pantalla en negro tras actualizar drivers]] — fallo de arranque tras update de GPU
- [[Disco lleno (No space left on device)]] — espacio en disco
- [[Teclado con layout incorrecto]] — teclado escribe símbolos equivocados
- [[Bluetooth no conecta]] — auriculares, ratón, teclado BT
- [[Resolución de pantalla y multi-monitor]] — pantalla incorrecta, monitor externo
- [[Reloj desincronizado en dual boot]] — hora incorrecta al cambiar de SO
- [[SSH no conecta]] — conexión SSH rechazada, troubleshooting detallado
- [[Docker permiso denegado]] — grupo docker, socket, rootless
- [[Fuentes rotas o faltantes (fontconfig)]] — fuentes rotas, emojis, fontconfig, caché
- [[Red no conecta]] — diagnóstico completo de conectividad (DNS/DHCP/firewall)
- [[Paquete roto]] — reparar paquetes rotos y actualización interrumpida (dpkg/apt/dnf/pacman)
- [[Sistema no arranca]] — recuperación desde pantalla negra hasta kernel panic
- [[Impresora no funciona]] — solucionar problemas de impresión (CUPS, drivers, red)
- [[Automatización y Scripts]] · [[Scripts del Vault]] — documentación completa de los 6 scripts · [[Cron]] · [[systemd timers]] · [[inotifywait]] — monitoreo de eventos del sistema de archivos · [[Git hooks para el vault]]
- [[Scripts de personalización del sistema]] — niri-gov, niri-ram, modo gaming · [[systemd user watchers para temas Noctalia]]
- [[OCR de pantalla con noctalia-ocr]] · [[Recordatorios con noctalia-remind]] — utilidades propias en el PATH del sistema

## Enlaces externos

- [kernel.org](https://www.kernel.org/) — sitio oficial del kernel Linux
- [Wikipedia — Linux](https://en.wikipedia.org/wiki/Linux)
- [Linux Foundation](https://www.linuxfoundation.org/)
- [Arch Wiki](https://wiki.archlinux.org/) — referencia técnica de referencia
- [GNU Operating System](https://www.gnu.org/)

---
#moc #linux
