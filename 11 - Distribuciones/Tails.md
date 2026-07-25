---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt (live)
base: Debian Stable
---

# Tails

## Qué es

**Tails** (The Amnesic Incognito Live System) es una distribución **live** diseñada para **anonimato extremo**. Se ejecuta desde un USB/DVD, enruta **todo el tráfico por Tor**, y **no deja rastro** en el disco duro al apagar.

Creada originalmente por el proyecto alemán **Incognito** (2008), luego reescrita como Tails por **Laura Poitras**, **Jacob Appelbaum** y voluntarios del proyecto Tor. Es financiada por Tor Project, Freedom of the Press Foundation y donaciones.

## Filosofía

- **Amnesia**: al apagar, no queda ningún rastro en el sistema (a menos que uses persistencia cifrada)
- **Tor por defecto**: toda conexión pasa por Tor — las conexiones que no usan Tor se bloquean
- **Usable**: interfaz amigable (GNOME) para que periodistas y activistas puedan usarlo sin ser expertos técnicos
- **Confianza cero**: diseñado para proteger contra adversarios con recursos (gobiernos, agencias de inteligencia)

## Características clave

```bash
# Todo el tráfico por Tor
# - Tor Browser preinstalado
# - Conexiones no Tor: BLOQUEADAS por defecto
# - AnonConnection Wizard para configurar puentes Tor

# Sin rastro
# - No escribe en discos duros internos
# - RAM se borra al apagar
# - Sin logs persistentes

# Persistencia cifrada (opcional)
# → Applications → Tails → Persistent Storage
# Puedes guardar:
#   - Documentos personales
#   - Marcadores de Tor Browser
#   - Llaves GPG
#   - Contraseñas (KeePassXC)
#   - Bitcoin/Ethereum wallets
```

## Instalación

```bash
# 1. Descargar ISO desde https://tails.net/install/
# 2. Usar el instalador oficial (Tails Installer):
#    - En Linux: usar GNOME Disks o dd
sudo dd if=tails-*.img of=/dev/sdX bs=4M status=progress
#    - En Windows: usar Etcher o Rufus

# 3. Arrancar desde USB e ingresar contraseña de persistencia (si se configuró)

# 4. Configurar persistencia (opcional, desde el menú de Tails):
#    Applications → Tails → Persistent Storage
#    Elegir qué datos persistir
```

## Aplicaciones incluidas

| Categoría | Aplicaciones |
|---|---|
| **Navegación** | Tor Browser |
| **Correo** | Thunderbird con Enigmail (cifrado) |
| **Mensajería** | Pidgin con OTR (Off-the-Record) |
| **Ofimática** | LibreOffice, Evince (PDF) |
| **Gráficos** | GIMP, Inkscape |
| **Audio/Video** | Audacity, VLC |
| **Utilidades** | KeePassXC, Kleopatra (GPG), Electrum Bitcoin |
| **Disco** | GNOME Disks, VeraCrypt |
| **Red** | OnionShare (compartir archivos vía Tor), Electrum |

### OnionShare

OnionShare permite compartir archivos de forma anónima creando un sitio onion temporal:

```bash
# Compartir archivo
onionshare documento-secreto.pdf
# Genera una URL como: http://abc123def456.onion/documento-secreto.pdf
# Compartes la URL por un canal seguro, el archivo se descarga directo

# Recibir archivos
onionshare receive
```

## Electrum Bitcoin Wallet

Tails incluye **Electrum** conectado por defecto a Tor para transacciones de Bitcoin anónimas.

## ⚠️ Limitaciones y riesgos

- **Rendimiento**: Tor ralentiza la conexión (latencia alta)
- **Tor no es mágico**: Tor oculta tu IP, pero no protege contra:
  - Metadatos en documentos (Office, PDF pueden contener información del autor original)
  - Ataques de *timing analysis*
  - Revelar información personal en sitios web (loguearse con nombre real)
  - Descargar archivos y abrirlos estando offline (metadatos incrustados)
- **No uses Tails en un sistema infectado**: si el BIOS/UEFI está comprometido, Tails no protege
- **Tamaño persistencia**: el volumen persistente no debe exceder la mitad de la capacidad del USB

## Buenas prácticas

1. **No uses persistencia para todo**: solo datos que necesites entre sesiones
2. **Contraseña fuerte** para la persistencia (calcula que podrías estar bajo coacción)
3. **No maximices la ventana del navegador**: los sitios web pueden detectar el tamaño de pantalla
4. **No uses extensiones de navegador** (incluso uBlock Origin puede ser fingerprint)
5. **Cámbiate de identidad** periódicamente: Tor Browser → New Identity (Ctrl+Shift+U)
6. **No descargues archivos grandes**: atrae atención sobre tu circuito Tor
7. **Usa teclado en pantalla** si sospechas keylogging hardware

## Ver también

- [[Kali Linux]] — herramienta de pentesting, enfoque diferente
- [[Parrot OS]] — seguridad + privacidad + pentesting
- [[WireGuard VPN]] — cifrado de comunicaciones (no reemplaza a Tor)
- [[Firewall]] — iptables/nftables
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]

## Enlaces externos

- [Tails — Página oficial](https://tails.net/)
- [Tails Documentation](https://tails.net/doc/index.es.html)
- [Tor Project](https://www.torproject.org/)
- [OnionShare](https://onionshare.org/)
- [Freedom of the Press Foundation](https://freedom.press/)

#distro #seguridad #privacidad
