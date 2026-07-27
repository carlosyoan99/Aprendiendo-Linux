---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# curl

> Transfiere datos desde o hacia un servidor usando protocolos de red (HTTP, HTTPS, FTP, SFTP, etc.). Es la navaja suiza para interactuar con servicios web desde la terminal: APIs REST, descargas, diagnóstico HTTP, subida de archivos.

## Sintaxis

```bash
curl [opciones] URL
curl [opciones] -d 'data' URL            # POST implícito
curl [opciones] -F 'campo=valor' URL     # multipart/form-data (subida)
```

## Descripción

`curl` (Client URL) es una herramienta de línea de comandos para transferir datos mediante más de 25 protocolos (HTTP, HTTPS, FTP, SFTP, SCP, LDAP, SMTP, etc.). Es la herramienta estándar para:

- **Probar APIs REST** (GET, POST, PUT, DELETE, PATCH)
- **Descargar archivos** desde cualquier URL
- **Diagnosticar servidores web** (cabeceras, tiempos, certificados SSL)
- **Automatizar interacciones** con servicios web en scripts

**⚠️ Seguridad**: pipear scripts de internet directamente a bash (`curl https://ejemplo.com/script.sh | bash`) es peligroso — verificar siempre la fuente antes de ejecutar.

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-O` | Descargar archivo conservando el nombre remoto | `curl -O https://ejemplo.com/archivo.zip` |
| `-o <archivo>` | Guardar salida en un archivo específico | `curl -o app.AppImage https://ejemplo.com/app` |
| `-L` | Seguir redirecciones HTTP (301/302/308) | `curl -L https://bit.ly/abc` |
| `-I` | Solo cabeceras HTTP (HEAD request) | `curl -I https://google.com` |
| `-s` | Modo silencioso (sin barra de progreso ni errores) | `curl -s https://api.ejemplo.com` |
| `-S` | Mostrar errores (usar con `-s`) | `curl -sS https://api.ejemplo.com` |
| `-v` | Verboso — muestra request y response completos | `curl -v https://ejemplo.com` |
| `-u user:pass` | Autenticación básica HTTP | `curl -u admin:pass https://api.ejemplo.com` |
| `-H "Key: val"` | Cabecera HTTP personalizada | `curl -H "Authorization: Bearer TOKEN" https://api.com` |
| `-d "datos"` | Enviar datos en POST (implica `-X POST`) | `curl -d '{"key":"val"}' https://api.com` |
| `-X <MÉTODO>` | Especificar método HTTP | `curl -X DELETE https://api.com/recurso/1` |
| `-k` | Permitir conexiones SSL inseguras | `curl -k https://localhost:8443` |
| `-F "campo=val"` | Multipart/form-data (para subir archivos) | `curl -F "file=@foto.jpg" https://api.com/upload` |
| `-T <archivo>` | Subir archivo (PUT) | `curl -T archivo.txt https://ejemplo.com/` |
| `--max-time <seg>` | Timeout máximo de la operación | `curl --max-time 10 https://ejemplo.com` |
| `--connect-timeout <seg>` | Timeout de conexión | `curl --connect-timeout 5 https://ejemplo.com` |
| `-w "%{formato}"` | Formato de salida personalizado | `curl -w "%{http_code}" URL` |
| `-o /dev/null` | Descartar el cuerpo de la respuesta | `curl -o /dev/null -w "%{http_code}" URL` |

## Formato de salida (-w)

Variables útiles para `-w`:

```bash
# Código de respuesta HTTP
curl -s -o /dev/null -w "%{http_code}\n" https://ejemplo.com
# → 200

# Tiempo total de la petición (segundos)
curl -s -o /dev/null -w "Tiempo total: %{time_total}s\n" https://ejemplo.com
# → Tiempo total: 0.345s

# Desglose de tiempos
curl -s -o /dev/null -w "\
  Tiempo conexión:  %{time_connect}\n\
  Tiempo TTFB:      %{time_starttransfer}\n\
  Tiempo total:     %{time_total}\n\
  Velocidad:        %{speed_download} B/s\n\
" https://ejemplo.com
```

## Ejemplos

```bash
# 1. Descargar archivo con nombre original
curl -O https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso

# 2. Descargar y renombrar
curl -o mi-app.AppImage https://ejemplo.com/app

# 3. GET básico (API REST)
curl https://api.github.com/repos/curl/curl

# 4. GET con JSON formateado (con jq)
curl -s https://api.github.com/users/octocat | jq .

# 5. Solo cabeceras (HEAD request)
curl -I https://google.com

# 6. POST con JSON
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"nombre":"test","email":"test@ejemplo.com"}' \
  https://api.ejemplo.com/usuarios

# 7. Autenticación Bearer (token JWT)
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..." \
  https://api.ejemplo.com/usuarios

# 8. Subir archivo (multipart/form-data)
curl -F "archivo=@documento.pdf" \
  -F "descripcion=Mi documento" \
  https://api.ejemplo.com/upload

# 9. Diagnóstico completo (ver request y response)
curl -v https://ejemplo.com

# 10. Solo código HTTP de respuesta
curl -s -o /dev/null -w "%{http_code}\n" https://ejemplo.com

# 11. Seguir redirects y ver URL final
curl -L -o /dev/null -w "%{url_effective}\n" https://httpbin.org/redirect/3

# 12. Timeout para peticiones lentas
curl --connect-timeout 5 --max-time 30 https://ejemplo.com
```

### Autenticación con cookies

```bash
# Guardar cookies después de login
curl -c cookies.txt -X POST \
  -d '{"username":"admin","password":"secret"}' \
  https://api.ejemplo.com/login

# Usar cookies guardadas para peticiones autenticadas
curl -b cookies.txt https://api.ejemplo.com/perfil
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Descargar release de GitHub** | `curl -L -o herramienta.tar.gz https://github.com/user/repo/releases/latest/download/linux-amd64.tar.gz` |
| **Verificar que un servicio está activo** | `curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health` |
| **Medir tiempo de respuesta** | `curl -s -o /dev/null -w "%{time_total}s\n" https://mi-servicio.com` |
| **Subir archivo a un endpoint** | `curl -F "file=@captura.png" https://api.imgbb.com/1/upload?key=API_KEY` |
| **Probar API con autenticación** | `curl -H "Authorization: Bearer TOKEN" https://api.ejemplo.com/recursos` |
| **Solicitar IP pública** | `curl -s https://api.ipify.org` |
| **Descargar script de instalación** (⚠️ verificar fuente) | `curl -fsSL https://get.docker.com | sh` |

## Combinaciones comunes con pipe

```bash
# Curl + jq para procesar JSON
curl -s https://api.github.com/repos/curl/curl/releases/latest | jq -r '.tag_name'

# Curl + grep para extraer info de cabeceras
curl -I https://ejemplo.com | grep -i "server\|x-powered-by"

# Curl + while para polling hasta que un servicio responda
while ! curl -s -o /dev/null http://localhost:3000/health; do sleep 1; done && echo "✅ Servicio listo"

# Curl + sha256sum para verificar checksum de descarga
curl -sL https://ejemplo.com/archivo.iso | sha256sum

# Descargar múltiples archivos en paralelo (con xargs)
echo -e "url1\nurl2\nurl3" | xargs -P 3 -I{} curl -O {} 
```

## Alternativas modernas

| Herramienta | Ventaja sobre curl |
|---|---|
| **httpie** (`http`) | Sintaxis más amigable para APIs: `http GET https://api.com nombre==valor`. Colorea JSON automáticamente |
| **wget** | Mejor para descargas recursivas (`-r`), descargas por lotes. No requiere `-O` para guardar archivos |
| **xh** (Rust) | Alternativa a httpie más rápida, escrita en Rust |
| **aria2c** | Descarga en paralelo por segmentos (mucho más rápido para archivos grandes). Soporta torrents |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `curl: (6) Could not resolve host` | DNS no resuelve el nombre | Verificar conectividad: `ping -c 1 google.com`. Probar con `nslookup` |
| `curl: (7) Failed to connect` | Servidor no accesible o firewall bloquea | Verificar URL, puerto (`curl -v http://localhost:3000`), reglas de firewall |
| `curl: (28) Operation timed out` | Servidor no responde en el tiempo límite | Aumentar `--max-time` o verificar estado del servidor |
| `curl: (35) SSL connect error` | Problema con el certificado SSL | Si es seguro ignorar: `curl -k`. Si no, actualizar CA certificates |
| `curl: (56) Unexpected EOF` | Servidor corta la conexión | Verificar logs del servidor, probar con `--http1.1` |
| `curl: (60) SSL certificate problem` | Certificado auto-firmado o caducado | Usar `-k` (dev) o instalar el CA correcto (prod) |
| **JSON sin formatear** en pantalla | curl no formatea JSON | Pipear a `jq`: `curl -s https://api.ejemplo.com | jq` |
| **La salida se mezcla con la terminal** | No hay salto de línea al final | Añadir `\n` al final: `curl -w "\n" URL` |

## Notas y advertencias

- **Salida a stdout**: por defecto, curl escribe la respuesta en la terminal. Usar `-O` (descargar) o `-o archivo` (guardar) según corresponda.
- **Pipear scripts a bash**: `curl -fsSL https://ejemplo.com/script.sh | sh` es conveniente pero peligroso. Siempre inspeccionar el script antes: `curl -fsSL https://ejemplo.com/script.sh | less`.
- **`-k` (insecure)**: omite la verificación del certificado SSL. Usar solo en desarrollo o entornos controlados. En producción, solucionar el certificado legítimo.
- **Rate limiting**: muchos servicios API limitan peticiones. `curl --limit-rate 100K` limita la velocidad de descarga.
- **User-Agent**: algunos servidores bloquean requests sin User-Agent. `curl -A "Mozilla/5.0" URL` simula un navegador.
- **Código de retorno**: curl devuelve 0 si la transferencia fue exitosa (sin errores de protocolo ni red). Un código HTTP 404/500 **no** hace que curl falle.

## Enlaces externos

- [Sitio oficial — curl.se](https://curl.se/)
- [Wikipedia — cURL](https://en.wikipedia.org/wiki/CURL)
- [GitHub — curl/curl](https://github.com/curl/curl)
- [curl manual completo](https://curl.se/docs/manual.html)
- [Everything curl — libro online](https://everything.curl.dev/)
- [Arch Wiki — curl](https://wiki.archlinux.org/title/Curl)

## Ver también

- [[wget]] — alternativa para descargas simples y recursivas
- [[ping]] — diagnóstico de conectividad básica
- [[Redes Basicas]] — conceptos de red
- [[SSH]] — transferencia segura de archivos
- [[jq]] — procesador JSON para terminal
- [[httpie]] — cliente HTTP con sintaxis más amigable
- [[Cheat Sheet - Comandos Esenciales]]

#comando
