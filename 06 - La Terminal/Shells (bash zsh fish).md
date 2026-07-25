---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: terminal
prioridad: alta
---

# Shells: bash, zsh, fish

## Qué es

La shell es el intérprete de comandos que lee lo que escribes en la terminal, lo ejecuta y te muestra el resultado. `bash` viene por defecto en prácticamente todas las distros; `zsh` y `fish` son alternativas populares que se instalan aparte.

Ver [[La Shell]] para entender qué diferencian una shell de un emulador de terminal.

## bash (Bourne Again Shell)

| Aspecto | Detalle |
|---|---|
| **Por defecto en** | Casi todas las distros Linux |
| **Archivo de config** | `~/.bashrc` (interactiva), `~/.bash_profile` (login) |
| **Compatibilidad** | 100% con POSIX sh — los scripts funcionan en cualquier lado |
| **Plugin manager** | No oficial, pero `bash-it` es el más conocido |

```bash
# Comandos útiles
type <comando>        # ¿qué tipo es? (alias, builtin, función, binario)
alias ll='ls -la'     # crear alias temporal (o en .bashrc para persistir)
echo $BASH_VERSION    # versión de bash
```

**Fortalezas**: es el estándar de facto. Cualquier script que escribas en bash funcionará sin cambios en cualquier máquina Linux y en macOS.

**Debilidades**: el autocompletado por defecto es básico (mejorable con `bash-completion`), el prompt requiere códigos de escape feas.

## zsh (Z Shell)

| Aspecto | Detalle |
|---|---|
| **Por defecto en** | macOS desde Catalina, algunas distros |
| **Archivo de config** | `~/.zshrc` |
| **Compatibilidad** | Alta con bash (no 100%, pero cubre el 95% de scripts diarios) |
| **Plugin manager** | Oh My Zsh (`~/.oh-my-zsh`), Antigen, zplug, zinit |

```bash
# Instalación
sudo apt install zsh          # Debian/Ubuntu
sudo pacman -S zsh            # Arch
sudo dnf install zsh          # Fedora

# Cambiar por defecto
chsh -s $(which zsh)
# Cerrar sesión y volver a entrar / abrir nueva terminal
```

**Oh My Zsh** es el framework más usado: instala themes, plugins y configuración con un solo comando:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Después editas ~/.zshrc: ZSH_THEME="robbyrussell", plugins=(git docker sudo)
```

**Ventajas clave sobre bash**:
- Autocompletado más inteligente (navegable con flechas/Tab)
- Corrección ortográfica automática (`$ apt apdate` → "¿quisiste decir apt update?")
- Temas de prompt potentes sin esfuerzo (Powerlevel10k, Spaceship)
- Sistema de plugins (git, docker, npm, sudo — si presionas Esc+Esc agrega `sudo` al comando anterior)

## fish (Friendly Interactive Shell)

| Aspecto | Detalle |
|---|---|
| **Por defecto en** | Ninguna distro |
| **Archivo de config** | `~/.config/fish/config.fish` |
| **Compatibilidad** | Baja — sintaxis propia, no compatible con bash |
| **Plugin manager** | `fisher` (gestor ligero) |

```bash
# Instalación
sudo apt install fish          # Debian/Ubuntu
sudo pacman -S fish            # Arch
sudo dnf install fish          # Fedora

# Probar sin cambiar la shell por defecto
fish
```

**Ventajas**:
- **Sugerencias out-of-the-box**: mientras escribes, te muestra en gris el comando más probable del historial, presionas → para aceptarlo
- **Resaltado de sintaxis**: colorea comandos válidos en azul, rutas existentes en subrayado, errores en rojo
- **No requiere config** para ser usable — ni `.bashrc` ni plugins
- **Web config**: `fish_config` abre una GUI en el navegador para cambiar theme, prompt y colores

**Desventajas**: como no es compatible con bash, no puedes copiar-pegar scripts de internet sin modificarlos. Muchos eligen tener `fish` como shell interactiva y usan `bash` para scripting.

## Comparativa rápida

| Característica | bash | zsh + Oh My Zsh | fish |
|---|---|---|---|
| Preinstalado | ✅ Sí | ❌ No (solo macOS) | ❌ No |
| Autocompletado | Básico | Avanzado | Excelente |
| Resaltado sintaxis | ❌ | Con plugin | ✅ Nativo |
| Sugerencias historial | Con Ctrl+R | Con plugin | ✅ Nativo |
| Compatibilidad scripts | ✅ 100% | ~95% | ❌ Baja |
| Config inicial | Editar .bashrc | Instalar oh-my-zsh | Funciona al instante |
| Curva de aprendizaje | Baja | Media-baja | Muy baja |

## Prompt (el texto que ves antes de escribir)

Es una forma fácil de darle personalidad a tu terminal:

| Shell | Herramientas de prompt |
|---|---|
| **bash** | Manual (`PS1='\u@\h:\w\$ '`) o `starship` |
| **zsh** | Themes de Oh My Zsh, **Powerlevel10k** (config wizard), `starship` |
| **fish** | `fish_config` o `starship` |

**[Starship](https://starship.rs)** es un prompt universal que funciona en las tres shells: muestra git branch, versión de Node/Python/Rust, tiempo de ejecución, etc.

## Notas personales

-

## Ver también

- [[La Shell]]
- [[Emuladores de Terminal]]
- [[Editores de Texto]]
- [[Variables de Entorno y PATH]]

#terminal #shell
