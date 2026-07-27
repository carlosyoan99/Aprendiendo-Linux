---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# kubectl

## Sintaxis
```bash
kubectl [command] [TYPE] [NAME] [flags]
```

## Descripción

**kubectl** es la interfaz de línea de comandos estándar para interactuar con clústeres de **Kubernetes**. Permite desplegar, inspeccionar, gestionar, escalar y depurar aplicaciones containerizadas en un clúster de Kubernetes. Es la navaja suiza del administrador de Kubernetes — cualquier operación sobre el clúster pasa por kubectl.

Para usar kubectl necesitas un clúster Kubernetes (como minikube, kind, o uno en la nube) y un archivo `~/.kube/config` con los credenciales de acceso.

## Contextos y configuración

```bash
# Ver configuración actual
kubectl config view

# Listar contextos disponibles
kubectl config get-contexts

# Cambiar de contexto (ej: entre dev, staging, prod)
kubectl config use-context mi-cluster-prod

# Ver contexto actual
kubectl config current-context
```

## Tipos de recursos principales

| Tipo | Abreviatura | Descripción |
|---|---|---|
| `pod` | `po` | La unidad mínima desplegable (uno o más contenedores) |
| `deployment` | `deploy` | Controla réplicas de Pods y actualizaciones rolling |
| `service` | `svc` | Expone un conjunto de Pods como servicio de red |
| `namespace` | `ns` | Aísla recursos dentro del clúster |
| `configmap` | `cm` | Configuración desacoplada (variables, archivos) |
| `secret` | — | Datos sensibles (contraseñas, tokens, claves) |
| `ingress` | `ing` | Reglas de enrutamiento HTTP/HTTPS hacia Services |
| `persistentvolumeclaim` | `pvc` | Solicitud de almacenamiento persistente |
| `node` | `no` | Máquina del clúster (worker o master) |
| `namespace` | `ns` | Aísla recursos dentro del clúster |

## Comandos esenciales

```bash
# --- Información y diagnóstico ---
kubectl get pods                    # listar todos los pods
kubectl get pods -o wide            # con IP y nodo
kubectl get pods --all-namespaces   # pods en todos los namespaces
kubectl describe pod mi-pod         # info detallada de un pod
kubectl logs mi-pod                 # ver logs de un pod
kubectl logs -f mi-pod              # seguir logs en tiempo real
kubectl top pod                     # métricas de CPU/memoria por pod
kubectl top node                    # métricas por nodo

# --- Crear y gestionar recursos ---
kubectl create deployment mi-app --image=nginx:alpine
kubectl apply -f deployment.yaml    # crear/actualizar desde archivo
kubectl delete pod mi-pod           # eliminar un pod
kubectl delete -f deployment.yaml   # eliminar desde archivo

# --- Escalar y actualizar ---
kubectl scale deployment mi-app --replicas=5
kubectl set image deployment/mi-app mi-app=nginx:1.25
kubectl rollout status deployment/mi-app
kubectl rollout undo deployment/mi-app   # revertir último cambio

# --- Acceso y depuración ---
kubectl exec -it mi-pod -- /bin/sh        # shell dentro del contenedor
kubectl port-forward pod/mi-pod 8080:80   # reenviar puerto local al pod
kubectl cp archivo.txt mi-pod:/tmp/       # copiar archivo al pod

# --- Namespaces ---
kubectl get namespaces
kubectl create namespace desarrollo
kubectl get pods -n desarrollo
kubectl config set-context --current --namespace=desarrollo
```

## Trabajar con archivos YAML

La forma más común y recomendada de operar Kubernetes es mediante archivos YAML declarativos:

```bash
# Aplicar configuración (crea o actualiza)
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f .                     # aplicar todo un directorio

# Eliminar lo definido en el archivo
kubectl delete -f deployment.yaml

# Ver diferencias entre el YAML y el estado actual
kubectl diff -f deployment.yaml
```

Ejemplo mínimo de `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
```

## Atajos y flags útiles

```bash
# Salida en formatos alternativos
kubectl get pods -o yaml              # salida YAML completa
kubectl get pods -o json              # salida JSON
kubectl get pods -o wide              # columnas adicionales
kubectl get pods -o name              # solo nombres (tipo:nombre)

# Filtrar por etiquetas
kubectl get pods -l app=nginx,env=prod

# Ver eventos del clúster
kubectl get events --sort-by='.lastTimestamp'

# Exponer un deployment como servicio
kubectl expose deployment mi-app --port=80 --target-port=8080 --type=LoadBalancer
```

## Instalación

```bash
# Linux (amd64)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Debian/Ubuntu (desde repositorio oficial)
sudo apt-get update && sudo apt-get install -y kubectl

# Arch Linux
sudo pacman -S kubectl

# Verificar instalación
kubectl version --client
```

## Troubleshooting

| Error | Causa | Solución |
|---|---|---|
| `The connection to the server was refused` | Clúster no corriendo o kubeconfig incorrecto | `kubectl cluster-info`, verificar `~/.kube/config` |
| `error: You must be logged in to the server` | Sesión expirada o sin credenciales | `kubectl config use-context` o re-autenticar |
| `Error from server (NotFound)` | Recurso no existe | Verificar namespace y nombre: `kubectl get pods -n <ns>` |
| `CrashLoopBackOff` | El contenedor arranca y crashea repetidamente | `kubectl logs mi-pod --previous`, revisar configuración |
| `ImagePullBackOff` | No puede descargar la imagen | Verificar nombre de imagen, credenciales del registry |

## Notas y advertencias

- Kubernetes no es una herramienta para el escritorio doméstico — está pensado para clústeres de producción, microservicios y orquestación a escala
- Para aprender localmente: instala **minikube** o **kind** (Kubernetes IN Docker)
- Los archivos YAML deben ser **declarativos** (deseas un estado) no imperativos (ejecutas comandos uno a uno)
- Siempre versiona tus YAMLs en Git — es la base de GitOps

## Enlaces externos

- [Documentación oficial de kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [Repositorio kubectl en GitHub](https://github.com/kubernetes/kubectl)
- [Kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Wikipedia — Kubectl](https://es.wikipedia.org/wiki/Kubectl)
- [Instalar kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

## Ver también

- [[Docker]] — contenedores, la base de Kubernetes
- [[Contenedores]] — concepto general
- [[systemd-nspawn]] — alternativa ligera a contenedores

#comando #kubernetes
