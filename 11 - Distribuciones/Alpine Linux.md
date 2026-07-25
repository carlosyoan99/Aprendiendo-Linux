---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-23
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: apk
base: independiente
---

# Alpine Linux

## Filosofía / público objetivo

Distro minimalista orientada a **seguridad y tamaño reducido** (imagen base de ~5 MB, comparado con ~200 MB+ de Ubuntu/Debian). Usa `musl libc` en vez de `glibc` (la libc estándar de casi todas las distros) y `busybox` en vez de coreutils GNU (ls, cp, mv, etc. más pequeños pero con menos opciones). Por eso algunos binarios precompilados para otras distros no funcionan directo en Alpine.

## ¿Dónde se encuentra Alpine?

Es la distro más usada como **base de imágenes Docker**: `FROM alpine:latest` pesa ~5MB. También se usa en:
- Contenedores Docker (inmensa mayoría de imágenes ligeras en Docker Hub)
- Routers y dispositivos embebidos
- Instalaciones minimalistas en servidores (OpenRC en vez de systemd)
- WSL (Windows Subsystem for Linux)

## Gestor de paquetes: apk

```bash
apk add <paquete>                        # instalar
apk update                               # actualizar lista de paquetes
apk upgrade                              # actualizar paquetes instalados
apk search <termino>                     # buscar
apk del <paquete>                        # eliminar
apk info <paquete>                       # info del paquete
apk -L info <paquete>                    # listar archivos que instaló
```

## musl vs glibc: diferencias clave

| Característica | glibc (Ubuntu, Debian, Arch, Fedora) | musl (Alpine) |
|---|---|---|
| Tamaño | ~2 MB | ~0.6 MB |
| Compatibilidad | Universal | Algunos binarios precompilados no funcionan |
| DNS | /etc/nsswitch.conf | /etc/hosts + resolución simple |
| Locales | Completo (locale-gen) | Limitado (musl-locales) |
| Threading | NPTL | ...

```bash
# En Alpine, instalar compatibilidad con glibc si es necesario:
# (no es trivial — requiere capa de compatibilidad externa)

# Saber qué libc usa tu sistema
ldd --version 2>&1 | head -1            # si muestra "musl" → estás en Alpine
```

## Por qué importa en contenedores

```dockerfile
# Dockerfile típico: Alpine es la opción más ligera
FROM alpine:latest
RUN apk add --no-cache python3 nodejs   # --no-cache evita dejar el índice de paquetes
```

**Ventaja**: imágenes de ~50-100 MB vs ~500 MB-1 GB con Ubuntu como base.
**Riesgo**: algunas gemas de Ruby, npm packages nativos, wheels de Python pueden necesitar compilación para musl, lo que alarga el build.

## Init system: OpenRC

Alpine usa **OpenRC** en vez de systemd (que es el estándar en casi todas las distros modernas):

```bash
rc-service nginx start                  # iniciar servicio
rc-update add nginx default             # habilitar en boot
rc-status                               # ver estado de servicios
```

## Notas de instalación propias

## Enlaces externos

- [Wikipedia — Alpine Linux](https://en.wikipedia.org/wiki/Alpine_Linux)
- [Sitio oficial](https://alpinelinux.org/)
- [Organización en GitHub](https://github.com/alpinelinux)
- [GitLab oficial de Alpine](https://gitlab.alpinelinux.org/)

## Ver también

- [[Arch Linux]] — enfoque minimalista pero con glibc y systemd
- [[Gestores de Paquetes]]
- [[systemd]] — el init que Alpine NO usa
- [[Utilidades Base del Sistema]]

#distro
