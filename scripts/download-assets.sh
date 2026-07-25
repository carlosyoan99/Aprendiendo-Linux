#!/bin/bash
# download-assets.sh — Descarga imágenes para el vault desde fuentes oficiales
# Uso: bash download-assets.sh [logos|screenshots|diagrams|all]
#
# Requisitos: curl, wget
# Las imágenes se guardan en assets/logos/, assets/screenshots/, assets/diagrams/

set -uo pipefail

UA='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="$DIR/assets"

download_logo() {
    local name="$1" url="$2"
    local file="$LOG_DIR/logos/$name"
    if [ -f "$file" ] && [ -s "$file" ]; then
        echo "  ✅ $name ya existe ($(stat -c%s "$file") bytes)"
        return 0
    fi
    echo "  ⬇️  $name..."
    if wget -q --user-agent="$UA" --timeout=15 -O "$file" "$url" 2>/dev/null && [ -s "$file" ]; then
        local type
        type=$(file -b "$file")
        if echo "$type" | grep -qi "SVG\|PNG\|image"; then
            echo "     ✅ OK ($(stat -c%s "$file") bytes - $type)"
            return 0
        fi
    fi
    rm -f "$file"
    echo "     ❌ Falló"
    return 1
}

download_screenshot() {
    local name="$1" url="$2"
    local file="$LOG_DIR/screenshots/$name"
    if [ -f "$file" ] && [ -s "$file" ]; then
        echo "  ✅ $name ya existe ($(stat -c%s "$file") bytes)"
        return 0
    fi
    echo "  ⬇️  $name..."
    if wget -q --user-agent="$UA" --timeout=15 -O "$file" "$url" 2>/dev/null && [ -s "$file" ]; then
        local type
        type=$(file -b "$file")
        if echo "$type" | grep -qi "PNG\|image\|SVG"; then
            echo "     ✅ OK ($(stat -c%s "$file") bytes - $type)"
            return 0
        fi
    fi
    rm -f "$file"
    echo "     ❌ Falló (prueba con: curl -sLA \"$UA\" -o \"$file\" \"$url\")"
    return 1
}

download_diagram() {
    local name="$1" url="$2"
    local file="$LOG_DIR/diagrams/$name"
    if [ -f "$file" ] && [ -s "$file" ]; then
        echo "  ✅ $name ya existe ($(stat -c%s "$file") bytes)"
        return 0
    fi
    echo "  ⬇️  $name..."
    if wget -q --user-agent="$UA" --timeout=15 -O "$file" "$url" 2>/dev/null && [ -s "$file" ]; then
        local type
        type=$(file -b "$file")
        if echo "$type" | grep -qi "SVG\|PNG\|image"; then
            echo "     ✅ OK ($(stat -c%s "$file") bytes - $type)"
            return 0
        fi
    fi
    rm -f "$file"
    echo "     ❌ Falló"
    return 1
}

# ============================================================
# LOGOS DE DISTRIBUCIONES
# ============================================================
logos_all() {
    echo "=== Logos de distribuciones ==="
    
    # Desde Wikimedia Commons (Special:FilePath redirect + User-Agent)
    download_logo "ubuntu.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Ubuntu-logo-no-wordmark-2022.svg"
    download_logo "debian.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Debian-OpenLogo.svg"
    download_logo "kalilinux.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Kali_Linux_2.0_wordmark.svg"
    download_logo "gentoo.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Gentoo_Linux_logo_matte.svg"
    
    # Desde sitios oficiales
    download_logo "ubuntu.svg" "https://assets.ubuntu.com/v1/ce518a18-CoF-2022_solid+O.svg"
    download_logo "debian.svg" "https://www.debian.org/logos/openlogo-nd.svg"
    
    # Fedora (requiere buscar en Fedora wiki)
    download_logo "fedora.svg" "https://fedoraproject.org/assets/images/fedora-logo.svg"
    
    # Arch Linux (desde GitHub artwork)
    download_logo "archlinux.svg" "https://raw.githubusercontent.com/archlinux/archlinux-artwork/master/logo/archlinux-logo-dark.svg"
    
    # Linux Mint
    download_logo "linuxmint.svg" "https://raw.githubusercontent.com/linuxmint/artwork/master/logo/logo-linux-mint.svg"
    
    # openSUSE
    download_logo "opensuse.svg" "https://raw.githubusercontent.com/openSUSE/artwork/master/logo/opensuse-official-logo.svg"
    
    # Manjaro
    download_logo "manjaro.svg" "https://raw.githubusercontent.com/manjaro/artwork/master/logo/Manjaro-logo.svg"
    
    # Alpine Linux
    download_logo "alpinelinux.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Alpine_Linux_Logo.svg"
    
    # NixOS
    download_logo "nixos.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/NixOS_logo.svg"
    
    # Void Linux
    download_logo "voidlinux.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Void_Linux_logo.svg"
    
    # CentOS
    download_logo "centos.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Centos-logo-2022.svg"
    
    # Slackware
    download_logo "slackware.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Slackware_logo.svg"
    
    # Pop!_OS
    download_logo "popos.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/POP!_OS_logo_silhouette.svg"
    
    # elementary OS
    download_logo "elementaryos.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Elementary_OS_logo.svg"
}

# ============================================================
# CAPTURAS DE PANTALLA (DEs y WMs)
# ============================================================
screenshots_all() {
    echo "=== Capturas de entornos ==="
    
    download_screenshot "gnome-shell.png" "https://commons.wikimedia.org/wiki/Special:FilePath/GNOME_Shell.png"
    download_screenshot "kde-plasma6.png" "https://commons.wikimedia.org/wiki/Special:FilePath/KDE_Plasma_6_screenshot.png"
    download_screenshot "xfce-desktop.png" "https://commons.wikimedia.org/wiki/Special:FilePath/XFCE-4.12-Desktop-standard.png"
    download_screenshot "cinnamon-desktop.png" "https://commons.wikimedia.org/wiki/Special:FilePath/Cinnamon_4.2.3_screenshot.png"
    download_screenshot "mate-desktop.png" "https://commons.wikimedia.org/wiki/Special:FilePath/Mate_Desktop_de.png"
    download_screenshot "i3-screenshot.png" "https://commons.wikimedia.org/wiki/Special:FilePath/I3_window_manager_screenshot.png"
    download_screenshot "hyprland-screenshot.png" "https://commons.wikimedia.org/wiki/Special:FilePath/Hyprland_screen.png"
}

# ============================================================
# DIAGRAMAS TÉCNICOS
# ============================================================
diagrams_all() {
    echo "=== Diagramas técnicos ==="
    
    download_diagram "kernel-structure.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Oversimplified_Structure_of_the_Linux_kernel.svg"
    download_diagram "fhs-hierarchy.svg" "https://commons.wikimedia.org/wiki/Special:FilePath/Standard-unix-filesystem-hierarchy.svg"
    download_diagram "boot-process.png" "https://commons.wikimedia.org/wiki/Special:FilePath/Linux_Boot_Schema.png"
}

# ============================================================
# MAIN
# ============================================================
mkdir -p "$LOG_DIR"/{logos,screenshots,diagrams}

case "${1:-all}" in
    logos) logos_all ;;
    screenshots) screenshots_all ;;
    diagrams) diagrams_all ;;
    all)
        logos_all
        echo
        screenshots_all
        echo
        diagrams_all
        ;;
    *)
        echo "Uso: $0 [logos|screenshots|diagrams|all]"
        exit 1
        ;;
esac

echo
echo "=== Resumen ==="
echo "Logos: $(find "$LOG_DIR/logos" -type f -size +0 2>/dev/null | wc -l) archivos"
echo "Screenshots: $(find "$LOG_DIR/screenshots" -type f -size +0 2>/dev/null | wc -l) archivos"
echo "Diagramas: $(find "$LOG_DIR/diagrams" -type f -size +0 2>/dev/null | wc -l) archivos"
echo
echo "Nota: Si algunas descargas fallan, prueba manualmente con:"
echo "  curl -sLA \"$UA\" -O <URL>"
echo "O busca las imágenes en https://commons.wikimedia.org y usa el enlace 'Original file'."
