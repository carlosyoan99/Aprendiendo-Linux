---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: baja
---

# httpie

> Cliente HTTP con sintaxis expresiva y salida coloreada. Alternativa moderna a `curl` para interactuar con APIs REST desde la terminal.

## Qué es

**httpie** (comando: `http`) es un cliente HTTP diseñado para ser más legible y expresivo que `curl`. Su sintaxis separa URL, cabeceras y cuerpo de forma intuitiva, y colorea el JSON automáticamente. Ideal para trabajar con APIs REST de forma interactiva.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install httpie

# Arch
sudo pacman -S httpie

# Fedora
sudo dnf install httpie

# pip (versión más reciente)
pip install httpie
```

## Sintaxis básica

```bash
http [flags] [METHOD] URL [ITEM ...]
```

Los ITEM pueden ser:

| Tipo | Ejemplo | Descripción |
|---|---|---|
| Cabeceras | `Authorization:token123` | Cabecera HTTP (string) |
| Datos form | `name=John` | Datos de formulario (POST) |
| JSON simple | `name:=John` | JSON con `:=` (parsea como JSON) |
| JSON array | `tags:=['a','b']` | Array JSON |
| JSON object | `meta:='{"key":"val"}'` | Objeto JSON |
| Query param | `page==1` | Parámetro de query string |

## Ejemplos

```bash
# GET básico
http https://api.github.com/users/octocat

# GET con cabeceras
http https://api.github.com/repos/curl/curl Authorization:"token xyz"

# POST con JSON
http POST https://jsonplaceholder.typicode.com/posts \
    title:=foo \
    body:=bar \
    userId:=1

# POST con formulario
http -f POST https://httpbin.org/post name=John age=30

# PUT
http PUT https://jsonplaceholder.typicode.com/posts/1 \
    id:=1 \
    title:=updated \
    userId:=1

# DELETE
http DELETE https://jsonplaceholder.typicode.com/posts/1

# Con autenticación básica
http -a usuario:contraseña https://api.ejemplo.com/recurso

# Seguir redirecciones
http --follow https://httpbin.org/redirect/3

# Descargar archivo
http --download https://example.com/archivo.zip

# Ver solo cabeceras de respuesta
http --headers https://google.com

# Salida sin colores (para pipes/scripts)
http --pretty=none https://api.github.com/users/octocat
```

## Casos de uso prácticos

```bash
# 1. Probar una API REST local
http POST localhost:3000/api/users name:=John email:="john@test.com"

# 2. Ver cabeceras de respuesta de un sitio
http --headers https://google.com

# 3. Autenticación con token Bearer
http https://api.github.com/user Authorization:"Bearer ghp_xxx"

# 4. Subir archivo
http -f POST https://httpbin.org/post file@~/foto.jpg

# 5. Probar webhook (enviar JSON)
http POST https://webhook.site/xxx event:=push data:='{"ref":"main"}'
```

## httpie vs curl

| Aspecto | httpie | curl |
|---|---|---|
| **Sintaxis** | `http GET url key=val` | `curl -X GET -d 'key=val' url` |
| **JSON automático** | ✅ Colorea y formatea | ❌ Raw |
| **POST JSON** | `name:=John` | `-H 'Content-Type: application/json' -d '{"name":"John"}'` |
| **Cabeceras** | `Header:value` | `-H 'Header: value'` |
| **Salida coloreada** | ✅ Por defecto | ❌ |
| **Preinstalado** | ❌ | ✅ En casi todas las distros |
| **Scripting** | ❌ Menos compatible | ✅ El estándar para scripts |
| **Peso** | ~5 MB | ~2 MB |

> httpie es mejor para **uso interactivo** y debugging de APIs. curl es mejor para **scripts** por su ubicuidad y opciones avanzadas (reintentos, timeouts, etc.).

## Pipe con jq

```bash
# httpie + jq para procesar JSON
http https://api.github.com/users/octocat/repos | jq '.[].name'

# Filtrar campos específicos
http https://api.github.com/users/octocat | jq '{login, name, location}'

# Contar elementos
http https://api.github.com/users/octocat/repos | jq length
```

## Ver también

- [[curl]] — cliente HTTP clásico (mejor para scripts)
- [[jq]] — procesador JSON de terminal
- [[fx]] — visor JSON interactivo
- [[xh]] — alternativa Rust a httpie

## Enlaces externos

- [Sitio oficial de httpie](https://httpie.io/)
- [GitHub — httpie/cli](https://github.com/httpie/cli)
- [Documentación](https://httpie.io/docs)

#programa #herramientas #red #http
