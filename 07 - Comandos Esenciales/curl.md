---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: media
---

# curl

## Sintaxis
```
curl [opciones] URL
```

## Descripción
Transfiere datos desde o hacia un servidor usando protocolos de red (HTTP, HTTPS, FTP, SFTP, etc.). Es la navaja suiza para interactuar con servicios web desde la terminal: descargar archivos, probar APIs REST, ver cabeceras HTTP, etc.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-O` | Descargar archivo conservando el nombre remoto |
| `-o <archivo>` | Guardar salida en un archivo específico |
| `-L` | Seguir redirecciones HTTP (301/302) |
| `-I` | Solo cabeceras HTTP (HEAD request) |
| `-s` | Modo silencioso (sin barra de progreso) |
| `-S` | Mostrar errores (usar con `-s`) |
| `-v` | Verboso — muestra request y response completos |
| `-u usuario:contraseña` | Autenticación básica HTTP |
| `-H "Header: valor"` | Cabecera HTTP personalizada |
| `-d "datos"` | Enviar datos en POST (`-X POST` implícito) |
| `-X <MÉTODO>` | Especificar método HTTP (GET, POST, PUT, DELETE) |
| `-k` | Permitir conexiones SSL inseguras (no verificar certificado) |

## Ejemplos
```bash
# Descargas
curl -O https://ejemplo.com/archivo.zip           # descargar con nombre original
curl -o mi-app.AppImage https://ejemplo.com/app   # descargar y renombrar

# APIs REST
curl https://api.github.com/users/octocat         # GET (JSON)
curl -s https://api.github.com/users/octocat | jq .  # con jq para formatear JSON
curl -I https://google.com                        # solo cabeceras
curl -X POST -d '{"nombre":"test"}' -H "Content-Type: application/json" https://api.ejemplo.com

# Diagnóstico
curl -v https://ejemplo.com                       # ver request y response completos
curl -s -o /dev/null -w "%{http_code}" https://ejemplo.com   # solo código HTTP
curl -L -o /dev/null -w "%{url_effective}" https://httpbin.org/redirect/3  # ver URL final tras redirects
```

## curl vs wget

| Característica | curl | wget |
|---|---|---|
| Descargar archivos | ✅ `-O` | ✅ Nativo |
| Seguir redirects | ✅ `-L` | ✅ Por defecto |
| Descarga recursiva | ❌ | ✅ `-r` |
| Subir archivos | ✅ `-F` o `-T` | ❌ |
| Probado APIs | ✅ Excelente | ❌ Básico |
| Verbosidad request | ✅ `-v` | ❌ |

**Cuándo usar cada uno**: `curl` para interactuar con APIs, probar cabeceras, subir archivos. `wget` para descargas simples y recursivas.

## Notas y advertencias
- Por defecto, `curl` muestra la respuesta en **stdout** (la terminal). Usar `-O` o `-o` para guardar en archivo.
- Si descargas un script de internet para pipearlo a bash (`curl https://ejemplo.com/script.sh | bash`), asegúrate de confiar en la fuente.
- `curl -k` omite verificación SSL — útil para desarrollo local, peligroso en producción.
- Combinado con `jq` (procesador JSON), `curl` se vuelve un cliente REST completo desde terminal.

## Ver también
- [[ping]]
- [[Redes Basicas]]
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — cURL](https://en.wikipedia.org/wiki/CURL)
- [Sitio oficial — curl.se](https://curl.se/)
- [GitHub — curl/curl](https://github.com/curl/curl)

#comando
