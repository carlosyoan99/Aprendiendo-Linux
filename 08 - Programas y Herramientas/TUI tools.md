---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# TUI Tools — Terminal User Interfaces

> Guía de las herramientas TUI más útiles para el día a día en Linux. Organizadas por categoría, con instalación, descripción y enlaces a notas del vault.

---

## 📊 Monitores del sistema

Estas herramientas muestran en tiempo real el estado del sistema: CPU, RAM, discos, red, procesos y GPU.

| Herramienta | Lenguaje | GPU | Gráficos | RAM | Ideal para |
|---|---|---|---|---|---|
| **htop** | C | ❌ | Barras coloreadas | ~10 MB | Uso diario ✅ |
| **btop** | C++ | ✅ | Gráficos realtime | ~30 MB | Monitoreo completo con GPU |
| **bottom** (btm) | Rust | ❌ | Gráficos + temas | ~15 MB | Alternativa moderna a htop |
| **glances** | Python | ❌ | Dashboard + web | ~40 MB | Monitoreo remoto vía web |
| **nvtop** | C | ✅ GPU | Simplificado | ~10 MB | GPU NVIDIA/AMD |

```bash
# Instalación
sudo apt install htop btop bottom glances nvtop
```

### bottom (btm)

Alternativa moderna a htop/btop escrita en Rust. Muestra CPU, memoria, discos, red y procesos con gráficos. Más ligero que btop, más vistoso que htop.

```bash
btm                                  # iniciar
# Atajos: ?=ayuda, q=salir, flechas=navegar, 1-4=pestañas
# Temas: --theme gruvbox, --theme nord, --theme default
```

### glances

Monitor todo-en-uno que expone un dashboard **también vía web**. Útil para servidores headless.

```bash
glances                              # TUI local
glances -w                           # servidor web en :61208
glances -c servidor-remoto           # cliente remoto
```

### Referencias existentes

- [[htop btop]] — nota completa en el vault
- nvtop — monitor de GPU (mencionado en [[htop btop]])
- [[top]] — monitor clásico, abuelo de todos

---

## 🗄️ Uso de disco

| Herramienta | Descripción | Alternativa a | Instalación |
|---|---|---|---|
| **ncdu** | Explorador de disco ncurses, el clásico | `du` interactivo | `sudo apt install ncdu` |
| **gdu** | ncdu pero más rápido (escrito en Go) | ncdu | `sudo apt install gdu` |
| **duf** | `df` moderno con colores y montajes | `df -h` | `sudo apt install duf` |
| **diskonaut** | Mapa de disco con teclas de vim | ncdu/gdu | Descargar binario |

### ncdu — El clásico infalible

```bash
ncdu                                 # escanear directorio actual
ncdu /                               # escanear todo el sistema
ncdu -x /                            # sin cruzar sistemas de archivos
# Navegación: flechas, Enter=entrar, d=borrar, q=salir
```

### gdu — ncdu pero en Rust

```bash
gdu /                                # escaneo rápido
gdu -l                               # seguir enlaces simbólicos
gdu -p                               # mostrar progreso en archivos grandes
```

### duf — df moderno

```bash
duf                                  # todos los discos con colores
duf --only local                     # solo discos locales
duf --hide-fs tmpfs                  # ocultar tmpfs
```

---

## 📁 Gestores de archivos (TUI)

Navegar y gestionar archivos desde la terminal con interfaz interactiva.

| Herramienta | Lenguaje | Keybindings | Característica destacada |
|---|---|---|---|
| **yazi** | Rust | Vim | ⚡ Más rápido, previsualización de imágenes |
| **nnn** | C | Varios | Minimalista, < 100 KB |
| **lf** | Go | Vim | Ligero, configurable en Go |
| **ranger** | Python | Vim | El clásico, previsualización de archivos |
| **broot** | Rust | Vim | Navegación por árbol + búsqueda difusa |
| **superfile** | Go | Vim | Moderno, pestañas, icons |

```bash
# Instalación
sudo apt install ranger              # el clásico (Python)
sudo apt install broot               # navegador de árbol
yazi                                 # descargar binario desde GitHub
nnn                                  # compilar desde fuente
```

### yazi — El más rápido

```bash
yazi                                 # lanzar navegador
# Teclas: h/j/k/l = vim, espacio=seleccionar, : = comandos,
# ~ = ir a home, / = buscar, t = nueva pestaña
```

### nnn — Minimalista

```bash
nnn                                  # lanzar
nnn -d                               # mostrar detalles
nnn -r                               # abrir como root
# Atajos: ?=ayuda, q=salir, ^G=ir a..., / = filtrar
```

### broot — Navegación por árbol

```bash
broot /ruta                          # navegar árbol de directorios
# :q = salir, :bd = back, / = buscar, Alt+Enter = abrir shell
```

### Referencias existentes

- [[Gestores de Archivos]] — nota general sobre gestores de archivos en Linux
- [[lf]] | [[ranger]] | [[nnn]] — notas individuales pendientes de crear

---

## 🐙 Git TUI tools

Navegar, revisar y gestionar repositorios Git sin salir de la terminal.

| Herramienta | Descripción | Instalación |
|---|---|---|
| **lazygit** | TUI Git completo: staging, branches, commits, merge | `sudo apt install lazygit` |
| **gitui** | Git TUI en Rust, muy rápido | `sudo apt install gitui` |
| **tig** | Visor de commits y log, el clásico | `sudo apt install tig` |
| **delta** | Diferenciador con syntax highlighting | `sudo apt install git-delta` |
| **gitv** | Cliente TUI para GitHub Issues | Descargar binario |

### lazygit — El indispensable

```bash
lazygit                              # lanzar en cualquier repo
# Navegación: flechas, Enter, espacio, p=push, P=pull
# C=commit, s=stash, d=diffs, b=branches
# ? = ayuda completa con atajos
```

### gitui — Alternativa rápida

```bash
gitui                                # lanzar
# Similar a lazygit pero más enfocado en velocidad
# Múltiples temas incluidos
```

### tig — El clásico de terminal

```bash
tig                                  # ver log de commits
tig diff                             # ver diff
tig blame archivo                    # blame de archivo
# Atajos: j/k = navegar, Enter = ver detalle, / = buscar
```

### delta — Diff bonito

```bash
# Configurar en ~/.gitconfig:
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    side-by-side = true
    line-numbers = true
    syntax-theme = Nord
```

### Referencias existentes

- [[Git]] — nota general sobre Git en el vault
- [[GitHub CLI (gh)]] — GitHub desde terminal

---

## 🐳 Docker & Kubernetes TUI tools

Gestionar contenedores y clústeres desde la terminal.

| Herramienta | Para | Instalación |
|---|---|---|
| **lazydocker** | Gestión Docker interactiva | `sudo apt install lazydocker` |
| **dive** | Explorar capas de imágenes Docker | `sudo apt install dive` |
| **ctop** | Top-like para contenedores | `sudo snap install ctop` |
| **k9s** | Gestión completa de Kubernetes | Descargar binario |
| **kdash** | Dashboard K8s simple | `sudo apt install kdash` |
| **kubetui** | TUI para monitorear K8s | Descargar binario |

### lazydocker — Docker sin pensar

```bash
lazydocker                           # lanzar (en directorio con docker-compose o no)
# Panel izquierdo: contenedores, imágenes, volúmenes
# Atajos: [ ] = cambiar panel, Enter = ver logs, s = start/stop
# r = restart, d = down, e = ejecutar comando en contenedor
```

### dive — Analizar imágenes

```bash
dive nginx:latest                    # explorar capas de imagen
# Muestra: qué cambia en cada capa, tamaño, comandos
# Útil para optimizar Dockerfiles
```

### k9s — El kubectl visual

```bash
k9s                                  # lanzar (necesita kubeconfig)
# :pods, :deployments, :services, :namespaces
# / = filtrar, d = describir, y = YAML, l = logs
# Ctrl+d = eliminar, ? = ayuda
```

### Referencias existentes

- [[Docker]] — notas sobre Docker en el vault
- [[Kubernetes]] — orquestación de contenedores
- [[Contenedores orquestación]] — Docker Compose, Swarm, K8s
- [[lazydocker]] | [[k9s]] | [[dive]] — notas pendientes de crear

---

## 🌐 Red y APIs

| Herramienta | Descripción | Instalación |
|---|---|---|
| **trippy** | traceroute+ping con TUI moderno | `sudo apt install trippy` |
| **bandwhich** | Ancho de banda por proceso | `sudo apt install bandwhich` |
| **bmon** | Monitor de ancho de banda clásico | `sudo apt install bmon` |
| **nethogs** | Ancho de banda por proceso (simple) | `sudo apt install nethogs` |
| **termshark** | Wireshark en terminal | `sudo apt install termshark` |
| **ATAC** | API client TUI (Rust) | Descargar binario |
| **posting** | HTTP client TUI (Python) | `pip install posting` |
| **oha** | HTTP load generator | `sudo apt install oha` |

```bash
# Monitoreo de red
trippy google.com                    # traceroute interactivo con gráficos
bandwhich                           # ver qué proceso consume más ancho de banda
sudo bmon                           # monitor de ancho de banda
sudo nethogs                        # procesos por ancho de banda

# Análisis de paquetes
sudo termshark -i eth0              # Wireshark TUI

# Clientes HTTP
ATAC                                # API client TUI
posting                             # HTTP client TUI
```

### Referencias existentes

- [[Redes Basicas]] — conceptos de red
- [[ping]] | [[traceroute]] | [[ss]] | [[ip]] — notas de comandos

---

## 🎵 Multimedia

| Herramienta | Descripción | Instalación |
|---|---|---|
| **cmus** | Reproductor de música (vim-keys) | `sudo apt install cmus` |
| **ncspot** | Spotify en terminal | `sudo apt install ncspot` |
| **spotify-player** | Spotify con streaming nativo | Descargar binario |
| **kew** | Reproductor de música local | `sudo apt install kew` |
| **chafa** | Ver imágenes en terminal | `sudo apt install chafa` |
| **timg** | Visor de imágenes en terminal | `sudo apt install timg` |
| **cava** | Visualizador de audio | ✅ Ya existe nota |

### cmus — Reproductor minimalista

```bash
cmus                                 # lanzar
# 1=lista, 2=navegación, 3=cola, 4=artista/álbum
# j/k = navegar, Enter = reproducir, v = pausa
# :add /ruta/musica = añadir directorio
# y = repetir, r = aleatorio
```

### ncspot — Spotify en terminal

```bash
ncspot                               # lanzar (pide login)
# j/k = navegar, Enter = reproducir, s = buscar
# flechas, q = salir
```

### chafa — Imágenes en terminal

```bash
chafa imagen.png                     # mostrar imagen en terminal
chafa --symbols block image.jpg      # con símbolos de bloque
chafa --animate gif.gif              # GIF animados
# Funciona con sixel, kitty, iterm2, o fallback a ANSI
```

### Referencias existentes

- [[Cava]] — visualizador de audio
- [[Audio en Linux]] — pila de audio (ALSA, PulseAudio, PipeWire)
- [[Multimedia (GStreamer HandBrake VLC MPV)]] — herramientas multimedia

---

## ✍️ Editores de texto TUI

| Herramienta | Descripción | Nota existente |
|---|---|---|
| **micro** | Editor moderno intuitivo (como nano++) | ✅ [[Micro]] |
| **helix** | Editor modal con LSP built-in | ✅ Mencionado en editores |
| **kakoune** | Editor modal, múltiples selecciones | ❌ Pendiente |
| **vis** | Editor modal basado en Plan 9 regex | ❌ Pendiente |
| **amp** | Editor terminal Rust | ❌ Pendiente |

> Ver [[Editores de Texto]] para la guía completa de editores TUI.

---

## 💬 Mensajería

| Herramienta | Plataforma | Instalación |
|---|---|---|
| **weechat** | IRC (el mejor cliente TUI) | `sudo apt install weechat` |
| **irssi** | IRC (el clásico) | `sudo apt install irssi` |
| **nchat** | Telegram + WhatsApp | `sudo snap install nchat` |
| **aerc** | Email (IMAP/SMTP) | `sudo apt install aerc` |
| **neomutt** | Email (el clásico) | `sudo apt install neomutt` |
| **gurk-rs** | Signal Messenger | `cargo install gurk-rs` |
| **tgt** | Telegram TUI | Descargar binario |

```bash
weechat                              # lanzar IRC
# /server add libera irc.libera.chat
# /connect libera
# /join #linux
```

---

## 📰 Lectura y productividad

| Herramienta | Descripción | Instalación |
|---|---|---|
| **glow** | Visor de Markdown bonito | `sudo apt install glow` |
| **newsboat** | Lector RSS/Atom | `sudo apt install newsboat` |
| **visidata** | Hoja de cálculo TUI | `pip install visidata` |
| **slides** | Presentaciones Markdown | `sudo apt install slides` |
| **presenterm** | Presentaciones Markdown | Descargar binario |
| **patat** | Presentaciones Pandoc | Descargar binario |

### glow — Markdown bonito

```bash
glow README.md                       # renderizar Markdown
glow -p README.md                    # modo presentación
glow                                  # explorador de archivos .md
```

### visidata — Hoja de cálculo en terminal

```bash
visidata datos.csv                   # abrir CSV
visidata datos.json                  # abrir JSON
# Navegación: flechas, = suma, ! = ordenar, : = gráfico
# g/G = ir a principio/final, " = expandir celdas
# Soporta: CSV, TSV, JSON, SQLite, Excel, HTML tables
```

### newsboat — RSS lector

```bash
newsboat                             # lanzar
# Config en ~/.newsboat/config
# Añadir feeds en ~/.newsboat/urls
# j/k = navegar, Enter = abrir en navegador
```

---

## 🔒 Seguridad y diagnóstico

| Herramienta | Descripción | Instalación |
|---|---|---|
| **gpg-tui** | Gestionar claves GPG | `cargo install gpg-tui` |
| **flawz** | Navegar CVEs | Descargar binario |
| **fail2ban** | Anti-bots (SSH, web) | ✅ Ya existe nota |
| **auditd** | Auditoría del sistema | ✅ Ya existe nota |

> Ver [[Seguridad en Linux (Guía completa)]] y [[fail2ban]], [[auditd]].

---

## 🧩 Otras herramientas TUI esenciales

### Multiplexores de terminal

```bash
tmux                                 # el moderno ✅ nota existente
screen                               # el clásico ✅ nota existente
zellij                              # el nuevo, con layout por pestañas
```

**zellij** — Multiplexor moderno con layout automatizado, paneles redimensionables y plugins:

```bash
sudo apt install zellij              # instalación
zellij                               # lanzar
# Atajos: Ctrl+p = menú, Ctrl+t = nueva pestaña
# Ctrl+n = nuevo panel, Ctrl+q = cerrar panel
# Escape = modo editor (pasar teclas a la terminal)
```

### Buscadores y filtros

```bash
fzf                                  # búsqueda difusa ✅ nota existente
fd                                   # búsqueda rápida de archivos ✅ nota existente
bat                                  # cat con syntax highlighting (moderno)
procs                                # ps moderno con árbol
doggo                                # dig moderno con colores
```

**bat** — cat con esteroides:

```bash
sudo apt install bat                 # instalación
bat archivo.txt                      # mostrar con números y syntax highlight
bat --language=python archivo        # forzar lenguaje
bat -A archivo                       # mostrar caracteres especiales
# Alias práctico: alias cat='bat'
```

**procs** — ps moderno:

```bash
sudo snap install procs              # instalación
procs                                # lista procesos con árbol
procs ssh                            # filtrar por nombre
procs --tree                         # vista de árbol
procs -a                             # todos los procesos
```

**doggo** — dig moderno:

```bash
sudo apt install doggo
doggo MX google.com                  # consultar registro MX
doggo @1.1.1.1 google.com           # con DNS específico
doggo -J google.com                  # salida JSON
```

### Procesamiento de datos

```bash
fx                                   # visor JSON interactivo
jq                                   # procesador JSON ✅ nota existente
choose                               # cort moderno (columnas)
```

**fx** — Visor JSON interactivo en terminal:

```bash
npm install -g fx                    # instalación
cat data.json | fx                  # explorar JSON interactivo
curl api.example.com | fx           # pipe de API
# Navegación: flechas, Enter=expandir, espacio=colapsar
# / = buscar, q = salir
```

---

## 📋 Tabla resumen: esenciales vs. opcionales

### 🟢 Instalar sí o sí (día a día)

| Herramienta | Reemplaza | Por qué |
|---|---|---|
| **bat** | `cat` | Syntax highlighting, números de línea |
| **lazygit** | Git CLI | Hace todo lo de Git muchísimo más fácil |
| **ncdu** / **gdu** | `du -sh` | Explorar disco interactivamente |
| **fzf** | Búsqueda manual | Búsqueda difusa en cualquier lista |
| **fd-find** | `find` | Búsqueda de archivos más rápida e intuitiva |

### 🟡 Muy recomendados

| Herramienta | Reemplaza | Por qué |
|---|---|---|
| **bottom** (btm) | htop | Monitor moderno con gráficos |
| **glow** | cat en .md | Leer Markdown bonito |
| **glances** | htop remoto | Dashboard web incluido |
| **yazi** / **lf** | Navegación manual | Gestor de archivos TUI |
| **trippy** | traceroute + ping | Diagnóstico de red visual |
| **procs** | `ps` | ps con colores y árbol |

### 🔴 Opcionales (según necesidad)

| Herramienta | Para qué tipo de usuario |
|---|---|
| **k9s** | Administradores de Kubernetes |
| **lazydocker** | Usuarios intensivos de Docker |
| **cmus** / **ncspot** | Música desde terminal |
| **visidata** | Analistas de datos |
| **newsboat** | Lectores de RSS |
| **zellij** | Usuarios que quieren algo más moderno que tmux |
| **gitui** | Como lazygit pero prefieres atajos diferentes |
| **bandwhich** | Diagnóstico fino de red |
| **termshark** | Analistas de red (wireshark en TUI) |

---

## 📦 Instalación masiva

Scripts para instalar todas las TUIs de esta guía de una sola vez, organizados por prioridad.

### 🟢 Instalación esencial (día a día)

```bash
#!/bin/bash
# install-tuis-essential.sh — TUIs que todo Linux user debería tener

echo "📦 Instalando TUIs esenciales..."

sudo apt update

# Monitores y sistema
sudo apt install -y \
    htop \
    bottom \
    ncdu \
    duf \
    bat

# Git
sudo apt install -y \
    lazygit \
    tig \
    git-delta

# Buscadores y filtros
sudo apt install -y \
    fzf \
    fd-find \
    ripgrep \
    tree \
    jq

# Terminal
sudo apt install -y \
    tmux \
    zellij

# Productividad
sudo apt install -y \
    glow

echo "✅ TUIs esenciales instalados."
echo "ℹ️  Algunos binarios usan nombres distintos:"
echo "   - bat  → usa 'batcat' en Debian/Ubuntu (o alias bat='batcat')"
echo "   - fd   → usa 'fdfind' en Debian/Ubuntu (o alias fd='fdfind')"
```

### 🟡 Instalación completa (esencial + recomendado)

```bash
#!/bin/bash
# install-tuis-full.sh — TUIs esenciales + muy recomendados

# Primero ejecutar la instalación esencial (script anterior)
# o instalar los paquetes extra:

echo "📦 Instalando TUIs recomendadas..."

sudo apt install -y \
    btop \
    glances \
    gdu \
    broot \
    gitui \
    trippy \
    bmon \
    nethogs \
    cmus \
    chafa \
    timg \
    newsboat \
    doggo \
    httpie

echo "✅ TUIs recomendadas instaladas."
```

### 🔴 Instalación completa (todo)

```bash
#!/bin/bash
# install-tuis-all.sh — TODO el arsenal TUI

echo "📦 Instalando TODAS las TUIs..."

# Esenciales + recomendados + opcionales
sudo apt install -y \
    # Monitores
    htop btop bottom glances nvtop \
    # Disco
    ncdu gdu duf \
    # Git
    lazygit gitui tig git-delta \
    # Docker (si tienes el repo de Docker añadido)
    lazydocker dive ctop \
    # Red
    trippy bmon nethogs bandwhich termshark oha \
    # Multimedia
    cmus chafa timg cava \
    # Editores
    micro \
    # Mensajería
    weechat irssi aerc neomutt \
    # Productividad
    glow newsboat slides \
    # Buscadores y filtros
    fzf fd-find ripgrep bat broot tree jq httpie doggo \
    # Terminal
    tmux zellij screen

echo "✅ Todas las TUIs instaladas."
echo "⚠️  Algunas herramientas requieren instalación manual:"
echo "   - yazi, nnn, lf, ranger — gestores de archivos"
echo "   - k9s, kdash — Kubernetes"
echo "   - ncspot, spotify-player — Spotify"
echo "   - fx, visidata, posting — vía npm/pip"
echo "   - gpg-tui, flawz — vía cargo/binario"
```

### 🐳 Docker + K8s stack

Para instalar las TUIs de contenedores se necesita tener los repositorios de Docker y Kubernetes configurados:

```bash
#!/bin/bash
# install-tuis-containers.sh

echo "📦 Instalando TUIs de contenedores..."

# Añadir repositorio Docker (si no está)
if ! dpkg -l | grep -q docker-ce; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
fi

sudo apt install -y lazydocker dive
sudo snap install ctop

echo "✅ TUIs de contenedores instaladas."
echo "ℹ️  k9s se descarga manualmente desde https://github.com/derailed/k9s/releases"
```

### 🐚 Script único todo-en-uno

```bash
#!/bin/bash
# install-tuis.sh — Instalación masiva de TUIs con menú interactivo
# Uso: bash install-tuis.sh [essentials|full|all|containers]

set -euo pipefail

MODE="${1:-menu}"

instalar_essentials() {
    echo "🟢 Instalando esenciales..."
    sudo apt install -y htop bottom ncdu duf bat lazygit tig \
        git-delta fzf fd-find ripgrep tree jq tmux zellij glow
    echo "✅ Esenciales listos"
}

instalar_recomendados() {
    echo "🟡 Instalando recomendados..."
    sudo apt install -y btop glances gdu broot gitui trippy \
        bmon nethogs cmus chafa timg newsboat doggo httpie
    echo "✅ Recomendados listos"
}

instalar_todo() {
    instalar_essentials
    instalar_recomendados
    echo "🔴 Instalando opcionales..."
    sudo apt install -y nvtop duf micro weechat irssi aerc \
        neomutt slides screen bandwhich termshark oha cava
    echo "✅ Todo listo"
}

case "$MODE" in
    essentials)  instalar_essentials ;;
    full)        instalar_essentials; instalar_recomendados ;;
    all)         instalar_todo ;;
    containers)  echo "🐳 Instalando TUIs de contenedores...";
                 sudo apt install -y lazydocker dive;;
    menu|*)
        echo "╔══════════════════════════════╗"
        echo "║   🚀 Instalador Masivo TUI   ║"
        echo "╠══════════════════════════════╣"
        echo "║  1) 🟢 Esenciales            ║"
        echo "║  2) 🟡 Esenciales + Recomen. ║"
        echo "║  3) 🔴 Todo                  ║"
        echo "║  4) 🐳 Solo contenedores     ║"
        echo "║  5) 🚪 Salir                 ║"
        echo "╚══════════════════════════════╝"
        read -p "Selecciona una opción: " opt
        case "$opt" in
            1) instalar_essentials ;;
            2) instalar_essentials; instalar_recomendados ;;
            3) instalar_todo ;;
            4) sudo apt install -y lazydocker dive;;
            *) echo "Hasta luego! 👋"; exit 0;;
        esac
        ;;
esac
```

> 💡 **Tip**: Guarda el script como `install-tuis.sh` en `~/scripts/` o en la carpeta `10 - Automatizacion y Scripts/scripts/` del vault y hazlo ejecutable con `chmod +x install-tuis.sh`.

---

## 🔗 Ver también

- [[Ncurses]] — la biblioteca que hace posibles muchas TUIs
- [[Emuladores de Terminal]] — dónde se ejecutan las TUIs
- [[La Shell]] — el intérprete base
- [[tmux]] / [[screen]] — multiplexores de terminal
- [[htop btop]] — monitores de sistema
- [[Cava]] — visualizador de audio
- [[Micro]] — editor TUI moderno
- [[Dia a Dia en CLI]] — comandos esenciales diarios
- [[Arsenal Power User]] — herramientas avanzadas

## Enlaces externos

- [awesome-tuis](https://github.com/rothgar/awesome-tuis) — lista completa de TUIs (referencia de esta nota)
- [Terminal Trove](https://terminaltrove.com/) — catálogo de herramientas CLI/TUI
- [Modern Unix](https://github.com/ibraheemdev/modern-unix) — alternativas modernas a comandos clásicos
- [Ratatui](https://ratatui.rs/) — framework Rust para construir TUIs
- [Textual](https://textual.textualize.io/) — framework Python para construir TUIs

#programa #tui #terminal #herramientas
