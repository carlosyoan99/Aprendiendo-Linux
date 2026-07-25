---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: baja
---

# Exec Shield

> Parche de seguridad de **Red Hat** (2002) para el kernel Linux que emula el **bit NX** en CPUs x86 sin soporte hardware de NX. También proporciona ASLR (aleatorización de direcciones de memoria). Liderado por **Ingo Molnar**, fue el estándar de protección de memoria en Fedora y RHEL durante los años 2000.

## Historia

| Hito | Fecha |
|---|---|
| Inicio del proyecto | 2002 |
| Primer parche publicado | Mayo 2003 |
| Incluido en Fedora Core 1 | Noviembre 2003 |
| Incluido en RHEL 3 (Update 3) | Agosto 2004 |
| Fin de soporte (FC6/RHEL 4) | ~2007 |

Exec Shield fue un proyecto de Red Hat para reducir el riesgo de **exploits de desbordamiento de búfer**. Marcaba la memoria de datos como no ejecutable y la memoria de programa como no escribible, rompiendo la inserción de shellcode sin necesidad de recompilar aplicaciones.

> Con la llegada del **bit NX** nativo en CPUs x86-64 y PAE, Exec Shield fue reemplazado por el soporte integrado en el kernel. Hoy su legado vive en las protecciones NX/XD modernas.

## Implementación técnica

Exec Shield funciona en CPUs x86 usando los **límites del segmento de código (CS)**. Su mecanismo es ligero: marca toda la memoria de datos como no ejecutable por defecto, y la pila como no escribible+no ejecutable.

**Limitación conocida**: si un proceso llama a `mprotect()` para aumentar la memoria ejecutable por debajo del límite CS, las protecciones pueden perderse. Ingo Molnar documentó este caso en listas de correo. Afortunadamente, la pila no se convierte en ejecutable a menos que la aplicación haga llamadas explícitas.

**Protección contra ROP/return-to-libc**: al combinar NX emulado con ASLR, incluso si un atacante no puede ejecutar shellcode directamente, la aleatorización de direcciones de memoria (`mmap()`, heap) dificulta el encadenamiento de gadgets.

## Proyectos relacionados

| Proyecto | Relación |
|---|---|
| **PaX** | Proyecto independiente que implementó W^X y ASLR antes que Exec Shield |
| **Openwall** | Parche enfocado en protección de pila y restricciones de /tmp |
| **StackGuard** | Protección contra stack smashing con canarios |
| **PIE** | Ejecutables con posición independiente (relacionado con ASLR) |
| **GCC Fortify Source** | Comprobaciones en tiempo de compilación contra desbordamientos |
| **GCC stack-protector** | Adaptación del concepto StackGuard en GCC |

### Colaboración con SELinux

La política estándar de Fedora Core integraba Exec Shield con **SELinux** para bloquear el comportamiento de ejecución de páginas W|X (escribibles y ejecutables a la vez) en la mayoría de los ejecutables, con excepciones de compatibilidad para Mono, Wine y XEmacs.

## Características

- ✅ Emulación de NX en CPUs x86 sin soporte hardware
- ✅ ASLR para `mmap()` y heap
- ✅ Integración con SELinux (políticas restrictivas)
- ✅ Sin recompilación de aplicaciones necesaria
- ❌ Incompatible con algunas apps (Mono, Wine, XEmacs)
- ⚠️ Reemplazado por NX nativo en CPUs modernas
- ⚠️ No protege contra `mprotect()` malicioso bajo el límite CS

## Enlaces externos

- [Página del parche Exec Shield (archivada)](http://people.redhat.com/mingo/exec-shield/)
- [Wikipedia — Exec Shield](https://es.wikipedia.org/wiki/Exec_Shield)

## Ver también

- [[SELinux y AppArmor]] — MAC en Linux
- [[Procesos y Senales]] — gestión de procesos y memoria

#concepto #seguridad
