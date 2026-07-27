---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: baja
---

# doggo

> `dig` moderno con colores, formato legible y salida JSON. Alternativa moderna para consultas DNS desde terminal.

## Descripción

**doggo** es un cliente DNS para terminal que combina la funcionalidad de `dig` con una salida más legible: colores por tipo de registro, formato tabular, y soporte para JSON. Escrito en Rust.

## Instalación

```bash
# Debian/Ubuntu (disponible en repos recientes)
sudo apt install doggo

# Arch
sudo pacman -S doggo

# Desde GitHub (binario estático)
# https://github.com/mr-karan/doggo/releases

# Con cargo (Rust)
cargo install doggo
```

## Uso básico

```bash
doggo google.com                    # Consulta A (IPv4) por defecto
doggo google.com MX                 # Consultar registro MX
doggo google.com @1.1.1.1          # Con DNS específico (Cloudflare)
doggo google.com -J                # Salida JSON
doggo google.com -t AAAA           # Forzar tipo IPv6
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `doggo dominio` | Consultar registro A por defecto |
| `doggo dominio MX` | Consultar registro MX |
| `doggo dominio @dns` | Usar servidor DNS específico |
| `-J`, `--json` | Salida en formato JSON |
| `-t`, `--type` | Tipo de registro (A, AAAA, MX, CNAME, NS, TXT, SOA, CAA, SRV) |
| `-n`, `--nameserver` | Nameserver específico (alternativa a @) |
| `-4` | Usar IPv4 para la consulta |
| `-6` | Usar IPv6 para la consulta |
| `-q` | Modo silencioso (solo respuesta) |
| `--timeout` | Timeout en segundos |

## Tipos de registro

```bash
doggo google.com A                  # IPv4
doggo google.com AAAA               # IPv6
doggo google.com MX                 # Mail exchange
doggo google.com NS                 # Nameservers
doggo google.com TXT                # Text records (SPF, DKIM)
doggo google.com CNAME              # Canonical name
doggo google.com SOA                # Start of Authority
doggo google.com CAA                # Certification Authority Authorization
doggo gmail.com SRV                 # Service records
doggo google.com CNAME              # Alias
```

## Ejemplos

```bash
# Consulta básica
doggo example.com

# Con DNS de Cloudflare
doggo example.com @1.1.1.1

# Con DNS de Google
doggo example.com @8.8.8.8

# Consulta MX + salida JSON (para scripts)
doggo gmail.com MX -J

# Consulta TXT (SPF, DKIM)
doggo google.com TXT

# Verificar propagación DNS desde diferentes servidores
doggo midominio.com @1.1.1.1
doggo midominio.com @8.8.8.8
doggo midominio.com @9.9.9.9        # Quad9

# Timeout personalizado
doggo midominio.com --timeout 10
```

## Salida típica

```
$ doggo google.com MX
  NAME                    TYPE    CLASS   TTL     ADDRESS
  google.com.             MX      IN      1799    10 smtp.google.com.
```

## Comparativa

| Aspecto | doggo | dig | host | nslookup |
|---|---|---|---|---|
| **Colores** | ✅ | ❌ | ❌ | ❌ |
| **Salida JSON** | ✅ `-J` | ❌ | ❌ | ❌ |
| **Formato tabular** | ✅ | ❌ Raw | ✅ Simple | ❌ |
| **Soporte moderno** | ✅ CAA, SRV | ✅ | ❌ | ❌ |
| **Preinstalado** | ❌ | ✅ (dnsutils) | ✅ | ✅ |
| **Peso** | ~5 MB | ~1 MB | ~0.1 MB | ~0.1 MB |

> doggo es más legible que dig para uso diario. Para scripts que requieren máxima compatibilidad, `dig` sigue siendo la opción segura.

## Ver también

- [[dig]] — el clásico, más opciones avanzadas
- [[DNS y BIND]] — servidor DNS y zonas
- [[Redes Basicas]] — conceptos de red

## Enlaces externos

- [GitHub — mr-karan/doggo](https://github.com/mr-karan/doggo)
- [Sitio oficial](https://doggo.mrkaran.dev/)

#comando #dns #red
