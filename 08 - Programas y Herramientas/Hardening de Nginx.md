---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
licencia: BSD-like
alternativas: [[Nginx]]
---

# Hardening de Nginx

> Guía práctica para **endurecer Nginx en producción**: TLS moderno, cabeceras de seguridad, protección contra brute force, WAF, ocultamiento de versión y auditoría. Complementa la nota general [[Nginx]] (configuración, proxy, balanceo).

## Checklist rápido

- [ ] `server_tokens off` — ocultar versión
- [ ] TLS 1.2/1.3 con ciphers modernos + HSTS
- [ ] Cabeceras de seguridad (CSP, X-Frame-Options, nosniff…)
- [ ] `limit_req` contra brute force en login/API
- [ ] `limit_conn` contra abuso de conexiones
- [ ] Deshabilitar métodos HTTP no usados (TRACE, etc.)
- [ ] Proteger rutas sensibles (`.git`, `.env`, admin, dotfiles)
- [ ] PHP-FPM endurecido (solo socket, open_basedir)
- [ ] fail2ban/sshguard para Nginx (no solo SSH)
- [ ] Auditoría periódica: `nginx -t`, `testssl.sh`, `sslyze`

## 1. Oculta la versión y los detalles

```nginx
# /etc/nginx/nginx.conf (contexto http)
server_tokens off;          # quita "nginx/1.26.0" del Server header

# Eliminar cabeceras de backend que filtran info
proxy_hide_header X-Powered-By;
proxy_hide_header X-AspNet-Version;
```

```bash
# Verificar
curl -I https://misitio.com | grep -i server
```

## 2. TLS moderno (HTTPS fuerte)

```nginx
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    ssl_protocols TLSv1.2 TLSv1.3;                 # nada de TLSv1/1.1
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 1d;
    ssl_session_tickets off;                        # evita reutilización de tickets

    # OCSP stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 1.1.1.1 8.8.8.8 valid=300s;

    # HSTS: fuerza HTTPS en el navegador (máx. 2 años)
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
}
```

> **Preload**: si apuntas a [hstspreload.org](https://hstspreload.org/), el navegador fuerza HTTPS incluso antes del primer contacto. Requiere HSTS con `preload` + todos los subdominios HTTPS.

## 3. Cabeceras de seguridad (hardening de respuesta)

```nginx
# Contexto http o server
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()" always;

# Content-Security-Policy (ajustar a tu app; empieza restrictivo y afloja)
add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; object-src 'none'; base-uri 'self'; frame-ancestors 'self'" always;
```

| Cabecera | Qué protege |
|---|---|
| `Strict-Transport-Security` | Downgrade HTTPS→HTTP (MITM) |
| `X-Frame-Options` / CSP `frame-ancestors` | Clickjacking |
| `X-Content-Type-Options: nosniff` | MIME sniffing |
| `Referrer-Policy` | Fugas de URL en Referer |
| `Permissions-Policy` | Cámara/mic/geo no usados |
| `Content-Security-Policy` | XSS e inyección (restringe orígenes) |

> ⚠️ `add_header` **solo se hereda en location si el nivel superior no tiene add_header**. Si defines cabeceras en `http {}` y luego un `location` añade otra, se pierden las del nivel superior. Solución: repetir todas en ese location o usar un snippet `include`.

## 4. Protección contra brute force (rate limiting)

```nginx
# En http {}
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/s;
limit_conn_zone $binary_remote_addr zone=conexiones:10m;

server {
    # Zona de conexiones concurrentes por IP
    limit_conn conexiones 10;

    location /login {
        # 5 req/s, ráfaga de 20, sin espera
        limit_req zone=login burst=20 nodelay;
        proxy_pass http://backend;
    }

    location /wp-login.php {
        # WP admin: mucho más estricto
        limit_req zone=login burst=5 nodelay;
    }
}
```

```bash
# Prueba del rate limit
for i in $(seq 1 50); do curl -s -o /dev/null -w "%{http_code}\n" -X POST http://misitio.com/login; done | sort | uniq -c
# Esperado: mayoría 200/302 y algunos 503 (limit exceeded)
```

## 5. Denegar rutas y archivos sensibles

```nginx
server {
    root /var/www/misitio;

    # Dotfiles (.git, .env, .htaccess…)
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }

    # Archivos de backup y config
    location ~* \.(bak|conf|sql|ini|log|sh|env|git|svn|orig|save)$ {
        deny all;
    }

    # Directorios de administración (solo IPs autorizadas)
    location /admin/ {
        allow 192.168.1.0/24;
        allow 203.0.113.10;    # tu IP de administración
        deny all;
    }

    # Ocultar rutas con contraseña HTTP Basic (auth_basic)
    location /privado/ {
        auth_basic "Zona restringida";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
```

```bash
# Generar usuario/contraseña
sudo apt install apache2-utils   # Debian/Ubuntu (provee htpasswd)
sudo htpasswd -c /etc/nginx/.htpasswd usuario
```

## 6. Deshabilitar métodos HTTP peligrosos

```nginx
# En server {}
if ($request_method !~ ^(GET|HEAD|POST|PUT|DELETE|PATCH|OPTIONS)$) {
    return 405;
}
```

Alternativa por location:

```nginx
location /api/ {
    limit_except GET POST OPTIONS {
        deny all;
    }
}
```

## 7. PHP-FPM endurecido

```nginx
# En la location de PHP
location ~ \.php$ {
    fastcgi_pass unix:/run/php/php8.2-fpm.sock;   # solo socket, nunca TCP
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    fastcgi_hide_header X-Powered-By;
}
```

En `/etc/php/8.2/fpm/pool.d/www.conf`:

```ini
; Ejecutar FPM como usuario no privilegiado (www-data ya lo es)
user = www-data
group = www-data

; Restringir acceso a archivos fuera de la raíz web
php_admin_value[open_basedir] = /var/www/misitio:/tmp
; Deshabilitar funciones peligrosas
php_admin_value[disable_functions] = exec,passthru,shell_exec,system,proc_open,popen
```

## 8. fail2ban para Nginx (no solo SSH)

```bash
# Debian/Ubuntu
sudo apt install fail2ban

# Crear jail para Nginx: /etc/fail2ban/jail.local
cat <<'EOF' | sudo tee /etc/fail2ban/jail.local
[nginx-http-auth]
enabled  = true
port     = http,https
filter   = nginx-http-auth
logpath  = /var/log/nginx/error.log

[nginx-botsearch]
enabled  = true
port     = http,https
filter   = nginx-botsearch
logpath  = /var/log/nginx/access.log
maxretry = 5
EOF

sudo systemctl restart fail2ban
sudo fail2ban-client status nginx-http-auth
```

> Alternativa ligera: **sshguard** también vigila Nginx (ver nota [[fail2ban]]). La diferencia práctica: fail2ban es más configurable; sshguard consume menos recursos.

## 9. Protección contra bots y scraping

```nginx
# Bloquear User-Agents conocidos de bots maliciosos
if ($http_user_agent ~* (curl|wget|python-requests|scrapy|semrushbot|ahrefsbot)) {
    return 403;
}

# Bloquear peticiones con referer de spam
if ($http_referer ~* (spam-site|buy-cheap-viagra)) {
    return 403;
}
```

> ⚠️ Evita bloquear `curl`/`wget` globalmente si los usas para saludar el sitio (monitoreo). Mejor una ACL por IP o un endpoint dedicado.

## 10. Restricciones de recursos

```nginx
# Tamaño máximo de body (anti DoS por POST gigante)
client_max_body_size 10M;

# Timeouts (anti slowloris)
client_body_timeout 10s;
client_header_timeout 10s;
keepalive_timeout 65;

# Máximo de headers (anti header bomb)
large_client_header_buffers 4 16k;

# Desactivar keepalive a backend cuando no haga falta
proxy_http_version 1.1;
proxy_set_header Connection "";
```

## Auditoría del hardening

```bash
# 1. Config válida y procesada
sudo nginx -t
sudo nginx -T | grep -E "server_tokens|ssl_protocols|add_header"

# 2. TLS: testssl.sh (herramienta completa)
git clone --depth 1 https://github.com/drwetter/testssl.sh.git
./testssl.sh/testssl.sh --severity MEDIUM https://misitio.com

# 3. Alternativa rápida: sslyze
pipx install sslyze
sslyze --regular https://misitio.com

# 4. Cabeceras desde fuera
curl -sI https://misitio.com

# 5. Comprobar HSTS/preload
# https://hstspreload.org  +  https://securityheaders.com
```

## Troubleshooting del hardening

| Problema | Causa | Solución |
|---|---|---|
| La web rompe tras añadir CSP | CSP demasiado restrictiva | Añadir orígenes a `script-src`/`img-src`; probar en modo report-only |
| HSTS bloquea acceso HTTP en intranet | `max-age` alto sin HTTPS en todos los subdominios | Bajar `max-age` o quitarlo hasta migrar todo a HTTPS |
| Rate limit 503 a usuarios legítimos | `rate` demasiado bajo o detrás de proxy compartido | Subir `rate`, usar `$http_x_forwarded_for` como key si hay proxy de confianza |
| `add_header` desaparece en algunas rutas | Herencia rota entre niveles | Repetir cabeceras en el `location` o usar snippet `include` |
| fail2ban banea tu propia IP | Regla demasiado agresiva | `ignoreip` con tu IP en jail.local |
| Permissions-Policy rompe embebidos | `frame-ancestors`/`embed` restringido | Ajustar según el uso real (analytics, iframes de pago) |

## Ver también

- [[Nginx]] — configuración general, proxy inverso, balanceo
- [[fail2ban]] — protección contra brute force (también para HTTP)
- [[SSH Hardening]] — endurecimiento del acceso por SSH (servidor)
- [[journald]] — logs del servidor (ver también monitoreo remoto)
- [[nftables]] · [[ufw]] — apertura de puertos 80/443
- [[DNS encriptado (DoH DoT)]] — DNS seguro en el servidor

## Enlaces externos

- [NGINXConfig — generador de configs seguras](https://nginxconfig.io/)
- [testssl.sh — análisis TLS](https://github.com/drwetter/testssl.sh)
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)
- [OWASP — Nginx hardening](https://owasp.org/www-project-web-security-testing-guide/)
- [securityheaders.com — análisis de cabeceras](https://securityheaders.com/)

#programa #web #servidor #seguridad