---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# Nextcloud

> Plataforma self-hosted de productividad y almacenamiento en la nube. Alternativa a Google Drive, Dropbox y Office 365 con control total de tus datos.

## Qué es

Nextcloud es una suite de software libre para montar tu propia nube privada: archivos, calendario, contactos, correo, videollamadas, colaboración en documentos y más. Nació como fork de ownCloud en 2016 y se ha convertido en la plataforma self-hosted más completa del ecosistema.

| Aspecto | Detalle |
|---|---|
| **Licencia** | AGPLv3 |
| **Stack** | PHP + JavaScript, base de datos (MySQL/PostgreSQL/SQLite) |
| **API** | WebDAV, REST, OCS |
| **Clientes** | Desktop (Win/Mac/Linux), Móvil (Android/iOS), CLI |
| **Comunidad** | ~400 contributors activos, ~200 apps en el store |

## Apps principales

Nextcloud es modular — cada funcionalidad es una app que se activa/desactiva desde el menú Apps.

| Categoría | App | Descripción |
|---|---|---|
| **Archivos** | Files | Almacenamiento y sync de archivos (como Google Drive) |
| **Ofimática** | Office | Edición colaborativa con Collabora o OnlyOffice |
| **Calendario** | Calendar | CalDAV — calendarios compartidos |
| **Contactos** | Contacts | CardDAV — libreta de contactos |
| **Comunicación** | Talk | Videollamadas, chat, pantalla compartida |
| **Correo** | Mail | Cliente IMAP/SMTP integrado |
| **Productividad** | Deck | Tableros Kanban (tipo Trello) |
| **Productividad** | Notes | Notas en Markdown |
| **Seguridad** | Pass | Gestor de contraseñas (Vaultwarden-compatible) |
| **Almacenamiento** | External Storage | SMB, S3, WebDAV, FTP como fuentes externas |
| **Automatización** | Flow | Automatizaciones tipo IFTTT (al subir archivo → acción) |

## Métodos de instalación

### Opción 1: All-in-One (recomendado para principiantes)

```bash
# Docker All-in-One — incluye reverse proxy, certs, backup
docker run -d \
  --name nextcloud-aio-mastercontainer \
  -p 8080:8080 \
  -v nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
  -v /var/run/docker.sock:/var/run/docker.sock \
  nextcloud/all-in-one:latest
# Acceder en https://localhost:8080
```

### Opción 2: Docker manual (control total)

```yaml
# docker-compose.yml
services:
  db:
    image: mariadb:10.11
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: ncpass
    volumes:
      - db_data:/var/lib/mysql

  redis:
    image: redis:7-alpine
    restart: always

  app:
    image: nextcloud:stable
    restart: always
    ports:
      - 8080:80
    depends_on:
      - db
      - redis
    environment:
      MYSQL_HOST: db
      MYSQL_PASSWORD: ncpass
      REDIS_HOST: redis
      NEXTCLOUD_TRUSTED_DOMAINS: localhost
    volumes:
      - nextcloud_data:/var/www/html

volumes:
  db_data:
  nextcloud_data:
```

```bash
docker compose up -d
```

### Opción 3: Snap (Ubuntu, más simple)

```bash
sudo snap install nextcloud
sudo nextcloud.manual-install admin password123
sudo nextcloud.enable-https lets-encrypt
```

### Opción 4: Manual con LAMP (para aprender)

```bash
# Instalar stack
sudo apt install apache2 mariadb-server php php-mysql php-gd php-curl \
  php-zip php-xml php-mbstring php-intl php-bcmath php-gmp

# Crear base de datos
sudo mysql -e "CREATE DATABASE nextcloud; CREATE USER 'nc'@'localhost' IDENTIFIED BY 'pass'; GRANT ALL ON nextcloud.* TO 'nc'@'localhost';"

# Descargar e instalar
cd /var/www/html
sudo wget https://download.nextcloud.com/server/releases/latest.tar.bz2
sudo tar xjf latest.tar.bz2
sudo chown -R www-data:www-data nextcloud
# Acceder en http://localhost/nextcloud
```

## Rendimiento y optimización

### Redis (obligatorio para producción)

```php
// config/config.php — añadir:
'memcache.local' => '\OC\Memcache\APCu',
'memcache.distributed' => '\OC\Memcache\Redis',
'memcache.locking' => '\OC\Memcache\Redis',
'redis' => [
    'host' => 'redis',
    'port' => 6379,
],
```

### PHP OPcache

```ini
; /etc/php/8.2/apache2/conf.d/20-opcache.ini
opcache.enable=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=10000
opcache.validate_timestamps=0  ; 1 en desarrollo
```

### Cron en vez de AJAX

```bash
# Cambiar de AJAX a System Cron en Admin → Configuración
# Verificar que el cron funciona:
crontab -u www-data -l
# Debería mostrar: */5 * * * * php -f /var/www/html/nextcloud/cron.php
```

### Base de datos

```ini
# MariaDB — /etc/mysql/mariadb.conf.d/50-server.cnf
innodb_buffer_pool_size = 1G    # 50-70% de la RAM del servidor
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2
query_cache_type = 1
query_cache_limit = 2M
```

## Seguridad

| Medida | Implementación |
|---|---|
| **HTTPS** | Let's Encrypt, Cloudflare, o certificado propio |
| **2FA** | Activar app TOTP desde Apps → Security |
| **App passwords** | Para clientes que no soportan 2FA |
| **Fail2Ban** | Bloquear intentos de login fallidos |
| **trusted_domains** | Limitar dominios en config.php |
| **data/ fuera de web** | Mover directorio de datos fuera del document root |

### Fail2Ban para Nextcloud

```ini
# /etc/fail2ban/filter.d/nextcloud.conf
[Definition]
failregex = ^.*Login failed: .* \(Remote IP: <HOST>\).*$
            ^.*\"remoteAddr\":\"<HOST>\".*Trusted domain error.*$
ignoreregex =
```

```ini
# /etc/fail2ban/jail.d/nextcloud.conf
[nextcloud]
enabled = true
port = 80,443
filter = nextcloud
logpath = /var/log/nextcloud/nextcloud.log
maxretry = 5
bantime = 3600
```

## Backups

```bash
# Script de backup completo
#!/bin/bash
BACKUP_DIR="/backup/nextcloud"
DATE=$(date +%Y%m%d)

# 1. Activar mantenimiento
sudo -u www-data php occ maintenance:mode --on

# 2. Backup de base de datos
mysqldump -u root nextcloud > "$BACKUP_DIR/db-$DATE.sql"

# 3. Backup de archivos
tar czf "$BACKUP_DIR/data-$DATE.tar.gz" /var/www/html/nextcloud/data/
tar czf "$BACKUP_DIR/config-$DATE.tar.gz" /var/www/html/nextcloud/config/

# 4. Desactivar mantenimiento
sudo -u www-data php occ maintenance:mode --off

# 5. Limpiar backups antiguos (>30 días)
find "$BACKUP_DIR" -mtime +30 -delete
```

## Clientes de sincronización

| Plataforma | Cliente | Funciones |
|---|---|---|
| **Linux** | Nextcloud Desktop | Sync archivos, CalDAV, CardDAV |
| **Windows** | Nextcloud Desktop | Igual + Explorer integration |
| **macOS** | Nextcloud Desktop | Igual + Finder integration |
| **Android** | Nextcloud App | Sync, auto-upload fotos, Talk |
| **iOS** | Nextcloud App | Sync, auto-upload fotos, Talk |

### Instalar cliente en Linux
```bash
# Ubuntu/Debian
sudo apt install nextcloud-desktop

# Fedora
sudo dnf install nextcloud-client

# Arch
sudo pacman -S nextcloud-client
```

## Comandos de administración (occ)

El CLI `occ` es la herramienta de administración principal. Ejecutar como usuario del servidor web.

```bash
# Siempre ejecutar como www-data (Debian/Ubuntu)
sudo -u www-data php occ <comando>

# En Docker:
docker exec -u www-data nextcloud php occ <comando>
```

| Comando | Para qué |
|---|---|
| `occ app:list` | Listar apps instaladas |
| `occ app:enable deck` | Activar una app |
| `occ app:disable mail` | Desactivar una app |
| `occ files:scan --all` | Re-escanear archivos (tras cambios externos) |
| `occ files:scan-app-data` | Re-escanear datos de apps |
| `occ maintenance:mode --on/off` | Activar/desactivar modo mantenimiento |
| `occ config:list system` | Ver configuración actual |
| `occ user:list` | Listar usuarios |
| `occ user:add --password-from-env admin` | Crear usuario |
| `occ db:convert-filecache-bigint` | Migrar a bigint (recomendado) |
| `occ upgrade` | Ejecutar actualización |
| `occ maintenance:repair` | Reparar problemas comunes |

## Troubleshooting conocido

| Problema | Causa probable | Solución |
|---|---|---|
| "Internal Server Error" | Falta extensión PHP | `php -m \| grep <ext>` e instalar |
| Archivos no se sincronizan | Cron no funciona | Verificar crontab de www-data |
| Lento en navegador | OPcache desactivado | Activar OPcache en php.ini |
| "Trusted domain error" | Dominio no autorizado | Añadir en config.php `trusted_domains` |
| CouchDB/SMB fallan | App no instalada | Instalar desde Apps → External storage |

## Notas personales

- Docker All-in-One es la forma más fácil de empezar; el manual te enseña más.
- Redis es obligatorio para producción — sin él, el file locking falla bajo carga.
- El cliente Desktop de Linux a veces tiene problemas con archivos grandes; usar `nextcloudcmd` para sync manual.
- Nextcloud Talk es decente para videollamadas internas pero no reemplaza a Jitsi/Zoom para uso intensivo.
- El store de apps tiene ~200 opciones — las más útiles: Deck, Notes, Talk, Mail, Pass.

## Enlaces externos

- [Sitio oficial de Nextcloud](https://nextcloud.com/)
- [GitHub — nextcloud/server](https://github.com/nextcloud/server)
- [Nextcloud Apps Store](https://apps.nextcloud.com/)
- [Documentación de administración](https://docs.nextcloud.com/server/stable/admin_manual/)
- [Nextcloud All-in-One (Docker)](https://github.com/nextcloud/all-in-one)
- [Wikipedia — Nextcloud](https://en.wikipedia.org/wiki/Nextcloud)

## Ver también

- [[Open-Xchange]] — suite colaborativa alternativa
- [[Docker]] — contenedores para desplegar Nextcloud
- [[Nginx]] — servidor web para producción
- [[PostgreSQL y MySQL]] — base de datos para Nextcloud
- [[Firewall]] — proteger el servidor
- [[Backups (borg restic duplicity rsync)]] — estrategias de backup

#programa #cloud #productividad
