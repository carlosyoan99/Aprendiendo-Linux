---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# fx

> Visor JSON interactivo para terminal. Explora archivos JSON y APIs con navegación por teclado, búsqueda, expansión/colapso y resaltado de sintaxis.

## Qué es

**fx** (Function eXecution) es un visor JSON interactivo para terminal. Permite explorar estructuras JSON navegando con flechas, expandiendo/colapsando objetos, buscando texto, y viendo el path de cada nodo. Ideal para trabajar con APIs REST, archivos de configuración JSON y logs estructurados.

Escrito en Go, binario único. No necesita Node.js (aunque se instala vía npm).

## Instalación

```bash
# Desde GitHub (binario estático - recomendado)
curl -sL https://github.com/antonmedv/fx/releases/latest/download/fx_linux_amd64 -o fx
chmod +x fx
sudo mv fx /usr/local/bin/

# Con npm (alternativa, necesita Node.js)
npm install -g fx

# Con Go
go install github.com/antonmedv/fx@latest
```

## Uso básico

```bash
# Abrir archivo JSON
fx data.json

# Pipe desde otro comando
curl -s https://api.github.com/users/octocat | fx
cat data.json | fx

# Desde stdin
echo '{"name": "John", "age": 30}' | fx
```

## Atajos esenciales

| Tecla | Acción |
|---|---|
| `Flechas` | Navegar entre nodos |
| `Enter` | Expandir/colapsar objeto o array |
| `Espacio` | Expandir todos los hijos |
| `Tab` | Siguiente nodo expandible |
| `/` | Buscar texto dentro del JSON |
| `n` | Siguiente resultado de búsqueda |
| `N` | Resultado anterior |
| `q` | Salir |
| `Esc` | Cerrar búsqueda / panel |
| `g` | Ir al principio |
| `G` | Ir al final |
| `Ctrl+c` | Copiar valor al portapapeles |
| `Ctrl+p` | Mostrar path completo del nodo actual |

## Características destacadas

### Navegación por path

```bash
# fx muestra el path completo del nodo seleccionado en la parte inferior
# Ejemplo: .store.book[0].title

# Útil para construir queries de jq:
# Mientras navegas, fx te muestra el path → lo copias a jq
```

### Búsqueda interactiva

```bash
# Presionar / para abrir la búsqueda
# Escribir texto para filtrar nodos
# n/N para siguiente/anterior
# Resalta las coincidencias en amarillo
```

### Colores por tipo

| Tipo | Color |
|---|---|
| String | Verde |
| Number | Rojo |
| Boolean | Azul |
| Null | Gris |
| Key | Blanco |

## Casos de uso

```bash
# Explorar respuesta de API
curl -s https://api.github.com/repos/curl/curl | fx

# Ver configuración de npm
cat package.json | fx

# Analizar logs JSON
tail -f app.log | fx

# Pipe con jq para pre-procesar
cat data.json | jq '.users[] | {name, email}' | fx

# Ver variables de entorno como JSON
# (no hay --env, pero se puede hacer:)
node -e "console.log(JSON.stringify(process.env))" | fx
```

## Comparativa

| Aspecto | fx | jq | bat | less |
|---|---|---|---|---|
| **Interactivo** | ✅ Navegación con flechas | ❌ Filtros declarativos | ❌ | ❌ |
| **Expandir/colapsar** | ✅ | ❌ | ❌ | ❌ |
| **Path del nodo** | ✅ Muestra el path | ❌ | ❌ | ❌ |
| **Transformar datos** | ❌ | ✅ Filtros potentes | ❌ | ❌ |
| **Pipe friendly** | ✅ | ✅ | ✅ | ✅ |
| **Ideal para** | Explorar JSON | Procesar JSON | Ver archivos | Paginar |

> `fx` es para **explorar** JSON interactivamente. `jq` es para **procesar** JSON en scripts. Se complementan: `cat data.json | jq '.users' | fx`.

## Ver también

- [[jq]] — procesador JSON de terminal (para scripts y filtros)
- [[cat]] — mostrar archivos raw
- [[less]] — paginador clásico
- [[bat]] — cat moderno con syntax highlighting
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — antonmedv/fx](https://github.com/antonmedv/fx)

#programa #tui #json
