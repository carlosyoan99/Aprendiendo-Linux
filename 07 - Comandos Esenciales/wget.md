---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# wget

## Sintaxis
```bash
wget [opciones] URL...
```

## Descripción
Descarga archivos desde HTTP, HTTPS y FTP. Es la herramienta clásica para descargas por terminal. Soporta descargas recursivas, reanudación de descargas interrumpidas, y operación en background.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-O archivo` | Guardar con nombre específico |
| `-c` | Continuar descarga interrumpida |
| `-q` | Modo silencioso (sin output) |
| `-P directorio` | Guardar en directorio específico |
| `--limit-rate=1m` | Limitar velocidad a 1 MB/s |
| `-b` | Descargar en background |
| `-r` | Descarga recursiva |
| `-np` | No seguir enlaces al directorio padre |
| `-l N` | Profundidad recursiva máxima |

## Ejemplos
```bash
wget https://example.com/archivo.iso             # descarga simple
wget -O programa.deb https://example.com/app.deb # renombrar archivo
wget -c https://example.com/video.mp4            # continuar descarga
wget -q https://example.com/paquete.tar.gz       # silencioso
wget -P ~/descargas https://example.com/app.deb  # guardar en carpeta
wget --limit-rate=500k https://example.com/archivo.iso  # limitar velocidad
wget -b https://example.com/grande.iso           # background (genera wget-log)
tail -f wget-log                                 # ver progreso en background

# Descargar sitio web completo (recursivo)
wget -r -np -l 2 https://example.com/docs/       # hasta 2 niveles de profundidad
```

## Casos de uso reales

### Descargar una ISO grande con reanudación

```bash
wget -c https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso
# Si la conexión se cae a mitad, vuelves a ejecutar el mismo comando
# y wget continúa desde donde se quedó (sin re-descargar lo anterior)
```

### Descargar todos los archivos de un tipo de un sitio

```bash
wget -r -l 1 -np -A "*.pdf" https://example.com/documentos/
# Descarga recursivamente solo archivos .pdf, 1 nivel de profundidad
```

### Descargar en background con control de velocidad

```bash
wget -b --limit-rate=1m https://example.com/video.mp4
# La descarga corre en segundo plano, no bloquea la terminal
# Ver progreso con: tail -f wget-log
```

## Combinaciones comunes con pipe

```bash
# Descargar desde una lista de URLs (una por línea)
cat urls.txt | xargs -P 4 -n 1 wget -q

# Descargar y procesar sin guardar archivo intermedio
wget -qO- https://api.github.com/repos/user/repo | grep "tag_name"

# Descargar y extraer directamente
wget -qO- https://example.com/archivo.tar.gz | tar xz
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `wget URL` | `curl -O URL` | Más protocolos, mejor para APIs |
| `wget -r` | `httrack` | Descarga recursiva más potente de sitios completos |
| `wget` (recursivo) | `aria2c` | Descarga en paralelo por fragmentos (mucho más rápida) |

```bash
# aria2c — descarga multi-conexión (más rápida para archivos grandes)
sudo apt install aria2
aria2c -x 4 -s 4 https://example.com/archivo.iso   # 4 conexiones paralelas
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `ERROR 404: Not Found.` | La URL no existe o está mal escrita | Verificar URL en el navegador |
| `Resolving... failed: Name or service not known.` | DNS no puede resolver el host | Verificar conectividad con `ping -c 2 8.8.8.8` |
| `Cannot write to 'archivo' (Permission denied).` | No tienes permiso de escritura en el directorio | Usar `cd ~/descargas` primero o `sudo wget -O /ruta` |
| `Certificate verification failed` | Certificado SSL inválido o auto-firmado | Usar `--no-check-certificate` (solo si confías en el origen) |
| La descarga es muy lenta | Sin límite de velocidad pero el servidor limita | `wget --limit-rate=0` para quitar límite; o usar `aria2c` |

## wget vs curl

| Característica | wget | curl |
|---|---|---|
| **Descarga archivos** | ✅ Excelente | ✅ Buena |
| **Recursivo** | ✅ Sí (`-r`) | ❌ No |
| **Reanudar descarga** | ✅ `-c` | ✅ `-C -` |
| **Protocolos** | HTTP, HTTPS, FTP | HTTP, HTTPS, FTP, SFTP, SCP, LDAP, etc. |
| **Subir archivos** | ❌ | ✅ (`-F`, `-T`) |
| **API REST/JSON** | ❌ | ✅ Excelente |
| **Velocidad limitada** | ✅ `--limit-rate` | ✅ `--limit-rate` |

## Notas
- `wget` es ideal para descargas directas y scripts simples.
- `curl` es más versátil para APIs, subidas y más protocolos.
- Para descargar archivos grandes que pueden fallar, `-c` (continuar) es esencial.

## Ver también
- [[curl]] — alternativa más versátil para APIs y subidas
- [[ping]] — probar conectividad de red
- [[Redes Basicas]] — fundamentos de red
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia - Wget](https://en.wikipedia.org/wiki/Wget)
- [GNU Wget manual](https://www.gnu.org/software/wget/manual/wget.html)

#comando