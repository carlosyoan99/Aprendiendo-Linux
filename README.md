# AprendiendoLinux 🐧

Vault de **Obsidian** para documentar el aprendizaje de Linux de forma incremental: conceptos, comandos, programas, entornos gráficos y soluciones a problemas reales.

## 📂 Estructura

| Carpeta | Contenido | Notas |
|---|---|---|
| `00 - Indices y Mapas` | MoC, Dashboard, Rutas de Aprendizaje, TODO, Arsenal Power User, Comparativas | 13 |
| `01 - Conceptos Fundamentales` | Kernel, GNU, Docker, contenedores, LFS, namespaces, locale, NTP, historia, DevOps, CI/CD | 46 |
| `02 - Instalación y Configuración` | Particionado, USB booteable, dual boot, cifrado, dist-upgrade, gestores de paquetes | 13 |
| `03 - Estructura del Sistema` | systemd, permisos, procesos, D-Bus, firewalls, ACLs, redes, audio, LVM, SELinux, FHS, /proc+/sys, boot, logging, RAID, cgroups, udev, firmware, LUKS2+Btrfs | 49 |
| `04 - Entornos de Escritorio` | GNOME, KDE Plasma, XFCE, Cinnamon, MATE, Budgie, Deepin, CDE, Sugar, Trinity, Pantheon, LXQt, Enlightenment, COSMIC Desktop, CutefishOS + Desktop Shells | 18 |
| `05 - Gestores de Ventanas` | i3, Hyprland, DWM, Awesome WM, Sway, bspwm, qtile, River, Openbox, Fluxbox, herbstluftwm, Niri, Labwc, Wayfire + tiling WMs | 15 |
| `06 - La Terminal` | Shell, shells (bash/zsh/fish), tmux, screen, Fish, Nushell, atajos, tuberías y redirecciones | 6 |
| `07 - Comandos Esenciales` | **122 comandos** documentados (Coreutils + util-linux, sudo, nano, vim, man, stat, file, gdb, sha256sum, groups, ltrace...) + cheat sheet | 122 |
| `08 - Programas y Herramientas` | Ansible, Git, KVM, Docker, Docker Compose, Nmap, Nginx, Samba, FFmpeg, WireGuard, editores, bases de datos, backups, monitors, juegos, audio, TUI tools, just, btop, hyperfine, duf, atajos de teclado | 211 |
| `09 - Solución de Problemas` | Recursos + **19 problemas resueltos** (WiFi, permisos, sonido, SSH, Docker, fuentes, paquete roto, pantalla negra, disco lleno, teclado, Bluetooth, resolución, reloj, NVIDIA, GRUB, red no conecta, sistema no arranca, impresora) | 19 |
| `10 - Automatización y Scripts` | Scripts propios (7: stats, weekly, logs, validación, huérfanas, fechas, setup), cron, git hooks, Log.md, docs | 10 |
| `11 - Distribuciones` | Catálogo completo de 50 distros (Ubuntu, Debian, Arch, Fedora, Mint, NixOS, Gentoo, Kali, Clear Linux, Drauger OS, Garuda...) | 50 |
| `Templates` | 7 plantillas reutilizables (comando, concepto, programa, distro, entorno/WM, problema, log) | 7 |

> **568 notas** documentando el ecosistema Linux: conceptos, comandos, programas, distribuciones, troubleshooting y más.

## 📊 Estado actual (2026-09-02)

| Métrica | Valor |
|---|---|
| **Notas totales** | **612** (+ 9 templates) |
| **Estado resuelto** | 582 |
| **Estado en progreso** | 6 (TODO, MoC, Dashboard, Log, Log-2026, Prompts de Trabajo) |
| **Estado borrador** | 0 |
| **Prioridad alta** | 216 |
| **Prioridad media** | 196 |
| **Prioridad baja** | 146 |
| **Categorías** | 12 |
| **Scripts de automatización** | 7 (stats, weekly, logs, validación, huérfanas, fechas, setup) |
| **Git hooks** | 3 (pre-commit, commit-msg, pre-push) |
| **Repositorio Git** | ✅ Inicializado (local) |

### Distribución por categoría

| Categoría | Notas | Categoría | Notas |
|---|---|---|---|
| **Programa** | 211 | **Comando** | 122 |
| **Concepto** | 49 | **Distribución** | 46 |
| **Sistema** | 50 | **Entorno / WM** | 33 |
| **Troubleshooting** | 19 | **Índice** | 13 |
| **Instalación** | 13 | **Terminal** | 5 |
| **Automatización** | 8 | **Log** | 2 |

## 🚀 Primeros pasos en Obsidian

1. Abrir esta carpeta como vault en **Obsidian** (File → Open Vault → Open folder as vault)
2. Instalar los plugins recomendados desde Settings → Community plugins:
   - **Dataview** — motor de consultas que alimenta el Dashboard
   - **Templater** — permite usar `{{date}}` y prompts en las plantillas
   - **Tasks** — checkboxes con fecha y prioridad
   - **QuickAdd** (opcional) — atajos de teclado para crear notas rápido
3. Configurar Templater: Settings → Templater → Template folder location → `Templates/`
4. Empezar por [[Rutas de Aprendizaje]] para ver qué priorizar
5. Usar el **Dashboard** (`00 - Indices y Mapas/Dashboard.md`) para filtrar por estado y categoría

## 🧰 Scripts de automatización

Todos en `scripts/`. Documentación completa en [[Scripts del Vault]].

| Script | Función |
|---|---|
| `daily-log.sh` | Crea nota de log diaria individual |
| `vault-stats.sh` | Estadísticas completas (--csv, --resumen) |
| `vault-stats-weekly.sh` | Wrapper cron para stats semanales |
| `check-frontmatter.sh` | Valida frontmatter de todas las notas |
| `find-orphans.sh` | Encuentra notas no enlazadas del MoC |
| `setup.sh` | Configuración inicial del vault (hooks, cron, verificación) |
| `add-modification-date.sh` | Sincroniza fecha_modificacion con mtime (perl) |

> ⚡ Los scripts han sido optimizados: `vault-stats.sh` pasó de ~11s a **~0.16s** (68x más rápido), `find-orphans.sh` de ~30s a ~6s, y `add-modification-date.sh` de ~23s a ~12s.

```bash
# Configuración cron recomendada (domingos)
# 0 8 * * 0 /path/scripts/add-modification-date.sh   # fechas
# 0 9 * * 0 /path/scripts/vault-stats-weekly.sh      # stats
```

## 🗺️ TODO y Roadmap

Ver `00 - Indices y Mapas/TODO.md` para el plan de trabajo completo, fases completadas y próximos pasos.

## 📝 Para la IA

El archivo `CLAUDE.md` en la raíz define las reglas que cualquier agente LLM debe seguir al leer, mantener o expandir este vault. Léelo antes de hacer cambios automatizados.
