---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: pacman
base: Arch Linux
---

# Manjaro

## Filosofía / público objetivo

Arch Linux con instalador gráfico y **"curación"**: los paquetes pasan un período de testeo propio antes de llegar a los repos estables de Manjaro (a diferencia de Arch, que recibe las actualizaciones apenas salen upstream). Pensado como puerta de entrada al mundo Arch sin la instalación manual.

Sin embargo, esta capa extra de testeo es también su principal fuente de problemas: los paquetes retrasados respecto a Arch + el uso del AUR = potenciales conflictos.

---

## Gestor de paquetes

### pacman (base)

```bash
sudo pacman -S <paquete>              # instalar
sudo pacman -Syu                      # actualizar TODO el sistema
pacman -Ss <paquete>                  # buscar
pacman -Si <paquete>                  # info detallada
sudo pacman -R <paquete>              # eliminar
sudo pacman -Rns <paquete>            # eliminar + dependencias + config
sudo pacman -Qdt                      # paquetes huérfanos (dependencias no usadas)
sudo pacman -Sc                       # limpiar caché de paquetes
```

### pamac (gestor alternativo)

Manjaro incluye **pamac** como gestor gráfico (GTK) y CLI, con soporte para AUR, Snap y Flatpak integrado:

```bash
pamac install <paquete>               # instalar (con soporte AUR si está habilitado)
pamac update                          # actualizar sistema + AUR
pamac search <paquete>
pamac remove <paquete>
pamac list-installed                  # listar paquetes instalados

# Configuración de pamac (GUI):
pamac-manager                         # lanzar interfaz gráfica
```

```bash
# Habilitar AUR en pamac (GUI):
# pamac-manager → Preferencias → AUR → "Enable AUR"

# O desde terminal:
sudo sed -i 's/#EnableAUR/EnableAUR/' /etc/pamac.conf
```

---

## Ediciones oficiales

| Edición | DE/WM | Ideal para |
|---|---|---|
| **Xfce** (principal) | [[XFCE]] | Ligero, hardware modesto, usuarios que quieren simplicidad |
| **KDE** | [[KDE Plasma]] | Escritorio completo y personalizable |
| **GNOME** | [[GNOME]] | Experiencia moderna, gestos, Wayland |
| **Sway** (community) | Sway (tiling Wayland) | Usuarios de tiling que quieren Wayland nativo |
| **Budgie** (community) | Budgie | Escritorio moderno pero liviano (Solus-style) |
| **Cinnamon** (community) | Cinnamon | Familiar para ex-usuarios de Windows |
| **i3** (community) | i3 | Tiling en X11, mínimo consumo |
| **Openbox** (community) | Openbox | Ultra-ligero, para hardware muy antiguo |

```bash
# El instalador permite elegir la edición al descargar la ISO
# Cada edición tiene su propia ISO en https://manjaro.org/download/
```

---

## AUR y paquetes retrasados

Manjaro retrasa los paquetes de Arch entre **1 y 3 semanas** para testeo propio. Esto choca con el **AUR (Arch User Repository)**, donde los PKGBUILD asumen las versiones más recientes de Arch puro.

### El problema

```
Arch (upstream) ──── paquete v2.0 ──── AUR espera v2.0
                                          ↓
Manjaro (estable) ── paquete v1.5 ──── ✗ Conflicto: AUR pide dependencias v2.0
```

### Síntomas típicos

| Síntoma | Causa | Solución |
|---|---|---|
| `error: failed to build ... (dependency version mismatch)` | Un paquete del AUR requiere una versión más nueva que la que tiene Manjaro | Esperar a que Manjaro actualice el paquete base, o instalar la dependencia desde AUR también |
| `error: target not found: libfoo>=2.0` | Manjaro tiene libfoo 1.5, AUR pide 2.0 | `pamac build libfoo` (compilar desde AUR la versión que necesita) |
| Paquete se compila pero la app no arranca | Binario compilado contra librerías nuevas, ejecutándose con librerías viejas | Revisar con `ldd` y esperar actualización de Manjaro |
| `pacman -Syu` rompe pamac o yay | El helper AUR se actualizó y dejó de ser compatible | Reinstalar: `sudo pacman -S pamac` o `yay -S yay` |

### Buenas prácticas con AUR en Manjaro

```bash
# ✅ Hacer: actualizar el sistema COMPLETO antes de tocar AUR
sudo pacman -Syu
pamac update                          # o: yay -Syu

# ❌ NO hacer: instalar desde AUR sin antes actualizar
# ❌ NO hacer: mezclar aurutils, yay y pamac para el mismo paquete

# ✅ Hacer antes de instalar un paquete AUR complicado:
# 1. Verificar en https://aur.archlinux.org/ si hay comentarios sobre Manjaro
# 2. Buscar en foros de Manjaro si alguien ya lo probó
# 3. Usar pamac build en vez de yay (más conservador con dependencias)

# ⚠️ Si usas mucho AUR, considera migrar a Arch vanilla o EndeavourOS
# (Manjaro añade fricción extra al ecosistema AUR)
```

---

## Gestión de kernels con MHWD

Manjaro permite tener **múltiples kernels instalados** y elegir cuál arrancar desde GRUB. Esto es útil si un kernel nuevo causa problemas de hardware.

### Con Manjaro Settings Manager (GUI)

```bash
# Aplicación → Preferencias → Manjaro Settings Manager → Kernel
# Desde ahí: instalar/eliminar kernels, ver cuál está activo
```

### Con mhwd-kernel (terminal)

```bash
# Listar kernels instalados
mhwd-kernel -l

# Listar kernels disponibles para instalar
mhwd-kernel -h | grep linux

# Instalar un kernel específico
sudo mhwd-kernel -i linux515          # kernel 5.15 LTS
sudo mhwd-kernel -i linux61           # kernel 6.1 LTS
sudo mhwd-kernel -i linux69           # kernel 6.9 (ejemplo)
sudo mhwd-kernel -i linux618          # kernel 6.18 (ejemplo)

# Eliminar un kernel (no puede eliminar el que está en uso)
sudo mhwd-kernel -r linux515

# Después de instalar/eliminar, GRUB se actualiza automáticamente
```

### ¿Cuándo usar cada kernel?

| Kernel | Rama | Para qué |
|---|---|---|
| **linux-lts** (ej: 5.15, 6.1) | LTS | Estabilidad máxima, hardware antiguo, servidores |
| **linux** (ej: 6.6, 6.9) | Estable | Uso diario general (viene por defecto) |
| **linux-mainline** (ej: 6.x-rc) | Experimental | Probar features nuevas, hardware muy reciente |
| **linux-rt** | Real-Time | Audio profesional, sistemas de tiempo real |

```bash
# Ver qué kernel está usando el sistema actualmente
uname -r

# Ver todos los kernels instalados (como archivos de boot)
ls /boot/vmlinuz-*

# En GRUB, al arrancar: Advanced options → elegir kernel
```

---

## Partial upgrades (actualizaciones parciales) — ⚠️ PELIGRO

**Nunca hacer `pacman -S <paquete>` sin haber hecho `pacman -Syu` primero.** Esto se llama **partial upgrade** y es la causa #1 de sistemas rotos en Arch/Manjaro.

### ¿Qué es un partial upgrade?

```bash
# ❌ PELIGRO: instalar un paquete sin actualizar el sistema
sudo pacman -S firefox              # si firefox depende de libfoo>=2.0
                                    # pero tu sistema tiene libfoo 1.5
                                    # → dependencias inconsistentes

# ✅ Correcto:
sudo pacman -Syu                    # actualizar TODO (incluye libfoo 2.0)
sudo pacman -S firefox              # ahora firefox tiene libfoo 2.0 disponible
```

### Por qué Manjaro es más propenso

En **Arch puro**, `pacman -Syu` siempre avanza a la última versión de todo. En **Manjaro**:

1. Algunos paquetes avanzan más rápido que otros (los repos de Manjaro se actualizan en tandas)
2. Puede haber **ventanas de inconsistencia** donde ciertos paquetes del repo están retrasados respecto a otros
3. Usar `pamac update` (que también actualiza AUR) vs `pacman -Syu` puede crear desfases

```bash
# Reglas de oro:
# ✅ Siempre: sudo pacman -Syu (o pamac update) ANTES de instalar algo
# ✅ Al reactivar una máquina apagada por semanas: sudo pacman -Syu (puede tardar)
# ❌ NUNCA: pacman -S <paquete> si no has actualizado antes ese mismo día
# ❌ NUNCA: ignorar advertencias de "replace X with Y?" sin leer
# ❌ NUNCA: forzar --overwrite a menos que sepas exactamente lo que haces
```

### Cómo recuperarse de un partial upgrade

```bash
# Si ya rompiste el sistema:
sudo pacman -Syu                     # intentar actualizar todo (suele resolverlo)
sudo pacman -Syu --overwrite='*'     # si hay conflictos de archivos (forzar)
# Si pacman -Syu falla con dependencias rotas:
pacman -Qdt                          # listar huérfanos
sudo pacman -Rdt                     # eliminar huérfanos
sudo pacman -Syu                     # reintentar
# Último recurso:
sudo pacman -S archlinux-keyring manjaro-keyring  # actualizar llaves primero
sudo pacman -Syyu                    # forzar refresco de repos + actualizar
```

---

## Herramientas propias de Manjaro (expandido)

| Herramienta | Propósito | Comando |
|---|---|---|
| **Manjaro Hardware Detection (MHWD)** | Detecta e instala drivers (GPU, WiFi) | `mhwd -l` (listar), `sudo mhwd -a pci free 0300` (instalar driver) |
| **Manjaro Settings Manager** | Gestión de kernels, módulos, idioma | `msm` o desde el menú de aplicaciones |
| **Pamac** | Gestor de paquetes con AUR, Snap, Flatpak | `pamac install/update/search/remove` |
| **Manjaro ISO Wizard** | Crear USB booteable de Manjaro | `manjaro-iso-wizard` |
| **Manjaro Notifier** | Notificador de actualizaciones en bandeja | Se ejecuta automáticamente |

```bash
# MHWD: ejemplos prácticos
sudo mhwd -a pci free 0300           # instalar driver libre para GPU
sudo mhwd -a pci nonfree 0300        # instalar driver privativo para GPU
mhwd -l -d                           # listar drivers disponibles

# Encontrar qué driver usar para tu hardware:
mhwd -l | grep -i nvidia
mhwd -l | grep -i wifi
```

---

## ⚠️ Advertencias importantes

1. **AUR + paquetes retrasados:** Manjaro testea paquetes 1-3 semanas antes de liberarlos. Los PKGBUILD del AUR asumen versiones de Arch puro. Si usas AUR intensivamente, tendrás conflictos. Solución: priorizar paquetes de los repos oficiales de Manjaro; usar AUR solo cuando sea estrictamente necesario.

2. **Partial upgrades:** `pacman -S <paquete>` sin `pacman -Syu` antes puede romper el sistema. Manjaro es más vulnerable a esto que Arch por su modelo de repositorios.

3. **`pacman -Syu` problemático:** La capa extra de repos de Manjaro hace que las actualizaciones grandes sean más propensas a conflictos que en Arch vanilla. Si algo se rompe tras actualizar, los foros de Manjaro suelen tener el fix publicado en horas.

4. **Incidentes de seguridad:** Manjaro ha tenido incidentes (certificados SSL caducados que rompieron actualizaciones en 2022, paquetes firmados incorrectamente). Nada catastrófico, pero refleja un equipo de mantenimiento más pequeño que el de Arch/Debian/Fedora.

5. **No es Arch:** Usar Manjaro no te convierte en usuario de Arch. La experiencia (repositorios, herramientas, comunidad) es distinta. Si tu objetivo es aprender Arch, instala Arch o EndeavourOS.

---

## Tabla comparativa: Manjaro vs Arch vs EndeavourOS vs CachyOS

| Aspecto | Manjaro | EndeavourOS | Arch Linux | CachyOS |
|---|---|---|---|---|
| **Instalación** | Gráfica (Calamares) | Gráfica (Calamares) | Manual (archinstall opcional) | Gráfica (Calamares) |
| **Repositorios** | Propios (retrasados) | Oficiales de Arch + EOS | Oficiales de Arch | Oficiales de Arch + optimizados |
| **AUR** | Pamac (configurable) | yay preinstalado | Manual | yay/paru preinstalado |
| **Estabilidad** | Media (retraso por testeo) | Rolling (últimos paquetes) | Rolling (últimos) | Rolling (últimos + optimizaciones) |
| **Kernels** | Varios (mhwd-kernel) | Varios (linux, linux-lts, linux-zen) | Varios | Varios + linux-cachyos |
| **Optimizaciones** | Pocas | Pocas | Ninguna (estándar) | x86-64-v3/v4, BORE scheduler |
| **Público** | Puerta a Arch | Entusiastas de Arch | Usuarios avanzados | Gaming, rendimiento |
| **Partial upgrade risk** | ⚠️ Alta | Baja (misma base que Arch) | Baja (misma base) | Baja (misma base) |

---

## Ciclo de lanzamiento

Rolling release con retraso de testeo. Las ISOs se refrescan periódicamente (cada ~6 meses) para no tener que descargar 2 GB de actualizaciones al instalar.

```bash
# Ver versión de Manjaro
cat /etc/manjaro-release
# manjaro 24.1.1

# Ver estado de los repos
pacman-mirrors --fasttrack            # seleccionar mirrors rápidos
pacman-mirrors --country Argentina    # mirrors por país
```

## Ver también

- [[Arch Linux]] — la base
- [[EndeavourOS]] — alternativa más cercana a Arch vanilla
- [[CachyOS]] — alternativa optimizada para gaming
- [[Gestores de Paquetes]] — pacman, pamac
- [[Proceso de Instalacion General]] — instalación paso a paso

#distro
