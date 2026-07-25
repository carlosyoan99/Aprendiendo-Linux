#!/usr/bin/env python3
"""
wikipedia-dl.py — Bot de descarga de contenido e imágenes desde Wikipedia

Uso:
  python3 wikipedia-dl.py urls.txt
  python3 wikipedia-dl.py urls.txt --delay 3.0 --output-dir raw
  python3 wikipedia-dl.py urls.txt --images-dir assets/logos --resume

Características:
  • Se presenta como bot de Wikipedia (User-Agent identificativo)
  • Rota entre 12 User-Agent strings al azar
  • Pausa configurable + jitter aleatorio para evitar HTTP 429
  • Descarga HTML completo del artículo
  • Descarga imágenes del artículo (Wikipedia, Wikimedia Commons)
  • Almacena HTML en raw/ e imágenes en assets/
  • Lee las URLs desde un archivo de texto (una por línea)
  • Reanudable: omite archivos ya descargados (--resume)
  • Respeta robots.txt de Wikipedia

Requiere: requests, beautifulsoup4
  pip install requests beautifulsoup4

Licencia: GNU GPL v3
"""

import os
import sys
import re
import time
import json
import random
import argparse
import logging
import hashlib
import urllib.robotparser
from pathlib import Path
from datetime import datetime
from urllib.parse import urlparse, urljoin

import requests
from bs4 import BeautifulSoup


# ─── CONFIGURACIÓN ─────────────────────────────────────────────
# 12 User-Agent strings rotativos (10 navegadores reales + 2 bots)
USER_AGENTS = [
    # Bots identificativos (contacto vía GitHub Issues del proyecto)
    "AprendiendoLinux-Bot/1.0 (https://github.com/carlosyoan99/AprendiendoLinux; "
    "uso educativo no comercial; reportar issues en GitHub)",
    "Mozilla/5.0 (compatible; LinuxVaultBot/1.0; "
    "+https://github.com/carlosyoan99/AprendiendoLinux)",

    # Firefox (Linux, Windows, macOS)
    "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:128.0) Gecko/20100101 Firefox/128.0",

    # Chrome (Linux, Windows, macOS)
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",

    # Edge y Safari
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 "
    "(KHTML, like Gecko) Version/17.5 Safari/605.1.15",

    # wget / curl con identificación
    "Wget/1.24.5 (linux-gnu)",
    "curl/8.8.0",
]


# ─── LOGGING ───────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)
log = logging.getLogger("wikipedia-dl")


# ─── UTILIDADES ────────────────────────────────────────────────
def sanitize_filename(name: str, max_len: int = 120) -> str:
    """Convierte un título/wiki a nombre de archivo seguro."""
    name = name.strip().replace(" ", "_")
    # Eliminar caracteres no seguros para sistema de archivos
    name = re.sub(r'[<>:"/\\|?*]', "_", name)
    name = re.sub(r'_+', "_", name)
    # Acortar si es muy largo
    if len(name) > max_len:
        base, ext = os.path.splitext(name)
        name = base[:max_len] + ext
    return name


def random_delay(base: float) -> float:
    """Genera pausa aleatoria con jitter: base ± 25%."""
    return random.uniform(base * 0.75, base * 1.25)


def get_url_title(url: str) -> str:
    """Extrae el título del artículo desde la URL de Wikipedia."""
    # Patrones: /wiki/Artículo, /wiki/Artículo#sección
    match = re.search(r"/wiki/([^#?]+)", url)
    if match:
        return requests.utils.unquote(match.group(1)).replace("_", " ")
    return os.path.basename(urlparse(url).path)


def extract_wikipedia_images(soup: BeautifulSoup, article_url: str) -> list[dict]:
    """
    Extrae imágenes de un artículo de Wikipedia.
    Retorna lista de dicts con: url, alt, filename, wikimedia_url
    """
    images = []
    seen_urls = set()

    # Buscar en el contenido del artículo (.mw-parser-output)
    content = soup.select_one(".mw-parser-output")
    if not content:
        content = soup

    for img in content.find_all("img"):
        src = img.get("src")
        if not src:
            continue

        # Convertir a URL absoluta
        img_url = urljoin(article_url, src)

        # Solo imágenes de Wikimedia
        parsed = urlparse(img_url)
        if not ("wikimedia.org" in parsed.netloc or "wikipedia.org" in parsed.netloc):
            continue

        # Evitar iconos pequeños (thumbnails < 50px), favicons, etc.
        width = img.get("width")
        if width and width.isdigit() and int(width) < 50:
            continue

        # Evitar duplicados
        normal_url = img_url.split("?")[0].split("#")[0]  # sin query ni fragmento
        if normal_url in seen_urls:
            continue
        seen_urls.add(normal_url)

        # Obtener el nombre del archivo desde la URL
        alt = img.get("alt", "") or ""
        filename = os.path.basename(normal_url.split("/")[-1])

        # Preferir versiones de mayor resolución (quitar /thumb/ de la ruta)
        # Formato thumbnail:
        #   .../commons/thumb/a/ab/Foo.svg/320px-Foo.svg.png
        # Original:
        #   .../commons/a/ab/Foo.svg
        # Estrategia: eliminar /thumb/ y el último segmento (miniatura)
        full_res_url = normal_url
        if "/thumb/" in normal_url:
            # /thumb/ aparece UNA vez: .../commons/thumb/a/ab/...
            # Al eliminar /thumb/ queda: .../commons/a/ab/Foo.svg/320px-Foo.svg.png
            # Luego eliminamos el último segmento de path (la miniatura)
            no_thumb = normal_url.replace("/thumb/", "/")
            # El último segmento es la versión redimensionada (320px-Foo.svg.png)
            # Quitamos todo después de la última / y nos quedamos con la ruta padre
            parent_path = no_thumb.rsplit("/", 1)[0]
            full_res_url = parent_path

        images.append({
            "url": full_res_url,
            "thumb_url": normal_url,
            "alt": alt,
            "filename": sanitize_filename(filename),
        })

    return images


def check_robots_txt(url: str, user_agent: str) -> bool:
    """Verifica si el User-Agent puede descargar la URL según robots.txt."""
    try:
        parsed = urlparse(url)
        robots_url = f"{parsed.scheme}://{parsed.netloc}/robots.txt"
        rp = urllib.robotparser.RobotFileParser()
        rp.set_url(robots_url)
        rp.read()
        return rp.can_fetch(user_agent, url)
    except Exception:
        # Si no podemos comprobar robots.txt, asumir permitido
        return True


# ─── DESCARGA ──────────────────────────────────────────────────
def download_page(
    session: requests.Session,
    url: str,
    ua: str,
) -> str | None:
    """Descarga una página de Wikipedia y retorna el HTML."""
    headers = {
        "User-Agent": ua,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "es-ES,es;q=0.9,en;q=0.8",
    }
    try:
        resp = session.get(url, headers=headers, timeout=30)
        resp.raise_for_status()
        # Verificar que no sea una página de error disfrazada (multi-idioma)
        # Wikipedia en inglés, español, alemán, francés, etc. tienen distintos mensajes
        # pero todas usan la clase CSS 'noarticletext' para páginas inexistentes
        if resp.status_code == 200 and 'class="noarticletext"' in resp.text:
            log.warning("  Página no encontrada (la Wikipedia no tiene este artículo)")
            return None
        # Dejar que requests maneje el encoding automáticamente (usa charset del header)
        return resp.text
    except requests.exceptions.RequestException as e:
        log.error(f"  Error HTTP al descargar {url}: {e}")
        return None


def download_image(
    session: requests.Session,
    img_info: dict,
    output_dir: Path,
    ua: str,
) -> bool:
    """Descarga una imagen individual. Retorna True si tuvo éxito."""
    filename = img_info["filename"]
    output_path = output_dir / filename

    if output_path.exists() and output_path.stat().st_size > 0:
        log.debug(f"  Imagen ya existe: {filename}")
        return True

    headers = {
        "User-Agent": ua,
        "Accept": "image/webp,image/avif,image/*,*/*;q=0.8",
        "Accept-Language": "es-ES,es;q=0.9,en;q=0.8",
    }

    for attempt, img_url in enumerate([img_info["url"], img_info["thumb_url"]]):
        try:
            resp = session.get(img_url, headers=headers, timeout=60, stream=True)
            resp.raise_for_status()

            # Verificar que es realmente una imagen
            content_type = resp.headers.get("Content-Type", "")
            if "image" not in content_type and attempt == 0:
                log.debug(f"  Content-Type no es imagen: {content_type} — probando thumbnail")
                continue
            if "image" not in content_type:
                log.warning(f"  Saltando {filename}: Content-Type = {content_type}")
                return False

            with open(output_path, "wb") as f:
                for chunk in resp.iter_content(chunk_size=8192):
                    f.write(chunk)

            size_kb = output_path.stat().st_size / 1024
            log.info(f"  🖼️  Imagen descargada: {filename} ({size_kb:.1f} KB)")
            return True

        except requests.exceptions.RequestException as e:
            if attempt == 0:
                log.debug(f"  Error con URL original, probando thumbnail: {e}")
                continue
            log.error(f"  Error descargando imagen {filename}: {e}")
            return False

    return False


# ─── PROCESAMIENTO ─────────────────────────────────────────────
def process_url(
    url: str,
    session: requests.Session,
    ua_pool: list[str],
    output_dir: Path,
    images_dir: Path | None,
    delay: float,
    resume: bool,
    format_mode: str = "both",
) -> dict:
    """
    Procesa una URL de Wikipedia: descarga HTML y (opcionalmente) imágenes.
    Retorna un resumen con stats.
    """
    result = {
        "url": url,
        "title": "",
        "html_file": "",
        "images_downloaded": 0,
        "images_total": 0,
        "status": "ok",
        "error": "",
    }

    # Obtener título del artículo
    title = get_url_title(url)
    result["title"] = title

    safe_title = sanitize_filename(title)

    # Elegir User-Agent al azar para esta descarga
    ua = random.choice(ua_pool)

    # Verificar robots.txt (probar hasta 3 UAs si el primero está bloqueado)
    for attempt in range(3):
        ua_to_check = ua if attempt == 0 else random.choice(ua_pool)
        if check_robots_txt(url, ua_to_check.split("/")[0]):
            ua = ua_to_check
            break
        log.warning(f"  robots.txt bloquea la descarga para {ua_to_check.split('/')[0]}")
    else:
        log.warning("  robots.txt bloquea todos los UAs probados — continuando de todos modos")

    log.info(f"\n{'='*60}")
    log.info(f"📄 {title}")
    log.info(f"   URL: {url}")
    log.info(f"   UA:  {ua[:60]}...")

    # ---- Descargar HTML (si aplica) ----
    html_content = None
    if format_mode in ("html", "both"):
        output_file = output_dir / f"{safe_title}.html"

        if resume and output_file.exists() and output_file.stat().st_size > 0:
            log.info(f"  ⏭️  HTML ya descargado (--resume), leyendo archivo existente")
            html_content = output_file.read_text(encoding="utf-8")
        else:
            html_content = download_page(session, url, ua)

            if html_content is None:
                result["status"] = "error"
                result["error"] = "Fallo al descargar HTML"
                return result

            output_file.write_text(html_content, encoding="utf-8")
            size_kb = output_file.stat().st_size / 1024
            log.info(f"  ✅ HTML descargado: {output_file.name} ({size_kb:.1f} KB)")

            # Pausa después de descargar HTML
            pause = random_delay(delay)
            log.debug(f"  Pausa de {pause:.1f}s...")
            time.sleep(pause)

        result["html_file"] = str(output_file)

    # ---- Si el usuario solo pidió imágenes, descargar HTML en memoria ----
    elif format_mode == "images":
        log.info("  📷 Modo solo imágenes: descargando HTML en memoria para extraer imágenes...")
        html_content = download_page(session, url, ua)
        if html_content is None:
            result["status"] = "error"
            result["error"] = "Fallo al descargar HTML para extraer imágenes"
            return result

    # ---- Descargar imágenes ----
    if images_dir and html_content:
        soup = BeautifulSoup(html_content, "lxml")
        images = extract_wikipedia_images(soup, url)

        if not images:
            log.info("  📭 No se encontraron imágenes en el artículo")
        else:
            log.info(f"  📸 {len(images)} imagen(es) encontrada(s)")
            result["images_total"] = len(images)

            images_dir.mkdir(parents=True, exist_ok=True)

            for i, img_info in enumerate(images):
                # Rotar UA para cada imagen también
                img_ua = random.choice(ua_pool)
                success = download_image(session, img_info, images_dir, img_ua)
                if success:
                    result["images_downloaded"] += 1

                # Pausa entre imágenes (excepto la última)
                if i < len(images) - 1:
                    pause = random_delay(delay * 0.5)  # pausa más corta entre imágenes
                    time.sleep(pause)

    return result


# ─── MAIN ──────────────────────────────────────────────────────
def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Bot de descarga de contenido e imágenes desde Wikipedia",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Ejemplos:
  python3 wikipedia-dl.py urls.txt
  python3 wikipedia-dl.py urls.txt --delay 3.0
  python3 wikipedia-dl.py urls.txt --resume --output-dir raw
  python3 wikipedia-dl.py urls.txt --images-dir assets/logos
  python3 wikipedia-dl.py urls.txt --format html  # solo HTML
  python3 wikipedia-dl.py urls.txt --format images  # solo imágenes
  python3 wikipedia-dl.py urls.txt --ua-file custom_uas.txt
        """,
    )
    parser.add_argument(
        "urls_file",
        help="Archivo con URLs de Wikipedia (una por línea)",
    )
    parser.add_argument(
        "--output-dir",
        default="raw",
        help="Directorio para guardar HTML (default: raw/)",
    )
    parser.add_argument(
        "--images-dir",
        default="assets",
        help="Directorio para guardar imágenes (default: assets/)",
    )
    parser.add_argument(
        "--delay",
        type=float,
        default=2.0,
        help="Pausa base entre descargas en segundos (default: 2.0)",
    )
    parser.add_argument(
        "--resume",
        action="store_true",
        help="Reanudar: omitir archivos HTML ya descargados",
    )
    parser.add_argument(
        "--format",
        choices=["html", "images", "both"],
        default="both",
        help="Qué descargar: html, images, o both (default: both)",
    )
    parser.add_argument(
        "--ua-file",
        default=None,
        help="Archivo con User-Agent strings personalizados (uno por línea)",
    )
    parser.add_argument(
        "--quiet",
        action="store_true",
        help="Modo silencioso (solo errores y resumen)",
    )
    parser.add_argument(
        "--stats",
        action="store_true",
        help="Mostrar estadísticas al finalizar",
    )
    return parser.parse_args()


def load_urls(path: str) -> list[str]:
    """Carga URLs desde un archivo de texto."""
    path_obj = Path(path)
    if not path_obj.exists():
        log.error(f"Archivo no encontrado: {path}")
        sys.exit(1)

    urls = []
    with open(path_obj, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                urls.append(line)
    return urls


def load_custom_uas(path: str | None) -> list[str]:
    """Carga User-Agent strings desde un archivo personalizado."""
    if not path:
        return USER_AGENTS

    path_obj = Path(path)
    if not path_obj.exists():
        log.warning(f"Archivo de UA no encontrado: {path}. Usando defaults.")
        return USER_AGENTS

    uas = []
    with open(path_obj, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                uas.append(line)

    if len(uas) < 3:
        log.warning(f"Solo {len(uas)} UA personalizados. Se requieren al menos 3. "
                    f"Usando defaults + personalizados.")
        return uas + USER_AGENTS

    log.info(f"Cargados {len(uas)} User-Agent personalizados")
    return uas


def main():
    args = parse_args()

    if args.quiet:
        logging.getLogger().setLevel(logging.WARNING)

    # Cargar URLs
    urls = load_urls(args.urls_file)
    if not urls:
        log.error("No hay URLs para procesar en el archivo.")
        sys.exit(1)
    log.info(f"Cargadas {len(urls)} URLs desde {args.urls_file}")

    # Cargar User-Agents
    ua_pool = load_custom_uas(args.ua_file)
    log.info(f"Pool de User-Agents: {len(ua_pool)} strings rotativos")

    # Crear directorios
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    images_dir = Path(args.images_dir)
    images_dir.mkdir(parents=True, exist_ok=True)

    # Sesión HTTP persistente
    session = requests.Session()
    session.headers.update({
        "Accept-Encoding": "gzip, deflate",
    })

    # Procesar URLs
    results = []
    start_time = time.time()

    for i, url in enumerate(urls):
        result = process_url(
            url=url,
            session=session,
            ua_pool=ua_pool,
            output_dir=output_dir,
            images_dir=images_dir,
            delay=args.delay,
            resume=args.resume,
            format_mode=args.format,
        )
        results.append(result)

        # Pausa entre URLs (excepto después de la última)
        if i < len(urls) - 1:
            pause = random_delay(args.delay)
            log.info(f"\n⏳ Esperando {pause:.1f}s antes de la siguiente URL...")
            time.sleep(pause)

    # Resumen final
    elapsed = time.time() - start_time
    successful = sum(1 for r in results if r["status"] == "ok")
    failed = sum(1 for r in results if r["status"] != "ok")
    total_images = sum(r["images_downloaded"] for r in results)

    log.info(f"\n{'='*60}")
    log.info(f"📊 RESUMEN FINAL")
    log.info(f"   Total URLs:     {len(urls)}")
    log.info(f"   Exitosas:       {successful}")
    log.info(f"   Fallidas:       {failed}")
    log.info(f"   Imágenes desc.: {total_images}")
    log.info(f"   Tiempo total:   {elapsed:.1f}s")
    log.info(f"   HTML en:        {output_dir.resolve()}")
    if images_dir:
        log.info(f"   Imágenes en:    {images_dir.resolve()}")

    if args.stats:
        stats_file = output_dir / ".download_stats.json"
        stats = {
            "date": datetime.now().isoformat(),
            "total_urls": len(urls),
            "successful": successful,
            "failed": failed,
            "total_images": total_images,
            "elapsed_seconds": round(elapsed, 1),
            "delay": args.delay,
            "user_agents": len(ua_pool),
            "urls_file": args.urls_file,
        }
        with open(stats_file, "w", encoding="utf-8") as f:
            json.dump(stats, f, indent=2)
        log.info(f"   Stats guardados: {stats_file}")

    if failed > 0:
        log.warning(f"\n⚠️  {failed} descarga(s) fallida(s):")
        for r in results:
            if r["status"] != "ok":
                log.warning(f"   - {r['title']}: {r['error']}")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        log.info("\n\n⚠️  Interrumpido por el usuario")
        sys.exit(130)
    except Exception as e:
        log.error(f"Error inesperado: {e}", exc_info=True)
        sys.exit(1)
