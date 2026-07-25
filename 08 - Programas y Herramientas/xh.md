---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# xh

> Cliente HTTP en Rust, compatible con la sintaxis de httpie pero más rápido y como binario único estático. Alternativa ligera a httpie y curl para interactuar con APIs REST.

## Qué es

**xh** es un cliente HTTP moderno escrito en Rust que replica la sintaxis expresiva de httpie con mejor rendimiento de arranque (binario compilado vs Python interpretado). Distribuido como binario único estático sin dependencias externas.

**Ventajas clave:**
- **Binario único**: ~5 MB, sin necesidad de Python, Node.js ni intérprete
- **Rápido**: arranque instantáneo frente a los ~200-400ms de httpie
- **Compatible**: misma sintaxis que httpie (`header:value`, `key=val`, `key:=json`)
- **HTTP/2**: soporte nativo (httpie añadió HTTP/2 en v3.0)
- **Flag `--curl`**: convierte cualquier comando xh a curl equivalente (útil para depurar)

## Instalación

```bash
# Debian/Ubuntu (desde Debian 13 / Ubuntu 25.04+)
sudo apt install xh

# Arch
sudo pacman -S xh

# Fedora (COPR)
sudo dnf copr enable atim/xh
sudo dnf install xh

# Cargo (Rust)
cargo install xh --locked

# Binario estático (recomendado para versiones recientes)
curl -sL https://github.com/ducaale/xh/releases/latest/download/xh-linux-amd64.tar.gz | tar xz
sudo mv xh /usr/local/bin/

# Verificar
xh --version
```

## Sintaxis

```bash
xh [flags] [METHOD] URL [ITEM ...]
```

Los ITEM son idénticos a httpie:

| Tipo | Ejemplo | Descripción |
|---|---|---|
| Cabeceras | `Authorization:token123` | Cabecera HTTP |
| Datos string | `name=John` | Campo de formulario / JSON string |
| Datos JSON | `name:=John` | Valor JSON (número, boolean, array, objeto) |
| JSON array | `tags:=['a','b']` | Array JSON |
| JSON object | `meta:='{"key":"val"}'` | Objeto JSON |
| Query param | `page==1` | Parámetro de query string |
| Descargar | `file@~/foto.jpg` | Subir archivo (multipart) |

## Ejemplos

```bash
# GET básico
xh https://api.github.com/users/octocat

# POST con JSON
xh POST https://jsonplaceholder.typicode.com/posts \
    title:=foo \
    body:=bar \
    userId:=1

# POST con formulario
xh -f POST https://httpbin.org/post name=John age=30

# PUT
xh PUT https://jsonplaceholder.typicode.com/posts/1 \
    id:=1 \
    title:=updated

# DELETE
xh DELETE https://jsonplaceholder.typicode.com/posts/1

# Con cabecera personalizada
xh GET https://api.github.com/user Authorization:"Bearer ghp_xxx"

# Query params
xh GET https://httpbin.org/json id==5 sort==true

# Seguir redirecciones
xh --follow https://httpbin.org/redirect/3

# Descargar archivo
xh -d https://example.com/archivo.zip -o archivo.zip

# Ver solo cabeceras
xh --headers https://google.com

# Atajo para localhost
xh :3000/api/users                     # = http://localhost:3000/api/users

# Forzar HTTPS (usando alias xhs)
# Si enlazas xh → xhs, automáticamente usa https://
```

## Flag `--curl`

```bash
# xh puede traducir cualquier comando a curl equivalente
xh --curl GET https://api.github.com/users/octocat

# Salida:
# curl -X GET https://api.github.com/users/octocat

# Con payload:
xh --curl POST https://httpbin.org/post name:=John
# curl -X POST -H 'Content-Type: application/json' -d '{"name":"John"}' https://httpbin.org/post
```

> Útil para: depurar, compartir comandos con quien solo usa curl, o ver exactamente qué envía xh por la red.

## Casos de uso

```bash
# 1. Probar API local con arranque rápido
xh POST localhost:3000/api/users name:=John email:="john@test.com"

# 2. Depurar webhook viendo el comando curl equivalente
xh --curl POST https://webhook.site/xxx event:=push

# 3. Scripting (xh tiene flags para evitar colores)
xh --pretty=none --print=Hb https://api.github.com/users/octocat

# 4. Subir archivo
xh -f POST https://httpbin.org/post file@~/foto.jpg

# 5. Ver métricas de tiempo de respuesta
xh --print=Hb --headers https://google.com
```

## xh vs httpie vs curl

| Aspecto | xh | httpie | curl |
|---|---|---|---|
| **Lenguaje** | Rust | Python | C |
| **Binario estático** | ✅ Sí (~5 MB) | ❌ Requiere Python | ✅ Sí (~2 MB) |
| **Arranque** | ⚡ Instantáneo (~5ms) | 🐢 ~200-400ms | ⚡ Instantáneo |
| **Sintaxis** | `key=val`, `key:=json` | `key=val`, `key:=json` | `-d 'key=val'`, `-H 'h: v'` |
| **JSON automático** | ✅ | ✅ | ❌ |
| **HTTP/2** | ✅ Nativo | ✅ Desde v3.0 | ✅ |
| **Flag `--curl`** | ✅ Traduce a curl | ❌ | ❌ |
| **Plugins** | ❌ | ✅ Extensible | ❌ |
| **Madurez** | Joven (2021+) | Madura (2012+) | Madurísima (1998+) |
| **Ideal para** | CLI rápida, APIs | Uso interactivo | Scripts, ubicuidad |

> xh es perfecto para **uso interactivo rápido** donde los ~300ms de arranque de httpie molestan, o donde no quieres instalar Python solo para un cliente HTTP. Para **scripts**, curl sigue siendo el estándar universal.

## Pipe con jq

```bash
# xh + jq (mismo ecosistema que httpie)
xh https://api.github.com/users/octocat/repos | jq '.[].name'

# Filtrar campos
xh https://api.github.com/users/octocat | jq '{login, name, location}'

# Contar
xh https://api.github.com/users/octocat/repos | jq length
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `xh: command not found` | No instalado | `sudo apt install xh` o binario estático desde GitHub |
| Quiero que use HTTPS por defecto | Crear alias `xhs` | `alias xhs='xh'` — detecta el nombre del binario |
| Error de conexión | URL sin protocolo | Usar `https://` explícito o alias `xhs` |
| Colores no se ven | Terminal sin soporte | `xh --pretty=none` para salida plana |
| Diferencia con httpie | Algún edge case | Usar `xh --curl` para ver el comando curl equivalente |

## Ver también

- [[httpie]] — el original en Python (más maduro, plugins)
- [[curl]] — el clásico (estándar en scripts)
- [[jq]] — procesador JSON para terminal
- [[fx]] — visor JSON interactivo
- [[TUI tools]] — otras herramientas TUI de red e HTTP

## Enlaces externos

- [GitHub — ducaale/xh](https://github.com/ducaale/xh)
- [Documentación](https://github.com/ducaale/xh#readme)
- [Comparativa xh vs httpie](https://github.com/ducaale/xh#comparison-between-xh-and-httpie)

#programa #herramientas #red #http
