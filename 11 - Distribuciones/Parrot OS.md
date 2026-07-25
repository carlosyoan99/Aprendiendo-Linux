---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: apt (dpkg)
base: Debian Testing
---

# Parrot OS

## Qué es

**Parrot OS** es una distribución Linux basada en **Debian Testing** con enfoque en **ciberseguridad, privacidad y anonimato**. A diferencia de Kali Linux (puro pentesting), Parrot OS está diseñado para ser **usado a diario** mientras ofrece herramientas de seguridad completas.

Creada por **Parrot Security Team**, es mantenida por la comunidad y la empresa **Parrot Security**. Su lema: "Security, Privacy, Development".

```bash
┌─────────────────────────────────────────────────┐
│                  Parrot OS                        │
├─────────────────────────────────────────────────┤
│  2013 — Primera versión (basada en Debian)       │
│  2015 — Parrot 2.0, adopta Debian Testing        │
│  2017 — Parrot 3.x, madurez como plataforma      │
│  2020 — Parrot 4.x, refuerzo privacidad/anonimato│
│  2022 — Parrot 5.x, actualización base           │
│  2024 — Parrot 6.x, LTS, mejoras rendimiento     │
│  2026 — Versión estable actual, activo           │
└─────────────────────────────────────────────────┘
```

## Filosofía

- **Pentesting + uso diario**: no necesitas dos sistemas — Parrot sirve para ambas cosas
- **Privacidad por defecto**: AnonSurv (Tor), cifrado, firewalls preconfigurados
- **Ligero**: pesa menos que Kali, funciona en hardware más modesto
- **Basado en Debian Testing**: equilibrio entre estabilidad y paquetes recientes
- **Open source**: todo el código es público y auditable

## Gestor de paquetes

```bash
# Basada en Debian, usa apt
sudo apt update                         # actualizar lista de paquetes
sudo apt upgrade                        # actualizar paquetes instalados
sudo apt install paquete                # instalar
sudo apt remove paquete                 # desinstalar
sudo apt search término                 # buscar

# Metapaquetes de Parrot
sudo apt install parrot-tools-full      # todas las herramientas de seguridad
sudo apt install parrot-pico            # herramientas ligeras (para equipos lentos)
sudo apt install parrot-devel           # herramientas de desarrollo
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | apt (dpkg) |
| **Base** | Debian Testing |
| **Formato** | `.deb` |
| **Rama** | Rolling (siguiendo Debian Testing) |
| **Init** | systemd |
| **DE por defecto** | MATE (también XFCE) |

## Ediciones

| Edición | Propósito | Tamaño |
|---|---|---|
| **Security Edition** | Pentesting completo (por defecto) | ~4 GB ISO |
| **Home Edition** | Uso diario sin herramientas de seguridad | ~3 GB ISO |
| **Hack The Box Edition** | Integración con HTB, VPN preconfigurada | ~4 GB ISO |

## Características clave

### 1. AnonSurf

AnonSurf es la herramienta de anonimato de Parrot OS: enruta todo el tráfico a través de la red Tor automáticamente.

```bash
# AnonSurf
sudo anonsurf start                     # iniciar Tor y redirigir tráfico
sudo anonsurf stop                      # detener Tor
sudo anonsurf status                    # verificar estado
sudo anonsurf restart                   # reiniciar circuito Tor

# Verificar IP pública (debe mostrar IP de Tor)
curl ifconfig.me
```

### 2. Entorno MATE personalizado

Parrot OS usa **MATE** (fork de GNOME 2) con temas, paneles y configuraciones propias optimizadas para flujo de trabajo de seguridad:

- Panel inferior con lanzadores de herramientas comunes
- Atajos de teclado para terminal, navegador, herramientas forenses
- Tema oscuro por defecto (batería, discreción, contraste)

### 3. Herramientas preinstaladas

| Categoría | Herramientas |
|---|---|
| **Reconocimiento** | nmap, masscan, dnsrecon, theHarvester, Sublist3r |
| **Explotación** | Metasploit, Searchsploit, SQLmap, BeEF |
| **Forense** | Autopsy, Guymager, binwalk, Foremost |
| **Wireless** | Aircrack-ng, Reaver, Kismet, Wifite |
| **Ing. inversa** | Ghidra, radare2, GDB, strace |
| **Cracking** | John the Ripper, Hashcat, Hydra |
| **Esteganografía** | Steghide, OutGuess, steghide |

```bash
# Instalar herramientas adicionales
sudo apt install ghidra                  # ing. inversa (desde repos)
sudo apt install burpsuite              # web app testing

# Herramientas fuera de los repos (instalación manual):
# - Burp Suite Professional (Java)
# - Nessus (deb)
# - Maltego (deb)
```

### 4. Cifrado y privacidad

```bash
# Cifrado de disco completo (LUKS) disponible en el instalador
# Cifrado de archivos con GPG
gpg -c archivo.txt                       # cifrar con contraseña
gpg archivo.txt.gpg                      # descifrar

# Cifrado de directorios (encfs)
sudo apt install encfs
encfs ~/privado ~/montura
```

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64, 1 GHz | 2 GHz dual-core |
| **RAM** | 2 GB | 4 GB+ |
| **Disco** | 20 GB | 40 GB+ SSD |
| **GPU** | Genérica | Cualquier GPU moderna |
| **Arranque** | BIOS o UEFI | UEFI |

## Instalación

```bash
# 1. Descargar ISO desde https://parrotsec.org/download/
#    Elegir edición: Security, Home, o HTB

# 2. Grabar en USB
sudo dd if=ParrotOS-*.iso of=/dev/sdX bs=4M status=progress

# 3. Arrancar desde USB
#    Instalador Calamares (similar a Ubuntu/Fedora/Mint)
#    - Seleccionar idioma, teclado, zona horaria
#    - Particionado: recomendado LUKS + LVM
#    - Crear usuario (root habilitado por separado)
#    - Elegir modo de instalación:
#      * Full install (todo el sistema)
#      * Persistencia en USB (live con persistencia)

# 4. Opciones de instalación especiales:
#    - Cifrado de disco completo (LUKS) — muy recomendado
#    - AnonSurf habilitado al arranque (opcional)
```

## Post-instalación checklist

```bash
# 1. Actualizar sistema
sudo apt update && sudo apt upgrade

# 2. Verificar herramientas esenciales
msfconsole -v                     # Metasploit
nmap --version                    # Nmap
ghidra --version                  # Ghidra (si se instaló)

# 3. Configurar AnonSurf (opcional)
sudo systemctl enable --now anonsurf

# 4. VPN (opcional, recomendada para pentesting)
sudo apt install openvpn network-manager-openvpn

# 5. Snapshot del sistema (antes de empezar a trabajar)
#    Parrot incluye timeshift
sudo timeshift --create --comments "Post-instalación"
```

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **AnonSurf frena navegación** | Tor es lento por naturaleza | Usar solo para pentesting, no para navegación diaria |
| **Faltan herramientas** | No todas vienen preinstaladas | `parrot-tools-full` instala el conjunto completo |
| **MATE ocupa más RAM que XFCE** | MATE es más completo visualmente | Usar edición XFCE para hardware limitado |
| **Debian Testing inestable** | Base Testing puede tener bugs | Congelar con `apt-mark hold` paquetes problemáticos |

## Parrot OS vs alternativas

| Aspecto | Parrot OS | Kali Linux | Tails |
|---|---|---|---|
| **Base** | Debian Testing | Debian Stable | Debian Stable |
| **Uso diario** | ✅ Sí | ⚠️ Posible pero no recomendado | ❌ Solo live USB |
| **Anonimato** | ✅ AnonSurf (Tor) | ⚠️ Manual | ✅ Tor por defecto |
| **Pentesting** | ✅ Completo | ✅ Más herramientas | ❌ Ninguna |
| **Persistencia** | ✅ Instalación normal | ✅ Instalación normal | ❌ No guarda cambios |
| **RAM mínima** | 2 GB | 2 GB | 1 GB |
| **Ideal para** | Pentester que usa su PC a diario | Pentester dedicado, laboratorios | Anonimato extremo, denunciantes |

## Ver también

- [[Kali Linux]] — la distro de pentesting más conocida
- [[Tails]] — anonimato extremo sin persistencia
- [[Debian]] — base de Parrot
- [[MATE]] — DE por defecto de Parrot
- [[Redes Basicas]] — conceptos de red para pentesting
- [[Firewall]] — configuración de seguridad
- [[WireGuard VPN]] — VPN para pentesting

## Enlaces externos

- [Parrot OS — Página oficial](https://parrotsec.org/)
- [Parrot OS — Documentación](https://parrotsec.org/docs/)
- [Parrot OS — Foro](https://community.parrotsec.org/)
- [Parrot OS — GitHub](https://github.com/ParrotSec)
- [AnonSurf — GitHub](https://github.com/ParrotSec/anonsurf)
- [Parrot OS — Wikipedia](https://en.wikipedia.org/wiki/Parrot_OS)
- [Debian Testing — Estado](https://wiki.debian.org/DebianTesting)

#distro #seguridad
