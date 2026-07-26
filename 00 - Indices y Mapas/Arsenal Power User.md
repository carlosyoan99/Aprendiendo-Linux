---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: indice
prioridad: alta
---

# 🧰 Arsenal Power User

> **Prioridad 3** — Especialización, automatización y alto rendimiento. Baja frecuencia, alto valor.
>
> Este MoC asume que ya dominas [[Dia a Dia en CLI]] (Prioridad 1) y [[Administración y Diagnóstico]] (Prioridad 2).

---

## 0. 🖥️ Terminal User Interfaces (TUIs)

Las herramientas TUI son esenciales para el power user:

| Herramienta | Para qué | Instalación |
|---|---|---|
| **lazygit** | Git visual (stage, commit, branch, merge) | `sudo apt install lazygit` |
| **gitui** | Git TUI alternativo en Rust | `sudo apt install gitui` |
| **ncdu** / **gdu** | Explorador de disco interactivo | `sudo apt install ncdu gdu` |
| **bottom** (btm) | Monitor de sistema moderno (gráficos) | `sudo apt install bottom` |
| **bat** | cat con syntax highlighting | `sudo apt install bat` |
| **procs** | ps moderno con árbol y colores | `sudo snap install procs` |
| **glances** | Dashboard sistema + web | `sudo apt install glances` |
| **trippy** | traceroute + ping visual | `sudo apt install trippy` |
| **zellij** | Multiplexor de terminal moderno | `sudo apt install zellij` |
| **glow** | Visor Markdown bonito | `sudo apt install glow` |

> Ver [[TUI tools]] para la guía completa con ejemplos de uso y comparativas.

---

## 1. 🐚 Shell Scripting Avanzado

### Bash scripts profesionales

| Herramienta | Para qué | Nota |
|---|---|---|
| `set -euo pipefail` | Modo estricto: fallar en errores, variables indefinidas | [[bash-avanzado]] |
| `[[ ]]` vs `[ ]` | Condicionales modernos con regex, `&&`, `\|\|` | [[bash-avanzado]] |
| `case` / `for` / `while` | Bucles y condicionales múltiples | [[bash-avanzado]] |
| Arrays y arrays asociativos | Datos estructurados en bash 4+ | [[bash-avanzado]] |
| `trap` | Manejo de señales, limpieza al salir | [[bash-avanzado]] |
| Expansiones `${var:-}` | Valores por defecto, prefijos, sufijos | [[bash-avanzado]] |
| Funciones con `local` | Ámbito de variables en scripts modulares | [[bash-avanzado]] |

### Procesamiento de texto

| Comando | Para qué | Nota |
|---|---|---|
| `awk` | Procesar columnas, reportes, sumas | [[awk]] |
| `sed` | Stream editor: buscar/reemplazar, eliminar líneas | [[sed y awk]] |
| `grep -P` | Regex Perl-compatible en búsquedas | [[grep]] |

### Scripts del vault

| Script | Propósito |
|---|---|
| `scripts/vault-stats.sh` | Estadísticas del vault |
| `scripts/check-frontmatter.sh` | Validar frontmatter de notas |
| `scripts/daily-log.sh` | Log diario automatizado |
| `scripts/find-orphans.sh` | Detectar notas huérfanas |

> [[Automatización y Scripts]]

---

## 2. 🧠 Kernel y Módulos

| Tema | Comandos clave | Nota |
|---|---|---|
| Cargar/descargar módulos | `modprobe`, `modprobe -r`, `insmod`, `rmmod` | [[Módulos del kernel (lsmod modprobe blacklist)]] |
| Información de módulos | `lsmod`, `modinfo` | [[Módulos del kernel (lsmod modprobe blacklist)]] |
| Blacklist | `/etc/modprobe.d/blacklist.conf` | [[Módulos del kernel (lsmod modprobe blacklist)]] |
| Parámetros de arranque | `GRUB_CMDLINE_LINUX` en `/etc/default/grub` | [[Proceso de Arranque (GRUB initramfs kernel params)]] |
| Tuning del kernel | `sysctl`, `/etc/sysctl.d/*.conf` | [[sysctl]] |
| Parámetros de red | `net.ipv4.tcp_syncookies`, `net.core.somaxconn` | [[sysctl]] |
| Parámetros de memoria | `vm.swappiness`, `vm.dirty_ratio`, `vm.vfs_cache_pressure` | [[sysctl]] |
| Versiones del kernel | Timeline LTS, innovaciones por versión | [[Historial de versiones del kernel de Linux]] |

### Comprobación rápida

```bash
# ¿Qué kernel tengo?
uname -r

# ¿Módulos cargados?
lsmod | head -20

# ¿Parámetro sysctl activo?
sysctl vm.swappiness

# ¿Secure boot activo?
mokutil --sb-state
```

---

## 3. 📦 Contenedores y Virtualización

| Tecnología | Para qué | Comando inicial | Nota |
|---|---|---|---|
| **Docker** | Contenedores de aplicaciones | `docker run`, `docker build` | [[Docker]] |
| **Podman** | Docker sin daemon, rootless | `podman run`, `podman build` | [[Docker]] |
| **systemd-nspawn** | Contenedores ligeros tipo chroot++ | `systemd-nspawn -D /ruta` | [[systemd-nspawn]] |
| **LXC / Incus** | Contenedores del sistema (como VMs ligeras) | `lxc launch`, `incus launch` | [[LXC y Contenedores del Sistema]], [[Incus]] |
| **KVM / QEMU** | Virtualización completa | `virt-manager`, `virsh` | [[Virtualización (KVM QEMU libvirt)]] |
| **Proxmox VE** | Hipervisor tipo 1 | Web UI + `qm` CLI | [[Proxmox VE]] |

```bash
# Comparativa rápida de contenedores
# Docker/Podman → aplicaciones empaquetadas
# LXC/Incus      → sistemas completos (como VMs ligeras)
# systemd-nspawn → chroot con esteroides
```

> Ver [[Contenedores - Comparativa LXC LXD Incus Docker Podman systemd-nspawn]].

---

## 4. ✍️ Editores y Entornos

| Editor | Configuración clave | Nota |
|---|---|---|
| **Vim / Neovim** | `.vimrc` / `init.vim`, plugins (vim-plug), LSP | [[Vim Neovim]] |
| **Nano** | `.nanorc`, syntax highlighting | [[Nano]] |
| **Micro** | Editor moderno tipo nano con plugins | [[Micro]] |
| **VSCode / Codium** | Configuración sincronizada, Settings Sync | [[Editores de código (VSCode Codium Zed Helix Antigravity)]] |
| **Helix** | Editor modal moderno (built-in LSP) | [[Editores de código (VSCode Codium Zed Helix Antigravity)]] |

### Gestión de dotfiles

| Herramienta | Para qué | Comandos básicos |
|---|---|---|
| **GNU Stow** | Symlink manager minimalista | `stow -t $HOME bash`, `stow -D bash` |
| **chezmoi** | Gestión declarativa de dotfiles | `chezmoi init`, `chezmoi add ~/.bashrc`, `chezmoi apply` |
| **Manual** | Script bash simple | `ln -s ~/dotfiles/.bashrc ~/.bashrc` |

> Ver [[Symlinks y Dotfiles]] y [[Mis Dotfiles]] (MoC con plantillas).

---

## 5. 🔒 Seguridad Ofensiva/Defensiva

| Herramienta | Para qué | Nota |
|---|---|---|
| **SELinux** | MAC (Fedora/RHEL) — contextos, booleanos, audit | [[SELinux y AppArmor]] |
| **AppArmor** | MAC (Ubuntu/Debian) — perfiles por programa | [[SELinux y AppArmor]] |
| **auditd** | Auditoría del sistema: quién, qué, cuándo | [[auditd]] |
| **ausearch** | Buscar eventos de auditoría | [[auditd]] |
| **aureport** | Reportes de seguridad | [[auditd]] |
| **strace** | Traza de syscalls (debug de permisos, archivos) | [[Desarrollo en Linux (gcc make gdb strace)]] |
| **ltrace** | Traza de llamadas a librerías | [[Desarrollo en Linux (gcc make gdb strace)]] |
| **fail2ban** | Protección contra fuerza bruta (SSH, web) | [[fail2ban]] |
| **Firewall** | ufw, firewalld, nftables, iptables | [[Firewall]] |
| **SSH hardening** | No root, solo claves, cambio de puerto | [[SSH]] |

### Flujo de investigación de seguridad

```bash
# 1. ¿Hay actividad sospechosa?
sudo lastb                    # intentos de login fallidos
sudo journalctl -u sshd | grep "Failed password"

# 2. ¿Archivos críticos modificados?
sudo ausearch -f /etc/passwd -ts today

# 3. ¿Puertos abiertos?
ss -tulpn

# 4. ¿Procesos inusuales?
ps auxf | grep -v "\[" | sort -k3 -rn | head -20

# 5. ¿Reglas de firewall activas?
sudo ufw status verbose
```

---

## 6. ⚡ Rendimiento

| Herramienta | Para qué | Nota |
|---|---|---|
| **perf** | Profiling de CPU (estadísticas, muestreo, flamegraphs) | [[perf]] |
| **perf stat** | Contadores de rendimiento (IPC, cache misses, branches) | [[perf]] |
| **perf record/report** | Muestreo de callchains, hotspots | [[perf]] |
| **FlameGraphs** | Visualización de perf.data en SVG | [[perf]] |
| **perf top** | Monitor de funciones en tiempo real | [[perf]] |
| **nice/renice** | Prioridad de procesos (CPU) | [[Procesos y Senales]] |
| **ionice** | Prioridad de E/S (disco) | [[Procesos y Senales]] |
| **cgroups v2** | Límites de CPU, memoria, E/S por servicio | [[cgroups (control de recursos)]] |

### Diagnóstico rápido de rendimiento

```bash
# ¿CPU o I/O bound?
perf stat -r 3 ./app 2>&1 | grep "instructions per cycle"
# IPC > 1 → compute bound; IPC < 0.5 → memory bound

# ¿Swapping?
vmstat 1

# ¿CPU saturada?
htop                   # o: mpstat -P ALL 1

# ¿Disco lento?
iotop                  # o: iostat -x 1
```

---

## 7. 🐞 Debugging y Análisis

| Herramienta | Para qué | Nota |
|---|---|---|
| **gdb** | Depurador de C/C++ (breakpoints, core dumps) | [[Desarrollo en Linux (gcc make gdb strace)]] |
| **strace** | Traza de syscalls (permisos, archivos, red) | [[Desarrollo en Linux (gcc make gdb strace)]] |
| **ltrace** | Traza de llamadas a librerías | [[Desarrollo en Linux (gcc make gdb strace)]] |
| **AddressSanitizer** | Detectar buffer overflows (-fsanitize=address) | [[Desarrollo en Linux (gcc make gdb strace)]] |
| **valgrind** | Fugas de memoria (más lento que ASan) | [[Desarrollo en Linux (gcc make gdb strace)]] |
| **ldd** | Dependencias de librerías | [[Desarrollo en Linux (gcc make gdb strace)]] |
| **perf** | Profiling de rendimiento | [[perf]] |

### Flujo de debugging

```
1. ¿Falta librería?         → ldd ./app | grep "not found"
2. ¿Error de permisos?      → strace -e trace=open ./app
3. ¿Crash sin mensaje?      → gcc -g -o app app.c && gdb ./app
4. ¿Crash en producción?    → ulimit -c unlimited → gdb ./app core
5. ¿Rendimiento lento?      → perf record -g ./app → perf report
6. ¿Fuga de memoria?        → valgrind ./app (lento) o -fsanitize=address (rápido)
```

---

## 8. 📁 Dotfiles y Personalización

| Recurso | Contenido |
|---|---|
| [[Symlinks y Dotfiles]] | Hard/soft links, GNU Stow, chezmoi, script manual |
| [[Mis Dotfiles]] (MoC) | Plantillas descargables de .bashrc, .gitconfig, .nanorc, init.vim |
| [[XDG Base Directory y dotfiles modernos]] | Estándar XDG, $XDG_CONFIG_HOME |
| [[La Shell]] | Prompt, alias, funciones, keybindings |

---

## Resumen de comandos por área

```bash
# Shell scripting
set -euo pipefail     ; [[ -f "$f" ]]  ; for i in {1..5} ; case "$1" in
# Kernel
modprobe && lsmod     ; sysctl -w       ; sysctl --system    ; mokutil
# Contenedores
docker run            ; podman run      ; systemd-nspawn     ; virsh
# Seguridad
getenforce            ; aa-status       ; sudo ausearch      ; sudo fail2ban-client
# Rendimiento
perf stat ./app       ; perf record -g  ; perf report        ; nice -n 10
# Debugging
gdb ./app             ; strace -f ./app ; ldd /usr/bin/git   ; valgrind
# Editores
vim archivo.txt       ; nano archivo    ; micro archivo      ; code .
# Dotfiles
stow -t $HOME bash    ; chezmoi add ~/.bashrc
```

## Enlaces externos

- [Perf Wiki — profiling con perf](https://perf.wiki.kernel.org/)
- [Arch Wiki — Kernel modules](https://wiki.archlinux.org/title/Kernel_modules)
- [Docker Docs](https://docs.docker.com/)
- [SELinux Project Wiki](https://selinuxproject.org/page/Main_Page)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [chezmoi — dotfile manager](https://www.chezmoi.io/)

## Ver también

- [[Dia a Dia en CLI]] — Prioridad 1: fundamentos diarios
- [[Administración y Diagnóstico]] — Prioridad 2: troubleshooting y administración
- [[MoC - Linux]] — mapa de contenido completo del vault
- [[Rutas de Aprendizaje]] — guía de priorización

#indice #poweruser
