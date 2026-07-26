---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: baja
---

# sleep

## Sintaxis

```bash
sleep N[sufijo]
```

Pausa la ejecución durante N segundos. Acepta sufijos: `s` (segundos, por defecto), `m` (minutos), `h` (horas), `d` (días).

## Ejemplos

```bash
sleep 5                          # 5 segundos
sleep 0.5                        # 500 ms
sleep 2m                         # 2 minutos
sleep 1h 30m                     # 1 hora 30 minutos
```

## Casos de uso

```bash
# Esperar a que un servicio esté listo
while ! curl -s localhost:3000 > /dev/null; do sleep 1; done
echo "Servicio listo"

# Loop con pausa
for i in $(seq 1 5); do echo "Paso $i"; sleep 1; done
```

## Ver también

- [[seq]] — generar secuencias numéricas
- [[yes]] — repetir string infinitamente
- [[watch]] — ejecutar comando periódicamente
- [[timeout]] — limitar tiempo de ejecución

#comando
