---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-08-31
estado: en progreso
categoria: log
---

# Log de Aprendizaje

Registro **compacto** de sesiones (una fila por sesión). El detalle extenso de cada sesión se registra en `00 - Indices y Mapas/TODO.md` (sección NOTAS); aquí solo un resumen de una línea.

> **Rotación**: cuando `Log.md` supere ~25 sesiones, mueve las más antiguas a `Log-2026.md` (el archivo del año en curso) y deja aquí solo las recientes. Al cambiar de año, el `Log.md` actual pasa a `Log-<año>.md` y empieza uno nuevo. Nunca borres historial del archivo de año — solo se traslada.

Historial completo del año (detallado): [[Log-2026]].

---

## 📋 Registro activo

| Fecha | Sesión | Tipo | Ámbito | Resumen |
|---|---|---|---|---|
| 2026-09-02 | v48 | fix | 05/11 | 4 notas v47 (Oracle Linux, fvwm, Ratpoison, evilwm) → resuelto |
| 2026-09-02 | v47 | feat | 05/11/MoC | 4 notas nuevas de cobertura: Oracle Linux (distro RHEL), fvwm, Ratpoison, evilwm (WMs X11); MoC actualizado |
| 2026-09-03 | v60 | feat | 08 | 1 nota nueva journald (logs systemd: journalctl, filtros, persistencia, auditoría) + dmidecode expandida (88→145: DMI types, -s strings, detectar VM, comparativa lshw/inxi); MoC actualizado |
| 2026-09-03 | v59 | expand | 08 | 8 notas 08 con Comparativa añadida: jq (yq/fx/gron/jql), QEMU (VirtualBox/VMware/UTM), libvirt (Incus/VirtualBox/Podman), Genkernel (dracut/mkinitcpio/update-initramfs), node_exporter (Telegraf/collectd/Netdata), Prometheus (InfluxDB/VictoriaMetrics/Zabbix), V4L2 (libcamera/PipeWire), Multimedia (GStreamer/VLC/MPV/HandBrake) |
| 2026-09-03 | v58 | expand | 00 | Comparativa contenedores expandida (¿400→520): seguridad (superficie ataque, rootless, userns), migraciones Docker→Podman/LXD→Incus/nspawn→Incus, redes (bridge/host/macvlan/port mapping) |
| 2026-09-03 | v57 | expand | 08 | WireGuard VPN expandida (304→518): QR móviles, PSK, wg syncconf, systemd-networkd, Docker, firewall ufw/nftables/firewalld, MTU, kill switch DNS |
| 2026-09-03 | v56 | feat | 08 | 1 nota nueva: Grabación de pantalla y streaming (OBS, VAAPI/NVENC, wf-recorder, gpu-screen-recorder, baja latencia, Twitch/YouTube); MoC actualizado |
| 2026-09-03 | v55 | feat | 08/09 | 2 notas nuevas: VirtualBox (Type 2, CLI, snapshots, Guest Additions), Problemas de audio avanzados (routing multi-device, Bluetooth A2DP, HDMI, latencia, migración PipeWire); MoC actualizado |
| 2026-09-03 | v54 | feat | 08 | 3 notas nuevas atajos: Git (aliases, funciones shell, staging/rebase), Docker CLI (aliases Docker/Compose, containers), Neovim (LSP, Telescope, buffers, tabs); MoC actualizado |
| 2026-09-03 | v53 | feat | 01 | 3 notas nuevas seguridad: SSH Hardening (claves, fail2ban, certs, port knocking), AppArmor (MAC, perfiles, containers), DNS encriptado (DoH/DoT, systemd-resolved, proveedores); MoC actualizado |
| 2026-09-03 | v52 | feat | 09 | 4 notas nuevas troubleshooting: Suspend-Resume no funciona, Permisos Flatpak, Arranque lento, Fuga de memoria; MoC actualizado |
| 2026-09-03 | v50 | feat | 09 | 3 notas nuevas troubleshooting: Kernel Panic, Display Manager no arranca, USB no detecta; MoC actualizado |
| 2026-09-02 | v49 | expand | 08 | 14 notas 08 con Comparativa añadida: hexyl, eza, vlc, mpv, KVM, restic, kew, yq, Go, Cargo, Gem, Grafana, fail2ban, Proton |
| 2026-09-02 | v48 | feat | 01/03 | 3 notas nuevas: Accesibilidad en Linux, Gestión de energía y batería, Compatibilidad Wayland; MoC actualizado |
| 2026-09-02 | v47b | fix | 05/11 | 4 borradores extras → resuelto (Ratpoison, evilwm, fvwm, Oracle Linux); 0 borradores restantes |
| 2026-09-02 | v47 | feat | 08 | 5 notas nuevas de atajos de teclado: tmux, Vim, Hyprland, LibreOffice, Chromium; MoC actualizado |
| 2026-09-02 | v46 | fix | 04/05/11 | 13 borradores → resuelto (5 WMs/DEs + 8 distros); hashtags #DE-WM → #entorno-escritorio; 0 borradores restantes |
| 2026-09-02 | v45 | docs | — | README.md actualizado con stats reales (568 notas, 557 resuelto, 206 programa, 122 comando) |
| 2026-09-02 | v42b | expand | 01/08/11 | 6 notas expandidas: AUR (78→120), Firefox OS (82→93), Debate Tanenbaum-Torvalds (83→92), lsusb (83→109), Ungoogled Chromium (86→106), Dolphin (86→108) |
| 2026-09-02 | v44 | fix | 08/10/MoC | Auditoría: 3 CJK corregidos (PCManFM, Log-2026), ethtool añadido al MoC, wikilinks verificados |
| 2026-09-02 | v43 | feat | 07/08 | 6 notas nuevas: sshfs, mtr, inotifywait, ncdu, flatpak-builder, yq; MoC actualizado |
| 2026-09-02 | v42 | expand | 08 | 10 notas programa 08 cortas expandidas a ~100-140 líneas (kew, Antigravity, Gem, Gnumeric, google-chrome, Proton, snapper, Calligra, FreeOffice, st) |
| 2026-09-01 | v41 | expand | 05 | labwc (WM Wayland) expandido: modelo stacking, labwc vs Openbox/Sway/Wayfire, troubleshooting |
| 2026-09-01 | v40 | expand | 08 | procps-ng reescrito + troubleshooting en lspci/lsusb/dmidecode (diagnóstico hardware 08) |
| 2026-09-01 | v39 | expand | 07 | comandos 07 (cut, seq/yes/sleep, basename/dirname) ampliados con casos de uso y troubleshooting |
| 2026-09-01 | v38 | docs | — | TODO.md: lotes 1 completados marcados + stats corregidas (551 resuelto/191 media/145 baja) |
| 2026-08-31 | v37 | feat | 07/08/11/hooks | 4 notas nuevas (7z AUR FRRouting Proton) + fix links rotos + pre-push ignora código inline + pre-commit sincroniza fecha_modificacion |
| 2026-08-31 | v36 | docs | — | TODO.md: estadísticas actualizadas (556 notas, 6 en progreso, 201 programa, log 2) |
| 2026-08-31 | v35 | expand | 07 | Lote 2: 6 comandos 07 (date sed du history timedatectl md5sum) → ~100+ líneas |
| 2026-08-31 | v34 | expand | 08 | Lote 1: 13 notas de programa 08 (uso diario) expandidas a ~100 líneas |
| 2026-08-31 | v34 | expand | 07 | 7 notas comando 07 restantes (nc, tar, expr, yes, paste, nl, comm) expandidas a ~120+ líneas |
| 2026-08-31 | v33 | expand | 07 | Lote 2: 7 notas comando 07 (du, md5sum, history, date, sed, zip, chmod) expandidas a ~120+ líneas |
| 2026-08-31 | v32 | expand | 08/11 | Lote 2+3: 8 notas programa 08 + 11 notas distro 11 expandidas a ~130+ líneas |
| 2026-08-31 | v31 | docs | — | AGENTS.md: flujo de commit por fase; TODO.md con stats reales (554 notas) |
| 2026-08-30 | v30 | fix | 04/05/11/03/07 | Media/baja: estructura duplicada limpiada, 2 títulos alineados |
| 2026-08-30 | v29 | fix | 01/03/07/08/11 | Alta: 8 errores factuales, 4 textos CJK, duplicado Actualización rota |
| 2026-08-31 | v28 | expand | 08 | 12 notas de programa 08 antiguas → ~130 líneas |
| 2026-08-30 | v27 | fix | 03/07/08/11 | 8 CJK corregidos, duplicados gdb/strace, rename yt-dlp |
| 2026-08-30 | v25 | expand | 06/08 | 3 terminal/monitores + 5 notas de atajos de teclado |
| 2026-08-30 | v24 | feat | 08 | 8 notas nuevas de programa (rclone, eza, zoxide, starship…) |
| 2026-08-30 | v22 | expand | 01/02/09 | Hub Gestores de Paquetes + 5 concepto/troubleshooting |
| 2026-08-30 | v21 | expand | 08 | 8 notas de programa cortas → ~120-150 líneas |
| 2026-08-30 | v20 | feat | 03/07 | Notas nuevas systemctl + fstab (alta) |
| 2026-08-30 | v19 | feat | 10/08/01/04 | Personalización al sistema real, 10 programas, scripts systemd |

---

## ➕ Añadir una sesión

Para registrar una sesión nueva, añade **una fila** a la tabla anterior con:

| Campo | Qué poner |
|---|---|
| **Fecha** | `AAAA-MM-DD` (fecha del día). |
| **Sesión** | `vNN` (número correlativo de sesión). |
| **Tipo** | Mismo tipo que el commit de la fase: `feat` / `fix` / `docs` / `expand` / `refactor` / `chore`. |
| **Ámbito** | Carpetas o categorías tocadas (p. ej. `08/07`), o `—` si no aplica. |
| **Resumen** | Una línea breve (qué se hizo y cuánto). Sin listas ni subtítulos. |

El detalle (tablas, notas tocadas, validación) va **solo** en `TODO.md` → sección NOTAS, no aquí. Si la fila no cabe en una línea, resume aún más.
