---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: programa
prioridad: media
---

# yq

> Procesador de YAML/JSON/XML/TOML desde línea de comandos. El equivalente a `jq` para YAML. Imprescindible para Kubernetes, Docker Compose y configuraciones modernas.

## Qué es

**yq** es un procesador ligero de archivos de configuración (YAML, JSON, XML, TOML, CSV, TSV) inspirado en `jq`. Permite leer, modificar y escribir estos formatos directamente desde la terminal, sin necesidad de editores o scripts complejos.

## Instalación

```bash
sudo apt install yq                   # Debian / Ubuntu
sudo pacman -S yq                     # Arch / CachyOS
sudo dnf install yq                   # Fedora
# desde binary (recomendado para última versión):
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
  -O /usr/local/bin/yq && sudo chmod +x /usr/local/bin/yq
```

> **Nota:** Asegúrate de usar la versión de **mikefarah/yq** (la más popular). Hay otra versión (`yq` de Andrey Kislyuk) que es más antigua y con menos features.

## Sintaxis

```bash
yq [expresión] archivo.yaml
```

## Ejemplos prácticos

```bash
# Leer un valor
yq '.server.port' config.yaml

# Leer con default si no existe
yq '.server.port // 8080' config.yaml

# Modificar un valor
yq -i '.server.port = 3000' config.yaml

# Añadir una entrada
yq -i '.server.debug = true' config.yaml

# Eliminar una entrada
yq -i 'del(.server.debug)' config.yaml

# Convertir YAML → JSON
yq -o=json config.yaml

# Convertir JSON → YAML
yq -P config.json

# Extraer una lista completa
yq '.services[].name' docker-compose.yaml

# Filtrar elementos de una lista
yq '.services[] | select(.image | contains("nginx"))' docker-compose.yaml

# Fusionar dos archivos YAML
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' base.yaml overlay.yaml

# Extraer solo claves
yq 'keys | .[]' config.yaml

# Verificar si un valor existe
yq -e '.database.host' config.yaml && echo "existe" || echo "no existe"
```

## yq vs jq

| Aspecto | yq | jq |
|---|---|---|
| Formatos | YAML, JSON, XML, TOML, CSV | JSON principal |
| Sintaxis | Similar a jq | JSONPath |
| Kubernetes | Excelente (K8s usa YAML) | No aplica |
| Docker Compose | Editar directamente | Requiere conversión |
| Instalación | Binario estático | Paquete de sistema |

## Uso avanzado

```bash
# Editar docker-compose.yaml: cambiar puerto
yq -i '.services.web.ports[0] = "8080:80"' docker-compose.yaml

# Añadir volumen a un servicio
yq -i '.services.db.volumes += ["/data:/var/lib/postgresql/data"]' docker-compose.yaml

# Kubernetes: ver todos los nombres de pods
kubectl get pods -o yaml | yq '.items[].metadata.name'

# Fusionar override de Helm
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' values.yaml values-dev.yaml

# Extraer todos los hosts de un config
yq '.spec.rules[].host' ingress.yaml

# Verificar si un campo existe (para scripts)
yq -e '.spec.template.spec.containers[0].resources.limits.memory' deployment.yaml
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| "document index required" | Multi-document YAML sin índice | Usar `yq e '.field' file.yaml` o `-n` |
| No modifica el archivo | Falta `-i` (in-place) | Añadir flag `-i` |
| Error con listas anidadas | Sintaxis de indexación | Usar `.[0]` en vez de `.[]` para un elemento |
| XML no parsea | Formato inválido | Verificar que el XML está bien formado |

## Ver también

- [[jq]] — procesador JSON
- [[Docker Compose]] — archivo YAML de Docker
- [[Kubernetes]] — archivos YAML de K8s
- [[Ansible]] — playbooks YAML

## Enlaces externos

- [yq — GitHub](https://github.com/mikefarah/yq)
- [yq documentation](https://mikefarah.gitbook.io/yq/)

#programa #yaml #json #devops
