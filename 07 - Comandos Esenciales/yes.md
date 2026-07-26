---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: baja
---

# yes

## Sintaxis

```bash
yes [string]
```

Repite un string infinitamente hasta que se interrumpe (Ctrl+C). Útil para auto-responder prompts interactivos.

## Ejemplos

```bash
yes                              # imprime "y" infinitamente
yes "instalar"                   # imprime "instalar" infinitamente
yes | sudo apt install paquete   # responder "y" automáticamente
yes '' | make install            # aceptar valores por defecto
```

## Ver también

- [[seq]] — generar secuencias numéricas
- [[sleep]] — pausar ejecución
- [[xargs]] — ejecutar comandos con argumentos

#comando
