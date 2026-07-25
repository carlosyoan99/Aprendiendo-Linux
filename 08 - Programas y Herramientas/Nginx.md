---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: programa
prioridad: media
licencia: BSD-like
alternativas: Apache HTTPD, Caddy, Lighttpd, HAProxy
---

# Nginx

> Servidor web, proxy inverso, balanceador de carga y proxy de correo de alto rendimiento. Diseñado para manejar **miles de conexiones simultáneas** con un uso mínimo de recursos gracias a su arquitectura asíncrona basada en eventos.

## Historia

| Hito | Año |
|---|---|
| Desarrollo inicial por **Igor Sysoev** (Rusia) | 2002 |
| Lanzamiento público | 2004 |
| Soporte comercial (NGINX Inc.) | 2011 |
| Versión estable moderna (1.26.x) | 2024 |

Nginx nació para resolver el **problema C10K** (10,000 conexiones concurrentes) que Apache no podía manejar bien con su modelo basado en procesos/hilos. Su arquitectura basada en eventos lo hizo significativamente más eficiente en recursos.

> Actualmente Nginx sirve ~**30% de los sitios web** del mundo (tras Apache, que ronda el ~31%, pero en sitios de alto tráfico Nginx domina).

## Instalación

```bash
# Debian/Ubuntu
sudo apt install nginx

# Arch Linux
sudo pacman -S nginx

# Fedora/RHEL
sudo dnf install nginx

# Verificar instalación
nginx -v
nginx -V                    # versión + módulos compilados

# Iniciar y habilitar
sudo systemctl enable --now nginx
sudo systemctl status nginx
```

### Estructura de directorios

| Ruta | Propósito |
|---|---|
| `/etc/nginx/` | Configuración principal |
| `/etc/nginx/nginx.conf` | Archivo de configuración principal |
| `/etc/nginx/sites-available/` | Sitios disponibles (Debian/Ubuntu) |
| `/etc/nginx/sites-enabled/` | Sitios activos (enlaces simbólicos) |
| `/etc/nginx/conf.d/` | Fragmentos de configuración (RHEL/Fedora) |
| `/usr/share/nginx/html/` | Raíz web por defecto |
| `/var/log/nginx/access.log` | Log de accesos |
| `/var/log/nginx/error.log` | Log de errores |
| `/var/cache/nginx/` | Caché de proxy y FastCGI |
| `/etc/nginx/modules-available/` | Módulos dinámicos disponibles |

## Configuración básica

### nginx.conf mínimo

```nginx
# /etc/nginx/nginx.conf
user www-data;
worker_processes auto;          # un worker por núcleo de CPU
pid /run/nginx.pid;

events {
    worker_connections 1024;     # conexiones por worker
    multi_accept on;
    use epoll;                   # Linux: epoll, FreeBSD: kqueue
}

http {
    # MIME types
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Rendimiento
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;

    # Logs
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;

    # Incluir sitios
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

### Server block (virtual host)

```nginx
# /etc/nginx/sites-available/misitio.conf
server {
    listen 80;
    listen [::]:80;                     # IPv6
    server_name misitio.com www.misitio.com;
    root /var/www/misitio;

    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    # Logs específicos del sitio
    access_log /var/log/nginx/misitio-access.log;
    error_log /var/log/nginx/misitio-error.log;
}
```

```bash
# Activar sitio (Debian/Ubuntu)
sudo ln -s /etc/nginx/sites-available/misitio.conf /etc/nginx/sites-enabled/
sudo nginx -t                          # probar config antes de recargar
sudo systemctl reload nginx
```

### Location blocks — matching

```nginx
# Prioridad (de mayor a menor):
# 1. = (exact match)
# 2. ^~ (prefijo con prioridad sobre regex)
# 3. ~ / ~* (regex, case-sensitive / insensitive)
# 4. (prefijo simple)

location = /favicon.ico {          # exact match
    log_not_found off;
    access_log off;
}

location /static/ {                 # prefijo simple: /static/*
    root /var/www;
    expires 365d;
}

location ~* \.(jpg|jpeg|png|css|js)$ {  # regex: archivos estáticos
    expires 7d;
    add_header Cache-Control "public, immutable";
}
```

## Directivas clave

| Directiva | Contexto | Descripción |
|---|---|---|
| `worker_processes` | `main` | Número de workers (`auto` = núcleos) |
| `worker_connections` | `events` | Conexiones simultáneas por worker |
| `sendfile` | `http/server/location` | Envío eficiente de archivos (copia desde kernel) |
| `keepalive_timeout` | `http/server/location` | Tiempo de conexión persistente |
| `client_max_body_size` | `http/server/location` | Tamaño máximo del cuerpo de la petición (default 1M) |
| `proxy_pass` | `location` | Proxy a backend (ver sección abajo) |
| `return` | `server/location` | Redirección o respuesta directa |
| `rewrite` | `server/location` | Reescritura de URI |
| `try_files` | `location` | Fallback de archivos (muy usado en PHP/SPA) |
| `add_header` | `http/server/location` | Añadir cabeceras HTTP de respuesta |
| `expires` | `http/server/location` | Cabecera Cache-Control + Expires |

## Proxy inverso

Nginx como proxy inverso es su uso más potente: recibe peticiones y las redirige a servidores de aplicaciones (Gunicorn, uWSGI, Node.js, Tomcat).

```nginx
# Proxy a una app Node.js corriendo en localhost:3000
server {
    listen 80;
    server_name app.misitio.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # WebSocket support
    location /ws/ {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### Cabeceras de proxy recomendadas

| Cabecera | Propósito |
|---|---|
| `Host $host` | Preserva el host original |
| `X-Real-IP $remote_addr` | IP real del cliente |
| `X-Forwarded-For` | Cadena de IPs (cliente + proxies intermedios) |
| `X-Forwarded-Proto $scheme` | HTTP o HTTPS original |
| `Upgrade/Connection` | Necesaria para WebSockets |

## TLS/SSL (HTTPS)

### Certificado autofirmado (para pruebas)

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/misitio.key \
    -out /etc/nginx/ssl/misitio.crt \
    -subj "/CN=misitio.com"
```

### Server block con HTTPS

```nginx
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name misitio.com;

    # Certificados
    ssl_certificate /etc/nginx/ssl/misitio.crt;
    ssl_certificate_key /etc/nginx/ssl/misitio.key;

    # Configuración moderna de seguridad
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers off;

    # HSTS (HTTP Strict Transport Security)
    add_header Strict-Transport-Security "max-age=63072000" always;

    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 1.1.1.1 8.8.8.8 valid=300s;
    resolver_timeout 5s;

    # Raíz web
    root /var/www/misitio;
    index index.html;
}

# Redirección HTTP → HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name misitio.com www.misitio.com;
    return 301 https://$server_name$request_uri;
}
```

### Certificados reales con Let's Encrypt

```bash
# Instalar certbot
sudo apt install certbot python3-certbot-nginx

# Obtener y configurar automáticamente
sudo certbot --nginx -d misitio.com -d www.misitio.com

# Renovación automática (certbot añade timer systemd)
sudo certbot renew --dry-run
```

## Balanceo de carga

Nginx puede distribuir tráfico entre múltiples servidores backend:

```nginx
upstream backend {
    # Algoritmos de balanceo
    # (por defecto: round-robin)
    # least_conn;       # menos conexiones activas
    # ip_hash;          # sticky sessions por IP
    # random;           # aleatorio

    server 10.0.0.1:3000 weight=3;   # recibe 3x más tráfico
    server 10.0.0.2:3000;
    server 10.0.0.3:3000 backup;      # solo si los otros fallan

    # Health checks (requiere NGINX Plus o módulo nginx-upsync)
    keepalive 32;
}

server {
    listen 80;
    server_name balanceado.misitio.com;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Algoritmos de balanceo

| Algoritmo | Comportamiento |
|---|---|
| **round-robin** (default) | Distribuye equitativamente en orden |
| **least_conn** | Envía al servidor con menos conexiones activas |
| **ip_hash** | Misma IP siempre al mismo servidor (sesiones persistentes) |
| **random** | Selección aleatoria |
| **weight** | Pesos en round-robin (server ... weight=3) |

## FastCGI (PHP)

```nginx
server {
    listen 80;
    server_name php.misitio.com;
    root /var/www/phpapp;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Denegar acceso a archivos ocultos
    location ~ /\. {
        deny all;
    }
}
```

## Seguridad

```nginx
# Cabeceras de seguridad básicas
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "0" always;      # obsoleto pero por compatibilidad
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;

# Limitar tasa (rate limiting)
limit_req_zone $binary_remote_addr zone=milimite:10m rate=10r/s;

location /login {
    limit_req zone=milimite burst=20 nodelay;
    proxy_pass http://backend;
}

# Ocultar versión de Nginx
server_tokens off;

# Limitar tamaño de body
client_max_body_size 10M;

# Denegar IPs
deny 192.168.1.100;
allow 192.168.1.0/24;
deny all;
```

## Optimización de rendimiento

```nginx
# En events { }
worker_connections 2048;
use epoll;

# En http { }
sendfile on;
tcp_nopush on;
tcp_nodelay on;
output_buffers 32 32k;
postpone_output 1460;

# Caché de archivos abiertos
open_file_cache max=1000 inactive=20s;
open_file_cache_valid 30s;
open_file_cache_min_uses 2;
open_file_cache_errors on;

# Caché de proxy (para Nginx como proxy inverso)
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=micache:10m
                 max_size=1g inactive=60m use_temp_path=off;

location /api/ {
    proxy_cache micache;
    proxy_cache_valid 200 5m;
    proxy_cache_valid 404 1m;
    proxy_pass http://backend;
}
```

## Troubleshooting

| Problema | Causa probable | Solución |
|---|---|---|
| `nginx: [emerg] bind() to 0.0.0.0:80 failed` | Puerto 80 ocupado | `sudo ss -tlnp \| grep :80`, matar proceso |
| `403 Forbidden` | Permisos incorrectos | `chmod 755 /var/www/misitio`, verificar `user` en nginx.conf |
| `Connection refused` al proxy_pass | Backend no corre | Verificar `systemctl status app`, puerto en escucha |
| Certificado SSL caducado | No se renovó Let's Encrypt | `sudo certbot renew` |
| `client intended to send too large body` | `client_max_body_size` muy bajo | Aumentar directiva |
| `502 Bad Gateway` | Backend caído o socket incorrecto | Verificar path del socket en `fastcgi_pass` o `proxy_pass` |
| Archivos estáticos no cargan | `sendfile` off o MIME types incorrectos | Verificar `include mime.types` |
| Redirect loop | `proxy_set_header Host` incorrecto | Asegurar que el backend recibe el Host correcto |

### Comandos de diagnóstico

```bash
# Probar configuración
sudo nginx -t

# Ver configuración completa procesada
sudo nginx -T

# Recargar sin cortar conexiones
sudo systemctl reload nginx

# Ver conexiones activas
sudo ss -tlnp | grep nginx

# Logs en tiempo real
sudo tail -f /var/log/nginx/access.log
sudo journalctl -u nginx -f --no-pager

# Probar respuesta HTTP
curl -I http://localhost
curl -I https://localhost -k  # ignorar SSL autofirmado
```

## Comparativa: Nginx vs Apache

| Aspecto | Nginx | Apache |
|---|---|---|
| **Arquitectura** | Asíncrona, basada en eventos | Basada en procesos/hilos |
| **Conexiones concurrentes** | Excelente (C10K+) | Buena (consume más RAM) |
| **Archivos estáticos** | Muy rápido (sendfile) | Adecuado |
| **Configuración** | Bloques `server`/`location` | Bloques `<VirtualHost>`/`<Directory>` |
| **.htaccess** | ❌ No soportado | ✅ Sí, por directorio |
| **Módulos dinámicos** | Sí (desde 1.9.11) | Sí (tradicional) |
| **PHP integración** | Vía FastCGI (externo) | Vía `mod_php` (integrado) |
| **Proxy inverso** | Excelente (nativo) | Correcto (requiere mod_proxy) |
| **Balanceo de carga** | Nativo (upstream) | Vía mod_proxy_balancer |
| **Streaming/TCP** | Nativo (stream {}) | No |

## Enlaces externos

- [Sitio oficial](https://nginx.org/)
- [Documentación oficial](https://nginx.org/en/docs/)
- [Nginx Wiki](https://www.nginx.com/resources/wiki/)
- [NGINXConfig — Generador de config online](https://nginxconfig.io/)
- [Let's Encrypt — Certificados gratis](https://letsencrypt.org/)

## Ver también

- [[Firewall]] — apertura de puertos para HTTP/HTTPS
- [[Docker]] — contenedores donde suele correr Nginx
- [[systemd]] — gestión del servicio Nginx
- [[journalctl]] — logs del servicio Nginx
- [[Redes Basicas]] — conceptos de red subyacentes
- [Certbot](https://certbot.eff.org/) — automatización de certificados SSL con Let's Encrypt

#programa #web #servidor
