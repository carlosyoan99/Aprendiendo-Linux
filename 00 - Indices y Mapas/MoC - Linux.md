---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: en progreso
categoria: indice
---

# Mapa de Contenidos: Aprendiendo Linux

## Dashboard
- [[Dashboard]] — vistas automáticas vía Dataview (pendientes, en progreso, todo por categoría)
- [[Dia a Dia en CLI]] — guía priorizada de comandos esenciales para el día a día (Prioridad 1)
- [[Administracion y Diagnostico]] — guía de administración del sistema y troubleshooting (Prioridad 2)
- [[Arsenal Power User]] — especialización, automatización y alto rendimiento (Prioridad 3)
- [[Mis Dotfiles]] — plantillas descargables y gestión de dotfiles
- [[Rutas de Aprendizaje]] — qué priorizar en cada categoría y por qué
- [[TODO]] — plan de trabajo, completado y roadmap
- [[Contenedores - Comparativa LXC LXD Incus Docker Podman systemd-nspawn]] — índice comparativo de tecnologías de contenedores
- [[Comparativa editores Linux]] — guía para elegir editor según caso de uso

## Fundamentos
- [[Que es Linux]] · [[GNU y Linux]] · [[Kernel Linux]]
- [[Regular Expressions]] — patrones de búsqueda en texto (grep, sed, awk, vim) — referencia central de BRE, ERE, PCRE, lookaround, patrones prácticos
- [[Variables de Entorno y PATH]] · [[Symlinks y Dotfiles]] · [[Compilacion desde Codigo Fuente]] · [[Linux From Scratch (LFS)]] — construye tu propio Linux desde cero
- [[Personalización en Linux]] · [[Contenedores]] · [[Contenedores orquestación]] — Docker Compose, Swarm, Kubernetes · [[LXC y Contenedores del Sistema]] · [[Gestión de usuarios avanzada (PAM chage skel chsh)]] · [[XDG Base Directory y dotfiles modernos]] · [[Canonical y su ecosistema]] · [[Seguridad en Linux (Guía completa)]] — ebook de ciberseguridad para newcomers
- [[Docker]] — contenedores, build, ship, run
- [[Exec Shield]] — protección NX · [[Graphics Execution Manager (GEM)]] — memoria GPU · [[Int 80h]] — syscalls x86 · [[RTAI (Tiempo Real)]] — tiempo real en Linux
- [[Namespaces (Linux)]] — aislamiento de recursos, base de contenedores
- [[Linux en servidores cloud IoT]] · [[Linux embebido]] · [[Android (sistema basado en Linux)]]
- [[Linux en Moviles (Ubuntu Touch postmarketOS)]] — sistemas Linux para teléfonos
- [[Firefox OS]] — SO móvil de Mozilla (basado en Linux, descontinuado)
- [[Daemon]] · [[Rust for Linux]] · [[Malware en Linux]] · [[Debate Tanenbaum-Torvalds]] · [[Historia de Linux]] · [[Historial de versiones del kernel de Linux]]
- [[Locale y configuracion de idioma]] — locale-gen, LC_*, teclado
- [[NTP y chrony]] — sincronización de hora, NTP, timesyncd

## Sistema
- [[Filesystem Hierarchy Standard]] · [[Proc y Sys]] · [[Sistemas de Archivos]] · [[Btrfs]]
- [[Proceso de Arranque (GRUB initramfs kernel params)]] · [[Bootloaders (GRUB Limine systemd-boot)]] · [[Logging del sistema (rsyslog journald logrotate)]]
- [[RAID (mdadm)]] · [[Módulos del kernel (lsmod modprobe blacklist)]]
- [[cgroups (control de recursos)]]
- [[systemd]] · [[systemd unidades personalizadas]] — templates, timers, sockets, paths, drop-ins · [[Permisos y Propietarios]] · [[Procesos y Senales]] · [[Redes Basicas]]
- [[Audio en Linux]] · [[Firewall]] · [[LVM]] · [[ACLs]] · [[SELinux y AppArmor]] · [[D-Bus]]
- [[systemd-networkd]] · [[systemd-resolved]] — resolución DNS integrada · [[Wayland vs X11]]
- [[systemd-nspawn]] — contenedores ligeros nativos de systemd
- [[zram]] · [[coreboot]] · [[s6 init]] · [[Linux Standard Base (LSB)]]

## Instalación
- [[Creacion de USB Booteable]] · [[Proceso de Instalacion General]] · [[Particionado y Esquemas de Disco]] · [[Dual Boot con Windows]] · [[Post-Instalacion Checklist]]
- [[Cifrado (LUKS dm-crypt GPG)]]
- [[Actualizacion entre versiones mayores]] — dist-upgrade, release upgrade
- [[De Windows a Linux]] — guía completa de migración con instalación, post-instalación y troubleshooting
- [[Gestores de Paquetes]] — apt, pacman, dnf, Flatpak, Snap, AppImage

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
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]] — incluye ChimeraOS y HoloISO como forks de SteamOS

## Entornos gráficos
- [[GNOME]] · [[KDE Plasma]] · [[XFCE]] · [[Cinnamon]]
- [[MATE]] · [[Budgie]] · [[LXQt]] · [[Deepin]] · [[Pantheon]] · [[Enlightenment]]
- [[Sugar]] · [[Trinity]]
- [[Common Desktop Environment (CDE)]] — escritorio Unix clásico
- [[Desktop Shells (Noctalia Caelestia)]]
- [[Comparativa entornos de escritorio]] — guía para elegir DE según perfil y caso de uso
- [[i3]] · [[Awesome WM]] · [[DWM]] · [[Hyprland]] · [[Niri]] · [[River]]
- [[bspwm]] · [[Sway]] · [[qtile]] · [[Openbox]] · [[Fluxbox]] · [[spectrwm]]
- [[herbstluftwm]]
- [[Comparativa gestores de ventanas]] — guía para elegir WM según perfil y caso de uso

## Programas comunes
- [[Navegadores Web]] · [[Firefox]] · [[Suite de Oficina]] · [[LibreOffice]] · [[Gestores de Archivos]] · [[Emuladores de Terminal]] · [[Utilidades Base del Sistema]] · [[Editores de Texto]] · [[Micro]]
- [[WireGuard VPN]] · [[Nouveau (controlador)]] — driver libre NVIDIA · [[NTFS-3G]] — controlador NTFS · [[GNOME VFS]] — sistema archivos virtual GNOME (histórico) · [[Genkernel]] — compilación del kernel (Gentoo)
- [[Kubernetes]] — orquestación de contenedores (pods, deployments, services) · [[Virtualización (KVM QEMU libvirt)]] · [[LXC y Contenedores del Sistema]] · [[Incus]] · [[Proxmox VE]] · [[ffmpeg]] · [[Multimedia (GStreamer HandBrake VLC MPV)]] · [[Android Debug Bridge]] — ADB · [[scrcpy]] · [[Xrdp]] — escritorio remoto · [[timeshift]] · [[Git]] · [[htop btop]] · [[Neofetch Fastfetch]]
- [[Nginx]] — servidor web, proxy inverso, balanceador de carga
- [[DNS y BIND]] — servidor DNS, zonas, resolución local
- [[Nmap]] — descubrimiento de red, escaneo de puertos
- [[Samba]] — compartición de archivos con Windows (SMB/CIFS)
- [[PostgreSQL y MySQL]] — bases de datos relacionales en Linux · [[PostgreSQL vs MongoDB]] — SQL vs NoSQL, cuándo usar cada uno, migraciones · [[SQLite]] — la base de datos embebida más usada del mundo · [[Redis]] — estructura de datos en memoria, caching, colas, pub/sub · [[MongoDB y NoSQL]] — documentos, clave-valor, columnar y grafos
- [[GitHub CLI (gh)]] — terminal para GitHub (PRs, issues, Actions, codespaces) · [[Backups (borg restic duplicity rsync)]] · [[Desarrollo en Linux (gcc make gdb strace)]] · [[Monitorización (Prometheus node_exporter)]]
- [[Impresión (CUPS)]] · [[Diagnóstico de hardware (lspci lsusb dmidecode smartctl)]]
- [[Busybox]] · [[Ncurses]] · [[Stratis]]
- [[Formatos de Paquetes en GNU Linux]] — anatomía de .deb, .rpm, .pkg.tar.zst y otros formatos
- [[PipeWire]] · [[Cava]] · [[Python en Linux]] · [[Editores de código (VSCode Codium Zed Helix Antigravity)]] · [[Lenguajes y gestores (Node.js Cargo PIP Go Gem)]]
- [[auditd]] · [[fail2ban]]
- [[Video4Linux (V4L2)]] · [[ffmpeg]] · [[Multimedia (GStreamer HandBrake VLC MPV)]]
- [[Videojuegos en Linux]] · [[Wine]] · [[Bottles]] · [[Gamescope]] · [[Snap y Flatpak]] · [[AppImage]] · [[linuxdeploy y AppImageKit]]
- [[Parted Magic]] — Live CD de particionado y rescate
- [[GNUstep]] — framework Cocoa libre
- [[Heartbeat (Linux-HA)]] — alta disponibilidad · [[Linux Virtual Server]] — balanceo de carga · [[Open-Xchange]] — suite colaborativa · [[SONiC]] — SO redes Microsoft
- [[Ansible]] — gestión de configuración, playbooks, roles
- [[Entorno de desarrollo Linux]] — toolchain completo por lenguaje, contenedores para desarrollo

## Terminal y comandos
- [[La Shell]] · [[Shells (bash zsh fish)]] · [[tmux]] · [[screen]]
- [[Cheat Sheet - Comandos Esenciales]] · [[SSH]] · [[sed y awk]] · [[awk]] · [[grep]] · [[find]]
- [[Vim comandos avanzados]] — macros, registros, quickfix, plegados, vimdiff, personalización Lua
- [[sudo]] · [[Man]] · [[Nano]] · [[Vim Neovim]] · [[Touch y History]]
- [[cp]] · [[mv]] · [[rm]] · [[chmod]] · [[chown]] · [[ps]] · [[kill]] · [[top]]
- [[ping]] · [[curl]] · [[cat]] · [[less]] · [[journalctl]]
- [[head]] · [[tail]] · [[wc]] · [[sort]] · [[uniq]] · [[tar]] · [[zip]] · [[diff]]
- [[source]] · [[export]] · [[alias]] · [[type]] · [[which]]
- [[xargs]] · [[tee]] · [[rsync]] · [[watch]] · [[dd]] · [[nc]] · [[kubectl]] — Kubernetes CLI · [[adduser]] — creación de usuarios
- [[pacman]] — gestor de paquetes de Arch Linux
- [[apt]] · [[cd]] · [[ls]] · [[mkdir]] · [[ln]] · [[locate]] · [[mount]] · [[ip]] · [[ss]] · [[dig]] · [[traceroute]] · [[wget]] · [[sysctl]] · [[perf]] · [[bash-avanzado]]
- [[Optimización de rendimiento]] — ciclo de diagnóstico, kernel tuning, ulimit, perfiles por uso
- [[df y du]] — espacio en disco · [[free]] — memoria RAM/swap · [[uname]] — información del kernel · [[date y timedatectl]] — fecha, hora, zona horaria
- [[Coreutils y util-linux]] — GNU Coreutils, util-linux, procps-ng

## Operativa
- [[Solucion de Problemas - Recursos]]
- [[WiFi no conecta]] · [[Error de permisos]] · [[Sin sonido]]
- [[Paquete roto]] · [[GRUB no arranca]] · [[NVIDIA no detecta]]
- [[Pantalla en negro tras actualizar drivers]] — fallo de arranque tras update de GPU
- [[Disco lleno (No space left on device)]] — espacio en disco
- [[Teclado con layout incorrecto]] — teclado escribe símbolos equivocados
- [[Bluetooth no conecta]] — auriculares, ratón, teclado BT
- [[Resolucion de pantalla y multi-monitor]] — pantalla incorrecta, monitor externo
- [[Reloj desincronizado en dual boot]] — hora incorrecta al cambiar de SO
- [[SSH no conecta]] — conexión SSH rechazada, troubleshooting detallado
- [[Docker permiso denegado]] — grupo docker, socket, rootless
- [[Fuentes rotas o faltantes (fontconfig)]] — fuentes rotas, emojis, fontconfig, caché
- [[Automatizacion y Scripts]] · [[Scripts del Vault]] — documentación completa de los 6 scripts · [[Cron y Systemd Timers]] · [[Git hooks para el vault]]

## Enlaces externos

- [kernel.org](https://www.kernel.org/) — sitio oficial del kernel Linux
- [Wikipedia — Linux](https://en.wikipedia.org/wiki/Linux)
- [Linux Foundation](https://www.linuxfoundation.org/)
- [Arch Wiki](https://wiki.archlinux.org/) — referencia técnica de referencia
- [GNU Operating System](https://www.gnu.org/)

---
#moc #linux
