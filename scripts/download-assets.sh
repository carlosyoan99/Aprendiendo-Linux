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

download_file() {
    local name="$1" url="$2" subdir="$3"
    local file="$LOG_DIR/$subdir/$name"
    if [ -f "$file" ] && [ -s "$file" ]; then
        local type
        type=$(file -b "$file")
        if echo "$type" | grep -qi "SVG\|PNG\|JPEG\|image"; then
            echo "  ✅ $name ya existe ($(stat -c%s "$file") bytes)"
            return 0
        fi
    fi
    echo "  ⬇️  $name..."
    sleep 8
    local attempt=1
    while [ $attempt -le 3 ]; do
        curl -sL --max-time 20 --retry 0 -A "$UA" -o "$file" "$url" 2>/dev/null
        if [ -s "$file" ]; then
            local type
            type=$(file -b "$file")
            if echo "$type" | grep -qi "SVG\|PNG\|JPEG\|image"; then
                echo "     ✅ OK ($(stat -c%s "$file") bytes)"
                return 0
            else
                echo "     ⚠️  Descargado pero no es imagen (intento $attempt/3)"
                rm -f "$file"
            fi
        else
            echo "     ⚠️  Vacío (intento $attempt/3)"
        fi
        attempt=$((attempt + 1))
        sleep 10
    done
    echo "     ❌ Falló tras 3 intentos"
    return 1
}





# ============================================================
# LOGOS DE DISTRIBUCIONES
# ============================================================
logos_all() {
    echo "=== Logos de distribuciones ==="
    
    # URLs verificadas via Wikimedia API (upload.wikimedia.org directo)
    download_file "ubuntu.svg" "https://upload.wikimedia.org/wikipedia/commons/9/9e/Ubuntu-logo-no-wordmark-2022.svg" "logos"
    download_file "debian.svg" "https://upload.wikimedia.org/wikipedia/commons/a/ad/Debian-OpenLogo.svg" "logos"
    download_file "kalilinux.svg" "https://upload.wikimedia.org/wikipedia/commons/2/25/Kali-dragon-icon.svg" "logos"
    download_file "gentoo.svg" "https://upload.wikimedia.org/wikipedia/commons/4/4d/Gentoo_Linux_logo_matte.svg" "logos"
    download_file "fedora.svg" "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fedora_logo.svg" "logos"
    download_file "archlinux.svg" "https://upload.wikimedia.org/wikipedia/commons/f/f9/Archlinux-logo-standard-version.svg" "logos"
    download_file "linuxmint.svg" "https://upload.wikimedia.org/wikipedia/commons/4/45/The_Linux_Mint_Logo.svg" "logos"
    download_file "opensuse.svg" "https://upload.wikimedia.org/wikipedia/commons/d/d0/OpenSUSE_Logo.svg" "logos"
    download_file "manjaro.svg" "https://upload.wikimedia.org/wikipedia/commons/8/85/Manjaro_logo_text.svg" "logos"
    download_file "alpinelinux.svg" "https://upload.wikimedia.org/wikipedia/commons/a/a6/Alpine_Linux_Logo.svg" "logos"
    download_file "nixos.svg" "https://upload.wikimedia.org/wikipedia/commons/4/4e/NixOS_logo.svg" "logos"
    download_file "voidlinux.svg" "https://upload.wikimedia.org/wikipedia/commons/0/02/Void_Linux_logo.svg" "logos"
    download_file "centos.svg" "https://upload.wikimedia.org/wikipedia/commons/d/d8/Centos-logo-2022.svg" "logos"
    download_file "slackware.svg" "https://upload.wikimedia.org/wikipedia/commons/3/34/Slackware_logo.svg" "logos"
    download_file "popos.svg" "https://upload.wikimedia.org/wikipedia/commons/4/46/Pop%21_OS_Icon.svg" "logos"
    download_file "elementaryos.svg" "https://upload.wikimedia.org/wikipedia/commons/a/ab/Elementary_logo.svg" "logos"
}

# ============================================================
# CAPTURAS DE PANTALLA (DEs y WMs)
# ============================================================
screenshots_all() {
    echo "=== Capturas de entornos ==="
    
    # URLs verificadas via Wikimedia API
    download_file "gnome-shell.png" "https://upload.wikimedia.org/wikipedia/commons/9/97/GNOME_Shell.png" "screenshots"
    download_file "kde-plasma6.png" "https://upload.wikimedia.org/wikipedia/commons/e/e2/KDE_Plasma_6_screenshot.png" "screenshots"
    download_file "xfce-desktop.png" "https://upload.wikimedia.org/wikipedia/commons/2/24/XFCE-4.12-Desktop-standard.png" "screenshots"
    download_file "cinnamon-desktop.png" "https://upload.wikimedia.org/wikipedia/commons/c/cd/Cinnamon_4.2.3_screenshot.png" "screenshots"
    download_file "mate-desktop.png" "https://upload.wikimedia.org/wikipedia/commons/5/55/Mate_Desktop_de.png" "screenshots"
    download_file "i3-screenshot.png" "https://upload.wikimedia.org/wikipedia/commons/a/af/I3_window_manager_screenshot.png" "screenshots"
    download_file "hyprland-screenshot.png" "https://upload.wikimedia.org/wikipedia/commons/2/2f/Hyprland_screen.png" "screenshots"
}

# ============================================================
# DIAGRAMAS TÉCNICOS
# ============================================================
diagrams_all() {
    echo "=== Diagramas técnicos ==="
    
    # URLs verificadas via Wikimedia API
    download_file "kernel-structure.svg" "https://upload.wikimedia.org/wikipedia/commons/a/ac/Oversimplified_Structure_of_the_Linux_kernel.svg" "diagrams"
    download_file "fhs-hierarchy.svg" "https://upload.wikimedia.org/wikipedia/commons/f/f3/Standard-unix-filesystem-hierarchy.svg" "diagrams"
    download_file "boot-process.png" "https://upload.wikimedia.org/wikipedia/commons/9/90/Linux_Boot_Schema.png" "diagrams"
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
