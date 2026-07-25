---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# k9s

> Interfaz TUI para gestionar clústeres Kubernetes. Navega y administra pods, deployments, services, namespaces y recursos personalizados sin escribir `kubectl`.

## Qué es

**k9s** es un cliente Kubernetes interactivo para terminal. Proporciona una vista continua de los recursos del clúster con navegación tipo Vim. Permite ver logs, describir recursos, editar YAML, ejecutar comandos en pods, y seguir cambios en tiempo real — todo sin escribir un solo comando `kubectl`.

Escrito en Go, binario único. Ideal para administradores de K8s que pasan el día mirando el clúster.

## Instalación

```bash
# Debian/Ubuntu (no está en repos oficiales)
# Descargar binario:
curl -sLO https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
tar -xzf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/

# O con Homebrew
brew install derailed/k9s/k9s

# O con Go
go install github.com/derailed/k9s@latest

# Verificar
k9s version
```

## Atajos esenciales

### Navegación global

| Tecla | Acción |
|---|---|
| `q` | Salir / Volver atrás |
| `?` | Ayuda completa |
| `:` | Línea de comandos (como en Vim) |
| `Ctrl+d` | Eliminar recurso (pide confirmación) |
| `Ctrl+f` | Filtrar recursos |
| `Tab` | Cambiar entre columnas |

### Vistas principales

| Comando (desde `:`) | Qué muestra |
|---|---|
| `:pods` | Pods del namespace actual |
| `:deployments` | Deployments |
| `:services` | Services |
| `:nodes` | Nodos del clúster |
| `:namespaces` | Cambiar de namespace |
| `:events` | Eventos del clúster |
| `:configmaps` | ConfigMaps |
| `:secrets` | Secrets |
| `:pv` | PersistentVolumes |
| `:pvc` | PersistentVolumeClaims |

### Acciones sobre recursos

| Desde la vista de pods | |
|---|---|
| `d` | Describir recurso (equivalente a `kubectl describe`) |
| `y` | Ver YAML |
| `l` | Ver logs en vivo (como `kubectl logs -f`) |
| `e` | Editar YAML in-situ |
| `s` | Abrir shell dentro del pod (`kubectl exec -it`) |
| `Ctrl+d` | Eliminar pod (`kubectl delete pod`) |
| `f` | Port-forward |

### Skins (temas)

```bash
# Los temas se configuran en:
# ~/.config/k9s/skins.yml

# Descargar temas populares:
# https://github.com/derailed/k9s/tree/master/skins
# nord, dracula, gruvbox, solarized, etc.
```

## Uso básico

```bash
# k9s necesita un kubeconfig válido
k9s                                  # abre en el namespace por defecto

# Con namespace específico
k9s -n production

# Con contexto específico
k9s --context prod-cluster

# Sin encabezados (más compacto)
k9s --headless

# Salir: q varias veces hasta volver al menú principal
```

## Personalización: `~/.config/k9s/config.yml`

```yaml
k9s:
  liveViewAutoRefresh: false
  noIcons: false
  headless: false
  readOnly: false
  ui:
    skin: nord                      # tema en skins.yml
    defaultMode: status             # full | status
    logo: "${K9S_LOGO:-k9s}"       # icono en la cabecera
  namespace:
    active: all                     # muestra todos los namespaces
    lockFavorites: false
  manualCommand: false
```

## Comparativa

| Aspecto | k9s | kubectl | Lens (GUI) | Octant (GUI) |
|---|---|---|---|---|
| **Curva aprendizaje** | Media | Alta | Baja | Baja |
| **Velocidad** | ⚡ Muy rápida | N/A | Moderada | Lenta |
| **Logs en vivo** | ✅ | ✅ `-f` | ✅ | ✅ |
| **Shell en pod** | ✅ `s` | ✅ `exec -it` | ✅ | ✅ |
| **Editar YAML** | ✅ Integrado | ✅ `edit` | ✅ | ✅ |
| **Port-forward** | ✅ | ✅ Manual | ✅ | ✅ |
| **Múltiples clústers** | ✅ Contextos | ✅ Contextos | ✅ | ❌ |
| **Requiere GPU/RAM** | ❌ ~50 MB | ❌ | ~500 MB | ~300 MB |

> k9s es la herramienta más rápida para el día a día en K8s. Si gestionas clústers con frecuencia, es indispensable.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No se conecta | kubeconfig no configurado | `k9s --kubeconfig ~/.kube/config` |
| Permiso denegado | El contexto no tiene permisos | Revisar con `kubectl auth can-i` |
| Sin pods visibles | Namespace incorrecto | `:namespaces` y seleccionar el correcto |
| Pantalla en blanco | Terminal muy pequeña | k9s requiere mínimo 80×24 |

## Ver también

- [[Kubernetes]] — orquestación de contenedores
- [[lazydocker]] — el equivalente a k9s pero para Docker
- [[Contenedores orquestación]] — Docker Compose, Swarm, K8s
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — derailed/k9s](https://github.com/derailed/k9s)
- [Documentación oficial](https://k9scli.io/)
- [Skins de k9s](https://github.com/derailed/k9s/tree/master/skins)

#programa #tui #kubernetes
