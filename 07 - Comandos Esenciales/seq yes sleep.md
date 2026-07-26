---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: baja
---

# seq, yes, sleep

> Tres utilidades simples: seq genera secuencias numéricas, yes repite un string infinitamente, sleep pausa la ejecución.

## seq — generar secuencia de números

```bash
seq [inicio] [paso] [fin]
seq 5                            # 1 2 3 4 5
seq 2 2 10                       # 2 4 6 8 10
seq -f "%03g" 5                  # 001 002 003 004 005
seq -s ", " 5                    # 1, 2, 3, 4, 5
```

## yes — repetir string infinitamente

```bash
yes                              # imprime "y" infinitamente
yes "instalar"                   # imprime "instalar" infinitamente
yes | sudo apt install paquete   # responder "y" a prompts automáticos
```

## sleep — pausar ejecución

```bash
sleep 5                          # pausar 5 segundos
sleep 0.5                        # pausar 500ms
sleep 2m                         # pausar 2 minutos
sleep 1h                         # pausar 1 hora
```

## Casos de uso

```bash
# Crear 100 archivos vacíos
seq -f "file_%03g.txt" 100 | xargs touch

# Loop con pausa
for i in $(seq 1 5); do echo "Paso $i"; sleep 1; done

# Auto-responder a prompt
yes | script-interactivo

# Esperar a que un servicio esté listo
while ! curl -s localhost:3000 > /dev/null; do sleep 1; done
echo "Servicio listo"
```

## Ver también

- [[xargs]] — ejecutar comandos con argumentos
- [[watch]] — ejecutar comando periódicamente
- [[bash-avanzado]] — loops y control de flujo

#comando
