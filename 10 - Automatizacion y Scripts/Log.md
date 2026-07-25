---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: en progreso
categoria: log
---

# Log de Aprendizaje

Registro cronológico de sesiones. Cada entrada la añade la IA (o tú) al final, nunca se reescribe el historial.

---

## 2026-07-18
- Vault creado: estructura de carpetas, plantillas base y notas iniciales. Múltiples rondas de expansión. **Total: ~153 notas de contenido.**
- **CLAUDE.md actualizado**: Nueva subsección sobre uso de imágenes de Wikipedia y enlaces externos.
- **README.md actualizado**: Tabla de estructura refleja cambios; cifras actualizadas (~126 notas).
- **Plan de trabajo**: Presentado al usuario y aceptado.
- **Creada nota XDG Base Directory y dotfiles modernos.md** en 01 - Conceptos Fundamentales/. Cubre las 7 variables XDG, apps que cumplen/no cumplen el estándar, script de forzado, y gestores de dotfiles. MoC actualizado. **Vault: 127 notas.**
- **Fase 1: Notas críticas que faltaban**: Creadas 9 notas: Kernel Linux, GNU y Linux, Personalización en Linux (conceptos), sudo, Nano, Vim Neovim, Man (comandos), Touch y History (combinada), Neofetch Fastfetch. **Vault: ~136 notas.**

### Correcciones
- **Encoding roto**: `Virtualización (KVM QEMU libvirt).md` corregido (wikilink del MoC apuntaba a archivo inexistente).
- **Typo**: `categoria: comandos` → `comando` en Cheat Sheet. `categoria: recursos` → `troubleshooting` en Solucion de Problemas - Recursos.md.
- **4 notas huérfanas** (Git, htop btop, tmux, screen) enlazadas desde el MoC.
- **Categorías**: Ampliado el esquema en CLAUDE.md con `instalacion` y `terminal`.
- **README.md**: Cifras corregidas (77→107 notas, 18→35 comandos).
- **Verificado**: check-frontmatter.sh: 111/111 notas de contenido pasan sin errores.

## 2026-07-19
### Fase 2: Expandir y reestructurar
- **Notas independientes creadas (7)**: Firefox, LibreOffice, Suite de Oficina, Bootloaders (GRUB Limine systemd-boot), PipeWire, Multimedia (GStreamer HandBrake VLC MPV), Coreutils y util-linux.
- Navegadores Web reescrito como nota general con tabla de motores; Firefox extraído a nota propia.
- Editores de Texto expandido con tabla comparativa de 10 editores.
- Proceso de Arranque simplificado (bootloaders ahora es nota propia).
- Audio en Linux simplificado (PipeWire ahora es nota propia).
- Suite de Oficina renombrada; LibreOffice movido a nota propia.
- **Vault: ~143 notas.**

### Fase 3: Programas y herramientas
- **Creadas 6 notas**: Editores de código (VSCode Codium Zed Helix Antigravity), Lenguajes y gestores (Node.js Cargo PIP Go Gem), Linux en servidores cloud IoT, Cava, Desktop Shells (Noctalia Caelestia), Python en Linux.
- **Vault: ~149 notas.**

### Fase 4: Entornos, WMs y distros faltantes
- **Creadas**: DEs adicionales (tabla 8 DEs), WMs adicionales (tabla 8 WMs), Distros adicionales.
- **Vault: ~152 notas.**

### Correcciones y notas individuales
- **Corregido**: Vim Neovim (+clipboard), Man (sección 0). Creada Micro.md.
- **Vault: ~153 notas.**
- **Creada D-Bus.md** — system/session bus, busctl, MPRIS.
- **Vault: ~154 notas.**
- **Creada Snap y Flatpak.md** — historia, comandos, permisos, tabla comparativa.
- **Vault: ~155 notas.**

### Expansión de contenido
- Expandido Gestores de Paquetes.md (AUR, helpers).
- Expandido Sistemas de Archivos.md (ReiserFS, SquashFS, CephFS).
- Creadas 3 distros: CentOS, SteamOS, EndeavourOS.
- **Vault: ~158 notas.**

### Continuación 2026-07-19
- Creada LXC y Contenedores del Sistema.md.
- Creada Wine.md como nota independiente.
- Expandida SteamOS.md a nota completa de distribución.
- Creada AppImage.md — funcionamiento interno, ecosistema.
- **Creadas 16 notas individuales**: Gentoo, Kali, Void, Tails, MX Linux, Zorin OS, elementary OS, MATE, Budgie, LXQt, Deepin, Pantheon, bspwm, Sway, qtile, Openbox.
- Creada Incus.md — gestor de contenedores, fork de LXD.
- Creada Proxmox VE.md — plataforma de virtualización.
- Creada Bottles.md — frontend gráfico para Wine.
- Expandida Videojuegos en Linux.md con nuevos launchers y emuladores.
- Creada Gamescope.md — micro-compositor de Valve.
- Creada Bazzite.md — distro gaming inmutable.
- Expandida Distros adicionales.md con ChimeraOS y HoloISO.
- Expandido Gestores de Paquetes.md con sección de formatos portables.
- Creada linuxdeploy y AppImageKit.md.
- **Creadas 6 notas individuales**: Slackware, Solus, Parrot OS, River, Fluxbox, Enlightenment.
- **Dashboard.md actualizado**: Dataview queries agrupando 191 notas.
- **Creada Contenedores - Comparativa.md** en 00 - Indices y Mapas.
- **Creada Canonical y su ecosistema.md** en 01 - Conceptos.
- **Expandida CachyOS.md** de ~80 a ~400 líneas con kernel BORE/EEVDF.
- **Templates actualizados**: 7 plantillas con mejoras estructurales (prioridad, enlaces externos, troubleshooting).
- **Creadas 3 notas**: Sugar, Trinity, herbstluftwm.
- **Expandidas 6 notas cortas**: Post-Instalacion Checklist, Wayland vs X11, Variables de Entorno, Linux Mint, find, grep.
- **Creadas 7 notas**: Busybox, coreboot, zram, Ncurses, Stratis, Daemon, Rust for Linux.
- **Creadas 5 notas**: Android (sistema basado en Linux), Linux embebido, Malware en Linux, s6 init, Debate Tanenbaum-Torvalds.
- **Creadas 5 notas**: AlmaLinux, Raspberry Pi OS, Puppy Linux, Historia de Linux, Linux Standard Base (LSB).
- **Auditoría completa**: 213 notas, 207 resueltas, 4 en progreso. 10 wikilinks rotos corregidos.
- **Expandida Permisos y Propietarios** (~8KB): sticky bit, SUID/SGID, umask, ACLs, atributos.
- **Expandida Proceso de Instalacion General** (~12KB): requisitos, FS, swap, cifrado, esquemas.
- **Expandida Procesos y Senales** (~7KB): estados /proc, nice, cgroups, señales.
- **Expandida Creacion de USB Booteable** (~9KB): BIOS/MBR vs UEFI/GPT, persistencia, Secure Boot.
- **Expandidos 4 comandos cortos**: wc, tail, uniq, sort.
- **Expandida Compilacion desde Codigo Fuente** (~7KB): Autotools, CMake, Meson, checkinstall.
- **Expandida Dual Boot con Windows** (~6KB): reparación boot, reloj, BitLocker, NTFS.
- **Expandida Pop OS** (~8KB, prioridad alta): COSMIC Desktop, Pop!_Shop, System76 hardware.
- **Expandida NixOS** (~9KB): flakes, home-manager, containers, caché binaria.
- **Creadas 2 notas de comando**: head, awk.
- **Movida De Windows a Linux** a 02 - Instalacion.
- **Creada Btrfs.md** como nota independiente.
- **Expandidos**: Gestores de Paquetes (dpkg, RPM, AUR), Sistemas de Archivos (ext*, F2FS, XFS, JFS, FAT).
- **Expandido**: Symlinks y Dotfiles, Dual Boot (ReFS).
- **Creadas**: Video4Linux (V4L2).md, Historial de versiones del kernel.md, Sabores de Ubuntu.md, Formatos de Paquetes en GNU Linux.md, Linux en Moviles.md.
- **Prioridad 1**: creado MoC Dia a Dia en CLI con 8 categorías. Creadas 8 notas de comando: ls, cd, mkdir, locate, wget, ss, ip, apt.
- **Prioridad 2**: creado MoC Administracion y Diagnostico. Creadas 4 notas: mount, dig, traceroute, fail2ban.
- **Prioridad 3**: creado MoC Arsenal Power User. Creado MoC Mis Dotfiles. Creadas 4 notas: bash-avanzado, sysctl, auditd, perf.

## 2026-07-20
- **10 notas nuevas de alta prioridad**: kubectl, Xrdp, ADB, adduser, Parted Magic, Ubuntu (tipo de letra), Nouveau, Genkernel, Versiones de Debian, NTFS-3G.
- **4 notas expandidas**: Proceso de Arranque, Linux Mint, Linux en Moviles (Mer), LVM.
- **7 distros nuevas**: Vanilla OS, Xero Linux, LXLE Linux, Peppermint OS, Linux Lite, EU OS, Zentyal.
- **6 programas/herramientas nuevas**: GNUstep, CDE, Heartbeat (Linux-HA), LVS, Open-Xchange, SONiC.
- **5 conceptos técnicos nuevos**: GNOME VFS, Exec Shield, GEM, Int 80h, RTAI.
- **6 troubleshooting entries** en 09 - Solucion de Problemas/: WiFi, permisos, sonido, paquete roto, GRUB, NVIDIA.
- **Fix bug en check-frontmatter.sh**: off-by-one reemplazado con awk.
- **Expandidas 6 notas**: Navegadores Web, Solucion de Problemas - Recursos, systemd, Redes Basicas, SSH, sed y awk.
- **97 notas marcadas como resuelto** vía batch sed. Quedan 4 en progreso: Dashboard, MoC, Log, Cheat Sheet.
- **Creada Audio en Linux.md** — ALSA, PulseAudio, PipeWire, JACK.
- **Creada Sistemas de Archivos.md** — ext4, Btrfs, XFS, ZFS.
- **Creada Virtualización (KVM QEMU libvirt).md** — instalación, virsh, snapshots, GPU passthrough.
- **Creada Firewall.md** — nftables, iptables, ufw, firewalld.
- **Creada Cifrado (LUKS dm-crypt GPG).md** — cifrado de bloque y archivos.
- **Creada Proceso de Arranque.md** — POST→login completo.
- **Creada Backups.md** — borg, restic, duplicity, rsync + 3-2-1.
- **Creada SELinux y AppArmor.md** — MAC, contextos, perfiles.
- **Creada Logging del sistema.md** — journald, rsyslog, logrotate.
- **Creada WireGuard VPN.md** — configuración, AllowedIPs, NAT.
- **Creada Impresión (CUPS).md** — instalación, drivers, troubleshooting.
- **Creada RAID (mdadm).md** — niveles, creación, fallos.
- **Creada Monitorización.md** — Prometheus, node_exporter, Grafana.
- **Creada Gestión de usuarios avanzada.md** — PAM, chage, skel, chsh.
- **Creada Módulos del kernel.md** — lsmod, modprobe, blacklist.
- **Creada Diagnóstico de hardware.md** — lspci, lsusb, smartctl.
- **Creada cgroups.md** — v1 vs v2, systemd, límites.
- **Correcciones en systemd-networkd.md**.
- **Creada Linux From Scratch (LFS).md**.
- **Expandida Git.md** de ~200 a ~700 líneas (ramas, merge, rebase, bisect, hooks).
- **Creada Kubernetes.md** — arquitectura, pods, deployments, services.
- **Expandida PostgreSQL y MySQL.md** de ~400 a ~900 líneas.
- **Creada GitHub CLI (gh).md** — ~450 líneas, PRs, issues, Actions.
- **Integrado ebook "Linux a prueba de balas"** como Seguridad en Linux (Guía completa).md.
- **Creada SQLite.md** — ~400 líneas.
- **Creada MongoDB y NoSQL.md** — ~400 líneas.
- **Creada PostgreSQL vs MongoDB.md** — ~350 líneas.
- **Creado docker-compose.yml** con MongoDB, Redis, Cassandra, Neo4j.
- **Creada Redis.md** — ~700 líneas.
- **Auditoría**: wikilinks añadidos a NVIDIA y GRUB; expandidas Exec Shield, SONiC, GNUstep, GNOME VFS, GEM, EU OS; nuevas Pacman, Lubuntu, Firefox OS; expandido Gentoo.

## 2026-07-21 (Auditoría v2)
- **Corregido**: 9 archivos con encoding roto (`#U00f3`, `#U00ed` en vez de ó/í) reintroducido por pipeline de generación.
- **Corregido**: 26 notas huérfanas (apt, cd, ls, mkdir, ip, ss, wget + auditd, fail2ban).
- **Corregido**: hashtag faltante en Log.md.
- **Detectado**: check-frontmatter.sh reporta falsos positivos al escanear vault completo (fuga de estado entre iteraciones).
- **README.md**: cifras corregidas (272→286 notas, 12+→40 distribuciones).
- **Verificado**: find-orphans.sh: 0 huérfanas reales (288 notas).

## 2026-07-23 — Fase 1: Prioridad alta
- **Creadas 6 troubleshooting** en 09: Pantalla en negro, Disco lleno, Teclado layout, Bluetooth, Resolución multi-monitor, Reloj dual boot.
- **Creados 4 comandos**: df y du, free, uname, date y timedatectl.
- **MoC actualizado** con wikilinks. **Vault: ~298 notas.**

## 2026-07-23 — Fase 2: Prioridad media
- **Creadas 5 notas**: Namespaces (Linux), Locale y configuración de idioma, NTP y chrony, Actualización entre versiones mayores, Ansible.
- **Expandidas 2 notas**: Symlinks y Dotfiles (inodos, link count), Backups (automatización + systemd timers).
- **MoC actualizado**. **Vault: ~303 notas.**

## 2026-07-23 — Fase 3: Prioridad baja
- **Creadas 4 notas**: SSH no conecta, Docker permiso denegado, Fuentes rotas o faltantes, Git hooks para el vault.
- **Nombres corregidos**: 3 archivos renombrados a español (SSH connection refused → SSH no conecta, etc.).
- **MoC actualizado**. **Vault: ~307 notas.**

## 2026-07-23 — Segunda ronda de reubicaciones
- **3 notas** de `01` → `03 Estructura del Sistema/`: systemd-networkd, systemd-resolved, Wayland vs X11.
- **5 notas** de `01` → `08 Programas y Herramientas/`: NTFS-3G, Nouveau, WireGuard VPN, Genkernel, GNOME VFS.
- **Docker.md** movido de `08` → `01 Conceptos Fundamentales/` (categoria: programa → concepto).
- **Gestores de Paquetes.md** movido de `08` → `02 Instalacion y Configuracion/` (categoria: programa → instalacion).
- **Coreutils y util-linux.md** movido de `08` → `07 Comandos Esenciales/` (categoria: programa → comando).
- **systemd-nspawn.md** movido de `08` → `03 Estructura del Sistema/` (categoria: programa → sistema).
- **MoC actualizado**: todas las entradas movidas a sus nuevas secciones.
- **Frontmatter y hashtags actualizados** en las 12 notas reubicadas.

## 2026-07-23 — Auditoría general y mejoras
- **7 templates actualizados**: Problema Resuelto (Escenarios, eliminados campos obsoletos), Comando (Formato salida, Combinaciones pipe, Alternativas modernas), Concepto (Comandos asociados, Casos prácticos, Diagrama), Programa (Comparativa con alternativas estructurada), Entorno/WM (Requisitos, Comparativa), Distro (Upgrade, Comandos asociados), Log Diario (tiempo_invertido, tema).
- **README.md actualizado** con cifras ~307 notas y nueva estructura.
- **CLAUDE.md actualizado**: 12 categorías documentadas, nuevas reglas de estilo por tipo de nota, sección de Git hooks.
- **TODO.md creado** en 00 - Indices y Mapas con roadmap completo, fases 1-3, próximas expansiones.
- **Log.md ordenado cronológicamente**.
- **Expandidas 5 notas cortas**: top (Formato salida, Casos de uso, Alternativas modernas), ps (Casos de uso, Combinaciones pipe, procs), kill (Escenarios kill, kill -0, Troubleshooting), Contenedores (Comandos Docker, Casos prácticos), La Shell (Globbing, Redirecciones, Expansión variables).
- **Dashboard.md actualizado**: cifras corregidas (~307 notas, 0 borrador real).
- **Verificado**: no existen notas con `estado: borrador` fuera de las plantillas. Las ~28 que mostraba el Dashboard eran un remanente de stats desactualizadas.

## 2026-07-23 — Enlaces externos + hashtags + cierre
- **Enlaces externos añadidos** (Wikipedia + GitHub) a **48 notas**: 06-Terminal (3: tmux, screen, La Shell), 04-Entornos (3: XFCE, GNOME, Cinnamon), 05-Gestores (3: Awesome WM, i3, Hyprland), 01-Conceptos (4: Linux, PAM, GEM, Contenedores), 02-Instalacion (6: Proceso, Dual Boot, Particionado, Cifrado, openSUSE, Alpine), 03-Sistema (17), 07-Comandos (12: cat, cd, mv, cp, ls, tar, sudo, ps, kill, top, rm, chown).
- **Hashtags corregidos**: `#DE-WM` → `#entorno-escritorio` en las **28 notas** de 04 y 05.
- **README.md actualizado**: cifras exactas (307 notas), estructura mejorada con contenido real de cada carpeta.
- **TODO.md actualizado**: estadísticas exactas del vault, tareas completadas registradas, próximos pasos actualizados con estados.
- **Dashboard.md verificado**: todas las cifras coinciden con el escaneo real (307 notas, 66 comandos, 68 programas, etc.).
- **Pendiente**: quedan ~40 comandos sin enlaces externos (encoding issue con str_replace — requiere batch `sed` por lotes).

## 2026-07-23 — Enlaces externos: 03-Sistema (completado) + 08-Programas
- **03 - Estructura del Sistema**: añadidos Enlaces externos a las 2 notas restantes: `Bootloaders` y `systemd`. ✅ Completo (26/26 notas).
- **08 - Programas y Herramientas**: añadidos Enlaces externos (Wikipedia + GitHub + sitios oficiales) a **28 notas**: Ansible, auditd, Backups, Cava, Desarrollo (gcc/make/gdb/strace), Diagnóstico hardware, Editores código, Editores Texto, Emuladores Terminal, fail2ban, ffmpeg, Firefox, Gestores Archivos, GNUstep, htop/btop, Impresión CUPS, LibreOffice, Micro, Monitorización (Prometheus), Multimedia, Navegadores Web, PipeWire, scrcpy, Suite Oficina, timeshift, Utilidades Base, Virtualización KVM, WireGuard VPN.
- **03 + 08 completados**: 30 notas procesadas en esta sesión.
- **Pendiente**: ~40 comandos de 07 sin enlaces externos (requiere batch sed).

## 2026-07-23 — Enlaces externos: 8 comandos (mkdir, chmod, mount, dd, rsync, head, tail, wc)
- **07 - Comandos Esenciales**: añadidos Enlaces externos (Wikipedia + GNU Coreutils/man7) a 8 notas: mkdir, chmod, mount, dd, rsync, head, tail, wc.
- **Total procesado en 07**: 20 comandos con Enlaces externos (cat, cd, mv, cp, ls, tar, sudo, ps, kill, top, rm, chown, mkdir, chmod, mount, dd, rsync, head, tail, wc).
- **Pendiente**: ~45 comandos restantes sin Enlaces externos.

## 2026-07-23 — Enlaces externos: 37 comandos restantes de 07
- **07 - Comandos Esenciales**: completados los 37 comandos pendientes con Enlaces externos:
  - sort, uniq, diff, tee, xargs, locate, which, type, alias, export, source
  - ip, ss, ping, curl, wget, nc, dig, traceroute
  - less, Man, journalctl
  - sed y awk, perf, bash-avanzado, zip, apt, Touch y History, ln, watch
  - sysctl, Cheat Sheet, Coreutils, SSH, pacman, Nano
- **07 completo**: 67/67 notas de comando con Enlaces externos.
- **Pendiente**: 0 comandos restantes en 07. ✅

## 2026-07-24 — Auditoría, actualización de índices y commit inicial
- **Auditoría completa del vault**: escaneados 314 archivos .md (real), verificadas stats vs disco.
- **TODO.md actualizado**: estadísticas corregidas (314 notas, 309 resueltas), próximos pasos re-priorizados con tabla expandible, carpeta 11 - Distribuciones añadida.
- **README.md actualizado**: tabla de estructura con conteo real por carpeta, estadísticas corregidas, scripts listados.
- **Repositorio Git inicializado**: commit inicial con 326 archivos, hooks activados.
- **Hallazgos clave**: 0 notas en estado borrador real (falsos positivos en CLAUDE.md y Log.md que contienen la palabra en su texto). `Comparativa editores Linux.md` ya existe. Dashboard Dataview funcional.
- **Vault: 314 notas (+ 7 templates).**

## 2026-07-24 — Expansión de 5 notas prioritarias
- **Daemon.md** expandido: señales para daemons (SIGHUP, SIGTERM, SIGUSR1, SIGUSR2), hardening systemd (ProtectSystem, PrivateTmp, CapabilityBoundingSet), buenas prácticas de logging con logrotate + journald.
- **Busybox.md** expandido: ash vs bash (tabla de diferencias clave), BusyBox init vs systemd vs SysV, compilación desde fuente con applets personalizados (make menuconfig, CROSS_COMPILE).
- **Ncurses.md** expandido: estructura terminfo, consultas con tput, ejemplo TUI completo con ventanas/colores/bucle de eventos, distinción ncurses vs ncursesw.
- **Ubuntu.md** expandido: Netplan (IP estática, WiFi YAML), Ubuntu Pro gratuito (ESM, Livepatch), cloud-init para automatización cloud.
- **Debian.md** expandido: apt pinning con tabla de prioridades, Debian packaging (dh_make, dpkg-buildpackage), evolución non-free-firmware en Bookworm.
- **Commit**: `3f0fc97` — 526 líneas añadidas en 5 archivos.

## 2026-07-24 — 3 notas nuevas planificadas
- **Regular Expressions.md** creada (01 - Conceptos): referencia central de regex — BRE, ERE, PCRE, lookaround, patrones prácticos (IPs, URLs, emails, logs), greedy vs non-greedy, catastrophic backtracking.
- **Vim comandos avanzados.md** creada (07 - Comandos): macros (recursivas, append), registros (9 tipos con ejemplos prácticos), quickfix/location list, marks locales+globales, plegados, sesiones, vimdiff, :global, dot repeat, personalización Lua.
- **systemd unidades personalizadas.md** creada (03 - Sistema): service types detallados (simple, exec, forking, oneshot, notify, dbus), template units con %i, timers calendar+monotonic, path units, socket activation (Accept=true/false), drop-in overrides, verificación con systemd-analyze.
- **MoC actualizado**: las 3 notas enlazadas con descripciones.
- **Commit**: `22ac5a2` + `fix`: 1136 líneas añadidas, 4 archivos modificados.
- **Vault: 317 notas (+ 7 templates).**

## 2026-07-24 — Dashboard actualizado con stats reales
- **Dashboard.md actualizado**: stats corregidas (316 notas, 311 resuelto, 4 en progreso), categorías actualizadas (Comando 67, Programa 70, Concepto 36, Índice 12, Entorno/WM 29), hardcoded counts de prioridades corregidos (153/105/53).
- **Nota**: Las queries Dataview se actualizan automáticamente en Obsidian; las cifras manuales ahora coinciden con el escaneo real.

## 2026-07-24 — Entorno de desarrollo Linux.md creado
- **Creada [[Entorno de desarrollo Linux]]** (08 - Programas): guía completa para montar un entorno de desarrollo en Linux desde cero.
- **Contenido**: toolchain base (build-essential, gcc, make), 6 stacks por lenguaje (Python, Node.js, Rust, Go, Java, Ruby) con gestores de versiones, contenedores para desarrollo (Docker, Dev Containers, Podman), editores e IDEs recomendados, terminal y multiplexores, bases de datos locales en contenedores, Git + flujo de trabajo, Dockerfile multi-etapa de ejemplo, checklist post-instalación, troubleshooting común, flujo completo de cero a proyecto funcionando.
- **Enlaces relacionados**: [[Desarrollo en Linux (gcc make gdb strace)]], [[Python en Linux]], [[Lenguajes y gestores]], [[Editores de código]], [[Git]], [[Docker]], [[Contenedores]].
- **TODO.md actualizado**: tarea movida a ✅ completado, próximos pasos reordenados.
- **Commit**: Entorno de desarrollo Linux creado.

## 2026-07-24 — Contenedores orquestación.md creado
- **Creada [[Contenedores orquestación]]** (01 - Conceptos): guía completa sobre Docker Compose (perfiles, watch, variables de entorno), Docker Swarm (stack, servicios, rolling updates), Kubernetes (resumen conceptual + kubectl básico), comparativa Compose vs Swarm vs K8s, árbol de decisión, alternativas (Nomad, ECS), servicios cloud gestionados (EKS, AKS, GKE, DOKS), flujo de desarrollo de Compose a producción con K8s, troubleshooting.
- **TODO.md actualizado**: duplicados corregidos, tarea marcada completada.
- **Enlaces relacionados**: [[Contenedores]], [[Docker]], [[Kubernetes]], [[kubectl]], [[Namespaces (Linux)]], [[cgroups]], [[Contenedores - Comparativa]].

## 2026-07-24 — Optimización de rendimiento.md creado + expansiones finales
- **Creada [[Optimización de rendimiento]]** (01 - Conceptos): última tarea de alta prioridad del TODO completada.
- **Contenido**: ciclo de diagnóstico (medir→identificar→ajustar→verificar), kernel tuning por subsistema (memoria, red, FS), límites de recursos (ulimit, limits.conf, systemd), CPU governors y nice/renice, I/O schedulers y opciones de montaje, zram, perfiles por uso (escritorio, servidor web, BD, desarrollo), troubleshooting.
- **Enlaces relacionados**: [[sysctl]], [[cgroups]], [[perf]], [[Procesos y Senales]], [[zram]].
- **MoC actualizado**: entrada añadida en sección Terminal y comandos.
- **TODO.md**: última tarea de alta prioridad marcada completada. TODO vacío de alta prioridad por primera vez.

## 2026-07-24 — Scripts verificados y documentados
- **Verificados los 6 scripts** del vault: vault-stats, vault-stats-weekly, daily-log, check-frontmatter, find-orphans, add-modification-date.
- **Scripts OK**: daily-log, vault-stats (--resumen, --csv), vault-stats-weekly, find-orphans (1 huérfana: README.md), add-modification-date (314/316 actualizadas).
- **Fix**: vault-stats.sh --resumen movido antes de "Últimas modificaciones" para salida más rápida y evitar SIGPIPE.
- **Creada [[Scripts del Vault]]** (10 - Automatizacion): documentación completa de los 6 scripts con uso, funcionamiento, troubleshooting y config cron.
- **README.md actualizado**: stats corregidas (316 notas, 6 scripts), tabla de scripts con descripciones.
- **MoC actualizado**: [[Scripts del Vault]] añadido en sección Operativa.
- **Pendiente**: check-frontmatter.sh (>30s para 316 notas — aceptable para el tamaño actual).

## 2026-07-24 — TUI tools + 7 notas nuevas + wikilinks corregidos

### 🖥️ TUI tools: nota principal + 6 específicas
- **Creada [[TUI tools]]** (08 - Programas): nota comprehensive con 12 categorías de Terminal User Interfaces, basada en awesome-tuis (~585 líneas). Monitores, disco, gestores archivos, git, Docker/K8s, red, multimedia, editores, mensajería, productividad, seguridad y otros. Tabla 🟢🟡🔴 de prioridades.
- **Creada [[bat]]** (08): cat moderno con syntax highlighting (~150 líneas). Integración Git, temas, alias, integración con man y help.
- **Creada [[lazygit]]** (08): Git TUI interactivo (~180 líneas). 30+ atajos (stage, commit, branch, merge, rebase, stash), flujo start→push, config.yml.
- **Creada [[lazydocker]]** (08): Docker TUI (~110 líneas). Logs en vivo, exec en contenedor, Docker Compose integrado.
- **Creada [[k9s]]** (08): Kubernetes TUI (~150 líneas). Vistas `:pods`, `:deployments`, `:services`, skins, port-forward, shell.
- **Creada [[yazi]]** (08): Gestor de archivos TUI en Rust (~130 líneas). Previsualización de imágenes, async I/O, vs lf/ranger/nnn.
- **Creada [[zellij]]** (08): Multiplexor de terminal moderno (~160 líneas). Modo editor `Ctrl+o`, layouts YAML, temas, vs tmux/screen.
- **Documentado [[ripgrep]]** en Buscadores y filtros de TUI tools.md. Sección de instalación y ejemplos de uso.

### 📦 Instalación masiva
- **Añadida sección** al final de TUI tools.md con 5 scripts bash para instalar TUIs:
  - `install-tuis-essential.sh` 🟢 — htop, bottom, ncdu, bat, lazygit, fzf, ripgrep, tmux, glow...
  - `install-tuis-full.sh` 🟡 — + btop, glances, gdu, broot, trippy, cmus, chafa...
  - `install-tuis-all.sh` 🔴 — todo lo disponible en apt
  - `install-tuis-containers.sh` 🐳 — lazydocker, dive, ctop
  - `install-tuis.sh` 🐚 — todo-en-uno con menú interactivo y `|| true` en apt install

### 📌 Índices actualizados
- **MoC - Linux.md**: añadidas [[TUI tools]] + 6 notas nuevas en Programas comunes.
- **Arsenal Power User.md**: nueva sección 0 TUIs con tabla de 10 herramientas.
- **Dia a Dia en CLI.md**: filas lazygit, ncdu, glow + enlace a TUI tools.
- **TUI tools.md**: enlaces a notas existentes ya no dicen "pendientes de crear".
- **TODO.md**: stats actualizadas (321 notas, 77 programas), nuevas secciones para sesión.

### 🐛 Bugs corregidos
- `[[xh]]` → texto plano en httpie.md (wikilink a nota inexistente).
- `[[api]]` → texto plano en jq.md (wikilink a nota inexistente).
- `[[nvtop]]` → texto plano en TUI tools.md (no es nota separada, está en [[htop btop]]).
- `|| true` añadido en todos los `sudo apt install` del script todo-en-uno (evita que `set -e` mate el menú).
- `duf` duplicado eliminado de los scripts recomendados/todo (ya está en essentials).

### Commits de la sesión
- `a15e353` feat: crear TUI tools.md — guía completa de Terminal User Interfaces
- `ad534c0` fix: añadir TUI tools en Dia a Dia CLI + arreglar wikilink nvtop
- `6b9c709` feat: añadir sección de instalación masiva de TUIs a TUI tools.md
- `0b833de` fix: añadir || true en scripts containers del menú
- `fbd824a` feat: 6 notas TUI nuevas - bat, lazygit, lazydocker, k9s, yazi, zellij
- `f97d5ec` docs: actualizar TODO.md con sesión TUI tools + 7 notas nuevas

### Stats
- **Vault: 321 notas (+7).** Programa: 70→77. 08 - Programas: 69→77.
- **Nuevos archivos**: TUI tools.md, bat.md, lazygit.md, lazydocker.md, k9s.md, yazi.md, zellij.md.

#log
