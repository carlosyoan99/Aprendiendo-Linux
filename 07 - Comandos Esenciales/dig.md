---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# dig / nslookup

## Sintaxis
```bash
dig [@servidor] dominio [tipo] [opciones]
nslookup dominio [servidor]
```

## Descripción
Herramientas para consultar registros DNS. `dig` es la moderna y más potente; `nslookup` es la clásica. Ambas son esenciales para diagnosticar problemas de resolución de nombres.

```bash
# Instalar (si no vienen instaladas)
sudo apt install dnsutils                  # Debian/Ubuntu (incluye dig + nslookup)
sudo pacman -S bind-tools                  # Arch
```

## dig — Consultas DNS avanzadas

### Consultas básicas
```bash
dig google.com                             # consulta A (IP) al DNS del sistema
dig @8.8.8.8 google.com                   # consultar a un DNS específico (Google)
dig @1.1.1.1 google.com +short            # solo la IP, menos verbose
dig google.com ANY                        # todos los registros
```

### Tipos de registro DNS
```bash
dig google.com A                          # IPv4 (por defecto)
dig google.com AAAA                       # IPv6
dig google.com MX                         # servidores de correo
dig google.com NS                         # servidores de nombres autoritativos
dig google.com TXT                        # registros de texto (SPF, DKIM, etc.)
dig google.com CNAME                      # alias canónico
dig google.com SOA                        # Start of Authority
dig google.com ANY                        # cualquier registro (obsoleto en algunos DNS)
```

### Opciones útiles
```bash
dig +short google.com                     # solo la respuesta (sin metadatos)
dig +noall +answer google.com             # solo las respuestas (sin header/estadísticas)
dig google.com +trace                     # seguimiento completo desde la raíz
dig -x 8.8.8.8                           # reverse lookup (IP → nombre)
dig google.com +stats                     # consulta + estadísticas (por defecto)
dig google.com +dnssec                    # verificar DNSSEC
```

### Ejemplos prácticos
```bash
# ¿Qué IP tiene este dominio?
dig +short ejemplo.com

# ¿Quién recibe el correo de este dominio?
dig +short gmail.com MX

# ¿Está el DNS propagado? (comparar servidores)
dig @8.8.8.8 +short midominio.com
dig @1.1.1.1 +short midominio.com

# Ver la ruta completa de resolución DNS
dig +trace archlinux.org

# Consultar un registro específico desde un servidor específico
dig @ns1.google.com google.com A

# Saber el TTL de un registro
dig google.com | grep -E "^google|^[0-9]"
```

## nslookup — La clásica

```bash
nslookup google.com                       # consulta simple
nslookup google.com 8.8.8.8              # usando servidor DNS específico
nslookup -type=MX gmail.com              # consultar MX
nslookup -type=NS wikipedia.org          # consultar NS
nslookup 8.8.8.8                         # reverse lookup
```

### Modo interactivo
```bash
nslookup                                  # entrar en modo interactivo
> server 8.8.8.8                         # cambiar servidor
> set type=MX                            # tipo de registro
> gmail.com                              # consultar
> 8.8.8.8                                # reverse lookup
> exit                                   # salir
```

## dig vs nslookup vs host

| Característica | dig | nslookup | host |
|---|---|---|---|
| **Salida detallada** | ✅ Completa | ✅ Verbosa | ⚠️ Escueta |
| **Scripting** | ✅ Fácil de parsear | ⚠️ Verbosa | ✅ Simple |
| **+short** | ✅ Sí | ❌ No | ✅ Por defecto |
| **+trace** | ✅ Sí | ❌ No | ❌ No |
| **DNSSEC** | ✅ Sí | ❌ No | ❌ No |
| **Recomendado para** | Diagnóstico avanzado | Consultas rápidas | Scripts simples |

## Troubleshooting de DNS

```bash
# 1. ¿El DNS del sistema funciona?
dig google.com

# 2. ¿El servidor DNS responde?
dig @8.8.8.8 google.com                  # si esto funciona, el problema es tu DNS local

# 3. ¿El dominio existe? (vs error de resolución)
dig +short dominioinexistente.xyz         # sin respuesta = dominio no existe o DNS mal

# 4. ¿Es un problema de caché local?
sudo resolvectl flush-caches              # systemd-resolved
sudo systemctl restart nscd               # nscd (si está instalado)

# 5. Ver configuración DNS del sistema
resolvectl status                         # systemd-resolved (mayoría de distros modernas)
cat /etc/resolv.conf                      # DNS servers configurados
```

## Ver también
- [[Redes Basicas]] — conceptos de red y DNS
- [[ping]] — probar conectividad
- [[ss]] — puertos abiertos
- [[curl]] — probar HTTP/HTTPS

## Enlaces externos

- [Wikipedia - dig (command)](https://en.wikipedia.org/wiki/Dig_(command))
- [Linux man page - dig](https://man7.org/linux/man-pages/man1/dig.1.html)

#comando