---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: programa
prioridad: media
---

# Bottles

## Qué es

**Bottles** es un **frontend gráfico moderno** para Wine que simplifica la gestión de entornos de ejecución de aplicaciones Windows en Linux. Organiza el software en **botellas** (bottles) — contenedores aislados con su propia configuración de Wine, dependencias y runners — todo gestionable desde una interfaz gráfica limpia e intuitiva.

A diferencia de [[Wine]] puro (que requiere terminal y winetricks), Bottles ofrece una experiencia visual completa sin sacrificar control. Es mantenido por el equipo de Bottles Developers y está disponible principalmente vía Flatpak en Flathub.

```
┌─────────────────────────────────────────────────────┐
│                    Bottles (GUI)                     │
├─────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │ Botella   │  │ Botella  │  │ Botella          │  │
│  │ Gaming    │  │ Software │  │ Custom           │  │
│  ├──────────┤  ├──────────┤  ├──────────────────┤  │
│  │ DXVK on  │  │ DXVK off │  │ Config manual    │  │
│  │ Fsync on │  │ Estable   │  │ Sin optimizac.   │  │
│  └──────────┘  └──────────┘  └──────────────────┘  │
├─────────────────────────────────────────────────────┤
│  Runners: Caffe · Wine-GE · Proton · Wine oficial   │
│  Dependencias: vcrun · dotnet · directx · physx     │
│  Gráficos: DXVK · VKD3D · Fsync · Esync            │
└─────────────────────────────────────────────────────┘
```

## Filosofía

- **Entornos aislados**: cada aplicación en su propia botella con su propia configuración
- **Sin terminal**: toda la gestión (instalar dependencias, cambiar runners, configurar DXVK) desde la interfaz
- **Moderno por defecto**: usa GTK 4 + libadwaita, con tema oscuro y diseño coherente
- **Portabilidad**: exporta e importa botellas completas para migrar entre equipos
- **Reproducibilidad**: las dependencias se instalan desde repositorios mantenidos por la comunidad

## Instalación

```bash
# Flatpak (método recomendado por los desarrolladores)
flatpak install flathub com.usebottles.bottles

# Arch Linux (AUR)
yay -S bottles

# Fedora (COPR)
sudo dnf copr enable bbenoit/bottles
sudo dnf install bottles

# Debian/Ubuntu (no recomendado — paquetes nativos suelen estar desactualizados)
# Mejor usar Flatpak
```

## Primeros pasos

### 1. Crear una botella

Al abrir Bottles por primera vez, te ofrece crear una botella con tres entornos predefinidos:

| Entorno | Ideal para | DXVK | Fsync | Esync |
|---|---|---|---|---|
| **Gaming** | Juegos (Steam, GOG, itch.io) | ✅ Activado | ✅ Activado | ✅ Activado |
| **Software** | Aplicaciones de productividad | ❌ Desactivado | ❌ Desactivado | ❌ Desactivado |
| **Custom** | Configuración manual desde cero | Configurable | Configurable | Configurable |

```bash
# Desde la GUI:
# 1. Abrir Bottles
# 2. Botón "+" → "Create a new bottle"
# 3. Elegir nombre y entorno (Gaming, Software, Custom)
# 4. Elegir runner (Caffe, Wine-GE, Wine oficial, Proton)
# 5. Crear
```

### 2. Instalar dependencias

Bottles tiene un gestor de dependencias integrado que instala componentes Windows con un clic:

| Dependencia | Para qué | Estado |
|---|---|---|
| **vcrun2022 / vcrun2019** | Visual C++ Redistributable (juegos, apps) | ✅ Estable |
| **dotnet48 / dotnet40** | .NET Framework (aplicaciones .NET) | ✅ Estable |
| **directx9** | DirectX 9 (juegos antiguos) | ✅ Estable |
| **d3dx9 / d3dx11_43** | Librerías DirectX adicionales | ✅ Estable |
| **xact** | DirectX Audio (sonido en juegos) | ✅ Estable |
| **xinput** | Soporte para mandos Xbox | ✅ Estable |
| **mono** | Runtime .NET alternativo | ✅ Estable |
| **gecko** | Motor HTML/Web (para apps que embeben IE) | ✅ Estable |
| **physx** | PhysX SDK (física en juegos) | ✅ Estable |
| **corefonts** | Fuentes Arial, Times New Roman, etc. | ✅ Estable |

```bash
# Desde la GUI:
# Botella → Dependencies → Install → buscar componente → instalar
```

### 3. Ejecutar programas

```bash
# Desde la GUI:
# Botella → "Run executable" → seleccionar .exe

# O desde el menú contextual del sistema:
# Click derecho en .exe → "Open with Bottles"

# O desde terminal:
flatpak run com.usebottles.bottles -e juego.exe
```

## Runners

Los **runners** son las distintas versiones de Wine que Bottles puede gestionar:

| Runner | Mantenido por | Ideal para |
|---|---|---|
| **Caffe** | Bottles Developers | Juegos y apps, optimizado para Bottles |
| **Wine-GE** | GloriousEggroll | Juegos, parcheado para máxima compatibilidad |
| **Proton GE** | GloriousEggroll | Juegos (fork de Proton de Valve)|
| **Wine oficial** | WineHQ | Estabilidad máxima, apps de productividad |
| **Wine-Staging** | WineHQ | Parches experimentales de Wine |
| **Soda** | Bottles Developers | Alternativa a Caffe, estable |

```bash
# Desde la GUI:
# Bottles → Preferences → Runners → descargar runner
# Luego al crear/editar botella: elegir runner

# Los runners se descargan automáticamente desde los repos de Bottles
```

### Cómo elegir runner

| Si buscas... | Usa |
|---|---|
| **La mejor compatibilidad gaming** | Wine-GE o Proton GE |
| **Una app de oficina estable** | Caffe o Wine oficial |
| **Renderizado por GPU NVIDIA** | Wine-GE (tiene parches para NVIDIA) |
| **Ejecutar el .exe más reciente** | Proton GE (sigue parches de Proton) |
| **Probar si un juego funciona** | Caffe (configurado por defecto) |

## Gestión de configuraciones avanzadas

### Parámetros gráficos

Bottles permite configurar por botella:

| Parámetro | Opciones | Efecto |
|---|---|---|
| **DXVK** | On / Off | DirectX 9/10/11 → Vulkan (mejor rendimiento) |
| **VKD3D** | On / Off | DirectX 12 → Vulkan (necesario para juegos DX12) |
| **Fsync** | On / Off | Sincronización rápida (kernel 5.16+, mejora CPU) |
| **Esync** | On / Off | Sincronización con eventfd (alternativa a Fsync) |
| **Virtual Desktop** | Resolución personalizable | Ejecutar en ventana en vez de pantalla completa |
| **Discrete GPU** | On / Off | Forzar GPU dedicada (laptops híbridas) |
| **GameMode** | On / Off | Optimización CPU/GPU con Feral GameMode |

### Variables de entorno

Bottles permite establecer variables de entorno por botella:

```bash
# Desde la GUI: Botella → Config → Environment Variables
# Ejemplos:
DXVK_HUD=1                    # mostrar estadísticas DXVK
DXVK_FRAME_RATE=60            # limitar FPS
PROTON_LOG=1                  # generar log de Proton
MANGOHUD=1                    # overlay de rendimiento
```

## Comparativa

### Bottles vs Lutris vs Wine puro

| Aspecto | Bottles | Lutris | Wine puro |
|---|---|---|---|
| **Enfoque** | Gestión de entornos aislados | Lanzador de bibliotecas de juegos | Capa de compatibilidad base |
| **Interfaz** | Moderna (GTK 4 / libadwaita) | Funcional (GTK 3) | Terminal |
| **Curva aprendizaje** | Baja (muy intuitiva) | Media (requiere configurar) | Alta |
| **Gestión de dependencias** | ✅ Integrada (un clic) | ✅ Scripts por juego | ❌ winetricks manual |
| **Runners** | Caffe, Wine-GE, Proton, Soda | Wine oficial, Wine-GE, Proton | Wine oficial |
| **Múltiples entornos** | ✅ Botellas aisladas | ✅ Prefijos Wine separados | ✅ WINEPREFIX manual |
| **Exportar/Importar** | ✅ Botella completa (.yml) | ❌ Manual | ❌ Manual |
| **Integración Steam** | ❌ (juegos fuera de Steam) | ✅ (Steam, GOG, Epic, Humble) | ❌ |
| **Instalación** | Flatpak (recomendado) | Nativo + Flatpak | Nativo |
| **Uso ideal** | Apps/juegos sueltos, entornos aislados | Catálogo completo de juegos | Usuarios avanzados, testing |
| **Licencia** | GPL-3.0 | GPL-3.0 | LGPL-2.1+ |

### Bottles vs Heroic

| Aspecto | Bottles | Heroic |
|---|---|---|
| **Enfoque** | Gestionar entornos Wine | Launcher para Epic/GOG |
| **Tienda integrada** | ❌ | ✅ Epic Games Store + GOG |
| **Juegos gratis Epic** | ❌ | ✅ Semanales |
| **Cloud saves** | ❌ | ✅ Epic + GOG |
| **Entornos personalizados** | ✅ Botellas flexibles | ✅ Prefijos por juego |

## Importar y exportar botellas

```bash
# Exportar botella completa (backup o migración)
# Botella → botón ⋮ → Export → Guardar .yml + .tar.gz

# La exportación incluye:
# - Configuración de Wine
# - Dependencias instaladas
# - Runner asignado
# - Variables de entorno
# - Programas instalados en drive_c/

# Importar en otro equipo
# Bottles → botón ⋮ → Import → seleccionar archivo .yml
```

## Bottles desde terminal (bottles-cli)

Bottles también ofrece un CLI para tareas avanzadas y scripting. Si instalaste Bottles como Flatpak, el comando se accede mediante:

```bash
# Flatpak (el CLI no está en el PATH, se usa --command)
flatpak run --command=bottles-cli com.usebottles.bottles bottles
flatpak run --command=bottles-cli com.usebottles.bottles new -n mi-botella -e gaming
flatpak run --command=bottles-cli com.usebottles.bottles run -b mi-botella -e programa.exe

# O crear un alias en ~/.bashrc:
alias bottles-cli='flatpak run --command=bottles-cli com.usebottles.bottles'

# Instalación nativa (AUR, COPR) — bottles-cli está en el PATH directamente
bottles-cli bottles
bottles-cli new -n mi-botella -e gaming
bottles-cli run -b mi-botella -e programa.exe
bottles-cli deps -b mi-botella -d vcrun2022
bottles-cli export -b mi-botella -p /ruta/backup.tar.gz
bottles-cli import -p /ruta/backup.tar.gz
```

## Troubleshooting

```bash
# 1. Bottles no arranca (Flatpak)
flatpak repair com.usebottles.bottles
flatpak update com.usebottles.bottles

# 2. Error de permisos (Flatpak)
# Asegurar permisos en Flatpak:
flatpak override --user com.usebottles.bottles --filesystem=home

# 3. DXVK no funciona
# Verificar que vulkan está instalado en el host:
vulkaninfo --summary
# Si no, instalar drivers Vulkan:
sudo apt install mesa-vulkan-drivers    # AMD/Intel
sudo pacman -S vulkan-radeon            # AMD
sudo pacman -S nvidia-utils             # NVIDIA

# 4. Sonido no funciona en la botella
# Verificar que PipeWire/PulseAudio está activo:
pactl info
# En config de botella → Audio → elegir PulseAudio

# 5. La app no detecta el mando
# Botella → Config → XInput → activar

# 6. Logs de la aplicación
# Botella → botón ⋮ → Logs → ver salida de Wine
```

## Ver también

- [[Wine]] — capa de compatibilidad base
- [[Videojuegos en Linux]] — gaming en Linux con Proton, Lutris, Heroic
- [[Snap y Flatpak]] — Bottles se distribuye principalmente como Flatpak
- [[PipeWire]] — audio de baja latencia para Wine
- [[AppImage]] — formato portable alternativo

## Enlaces externos

- [Bottles — Página oficial](https://usebottles.com/)
- [Bottles — Flathub](https://flathub.org/apps/com.usebottles.bottles)
- [Bottles — GitHub](https://github.com/bottlesdevs/Bottles)
- [Bottles Documentation](https://docs.usebottles.com/)
- [Bottles Community — Discord](https://discord.gg/bottles)
- [Bottles — Wikipedia](https://en.wikipedia.org/wiki/Bottles_(software))

#programa #wine #gaming
