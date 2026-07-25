---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-19
estado: resuelto
categoria: concepto
prioridad: media
---

# Compilación desde Código Fuente

## Definición

Cuando un programa no está en los repositorios de tu distro (o quieres una versión/parche específico, como con [[DWM]]), se compila manualmente desde su código fuente. Compilar no es solo "tirar make" — implica **configurar** el proyecto (elegir opciones, detectar dependencias), **compilar** el código, y **copiar** los binarios resultantes al sistema.

---

## Sistemas de build (build systems)

Un sistema de build es el software que orquesta la compilación: detecta dependencias, decide qué compilar y en qué orden, y produce los binarios. Hay varios según el lenguaje y la época del proyecto.

### Autotools (GNU Build System) — El clásico

Usado por proyectos GNU y mucho software de los 90s/2000s. Detecta dependencias automáticamente y genera archivos Makefile portables.

```bash
git clone <repo>
cd proyecto
./configure --prefix=/usr/local           # detecta dependencias y genera Makefile
make                                       # compila
sudo make install                          # instala
```

```bash
# Opciones comunes de configure
./configure --help                         # ver todas las opciones disponibles
./configure --prefix=/usr                  # instalar en /usr en vez de /usr/local
./configure --enable-feature-x             # activar una feature opcional
./configure --disable-feature-y            # desactivar una feature
./configure --with-python=/usr/bin/python3 # especificar ruta de una dependencia

# Separar build y source (out-of-tree build)
mkdir build && cd build
../configure --prefix=/usr/local
make
```

**Ventajas:** Altamente portable, autodetecta dependencias.
**Desventajas:** Lento (`configure` puede tardar minutos), scripts complejos difíciles de debuguear.

---

### CMake — El estándar moderno (C/C++)

Usado por la mayoría de proyectos modernos (KDE, LLVM, OpenCV, MySQL, Blender). Más rápido que autotools y más portable.

```bash
git clone <repo>
cd proyecto
mkdir build && cd build
cmake ..                                 # detectar dependencias y generar Makefile/Ninja
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)                          # compilar en paralelo
sudo make install                        # instalar
```

```bash
# Opciones comunes de cmake
cmake .. -DCMAKE_BUILD_TYPE=Release       # Release (optimizado) vs Debug
cmake .. -DCMAKE_BUILD_TYPE=Debug         # con símbolos de depuración
cmake .. -DWITH_FEATURE_X=ON              # activar feature
cmake .. -DCMAKE_INSTALL_PREFIX=/usr      # cambiar prefijo de instalación
cmake .. -G Ninja                         # usar Ninja en vez de Make (más rápido)

# Ver qué opciones tiene un proyecto
cmake .. -LAH | less                      # listar todas las variables disponibles

# Compilar con Ninja (más rápido que make)
cmake .. -G Ninja
ninja -j$(nproc)
sudo ninja install

# Limpiar build (borrar el directorio build y empezar de nuevo)
rm -rf build && mkdir build && cd build && cmake ..

# Cross-compilation
cmake .. -DCMAKE_TOOLCHAIN_FILE=../toolchain-arm.cmake
```

**CMakePresets.json** (CMake 3.19+ para configure presets, 3.23+ para build presets): los proyectos modernos incluyen un archivo `CMakePresets.json` con configuraciones predefinidas:

```bash
# Ver presets disponibles (CMake ≥3.19)
cmake --list-presets

# Usar un preset de configuración (CMake ≥3.19)
cmake --preset=release

# Usar un preset de build (CMake ≥3.23)
cmake --build --preset=release
```

---

### Meson — El más moderno y rápido

Usado por GNOME, systemd, Mesa, GStreamer, QEMU. Diseñado para ser rápido (compila desde cero más rápido que CMake).

```bash
git clone <repo>
cd proyecto
meson setup build                     # detectar dependencias
meson configure build -Dprefix=/usr/local -Dbuildtype=release
ninja -C build                        # compilar (ninja integrado)
sudo ninja -C build install           # instalar
```

```bash
# Opciones comunes
meson setup build -Dbuildtype=release   # Release
meson setup build -Dbuildtype=debug     # Debug
meson configure build -Doption=value    # cambiar opción en build existente
meson configure build                   # listar todas las opciones

# Reconfigurar (cambiar opciones sin borrar build)
meson configure build -Denable-feature-x=true

# Limpiar
ninja -C build clean
```

**Ventajas de Meson:** El más rápido en configuración, sintaxis legible (`meson.build` en vez de `CMakeLists.txt`), soporte nativo de `clang-tidy`, `sanitizers`, y profiling.

---

### Tabla comparativa de sistemas de build

| Sistema | Configuración | Compilación | Instalación | Popular en |
|---|---|---|---|---|
| **Autotools** | `./configure` | `make` | `make install` | GNU tools, software legacy |
| **CMake** | `cmake ..` | `make` / `ninja` | `make install` / `ninja install` | KDE, LLVM, OpenCV, VTK |
| **Meson** | `meson setup build` | `ninja` | `ninja install` | GNOME, systemd, Mesa |
| **Makefile directo** | — | `make` | `make install` | Proyectos pequeños, suculentos (suckless: [[DWM]]) |

---

## Dependencias de compilación

Se suelen necesitar paquetes de desarrollo que no vienen por defecto. El nombre varía entre distros:

```bash
# Debian / Ubuntu
sudo apt install build-essential          # gcc, g++, make
sudo apt install cmake                    # si el proyecto usa CMake
sudo apt install meson ninja-build        # si usa Meson
sudo apt install libfoo-dev               # headers de una librería específica

# Arch
sudo pacman -S base-devel                 # gcc, make, autotools
sudo pacman -S cmake                      # CMake
sudo pacman -S meson ninja                # Meson + Ninja
sudo pacman -S extra-cmake-modules        # módulos extra de CMake para KDE

# Fedora
sudo dnf groupinstall "Development Tools" # gcc, make, etc.
sudo dnf install cmake                    # CMake
sudo dnf install meson ninja-build        # Meson
sudo dnf install "Development Libraries"  # headers de librerías
```

### Encontrar dependencias (pkg-config)

`pkg-config` es la herramienta que usan los build systems para encontrar headers y librerías instaladas:

```bash
# Saber qué flags de compilación necesita una librería
pkg-config --cflags gtk+-3.0
# -I/usr/include/gtk-3.0 -I/usr/include/pango-1.0 ...

# Saber qué flags de linking necesita
pkg-config --libs gtk+-3.0
# -lgtk-3 -lgdk-3 -lpangocairo-1.0 -lpango-1.0 ...

# Saber qué versión está instalada
pkg-config --modversion gtk+-3.0
# 3.24.41

# Ver todas las librerías disponibles en el sistema
pkg-config --list-all | sort

# Buscar una librería específica
pkg-config --list-all | grep -i sdl

# Ver dependencias de una librería
pkg-config --print-requires gtk+-3.0

# Verificar que una librería existe y es >= cierta versión
# (nota: no produce salida, solo exit code 0/1)
pkg-config --atleast-version=3.20 gtk+-3.0 && echo "✅ OK" || echo "❌ Muy vieja o no encontrada"
```

**Troubleshooting con pkg-config:**

```bash
# ¿pkg-config no encuentra una librería que instalaste?
# 1. Verificar que el archivo .pc existe
find /usr -name "*.pc" | grep -i nombre

# 2. Si está en /usr/local/lib/pkgconfig, agregar al path:
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# 3. En sistemas de 64 bits con librerías 32-bit:
export PKG_CONFIG_PATH=/usr/lib32/pkgconfig:$PKG_CONFIG_PATH
```

---

## checkinstall — Instalación rastreable

`checkinstall` reemplaza `make install` y genera un paquete `.deb`, `.rpm` o `.pkg.tar.zst` que se instala a través del gestor de paquetes de tu distro. Esto permite desinstalar limpiamente:

```bash
# Instalar checkinstall
sudo apt install checkinstall            # Debian/Ubuntu
sudo pacman -S checkinstall              # Arch

# En vez de sudo make install:
sudo checkinstall

# Opciones:
sudo checkinstall --deldoc=yes           # no generar docs
sudo checkinstall --pkgname=mi-programa  # nombre personalizado
sudo checkinstall --requires="libfoo,libbar"  # dependencias del paquete

# Flujo completo:
./configure --prefix=/usr/local
make
sudo checkinstall                        # genera .deb y lo instala

# Después puedes desinstalar como cualquier paquete:
sudo apt remove mi-programa              # Debian/Ubuntu
sudo pacman -R mi-programa               # Arch
```

> ⚠️ En **Arch Linux**, `checkinstall` ha tenido problemas de compatibilidad con pacman 6.0+. La alternativa idiomática es `makepkg` con un `PKGBUILD`:
> ```bash
> # Clonar o crear un PKGBUILD para el proyecto
> # Editar según sea necesario
> makepkg -si          # compila e instala, generando un paquete .pkg.tar.zst
> ```

**Ventaja sobre `make install`:** `make install` no deja rastro — no puedes desinstalar a menos que el proyecto tenga `make uninstall` (que no suele existir o está incompleto). `checkinstall` crea un paquete rastreable.

---

## DESTDIR — Staging installs (instalación en un directorio temporal)

`DESTDIR` es una variable estándar que usan los Makefiles para instalar en un directorio temporal en lugar de en la raíz del sistema. Útil para:

- **Empaquetar** (crear un paquete para otra máquina)
- **Probar la instalación** sin modificar el sistema
- **Instalar sin root** en un directorio personal

```bash
# El flujo normal:
./configure --prefix=/usr
make
sudo make install              # escribe a /usr/bin/, /usr/lib/, etc.

# Con DESTDIR (sin sudo):
make install DESTDIR=/tmp/staging
# Los archivos se escriben en /tmp/staging/usr/bin/, /tmp/staging/usr/lib/, etc.
# Luego puedes empaquetarlos o copiarlos al sistema real

# Ejemplo práctico: instalar en un directorio personal
./configure --prefix=/usr
make
make install DESTDIR=$HOME/.local
# Ahora los binarios están en $HOME/.local/usr/bin/
# Agregar al PATH: export PATH="$HOME/.local/usr/bin:$PATH"

# Crear un tar.gz para instalar en otra máquina
make install DESTDIR=/tmp/pkg
cd /tmp/pkg
tar czf mi-programa.tar.gz .
# En la otra máquina: tar xzf mi-programa.tar.gz -C /
```

`DESTDIR` funciona con autotools, CMake (`DESTDIR=... make install`), y la mayoría de proyectos. Meson usa un enfoque similar pero con `meson install --destdir`:

```bash
meson setup build
ninja -C build
DESTDIR=/tmp/staging ninja -C build install
# O con Meson 0.57+:
meson install -C build --destdir /tmp/staging
```

---

## Troubleshooting de compilación

### Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `configure: error: libfoo not found` | Falta una dependencia de desarrollo | Buscar e instalar `libfoo-dev` (Debian) o `libfoo` (Arch). Probar `apt search foo` |
| `fatal error: X11/Xlib.h: No such file or directory` | Faltan headers de X11 | `sudo apt install libx11-dev` / `sudo pacman -S libx11` |
| `fatal error: python3.10/Python.h: No such file or directory` | Falta el header de Python para extensiones C | `sudo apt install python3-dev` / `sudo pacman -S python` |
| `undefined reference to 'dlopen'` | Falta enlazar con `-ldl` | Agregar `-ldl` a LDFLAGS: `export LDFLAGS="-ldl $LDFLAGS"` |
| `/usr/bin/ld: cannot find -lfoo` | El linker no encuentra la librería `libfoo.so` | Instalar `libfoo-dev` o crear un symlink: `sudo ln -s /usr/lib/libfoo.so.1 /usr/lib/libfoo.so` |
| `make: command not found` | `build-essential` no instalado | `sudo apt install build-essential` |
| `c++: internal compiler error` (Killed) | RAM insuficiente durante la compilación (OOM) | Reducir paralelismo: `make -j1` o aumentar swap |
| `checking for ... compiler cannot create executables` | Toolchain rota o incompleta | Reinstalar `build-essential` / `base-devel` |
| `Could NOT find PkgConfig (missing: PKG_CONFIG_EXECUTABLE)` | pkg-config no instalado | `sudo apt install pkg-config` / `sudo pacman -S pkg-config` |
| `ERROR: Problem encountered: openssl version is too old` | Dependencia demasiado vieja para el proyecto | Usar backports, flatpak/snap, o una versión anterior del proyecto |
| `Meson: ERROR: Unknown options: "foobar"` | La opción no existe o el nombre cambió | Revisar `meson configure build` para ver opciones válidas |

### Técnicas de diagnóstico

```bash
# 1. Ver la salida completa de configure/cmake (no solo las últimas líneas)
./configure 2>&1 | tee config.log          # autotools
cmake .. 2>&1 | tee cmake-output.log       # cmake

# 2. Buscar errores específicos
grep -i "error\|not found\|missing" config.log cmake-output.log

# 3. Verificar qué versión de una librería está instalada
apt-cache policy libfoo-dev                # Debian/Ubuntu
pacman -Qi libfoo                          # Arch
pkg-config --modversion libfoo             # si tiene .pc

# 4. Encontrar dónde está un header
find /usr/include -name "Xlib.h" 2>/dev/null

# 5. Ver la ruta de una librería
ldconfig -p | grep libfoo

# 6. Probar el compilador directamente (aislar el problema)
echo 'int main() { return 0; }' | gcc -x c - -o /tmp/test && echo "OK" || echo "FAIL"
```

### Compilación con flags personalizados

```bash
# Agregar flags de optimización
export CFLAGS="-O3 -march=native -pipe"
export CXXFLAGS="$CFLAGS"
export MAKEFLAGS="-j$(nproc)"              # compilar en paralelo por defecto

# Agregar paths de búsqueda
export C_INCLUDE_PATH=/opt/include:$C_INCLUDE_PATH
export LIBRARY_PATH=/opt/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/lib:$LD_LIBRARY_PATH

# Para Autotools
./configure CFLAGS="$CFLAGS" LDFLAGS="-Wl,--as-needed"
make

# Para CMake
cmake .. -DCMAKE_C_FLAGS="$CFLAGS" -DCMAKE_EXE_LINKER_FLAGS="-Wl,--as-needed"

# Para Meson (en cross-file o native-file)
meson setup build -Dc_args="$CFLAGS" -Dc_link_args="-Wl,--as-needed"
```

---

### Cómo evitar compilar desde fuente

Antes de decidir compilar, considera alternativas:

| Alternativa | Cuándo usarla |
|---|---|
| **Backports** | Versiones más nuevas para Debian/Ubuntu estable |
| **Flatpak / Snap** | Aislado del sistema, actualizaciones automáticas |
| **AppImage** | Portable, no requiere instalación |
| **`pip install --user`** | Para herramientas Python |
| **`cargo install`** | Para herramientas Rust |
| **Docker / Podman** | Entorno aislado con la versión exacta |
| **PPA (Ubuntu)** | Repositorio de terceros con paquetes actualizados |
| **AUR (Arch)** | Build desde fuente automatizado y trackeado |

```bash
# Ejemplo: si solo necesitas una herramienta reciente sin instalarla
docker run --rm -it ubuntu:24.04 bash
# Dentro del contenedor: instalar herramientas, compilar, probar
```

---

## Flujo completo de troubleshooting (checklist)

Cuando un proyecto no compila, sigue este orden:

```
1. ✅ Leer el error COMPLETO — no solo la última línea
2. ✅ Buscar el error en Google entre comillas: "error: ..."
3. ✅ Verificar dependencias: el 90% de las fallas son dependencias faltantes
4. ✅ Buscar en la documentación del proyecto: INSTALL, README, BUILDING.md
5. ✅ Probar con menos paralelismo: make -j1 (evita OOM)
6. ✅ Buscar en Arch Wiki / GitHub Issues del proyecto
7. ✅ Limpiar el build y empezar de nuevo: rm -rf build && mkdir build
8. ✅ Verificar la versión del compilador: gcc --version
```

## Por qué importa

Compilar desde fuente te da control total sobre qué versión y con qué opciones se instala un programa. Es esencial para [[DWM]] (config.h), suckless tools en general, y software muy reciente que aún no llegó a los repos. `checkinstall` y `DESTDIR` evitan el mayor riesgo de compilar: que `make install` deje archivos huérfanos imposibles de desinstalar.

## Ver también

- [[DWM]] — caso práctico de compilación desde fuente
- [[Gestores de Paquetes]] — alternativa a compilar
- [[Docker]] — entornos aislados para compilar sin contaminar el sistema
- [[Git]] — clonar repositorios
- [[AppImage]] — formato portable que evita compilar

## Enlaces externos

- [Autotools Tutorial](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html)
- [CMake Documentation](https://cmake.org/documentation/)
- [Meson Documentation](https://mesonbuild.com/)
- [Arch Wiki — Makepkg](https://wiki.archlinux.org/title/Makepkg)
- [checkinstall — GitHub](https://github.com/checkinstall/checkinstall)

#concepto #compilacion
