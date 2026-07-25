# AprendiendoLinux 🐧

Vault de **Obsidian** para documentar el aprendizaje de Linux de forma incremental: conceptos, comandos, programas, entornos gráficos y soluciones a problemas reales.

## 📂 Estructura

| Carpeta | Contenido | Notas |
|---|---|---|
| `00 - Indices y Mapas` | MoC, Dashboard, Rutas de Aprendizaje, TODO, Arsenal Power User, Comparativas | 12 |
| `01 - Conceptos Fundamentales` | Kernel, GNU, Docker, contenedores, LFS, namespaces, locale, NTP, historia | 35 |
| `02 - Instalacion y Configuracion` | Particionado, USB booteable, dual boot, cifrado, dist-upgrade, gestores de paquetes | 9 |
| `03 - Estructura del Sistema` | systemd, permisos, procesos, D-Bus, firewalls, ACLs, redes, audio, LVM, SELinux, FHS, /proc+/sys, boot, logging, RAID, cgroups | 28 |
| `04 - Entornos de Escritorio` | GNOME, KDE Plasma, XFCE, Cinnamon, MATE, Budgie, Deepin, CDE, Sugar, Trinity, Pantheon, LXQt, Enlightenment + Desktop Shells | 15 |
| `05 - Gestores de Ventanas` | i3, Hyprland, DWM, Awesome WM, Sway, bspwm, qtile, River, Openbox, Fluxbox, herbstluftwm, Niri + tiling WMs | 14 |
| `06 - La Terminal` | Shell, shells (bash/zsh/fish), tmux, screen, atajos, tuberías y redirecciones | 4 |
| `07 - Comandos Esenciales` | **67 comandos** documentados (Coreutils + util-linux, sudo, nano, vim, man, pacman, df, free, uname, date, sed+awk) + cheat sheet | 67 |
| `08 - Programas y Herramientas` | Ansible, Git, KVM, Docker, Nmap, Nginx, Samba, FFmpeg, WireGuard, editores, bases de datos, backups, monitors, juegos, audio | 69 |
| `09 - Solucion de Problemas` | Recursos + **16 problemas resueltos** (WiFi, sonido, permisos, SSH, Docker, fuentes, paquete roto, pantalla negra, disco lleno, teclado, Bluetooth, resolución, reloj, NVIDIA, GRUB) | 16 |
| `10 - Automatizacion y Scripts` | Scripts propios (5), cron, systemd timers, git hooks, Log.md de aprendizaje | 4 |
| `11 - Distribuciones` | Catálogo completo de 40 distros (Ubuntu, Debian, Arch, Fedora, Mint, NixOS, Gentoo, Kali, etc.) | 40 |
| `Templates` | 7 plantillas reutilizables (comando, concepto, programa, distro, entorno/WM, problema, log) | 7 |

## 📊 Estado actual (2026-07-24)

| Métrica | Valor |
|---|---|
| **Notas totales** | **314** (+ 7 templates) |
| **Estado resuelto** | 309 |
| **Estado en progreso** | 4 (TODO, MoC, Dashboard, Log) |
| **Estado borrador** | 0 |
| **Prioridad alta** | 153 |
| **Prioridad media** | 103 |
| **Prioridad baja** | 53 |
| **Categorías** | 12 |
| **Scripts de automatización** | 5 |
| **Git hooks** | 3 (pre-commit, commit-msg, pre-push) |
| **Repositorio Git** | ✅ Inicializado (local) |

### Distribución por categoría

| Categoría | Notas | Categoría | Notas |
|---|---|---|---|
| **Programa** | 70 | **Comando** | 67 |
| **Concepto** | 36 | **Distribución** | 40 |
| **Sistema** | 28 | **Entorno / WM** | 29 |
| **Troubleshooting** | 16 | **Índice** | 12 |
| **Instalación** | 9 | **Terminal** | 4 |
| **Automatización** | 3 | **Log** | 1 |

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

Todos en `10 - Automatizacion y Scripts/scripts/` y documentados en la nota de Automatización.

```bash
./scripts/daily-log.sh "Texto del día"      # crear log diario
./scripts/vault-stats.sh                    # estadísticas completas
./scripts/check-frontmatter.sh              # validar frontmatter
./scripts/find-orphans.sh                   # notas no enlazadas
./scripts/vault-stats-weekly.sh             # estadísticas semanales (cron domingo 9AM)
```

## 🗺️ TODO y Roadmap

Ver `00 - Indices y Mapas/TODO.md` para el plan de trabajo completo, fases completadas y próximos pasos.

## 📝 Para la IA

El archivo `CLAUDE.md` en la raíz define las reglas que cualquier agente LLM debe seguir al leer, mantener o expandir este vault. Léelo antes de hacer cambios automatizados.
