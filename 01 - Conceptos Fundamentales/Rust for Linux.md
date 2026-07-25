---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: concepto
prioridad: alta
---

# Rust for Linux

> El proyecto para añadir **Rust como segundo lenguaje de programación** en el kernel de Linux, permitiendo escribir módulos y controladores con garantías de memoria seguras sin sacrificar rendimiento. Aceptado oficialmente en el kernel 6.1 (diciembre 2022).

## Qué es

**Rust for Linux** es una iniciativa para habilitar el uso del lenguaje de programación **Rust** en el kernel de Linux, como alternativa a C para escribir módulos, drivers y subsistemas. Rust ofrece **seguridad de memoria en tiempo de compilación** (sin garbage collector) mediante su sistema de ownership y borrow checker, eliminando clases enteras de bugs de memoria (use-after-free, buffer overflows, dobles liberaciones) que son las causas más comunes de vulnerabilidades de seguridad en el kernel.

El proyecto fue iniciado por **Miguel Ojeda** y es mantenido por el equipo **Rust for Linux** con apoyo de Google, ISRG (Internet Security Research Group) y la comunidad.

## Historia

| Hito | Fecha | Detalle |
|---|---|---|
| **Primera propuesta** | 2020 | Miguel Ojeda presenta RFC en LKML |
| **Rust for Linux v1** | 2021 | Parche inicial con soporte básico |
| **Revisión profunda** | 2022 | Discusión y refinamiento con maintainers |
| **Aceptado en kernel 6.1** | Dic 2022 | Infraestructura Rust + primer driver (Semihosting) |
| **Kernel 6.7+** | 2024 | Más abstracciones, bindings mejorados, drivers NVMe |
| **Estado actual (2026)** | Actual | Soporte estable, drivers en Rust aceptados regularmente |

## Por qué Rust en el kernel

El kernel de Linux está escrito en **C**, un lenguaje que requiere que el programador gestione la memoria manualmente. Esto es fuente de aproximadamente **~70% de las vulnerabilidades de seguridad** del kernel (CVE).

```c
// Ejemplo clásico de bug en C (use-after-free)
void peligroso(struct dispositivo *dev) {
    struct datos *d = dev->datos;
    liberar_dispositivo(dev);   // libera dev y sus datos
    d->valor = 42;              // ❌ use-after-free! d ya no existe
}
```

> **Nota**: El siguiente ejemplo es ilustrativo de cómo Rust previene errores de memoria en el kernel. El código real del kernel usa abstracciones como `Ref`, `UniqueArc` y `Box` con el allocador del kernel.

```rust
// Rust: el compilador detecta el error en compilación
fn seguro(dev: &mut Dispositivo) {
    let d = &dev.datos;
    // drop(dev);  // ❌ Error del compilador: no se puede mover dev
    // mientras d lo está prestando
}
```

### Beneficios

| Aspecto | C en kernel | Rust en kernel |
|---|---|---|
| **Seguridad memoria** | Manual (error-prone) | Garantizada en compile-time |
| **Data races** | No detectados | Prevenidos por el tipo system |
| **Gestión de recursos** | Manual (goto cleanup) | RAII (automático) |
| **Concurrencia** | Manual (mutex, spinlock) | Garantizada (Send + Sync traits) |
| **Documentación** | Comentarios | Tests integrados, doc tests |
| **Performance** | Excelente | Comparable (sin runtime) |

## Cómo funciona

Rust en el kernel **no usa std** (no hay libc, heap allocator, o threading runtime). En su lugar usa:

- **`core`** — biblioteca estándar mínima (sin asignación dinámica)
- **`alloc`** — asignación dinámica (usando el allocator del kernel)
- **Bindings** — wrappers seguros sobre APIs del kernel en C
- **`kernel` crate** — abstracciones para módulos, drivers, file operations

```rust
// Módulo mínimo en Rust para el kernel
//! Módulo ejemplo de Rust en Linux

use kernel::prelude::*;

module! {
    type: MiModulo,
    name: "mi_modulo_rust",
    author: "Yo",
    description: "Driver de ejemplo en Rust",
    license: "GPL",
}

struct MiModulo;

impl kernel::Module for MiModulo {
    fn init(_module: &'static Module) -> Result<Self> {
        pr_info!("Módulo Rust cargado correctamente!\n");
        Ok(MiModulo)
    }
}

impl Drop for MiModulo {
    fn drop(&mut self) {
        pr_info!("Módulo Rust descargado!\n");
    }
}
```

## Estado de adopción (2026)

| Componente | Estado |
|---|---|
| **Infraestructura Rust** (`rust/` en kernel) | ✅ Estable |
| **Bindings básicos** (alloc, sync, printk) | ✅ Estables |
| **Abstracciones de drivers** | 🟡 En desarrollo activo |
| **Driver NVMe** | ✅ Aceptado | 
| **Driver de red** | 🟡 RFC |
| **Soporte de GPU** | 🔴 Planificado |
| **Android** | 🟡 Uso de Rust en drivers Android |
| **Herramientas** (bindgen, rustc_codegen_gcc) | ✅ Uso en producción |

## Cómo compilar un módulo en Rust

```bash
# Requisitos
# - kernel 6.1+ con `CONFIG_RUST=y`
# - Rust toolchain (rustc, bindgen)

# Configurar y compilar kernel con soporte Rust
make menuconfig
# General setup → Rust support → Y
make -j$(nproc)

# Compilar un módulo Rust externo
make -C /lib/modules/$(uname -r)/build M=/ruta/a/mi-modulo

# Cargar módulo
sudo insmod mi_modulo_rust.ko
dmesg | tail
# [  OK  ] Módulo Rust cargado correctamente!
```

## Controversias y desafíos

| Desafío | Explicación |
|---|---|
| **Mantenimiento a largo plazo** | El kernel es C, agregar Rust añade complejidad |
| **Bindings** | Mantener wrappers sobre APIs C que cambian constantemente |
| **Toolchain** | Requiere versiones específicas de rustc + bindgen |
| **Rendimiento** | Algunas abstracciones Rust tienen overhead mínimo |
| **Curva de aprendizaje** | Maintainers de kernel necesitan aprender Rust |
| **Linus Torvalds** | Postura inicial: abierto pero cauto. En 2024: \"Rust está avanzando bien\" |

## Espacio de usuario vs Kernel

```rust
// Rust en espacio de usuario (std disponible)
use std::fs;

fn main() {
    let data = fs::read_to_string("/proc/cpuinfo").unwrap();
    println!("CPU: {}", data.lines().next().unwrap_or("?"));
}

// Rust en kernel (sin std, solo core + alloc)
//! Rust en kernel usa `kernel` crate, no `std`
use kernel::prelude::*;
// No println! — usar pr_info!, pr_err!, etc.
// No Vec<T> sin alloc — usar kernel::alloc::KVec
// No `unwrap()` — usar ? con Result
```

## Ver también

- [[Compilacion desde Codigo Fuente]] — compilar kernel desde fuente
- [[Módulos del kernel (lsmod modprobe blacklist)]] — gestión de módulos
- [[Desarrollo en Linux (gcc make gdb strace)]] — herramientas de desarrollo
- [[Kernel Linux]] — historia y versiones del kernel
- [[GNU y Linux]] — relación GNU/Linux

## Enlaces externos

- [Rust for Linux GitHub](https://github.com/Rust-for-Linux/linux)
- [Documentación oficial — Rust in kernel](https://rust-for-linux.com/)
- [LKML — RFC de Rust for Linux](https://lkml.org/lkml/2022/12/6/1066)
- [Kernel 6.1 release notes — Rust](https://kernelnewbies.org/Linux_6.1#Rust_in_the_Linux_kernel)
- [The case for Rust in the Linux kernel](https://lwn.net/Articles/870555/)
- [Wikipedia — Rust for Linux](https://en.wikipedia.org/wiki/Rust_for_Linux)

#concepto
