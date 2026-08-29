---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-29
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

## 2026-07-24 — Segunda ronda TUI: 6 notas faltantes (dive, ctop, gitui, tig, trippy, glow)

### 🆕 Notas creadas
- **[[dive]]** (08): Explorador de capas Docker. Eficiencia de imágenes, optimización de Dockerfiles (~120 líneas).
- **[[ctop]]** (08): top-like para contenedores. CPU/RAM/IO/Red en vivo (~60 líneas).
- **[[gitui]]** (08): Git TUI en Rust. Rápido, ~5 MB, temas Nord/Dracula/Gruvbox integrados (~100 líneas).
- **[[tig]]** (08): Visor de commits y log Git. Blame, diff, stash, ~1 MB (~120 líneas).
- **[[trippy]]** (08): traceroute + ping visual. Gráficos históricos por hop, modo JSON (~130 líneas).
- **[[glow]]** (08): Visor Markdown bonito. Explorador TUI, 30+ temas, modo presentación (~110 líneas).

### 📌 Índices actualizados
- **MoC - Linux.md**: dive, ctop, gitui, tig, trippy, glow añadidos en Programas comunes (4 líneas).
- **TUI tools.md**: enlaces a [[trippy]] en Red, [[dive]]/[[ctop]] en Docker.

### Commits de la sub-sesión
- `46668c7` feat: 6 notas TUI faltantes - dive, ctop, gitui, tig, trippy, glow

### Stats
- **Vault: 327 notas (+6).** Programa: 77→83. 08 - Programas: 77→83.
- **Nuevos archivos**: dive.md, ctop.md, gitui.md, tig.md, trippy.md, glow.md.
- **Total TUI esta sesión**: 14 notas (1 guía + 13 herramientas específicas).

## 2026-07-25 — Expansiones y enlaces externos

### 🆕 6 notas de alta prioridad (auditoría)
- **Creadas**: [[ripgrep]] (~170 líneas, 07), [[tree]] (~110, 07), [[procs]] (~110, 07), [[doggo]] (~120, 07), [[bandwhich]] (~120, 08), [[fx]] (~120, 08).
- **MoC actualizado**: 4 comandos en Terminal, 2 programas en Programas comunes.
- **Commits**: `4202c1e` feat + MoC update.

### 📝 5 notas TUI expandidas
- **[[ctop]]**: ~60 → 131 líneas. Comparativa con lazydocker, troubleshooting.
- **[[httpie]]**: ~40 → 153 líneas. Sintaxis completa, pipes con jq, vs curl.
- **[[fd-find]]**: ~40 → 157 líneas. 20+ opciones, integración fzf, comparativa.
- **[[fzf]]**: ~50 → 189 líneas. Key bindings, config avanzada, temas.
- **[[nala]]**: ~40 → 129 líneas. nala fetch mirrors, historial transacciones, vs apt.
- **Commit**: `85592bf` feat: expandir 5 notas TUI cortas.

### 🔗 Enlaces externos a 10 notas
- **6 distros**: Fedora, CentOS, Rocky Linux, EndeavourOS, Manjaro, Arch Linux.
- **4 programas**: jq, Nextcloud, Podman, Motif.
- **Commit**: `c14d547` feat: enlaces externos.

### 🐛 Bugs corregidos
- `[[xh]]` → texto plano en httpie.md (xh sin nota propia).
- `prioridad: media` → `baja` en fd-find.md (consistencia).
- Troubleshooting duplicado fusionado en nala.md.
- Secciones invertidas corregidas en jq.md (Enlaces externos antes de Ver también).
- **Commits**: `6bdfc74`, `312d147`.

### 📊 Stats finales
- **Vault: 357 notas (+30 acumulados, +6 en esta sesión).**
- Programa: 83→93. Comando: 68→83. 08 - Programas: 83→92. 07 - Comandos: 68→82.
- **Archivos nuevos en esta sesión**: ripgrep, tree, procs, doggo (07), bandwhich, fx (08).
- **TODO.md y Log.md actualizados** con todo el progreso.
## 2026-07-25 (auditoría v3 — nueva estructura)
- **Confirmado con git status**: el bug de encoding (`#U00f3`/`#U00ed`) NO viene del pipeline de generación de notas — git tenía las 11 versiones correctas ya commiteadas, y el zip subido contenía en su lugar las versiones rotas sin trackear. El problema está específicamente en el paso de zip/exportación previo a la subida, no en el proceso de creación de notas. Restauradas las 11 con `git checkout`.
- **Corregido**: 2 notas huérfanas (Motif, xh) enlazadas desde el MoC.
- **Eliminada** carpeta vacía residual `02 - Instalacion y Configuracion/Distribuciones/` (ya migrada a `11 - Distribuciones/`).
- **Corregidas** cifras del README con `vault-stats.sh --resumen` (317→358 notas, comando 68→83, programa 70→94, distribucion 40→41).
- **Observación**: `fecha_modificacion` se deriva de `mtime` del archivo — 354/358 notas comparten la misma fecha (2026-07-24), casi seguro por un `git checkout`/clone que resetea mtimes, no por edición real el mismo día. Recomendado: derivar `fecha_modificacion` de `git log -1 --format=%ad -- <archivo>` en vez de mtime, para que sobreviva a clones/checkouts/zips.
- **Observación**: `core.hooksPath` en `.git/config` usa una ruta absoluta (`/home/carlos/Documentos/...`) — es config local no versionada así que no rompe para otros, pero se rompe si mueves/renombras la carpeta del vault en tu propia máquina. Considera `git config core.hooksPath .githooks` (relativo) para portabilidad.
- Verificado: `check-frontmatter.sh` → 358/358 OK. `find-orphans.sh` → 0 huérfanas reales tras el fix.

## 2026-07-25 (v3) — Expansiones, unificación de bloques, GTK+Qt, MoC

### 📝 6 notas expandidas
- **Motif.md**: ~50 → ~110 líneas. Historia CDE, Motif 2.1 vs 3.x, instalación, bindings Python/Rust.
- **Alpine Linux.md**: ~92 → ~190 líneas. apk avanzado, OpenRC, musl vs glibc, Docker containers, multi-stage builds.
- **Linux Lite.md**: ~82 → ~165 líneas. 6 herramientas propias (Lite Welcome, Lite Tweaks, Lite Software, etc.), tabla equivalencias Windows, comparativa Zorin/Mint/LXLE.
- **openSUSE.md**: ~101 → ~175 líneas. YaST módulos detallados, Zypper avanzado, Tumbleweed vs Leap, OBS/osc, Snapper+Btrfs, Aeon/Kalpa immutable.
- **Versiones de Debian.md**: ~103 → ~195 líneas. Timeline releases con fechas precisas, LTS/ELTS, freeze process, Toy Story naming, ramas stable/testing/unstable.
- **Peppermint OS.md**: ~61 → ~115 líneas. SSBs/Ice framework con ejemplos, requisitos hardware, Pep Tools, edición Loaded, comparativa alternativas ligeras.

### 🆕 2 notas nuevas
- **GTK.md**: Historia, GTK3 vs GTK4, instalación, hello world C, comparativa con Qt, troubleshooting.
- **Qt.md**: Historia, Qt5 vs Qt6, instalación, hello world C++/CMake, MOC, comparativa con GTK, troubleshooting.

### 🔧 7 notas con bloques de código unificados
- **Fedora.md**: 5 bloques → 1 con comentarios de sección.
- **NixOS.md**: 5 pares nix+bash → 4 unificados con comentarios `#`.
- **GitHub CLI (gh).md**: ~27 minibloques → ~10 por tema.
- **Sistemas de Archivos.md**: ~12 bloques → ~5 (ext4, Btrfs, XFS, ZFS, crear+fsck).
- **Permisos y Propietarios.md**: ~15 bloques → ~5 (bits especiales, ACLs, casos prácticos).
- **FHS.md**: ~10 bloques → ~5 (etc, var, usr, proc+sys, tmp+run+mnt+opt).
- **DNS y BIND.md**: ~8 bloques → ~4 (host+nslookup, hosts+resolv.conf, resolved+NSSwitch, verificación).

### 🏗️ MoC actualizado
- [[GTK]] · [[Qt]] añadidos en Programas comunes (toolkits de interfaz gráfica).

### 📊 Stats
- **Vault: 360 notas (+2).** Programa: 94→96. Distribución: 41→43. 08 - Programas: 92→94. 11 - Distribuciones: 42→43.
- **Nuevos archivos**: GTK.md, Qt.md.
- **Bloques bash totales reducidos**: ~100 bloques sueltos eliminados.

## 2026-07-25 (v4) — Reorganización de scripts

- **Reorganización**: scripts movidos de `10 - Automatizacion y Scripts/scripts/` a `scripts/` raíz. Rutas internas actualizadas (`../../` → `../`). Documentación y CLAUDE.md actualizados.

#log

## 2026-07-26 — Fragmentación: Lenguajes y gestores → 5 notas individuales
- **Nota fragmentada**: `Lenguajes y gestores (Node.js Cargo PIP Go Gem).md` contenía 5 ecosistemas de lenguajes en una sola nota. Se extrajo cada uno a nota independiente.
- **5 notas nuevas**: [[Node.js]], [[Cargo]], [[pip]], [[Go]], [[Gem]] — cada una con frontmatter, contenido propio y enlaces cruzados.
- **Nota original reducida**: ahora es un índice/comparativa ligera con tabla y buenas prácticas, enlazando a las 5 notas hijas.
- **MoC actualizado**: reemplazado enlace único por `[[Node.js]] · [[Cargo]] · [[pip]] · [[Go]] · [[Gem]] — gestores de paquetes por lenguaje`.
- **Wikilinks actualizados**: Python en Linux.md, Entorno de desarrollo Linux.md, mise.md — referencias corregidas.
- **Validación**: check-frontmatter.sh → 420/420 OK. find-orphans.sh --backlinks → 1 huérfana (README.md, intencional).

## 2026-07-26 — Fragmentación: Backups → 3 notas individuales
- **Nota fragmentada**: `Backups (borg restic duplicity rsync).md` contenía 4 herramientas de backup en una sola nota. Se extrajeron borg, restic y duplicity a notas independientes.
- **3 notas nuevas**: [[borg]], [[restic]], [[duplicity]] — cada una con frontmatter, contenido propio y enlaces cruzados.
- **Nota original reducida**: ahora es un índice/comparativa con tablas, estrategia 3-2-1 y alternativas, enlazando a las 3 notas hijas + rsync.
- **MoC actualizado**: añadidos `[[borg]] · [[restic]] · [[duplicity]]` en Programas comunes, junto al índice existente.
- **Validación**: check-frontmatter.sh → 423/423 OK. find-orphans.sh --backlinks → 1 huérfana (README.md, intencional).

## 2026-07-26 — Fragmentación: Distros adicionales → ChimeraOS + HoloISO
- **Nota fragmentada**: `Distros adicionales (...) .md` contenía 10+ distros. Se extrajeron ChimeraOS y HoloISO a notas independientes.
- **2 notas nuevas**: [[ChimeraOS]] (prioridad media, ~140 líneas), [[HoloISO]] (prioridad baja, ~80 líneas) — cada una con frontmatter, contenido propio y enlaces cruzados.
- **Nota original reducida**: ahora solo contiene Slackware, Solus y Parrot OS como mini-distros + tablas comparativas SteamOS. Enlaces a ChimeraOS y HoloISO añadidos en la sección de notas individuales.
- **MoC actualizado**: reemplazado enlace único por `[[ChimeraOS]] · [[HoloISO]]` + el índice existente.
- **Wikilinks actualizados**: Bazzite.md (referencia a ChimeraOS), SteamOS.md (a la sección Distros adicionales).
- **Validación**: check-frontmatter.sh → 425/425 OK. find-orphans.sh --backlinks → 1 huérfana (README.md).

## 2026-07-26 — Fragmentación: Multimedia → 4 notas individuales
- **Nota fragmentada**: `Multimedia (GStreamer HandBrake VLC MPV).md` contenía 4 programas multimedia en una sola nota.
- **4 notas nuevas**: [[gstreamer]], [[vlc]], [[mpv]], [[handbrake]] — cada una con frontmatter, instalación, comandos y atajos.
- **Nota original reducida**: ahora es un índice con enlaces a las 4 notas hijas + sección de codecs y VAAPI.
- **MoC actualizado**: añadidos `[[gstreamer]] · [[vlc]] · [[mpv]] · [[handbrake]]` junto al índice existente.
- **Wikilinks actualizados**: 4 archivos (Snap y Flatpak.md, Video4Linux.md, TUI tools.md, Videojuegos en Linux.md).
- **Validación**: check-frontmatter.sh → 429/429 OK. find-orphans.sh --backlinks → 1 huérfana (README.md).

## 2026-07-26 — Fragmentación: Desarrollo en Linux → 4 notas individuales
- **Nota fragmentada**: `Desarrollo en Linux (gcc make gdb strace).md` contenía el toolchain completo de desarrollo C/C++.
- **4 notas nuevas**: [[gcc]], [[make]], [[gdb]], [[strace]] — cada una con frontmatter, flags/uso, troubleshooting y enlaces cruzados.
- **Nota original reducida**: ahora es un índice con toolchain de instalación, flujo de troubleshooting y tabla de alternativas modernas.
- **MoC actualizado**: añadidos `[[gcc]] · [[make]] · [[gdb]] · [[strace]]` junto al índice existente.
- **Validación**: check-frontmatter.sh → 433/433 OK. find-orphans.sh --backlinks → 1 huérfana (README.md).

## 2026-07-26 — Fragmentación: 6 comandos agrupados → 13 notas individuales
- **Notas fragmentadas**: sed+yawk, Touch+History, seq+yes+sleep, date+timedatectl, df+du, nohup+timeout+at — 6 notas que agrupaban entre 2 y 3 comandos cada una.
- **13 notas nuevas**: [[sed]], [[touch]], [[history]], [[seq]], [[yes]], [[sleep]], [[date]], [[timedatectl]], [[df]], [[du]], [[nohup]], [[timeout]], [[at]] — cada una con frontmatter, sintaxis, ejemplos y enlaces cruzados.
- **6 notas originales reducidas**: ahora son índices ligeros con enlaces a las notas hijas.
- **MoC actualizado**: 4 bloques del MoC reescritos para incluir los nuevos comandos.
- **Validación**: check-frontmatter.sh → 446/446 OK. find-orphans.sh --backlinks → 1 huérfana (README.md).

## 2026-07-26 — Fragmentación: Navegadores Web → 7 notas individuales
- **Nota fragmentada**: `Navegadores Web.md` contenía 10 navegadores en una sola nota (Firefox ya tenía nota propia).
- **7 notas nuevas**: [[Chromium]], [[Brave]], [[LibreWolf]], [[Vivaldi]], [[Ungoogled Chromium]], [[GNOME Web (Epiphany)]], [[Falkon]] — cada una con instalación, descripción y enlaces cruzados.
- **Nota original reducida**: ahora es un índice con tabla de motores, enlaces a las 8 notas (incluyendo Firefox) y gestión de perfiles.
- **MoC actualizado**: añadidos los 7 nuevos navegadores en la línea de Navegadores Web.
- **Validación**: check-frontmatter.sh → 453/453 OK. find-orphans.sh --backlinks → 1 huérfana (README.md).

## 2026-07-26 — Auditoría completa + fixes
- **Auditoría completa del vault**: 5 checks ejecutados (nombres de archivo, huérfanas, frontmatter, README vs realidad, estructura).
- **Hallazgos**: 1 error real (README: carpeta 10 decía 6 notas, son 5), 2 mejoras (Prompts de Trabajo no enlazada del MoC, setup.sh faltaba en tabla de scripts), todo lo demás ok.
- **Fixes**: README.md corregido (carpeta 10: 6→5, añadida fila setup.sh, fecha actualizada a 2026-07-26). MoC actualizado ([[Prompts de Trabajo]] añadido en Dashboard).
- **Validación**: check-frontmatter.sh → 415/415 OK. find-orphans.sh --backlinks → 1 huérfana real (README.md, intencional).

## 2026-07-25 (v5) — 5 notas nuevas de conceptos (SOs)

### 🆕 Notas creadas (01 - Conceptos Fundamentales)
- **[[Windows]]**: SO de Microsoft, NT vs 9x, comparativa con Linux (filesystem, permisos, comandos), WSL2.
- **[[macOS]]**: basado en UNIX (Darwin/Mach+BSD), Homebrew, launchd vs systemd, comparativa con Linux.
- **[[MS-DOS]]**: sistema operativo de línea de comandos (1981-1993), tabla comparativa de comandos DOS vs Bash, FAT32, herencia en Windows CMD.
- **[[UNIX]]**: historia completa (Bell Labs → System V → BSD → POSIX → Linux), filosofía UNIX, tabla de derivados.
- **[[Distribuciones de Linux]]**: qué son, 6 familias, tabla comparativa amplia, árbol de decisión, modelo de lanzamiento.

### 📌 MoC actualizado
- 5 notas añadidas en sección Fundamentos con descripciones y wikilinks.

### 🔍 Verificación
- `check-frontmatter.sh`: 5/5 OK. Frontmatter completo, hashtags correctos.
- Code reviewer: contenido preciso, wikilinks válidos, estilo consistente.

### 📊 Stats
- **Vault: 365 notas (+5).** Concepto: 38→43. 01 - Conceptos: 37→42.
- **Nuevos archivos**: Windows.md, macOS.md, MS-DOS.md, UNIX.md, Distribuciones de Linux.md.

## 2026-07-25 (v6) — 13 notas faltantes (wikilinks rotos)

### 🆕 Notas creadas (03 - Sistema)
- **[[ufw]]**: firewall simplificado (frontend nftables), comandos, profiles, troubleshooting.
- **[[NetworkManager]]**: daemon de gestión de red, nmcli, nmtui, WiFi, IP estática, VPN.

### 🆕 Notas creadas (07 - Comandos)
- **[[gdb]]**: GNU Debugger, breakpoints, core dumps, segfault analysis.
- **[[sha256sum]]**: hashes de integridad, verificar descargas, backups.
- **[[ltrace]]**: trazador de llamadas a librerías, malloc tracking.
- **[[groups]]**: gestión de grupos de usuarios, usermod -aG.

### 🆕 Notas creadas (08 - Programas)
- **[[ranger]]**: gestor de archivos TUI (Python), atajos, w3m preview.
- **[[iftop]]**: monitor de bandwidth por conexión, filtros pcap.
- **[[bmon]]**: monitor de bandwidth con gráficos ASCII.
- **[[nethogs]]**: monitor de bandwidth por proceso.
- **[[nvtop]]**: monitor de GPU TUI (NVIDIA/AMD/Intel).
- **[[lf]]**: gestor de archivos TUI (Go), alternativa rápida a ranger.
- **[[gdebi]]**: instalador de .deb con resolución de dependencias.

### 📌 MoC actualizado
- [[ufw]] añadido en sección Operativa.

### 📊 Stats
- **Vault: 378 notas (+13).**
- **Wikilinks rotos eliminados**: ufw, gdb, ranger, sha256sum, NetworkManager, iftop, bmon, nethogs, nvtop, ltrace, lf, gdebi, groups.

## 2026-07-25 (v7) — Expansiones nftables + Nextcloud + assets

### 📝 Notas expandidas
- **[[nftables]]** (03 - Sistema): 27 → ~180 líneas. Sets, maps, NAT (masquerade/SNAT/DNAT), rate limiting, logging, contadores, migración desde iptables, troubleshoot.
- **[[Nextcloud]]** (08 - Programas): 39 → ~180 líneas. Apps principales, 4 métodos de instalación (AIO, Docker, Snap, manual), Redis/OPcache, Fail2Ban, backups, clientes, 14 comandos occ.



### 📊 Stats finales de sesión
- **Vault: ~378 notas.** Cambios en 20+ archivos.

## 2026-07-25 (v8) — Auditoría completa + 22 notas nuevas

### 🔍 Auditoría del vault
- Ejecutadas todas las verificaciones: vault-stats.sh, find-orphans.sh, check-frontmatter.sh, wikilinks rotos.
- **379 notas**, 373 resueltas, 5 en progreso, 2 borrador (README/CLAUDE por diseño).
- **Frontmatter**: 379/379 OK, 0 errores.
- **Huérfanas**: 2 (Prompts de Trabajo, README) — archivos de estructura, no reales.
- **Corregido**: `[[iptables]]` y `[[md5sum]]` rotos → notas creadas.
- **Corregido**: `[[Automatización y Scripts]]` path completo en Arsenal Power User.
- **Eliminada**: carpeta vacía `02 - Instalacion y Configuracion/Distribuciones/`.

### 🆕 8 notas de prioridad alta (nuevas)
- **[[DevOps]]** (01 - Conceptos): definición, ecosistema de herramientas (Docker/K8s/Ansible/Terraform), pipeline CI/CD ejemplo.
- **[[systemd timers]]** (03 - Sistema): alternativa moderna a cron, OnCalendar, Persistent, comparativa con cron.
- **[[stat]]** (07 - Comandos): metadata de archivos, 3 timestamps (atime/mtime/ctime), formato personalizado.
- **[[file]]** (07 - Comandos): magic numbers, identificar tipo real de archivo, MIME type.
- **[[Docker Compose]]** (08 - Programas): archivos YAML multi-contenedor, profiles, watch, healthchecks.
- **[[Red no conecta]]** (09 - Troubleshooting): flujo de decisión completo (DNS/DHCP/firewall/cable).
- **[[Sistema no arranca]]** (09 - Troubleshooting): desde pantalla negra hasta kernel panic, live USB recovery.
- **[[Cron]]** (10 - Automatizacion): crontab, anacron, comparativa con systemd timers.

### 🆕 6 notas de prioridad media (nuevas)
- **[[Tmpfs y ramfs]]** (03 - Sistema): filesystems en memoria, /dev/shm, relación con zram.
- **[[initramfs]]** (03 - Sistema): qué es, generación (dracut/mkinitcpio/update-initramfs), cuándo regenerar.
- **[[nohup, timeout, at]]** (07 - Comandos): control de ejecución de procesos.
- **[[hyperfine]]** (08 - Programas): benchmarking CLI con análisis estadístico.
- **[[duf]]** (08 - Programas): df moderno con colores y barras de progreso.
- **[[seq, yes, sleep]]** (07 - Comandos): utilidades simples de secuencias y pausas.

### 🆕 8 notas de prioridad baja (nuevas)
- **[[atuin]]** (08 - Programas): shell history sync.
- **[[mise]]** (08 - Programas): gestor de versiones universal.
- **[[delta]]** (08 - Programas): git diff con syntax highlighting.
- **[[Impresora no funciona]]** (09 - Troubleshooting): CUPS, drivers, red.
- **[[Wayfire]]** (05 - Gestores): compositor Wayland tipo Compiz.
- **[[CutefishOS]]** (04 - Entornos): DE Wayland estética macOS.
- **[[Nushell]]** (06 - Terminal): shell estructurada con tablas tipadas.
- **[[seq yes sleep]]** — utilidades básicas CLI.

### 🔧 Scripts verificados
- **check-frontmatter.sh** + **find-orphans.sh**: ejecutados, 0 errores.

### 📌 MoC actualizado
- Todas las notas nuevas enlazadas con wikilinks y descripciones.

### 📊 Stats finales de sesión
- **Vault: 401 notas (+22 notas v8, +2 audit-fix iptables/md5sum, +13 wikilinks fix, +2 expansiones).**
- **Total archivos modificados hoy**: ~50+
- **Sesión más productiva del proyecto**: 22 notas nuevas + auditoría completa + expansiones + fixes.

## 2026-07-25 (v9) — 9 notas media nuevas + limpieza assets/raw/scripts

### 🆕 9 notas de prioridad media nuevas (commit `e5716cf`)
- **[[Fish]]** (06 - Terminal): shell con autocompletado predictivo, syntax highlighting, Fisher.
- **[[systemd-boot]]** (03 - Sistema): bootloader UEFI-only, entradas .conf, vs GRUB.
- **[[Ansible]]** (08 - Programas): playbooks YAML, roles, Galaxy, Vault, agentless.
- **[[just]]** (08 - Programas): ejecutor de tareas tipo make, justfile, vs Make.
- **[[btop]]** (08 - Programas): monitor de recursos TUI con gráficos.
- **[[COSMIC Desktop]]** (04 - Entornos): DE Rust por System76, cosmic-comp.
- **[[Garuda Linux]]** (11 - Distribuciones): Arch-based, Btrfs, Dracut.
- **[[Labwc]]** (05 - Gestores): compositor Wayland tipo Openbox.
- **[[Actualización rota]]** (09 - Troubleshooting): dpkg/apt/dnf/pacman repair.

> **Nota**: Cron, Tmpfs y ramfs, initramfs, nohup/timeout/at, hyperfine, duf, seq/yes/sleep ya estaban listados en v8.

### 🧹 Limpieza de assets, raw y scripts de descarga
- **Eliminados**: `assets/` (61 archivos, ~23 MB), `raw/` (29 HTML, ~7.3 MB).
- **Eliminados scripts**: `download-assets.sh`, `wikipedia-dl.py`, `urls.txt`.
- **Referencias limpiadas en 9 archivos**:
  - `CLAUDE.md`: sección "Assets locales" → "Imágenes externas" (solo enlaces).
  - `NixOS.md`, `Gentoo.md`, `Debian.md`, `Ubuntu.md`: eliminadas líneas de imagen.
  - `Log.md`: entradas v4, v7, v8 limpiadas de menciones a assets/scripts.
  - `TODO.md`: items eliminados marcados con tachado, encabezado actualizado a v9.
  - `.gitignore`: eliminadas entradas `.raw/` y `raw/`.
  - `Scripts del Vault.md`: tabla actualizada (7 scripts, incluye setup.sh).

### 📊 Stats
- **Vault: ~410 notas** (401 + 9 media nuevas). Commits: `e5716cf` (15 notas, incluye 6 ya listadas en v8).
- **Archivos eliminados**: ~93 (61 assets + 29 raw + 3 scripts).
- **Referencias rotas**: 0 tras la limpieza.

## 2026-07-25 (v10) — 6 notas baja + commits finales + rename

### 🆕 6 notas de prioridad baja nuevas
- **[[Firmware y BIOS-UEFI]]** (03 - Sistema): BIOS legacy vs UEFI, Secure Boot, ESP, fwupd.
- **[[Device nodes y udev]]** (03 - Sistema): /dev, nodos carácter/bloque, reglas udev, sysfs.
- **[[CI-CD]]** (01 - Conceptos): integración continua, despliegue continuo, GitHub Actions, GitLab CI, Jenkins.
- **[[LUKS2 y Btrfs]]** (03 - Sistema): cifrado de bloque + Btrfs, snapshots cifrados, borg backup.
- **[[Clear Linux]]** (11 - Distribuciones): distro Intel optimizada, swupd, bundles modulares.
- **[[Drauger OS]]** (11 - Distribuciones): distro gaming, Steam/Proton/Lutris, kernel optimizado.

### 🔧 Rename de archivo
- `nohup timeout at.md` → `nohup-timeout-at.md` (eliminados espacios del nombre).
- Commit: `596bf9b`.

### 📌 Commits de la sesión
- `cd43385` — 34 archivos nuevos (6 baja + 28 de sesiones anteriores), +4022 líneas.
- `7ffb936` — limpieza assets/raw/scripts, -1035 líneas, 9 referencias limpiadas.
- `596bf9b` — rename nohup-timeout-at.md.
- `e5716cf` — 15 notas media (commit previo).

### 📊 Stats finales de sesión 2026-07-25
- **Vault: 416 notas** (410 + 6 baja nuevas).
- **Commits hoy**: 4 commits (`e5716cf`, `cd43385`, `7ffb936`, `596bf9b`).
- **Notas creadas hoy**: ~55 (8 alta + 15 media + 14 baja + 13 wikilinks + 5 SOs).
- **Notas expandidas hoy**: 2 (nftables, Nextcloud).
- **Archivos eliminados**: ~93 (assets/raw/scripts).
- **Sesión más productiva del proyecto**: de ~357 a 416 notas (+59).

## 2026-07-25 (v11) — Fix duplicidad Cron: notas independientes

### 🔧 Cambio estructural
- **Eliminada** `Cron y Systemd Timers.md` (nota combinada redundante, ~500 líneas).
- **Expandida** `Cron.md` (10 - Automatizacion): de ~130 → **244 líneas**. Nuevas secciones: símbolos especiales, 7 ejemplos prácticos, redirigir salida, variables de entorno, system crontab, anacron detallado, tabla comparativa expandida, troubleshooting ampliado.
- **Expandida** `systemd timers.md` (03 - Sistema): de ~220 → **317 líneas**. Nuevas secciones: directivas de temporización extendidas (OnCalendar, monotónicos), timers de usuario + linger, tabla comparativa detallada, ejemplo backup con notificación, prevención de duplicados, troubleshooting ampliado.
- **Actualizados 14 archivos** que referenciaban `[[Cron y Systemd Timers]]`: MoC, Daemon, systemd, systemd unidades personalizadas, s6 init, timeshift, Monitorización, Administracion y Diagnostico, Automatizacion y Scripts, Git hooks, Scripts del Vault, openSUSE, Backups.
- **Verificación**: `grep -rn 'Cron y Systemd Timers'` → 0 resultados. `check-frontmatter.sh` → 415/415 OK.

### 📊 Stats
- **Vault: 415 notas** (416 - 1 eliminada).
- **Archivos modificados**: 16 (Cron.md, systemd timers.md, +14 wikilinks).
- **Archivos eliminados**: 1 (Cron y Systemd Timers.md).

## 2026-07-25 (v12) — Enlazar 49 notas huérfanas al MoC

### 📌 MoC actualizado
- **47 wikilinks añadidos** al MoC en 9 secciones:
  - Fundamentos: [[DevOps]], [[CI-CD]]
  - Sistema: [[initramfs]], [[Firmware y BIOS-UEFI]], [[systemd-boot]], [[LUKS2 y Btrfs]], [[iptables]], [[NetworkManager]], [[Device nodes y udev]], [[Tmpfs y ramfs]]
  - Entornos gráficos: [[COSMIC Desktop]], [[CutefishOS]], [[Labwc]], [[Wayfire]]
  - Terminal: [[Fish]], [[Nushell]]
  - Comandos: [[stat]], [[file]], [[groups]], [[sha256sum]], [[md5sum]], [[nohup-timeout-at]], [[seq yes sleep]], [[gdb]], [[ltrace]]
  - Programas: [[ranger]], [[lf]], [[Docker Compose]], [[delta]], [[duf]], [[btop]], [[iftop]], [[bmon]], [[nethogs]], [[nvtop]], [[gdebi]], [[just]], [[mise]], [[hyperfine]], [[atuin]]
  - Troubleshooting: [[Red no conecta]], [[Actualización rota]], [[Sistema no arranca]], [[Impresora no funciona]]
  - Distribuciones: [[Clear Linux]], [[Drauger OS]], [[Garuda Linux]]
- **Verificación**: `find-orphans.sh`: de 49 → **2** (solo README.md + Prompts de Trabajo.md, intencionales).
- **Frontmatter**: 415/415 OK.

### 📊 Stats
- **Vault: 415 notas.**
- **Links en MoC**: 410 (de 363).

## 2026-07-25 (v13) — Unificar tildes en nombres de archivos y carpetas

### 🔧 Renombres masivos
- **10 archivos renombrados** con tildes correctas:
  - `Administracion y Diagnostico` → `Administración y Diagnóstico`
  - `Compilacion desde Codigo Fuente` → `Compilación desde Código Fuente`
  - `Actualizacion entre versiones mayores` → `Actualización entre versiones mayores`
  - `Creacion de USB Booteable` → `Creación de USB Booteable`
  - `Post-Instalacion Checklist` → `Post-Instalación Checklist`
  - `Proceso de Instalacion General` → `Proceso de Instalación General`
  - `Actualizacion rota` → `Actualización rota`
  - `Resolucion de pantalla y multi-monitor` → `Resolución de pantalla y multi-monitor`
  - `Solucion de Problemas - Recursos` → `Solución de Problemas - Recursos`
  - `Automatizacion y Scripts` → `Automatización y Scripts`
- **3 carpetas renombradas**:
  - `02 - Instalacion y Configuracion` → `02 - Instalación y Configuración`
  - `09 - Solucion de Problemas` → `09 - Solución de Problemas`
  - `10 - Automatizacion y Scripts` → `10 - Automatización y Scripts`
- **Wikilinks actualizados** en todas las notas del vault mediante sed batch (solo dentro de `[[...]]`).
- **README.md y CLAUDE.md** actualizados con los nuevos nombres de carpeta.
- **Verificación**: `check-frontmatter.sh` 415/415 OK. `find-orphans.sh` → 2 intencionales. `grep` de nombres antiguos → 0 resultados.

### 📊 Stats
- **Vault: 415 notas.** Misma cantidad, todos los nombres ahora con tildes consistentes.

## 2026-07-26 — Fragmentación: Editores de Texto → 7 notas individuales
- **Nota fragmentada**: `Editores de Texto.md` contenía 10 editores en una sola nota (Nano, Vim, Micro ya tenían nota propia).
- **7 notas nuevas**: [[Helix]], [[Zed]], [[Lapce]], [[Antigravity]], [[Geany]], [[Kate]], [[Gedit]] — cada una con frontmatter, instalación, características y enlaces cruzados.
- **Nota original reducida**: ahora es un índice con tabla comparativa (wikilinks a los 10 editores), criterios de elección y referencia a [[Editores de código (VSCode Codium Zed Helix Antigravity)]].
- **MoC actualizado**: `[[Editores de Texto]] — índice + comparativa · [[Nano]] · [[Micro]] · [[Helix]] · [[Lapce]] · [[Zed]] · [[Antigravity]] · [[Geany]] · [[Kate]] · [[Gedit]]`.
- **Validación**: check-frontmatter.sh → 460/460 OK. find-orphans.sh --backlinks → 2 huérfanas (GNOME Web.md de sesión anterior, README.md).

## 2026-07-26 — Fragmentación: Diagnóstico de hardware → 5 notas individuales
- **Nota fragmentada**: `Diagnóstico de hardware (lspci lsusb dmidecode smartctl).md` contenía 6+ herramientas de hardware en una sola nota.
- **5 notas nuevas**: [[lspci]], [[lsusb]], [[dmidecode]], [[lshw]], [[smartctl]] — cada una con frontmatter, instalación, ejemplos y enlaces cruzados.
- **Nota original reducida**: ahora es un índice con diagrama ASCII, tabla de herramientas con wikilinks, buenas prácticas y referencias a notas existentes (hdparm, lscpu).
- **MoC actualizado**: `[[Diagnóstico de hardware]] — índice + tools · [[lspci]] · [[lsusb]] · [[dmidecode]] · [[lshw]] · [[smartctl]]`.
- **Validación**: check-frontmatter.sh → 465/465 OK. find-orphans.sh --backlinks → 2 huérfanas (GNOME Web.md, README.md).

## 2026-07-26 — Fragmentación: Emuladores de Terminal → 8 notas individuales
- **Nota fragmentada**: `Emuladores de Terminal.md` contenía 10+ emuladores en una sola nota entre DE defaults y alternativas populares.
- **8 notas nuevas**: [[GNOME Terminal]], [[Konsole]], [[Xfce Terminal]], [[Alacritty]], [[Kitty]], [[Foot]], [[st]], [[wezterm]] — cada una con frontmatter, instalación, características y enlaces cruzados.
- **Nota original reducida**: ahora es un índice con tabla comparativa de 8 wikilinks + características a considerar + transparencia.
- **MoC actualizado**: `[[Emuladores de Terminal]] — índice + comparativa · [[GNOME Terminal]] · [[Konsole]] · [[Xfce Terminal]] · [[Alacritty]] · [[Kitty]] · [[Foot]] · [[st]] · [[wezterm]]`.
- **Validación**: check-frontmatter.sh → ? | find-orphans.sh --backlinks → ?

## 2026-07-26 — Fragmentación: Gestores de Archivos → 8 notas individuales
- **Nota fragmentada**: `Gestores de Archivos.md` contenía 8+ gestores entre GUI (DE-defaults) y TUI en una sola nota.
- **8 notas nuevas**: [[Nautilus]], [[Dolphin]], [[Thunar]], [[Nemo]], [[PCManFM]], [[Double Commander]], [[SpaceFM]], [[nnn]] — con frontmatter, instalación, características y enlaces cruzados.
- **Notas existentes referenciadas**: [[ranger]], [[yazi]], [[lf]] ya tenían nota propia, ahora enlazadas desde el índice.
- **Nota original reducida**: ahora es un índice con tabla comparativa de 7 gestores gráficos + tabla de 4 gestores TUI.
- **MoC actualizado**: `[[Gestores de Archivos]] — índice + comparativa · [[Nautilus]] · [[Dolphin]] · [[Thunar]] · [[Nemo]] · [[PCManFM]] · [[Double Commander]] · [[SpaceFM]]`.
- **Validación**: check-frontmatter.sh → ? | find-orphans.sh --backlinks → ?

## 2026-07-26 — Fragmentación: Virtualización (KVM/QEMU/libvirt) → 3 notas individuales
- **Nota fragmentada**: `Virtualización (KVM QEMU libvirt).md` contenía KVM, QEMU y libvirt como stack completo en una sola nota (~400 líneas).
- **3 notas nuevas**: [[KVM]], [[QEMU]], [[libvirt]] — cada una con frontmatter, instalación, arquitectura, comandos clave y enlaces cruzados entre sí.
- **Nota original reducida**: ahora es un índice con diagrama ASCII del stack, tabla de componentes e instalación conjunta.
- **MoC actualizado**: `[[Virtualización (KVM QEMU libvirt)]] — índice del stack · [[KVM]] · [[QEMU]] · [[libvirt]]`.
- **Validación**: check-frontmatter.sh → ? | find-orphans.sh --backlinks → ?

## 2026-07-26 — Fragmentación: Monitorización (Prometheus/node_exporter) → 2 notas individuales
- **Nota fragmentada**: `Monitorización (Prometheus node_exporter).md` contenía Prometheus, node_exporter, Grafana y Alertmanager en una sola nota.
- **3 notas nuevas**: [[Prometheus]] (servidor, PromQL, alertas), [[node_exporter]] (métricas, colectores, systemd), y [[Grafana]] (dashboards visuales).
- **Nota original reducida**: ahora es un índice con tabla de componentes + arquitectura + tabla comparativa de opciones de monitorización.
- **MoC actualizado**: `[[Monitorización (Prometheus node_exporter)]] — índice del stack · [[Prometheus]] · [[node_exporter]]`.
- **Validación**: check-frontmatter.sh → ? | find-orphans.sh --backlinks → ?

## 2026-07-26 — Fragmentación: Suite de Oficina → 6 notas individuales
- **Nota fragmentada**: `Suite de Oficina.md` contenía 8 suites/herramientas ofimáticas en una nota.
- **6 notas nuevas**: [[OnlyOffice]], [[WPS Office]], [[FreeOffice]], [[Calligra Suite]], [[AbiWord]], [[Gnumeric]] — con frontmatter, instalación y enlaces cruzados.
- **Nota existente**: [[LibreOffice]] ya tenía nota propia desde antes.
- **Nota original reducida**: ahora es un índice con tabla comparativa de 8 suites + tabla de recomendación.
- **MoC actualizado**: `[[Suite de Oficina]] — índice + comparativa · [[LibreOffice]] · [[OnlyOffice]] · [[WPS Office]] · [[FreeOffice]] · [[Calligra Suite]] · [[AbiWord]] · [[Gnumeric]]`.
- **Validación**: check-frontmatter.sh → ? | find-orphans.sh --backlinks → ?

## 2026-07-26 — Fragmentación: Utilidades Base del Sistema → 2 notas individuales
- **Nota reestructurada**: `Utilidades Base del Sistema.md` mapeaba paquetes preinstalados (coreutils, binutils, procps-ng, systemd, etc.). Coreutils/util-linux, systemd, NetworkManager, CUPS, PipeWire, GRUB ya tenían notas propias.
- **2 notas nuevas**: [[binutils]] (strings, objdump, nm, strip, readelf) y [[procps-ng]] (ps, top, free, uptime, vmstat).
- **Nota original reducida**: ahora es un índice con tabla de 10 paquetes base + enlaces a sus notas dedicadas.
- **MoC actualizado**: `[[Utilidades Base del Sistema]] — índice de paquetes base · [[binutils]] · [[procps-ng]]`.
- **Validación**: check-frontmatter.sh → ? | find-orphans.sh --backlinks → ?

## 2026-07-26 — Completadas 10 notas en borrador → resuelto
- **Notas completadas** (10): [[AbiWord]], [[Antigravity]], [[Calligra Suite]], [[Double Commander]], [[Gnumeric]], [[Grafana]], [[PCManFM]], [[SpaceFM]], [[st]], [[wezterm]] — todas extraídas durante fragmentaciones previas.
- **Mejoras por nota**: secciones de atajos, tablas de formatos compatibles, ventajas/desventajas, ejemplos de uso, config examples y enlaces externos.
- **Nota nueva**: [[suckless]] — para reparar wikilink roto en st.md (que referenciaba a esta nota inexistente).
- **Estado**: las 10 notas pasaron de `borrador` → `resuelto`. Total: 489 resueltas + 5 templates en borrador.
- **Validación**: check-frontmatter → ✅ 496/496 OK | find-orphans → ✅ 2 huérfanas esperadas (GNOME Web.md, README.md)

## 2026-07-26 — Fragmentación completa: 8 notas agrupadas → ~20 notas individuales
- **PostgreSQL y MySQL** → [[PostgreSQL]], [[MySQL]] + índice comparativo
- **Vim Neovim** → [[Vim]], [[Neovim]] + índice comparativo
- **Logging del sistema** → [[journald]], [[rsyslog]], [[logrotate]] + índice
- **Bootloaders** → [[GRUB]], [[Limine]] ([[systemd-boot]] ya existía) + índice
- **SELinux y AppArmor** → [[SELinux]], [[AppArmor]] + índice
- **Gestión usuarios avanzada** → [[PAM]], [[chage]], [[chsh]], [[skel]] + índice
- **Cifrado** → [[LUKS]], [[GPG]] + índice
- **Gestores de Paquetes** → [[dnf]], [[Flatpak]], [[Snap]] ([[apt]], [[pacman]], [[AppImage]] ya existían) + índice
- **MoC actualizado**: 7 líneas actualizadas con wikilinks inline + descripciones.
- **Validación**: check-frontmatter → ✅ 516/516 OK | find-orphans → ✅ 2 huérfanas esperadas (GNOME Web.md, README.md)

## 2026-07-26 — Sesión completa: borradores → resuelto + fragmentación total + auditoría
- **10 notas en borrador completadas y puestas a resuelto**: AbiWord, Antigravity, Calligra Suite, Double Commander, Gnumeric, Grafana, PCManFM, SpaceFM, st, wezterm — todas con secciones de atajos, tablas de formatos, ventajas/desventajas, ejemplos de uso y enlaces externos.
- **Nota nueva**: [[suckless]] creada para reparar wikilink roto en [[st]].
- **Fragmentación final (8 notas → ~20 individuales)**:
  - PostgreSQL y MySQL → [[PostgreSQL]], [[MySQL]]
  - Vim Neovim → [[Vim]], [[Neovim]]
  - Logging del sistema → [[journald]], [[rsyslog]], [[logrotate]]
  - Bootloaders → [[GRUB]], [[Limine]]
  - SELinux y AppArmor → [[SELinux]], [[AppArmor]]
  - Gestión usuarios avanzada → [[PAM]], [[chage]], [[chsh]], [[skel]]
  - Cifrado → [[LUKS]], [[GPG]]
  - Gestores de Paquetes → [[dnf]], [[Flatpak]], [[Snap]]
- **GNOME Web.md renombrado** a GNOME Web (Epiphany).md — wikilink corregido en MoC, 1 huérfana eliminada.
- **MoC actualizado** con wikilinks inline en 7 líneas.
- **Validación**: check-frontmatter → 516/516 OK | find-orphans → 1 (README.md, intencional).
- **Vault**: ~516 notas. Sin notas agrupadas pendientes de fragmentar.

## 2026-07-27 — Expansión de 4 notas fragmentadas (segunda ronda)

### 📈 Notas expandidas

| Nota | Antes | Después | Secciones nuevas |
|---|---|---|---|
| [[LUKS]] | ~90 | **~270** | LUKS1 vs LUKS2 (tabla), detached headers, LVM sobre LUKS, TPM2 con systemd-cryptenroll, SSH unlock con dropbear, header backup/restore, resize, troubleshooting |
| [[chage]] | ~50 | **~110** | Salida `chage -l` completa, /etc/shadow fields, script de auditoría, tabla de casos de uso, cuenta de servicio sin caducidad |
| [[chsh]] | ~30 | **~75** | Opciones, validaciones de seguridad, /etc/passwd, casos de uso, troubleshooting table |
| [[skel]] | ~40 | **~90** | Estructura completa recomendada, personalización avanzada (.bashrc, .profile, user-dirs), personalización por grupo (-k flag), troubleshooting |

### ✅ Validación
- **check-frontmatter.sh**: 516/516 OK.
- **Code review**: 1 typo corregido ("rata" → "ruta" en chsh.md). Sin otros errores.

## 2026-07-27 — Expansión de 4 notas fragmentadas (alto impacto)

### 📈 Notas expandidas

| Nota | Antes | Después | Secciones nuevas |
|---|---|---|---|
| [[MySQL]] | ~100 | **~280** | Replicación GTID, Galera Cluster, performance_schema, user management avanzado, binary log management, troubleshooting table, Docker Compose |
| [[GPG]] | ~70 | **~230** | Subclaves + backup offline, Web of Trust + keyservers, firma Git commits, GPG como SSH agent, YubiKey/smartcards, cifrado híbrido (explicación), revocación con keyserver |
| [[rsyslog]] | ~80 | **~220** | RainerScript, templates JSON, filtrado avanzado, RELP+TLS, forwarding a BD (MySQL), imfile (log ingestion), colas disk-assisted, impstats, troubleshooting |
| [[logrotate]] | ~70 | **~200** | copytruncate vs create, compresión avanzada (bzip2/xz/zstd), dateext/dateformat, sharedscripts vs individual, prerotate, troubleshooting con permisos/SELinux |

### ✅ Validación
- **check-frontmatter.sh**: 516/516 OK. Sin errores.
- **Code review**: 4 notas sin errores críticos. Estilo consistente, wikilinks correctos, ejemplos técnicamente precisos.

## 2026-07-27 — Scripts optimizados + docs + MoC fix

### ⚡ Optimización de scripts (3)
- **vault-stats.sh**: single-pass combinado (estado+prioridad+categoria en 1 scan) + directorios con `find|awk`. **~11s → ~0.16s (68x)**
- **find-orphans.sh**: arrays asociativos O(1) en vez de O(n×m) loop. **~30s → ~6s (5x)**
- **add-modification-date.sh**: `perl -i` en vez de `sed -i`. **~23s → ~12s (2x)**

### 🔗 MoC fix
- [[suckless.md]] enlazada al MoC (Programas comunes). find-orphans ahora reporta 0 huérfanas.

### 📄 Documentación actualizada
- **Dashboard.md**: stats corregidas (509 resuelto, 215 alta, 162 media)
- **TODO.md**: v11 con sesiones completadas, 2 tareas movidas a ✅
- **README.md**: stats 516 notas, tiempos de scripts optimizados
- **Scripts del Vault.md**: documentación de optimizaciones y rendimiento

### ✅ Validación
- check-frontmatter.sh: 516/516 OK.
- find-orphans.sh: 0 huérfanas (suckless.md enlazada).

## 2026-08-29 — Creación de AGENTS.md + corrección de stats

### 🆕 AGENTS.md
- Creado `AGENTS.md` en la raíz con guía compacta para agentes de IA (flujo de validación vía `.githooks/`, formato de commit, convenciones de frontmatter/MoC/Log, restricciones de filenames).
- Añadido a las **exclusiones** de `pre-commit` y `pre-push` (como CLAUDE.md/README.md) y a la lista de estructura en `find-orphans.sh`.

### 📊 Stats corregidas (vault-stats.sh 2026-08-29)
- **Notas totales**: 516 → **517** (AGENTS.md). Resuelto 509, en progreso 5, borrador 3.
- **README.md**: conteos por carpeta corregidos (01=46, 02=13, 03=47, 07=109, 08=178, 11=45), fecha a 2026-08-29, fila duplicada de `find-orphans.sh` eliminada.
- **Dashboard.md** y **TODO.md**: totales y fecha de encabezado actualizados, tabla "por carpeta" corregida (01=46).

### ✅ Validación
- check-frontmatter.sh: 517 OK (CLAUDE/README/AGENTS/Log sin frontmatter por diseño).
- find-orphans.sh: 0 huérfanas (AGENTS.md excluida como nota de estructura).
