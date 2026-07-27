---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: alta
---

# Kubernetes (K8s)

> Orquestador de contenedores de código abierto. Creado por **Google** (basado en su sistema interno Borg) y donado a la CNCF en 2015. Automatiza el despliegue, escalado y operación de aplicaciones containerizadas en clústeres de máquinas.

## Qué es

Kubernetes (K8s) es una plataforma para **orquestar contenedores** a escala de producción. A diferencia de Docker (que gestiona contenedores individuales), Kubernetes gestiona **clústeres completos** de máquinas y decide dónde ejecutar cada contenedor, cómo conectarlos, cómo escalarlos y cómo recuperarse de fallos.

**El principio fundamental:** declaras el **estado deseado** de tu aplicación (3 réplicas, puerto 80, imagen nginx:alpine) y Kubernetes se encarga de que el **estado actual** coincida siempre — aunque un nodo falle, una réplica se caiga, o necesites escalar.

```yaml
# Esto es todo lo que necesita Kubernetes para ejecutar nginx en 3 réplicas
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
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

```bash
kubectl apply -f nginx.yaml    # Kubernetes crea 3 pods, los monitorea, los mantiene
```

---

## Arquitectura

Un clúster Kubernetes tiene dos partes: el **plano de control** (control plane) y los **nodos trabajadores** (worker nodes).

```
┌─────────────────────────────────────────────────────┐
│                  CONTROL PLANE                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │  API     │  │  etcd    │  │  Scheduler       │  │
│  │  Server  │◄─┤ (KV DB)  │  │  (asigna pods a  │  │
│  │          │  │          │  │   nodos)          │  │
│  └────┬─────┘  └──────────┘  └──────────────────┘  │
│       │                                              │
│  ┌────▼─────┐  ┌──────────────────┐                  │
│  │Controller │  │ Cloud Controller │                  │
│  │  Manager  │  │    Manager       │                  │
│  └──────────┘  └──────────────────┘                  │
└──────────────────────┬──────────────────────────────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│   WORKER NODE 1 │ │   WORKER NODE 2 │ │   WORKER NODE 3 │
│ ┌───────────┐  │ │ ┌───────────┐  │ │ ┌───────────┐  │
│ │  kubelet  │  │ │ │  kubelet  │  │ │ │  kubelet  │  │
│ │  kube-proxy│ │ │ │  kube-proxy│ │ │ │  kube-proxy│ │
│ │  Pods...  │  │ │ │  Pods...  │  │ │ │  Pods...  │  │
│ └───────────┘  │ │ └───────────┘  │ │ └───────────┘  │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

### Plano de control (Control Plane)

| Componente | Función |
|---|---|
| **kube-apiserver** | Puerta de entrada al clúster. Todas las comunicaciones (kubectl, dashboards, otros componentes) pasan por aquí. Expone la API REST de Kubernetes |
| **etcd** | Base de datos clave-valor **consistente y distribuida**. Almacena todo el estado del clúster (qué pods, dónde, qué servicios, etc.). Es el "source of truth" |
| **kube-scheduler** | Decide en qué nodo ejecutar cada nuevo pod. Considera recursos disponibles, restricciones (affinity/taints), y políticas |
| **kube-controller-manager** | Ejecuta los **controladores** (loops que reconcilian estado actual con estado deseado): Node Controller, Replication Controller, Endpoint Controller, etc. |
| **cloud-controller-manager** | Interactúa con el proveedor cloud (AWS, GCP, Azure) para crear load balancers, volúmenes, nodos, etc. |

### Nodos trabajadores (Worker Nodes)

| Componente | Función |
|---|---|
| **kubelet** | El agente que corre en **cada nodo**. Se asegura de que los pods asignados a ese nodo estén ejecutándose y saludables. Se comunica con el API server |
| **kube-proxy** | Mantiene las reglas de red en cada nodo. Implementa Services (ClusterIP, NodePort, LoadBalancer) gestionando iptables/IPVS |
| **Container runtime** | El software que ejecuta los contenedores (containerd, CRI-O, o Docker como runtime a través de cri-dockerd) |

---

## Objetos fundamentales

### Pod — La unidad mínima

Un **Pod** es la unidad más pequeña y básica en Kubernetes. Representa una **instancia en ejecución** de un proceso en el clúster.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mi-pod
  labels:
    app: mi-app
    env: dev
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
  - name: sidecar
    image: alpine
    command: ["sh", "-c", "tail -f /dev/null"]
```

**Características clave de un Pod:**

| Característica | Descripción |
|---|---|
| **IP única** | Cada pod tiene su propia IP dentro del clúster |
| **Uno o varios contenedores** | Contenedores en el mismo pod comparten red (localhost) y almacenamiento (volúmenes) |
| **Patrón sidecar** | Contenedor auxiliar (logger, proxy, sync) que acompaña al principal |
| **Efímero** | Los pods no se reparan — si uno muere, el Deployment crea otro nuevo con nueva IP |
| **Atomicidad** | O todos los contenedores del pod arrancan, o ninguno |

> **⚠️ No crees pods directamente.** Usa Deployments, StatefulSets o DaemonSets. Los pods directos no se recuperan si fallan.

### Deployment — Aplicaciones stateless

Un **Deployment** gestiona **ReplicaSets**, que a su vez gestionan pods. Es la forma correcta de ejecutar aplicaciones stateless (api REST, frontend, workers):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mi-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mi-api
  template:
    metadata:
      labels:
        app: mi-api
    spec:
      containers:
      - name: api
        image: mi-api:1.2.3
        ports:
        - containerPort: 3000
        resources:
          requests:
            cpu: "250m"       # 0.25 CPU
            memory: "128Mi"
          limits:
            cpu: "500m"
            memory: "256Mi"
```

#### Rolling updates

```bash
# Actualizar imagen
kubectl set image deployment/mi-api api=mi-api:1.3.0

# Estrategias de actualización
kubectl edit deployment mi-api
# spec.strategy.type: RollingUpdate (default) | Recreate
# spec.strategy.rollingUpdate:
#   maxUnavailable: 25%   # pods que pueden estar caídos durante update
#   maxSurge: 25%         # pods extra permitidos durante update

# Gestionar rollout
kubectl rollout status deployment/mi-api
kubectl rollout history deployment/mi-api        # historial de revisiones
kubectl rollout undo deployment/mi-api           # revertir al anterior
kubectl rollout undo deployment/mi-api --to-revision=2  # revertir a revisión 2
```

#### Estrategias de actualización

| Estrategia | Descripción | Cuándo usarla |
|---|---|---|
| **RollingUpdate** (default) | Reemplaza pods gradualmente (maxUnavailable/maxSurge) | La mayoría de casos |
| **Recreate** | Mata todos los pods, luego crea los nuevos | Apps que no soportan dos versiones simultáneas (bases de datos) |

### Service — Red estable para pods

Un **Service** es una abstracción que define una política de acceso a un conjunto de pods. Como los pods son efímeros (cambian de IP), el Service proporciona una **IP y nombre DNS estables**.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mi-api-svc
spec:
  selector:
    app: mi-api              # enruta tráfico a pods con label app=mi-api
  ports:
  - port: 80                 # puerto del Service
    targetPort: 3000         # puerto del contenedor
  type: ClusterIP
```

#### Tipos de Service

| Tipo | Accesible desde | Caso de uso |
|---|---|---|
| **ClusterIP** (default) | Dentro del clúster solo | Comunicación entre servicios internos |
| **NodePort** | `NodeIP:Puerto` (externo) | Desarrollo, debugging, acceso directo |
| **LoadBalancer** | IP pública (cloud) | Exponer al mundo (crea un LB cloud) |
| **ExternalName** | DNS externo | Proxy a servicios fuera del clúster |

```yaml
# NodePort: expone en cada nodo un puerto (30000-32767)
apiVersion: v1
kind: Service
metadata:
  name: mi-api-nodeport
spec:
  type: NodePort
  selector:
    app: mi-api
  ports:
  - port: 80
    targetPort: 3000
    nodePort: 30080           # opcional; si no se asigna uno aleatorio
```

```yaml
# LoadBalancer: crea un balanceador en el cloud
apiVersion: v1
kind: Service
metadata:
  name: mi-api-lb
spec:
  type: LoadBalancer
  selector:
    app: mi-api
  ports:
  - port: 80
    targetPort: 3000
```

### Descubrimiento de servicios interno

Kubernetes asigna un nombre DNS a cada Service: `<nombre>.<namespace>.svc.cluster.local`. Los pods pueden comunicarse entre sí usando solo el nombre del Service:

```bash
# Desde cualquier pod del namespace default:
curl http://mi-api-svc                # resuelve a la IP del Service
                                     # balancea entre los pods del selector
```

### Ingress — Enrutamiento HTTP/HTTPS

**Ingress** expone servicios HTTP/HTTPS fuera del clúster con enrutamiento basado en host/ruta. Requiere un **Ingress Controller** (nginx-ingress, traefik, haproxy):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mi-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: api.midominio.com
    http:
      paths:
      - path: /v1
        pathType: Prefix
        backend:
          service:
            name: mi-api-v1
            port:
              number: 80
      - path: /v2
        pathType: Prefix
        backend:
          service:
            name: mi-api-v2
            port:
              number: 80
  - host: frontend.midominio.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-svc
            port:
              number: 80
```

```bash
# Instalar Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

**Service vs Ingress: ¿cuándo usar cada uno?**

| Situación | Usa |
|---|---|
| Comunicación interna entre servicios | Service ClusterIP |
| Exponer un solo servicio al exterior | Service LoadBalancer |
| Varios servicios bajo el mismo dominio | Ingress (enruta por host/ruta) |
| SSL/TLS termination | Ingress (con certificados) |

---

## Namespaces — Aislamiento lógico

Los **Namespaces** dividen un clúster en entornos virtuales. No aíslan a nivel de red (pods de distintos namespaces pueden comunicarse), pero sí a nivel de organización:

```bash
kubectl get namespaces
kubectl create namespace desarrollo
kubectl create namespace produccion

# Trabajar en un namespace específico
kubectl get pods -n desarrollo
kubectl config set-context --current --namespace=desarrollo

# Namespaces por defecto
kubectl get pods --all-namespaces        # ver todo el clúster
```

| Namespace predefinido | Propósito |
|---|---|
| `default` | Recursos sin namespace explícito |
| `kube-system` | Componentes del sistema (CoreDNS, kube-proxy, dashboard) |
| `kube-public` | Recursos legibles por todos los usuarios |
| `kube-node-lease` | Heartbeats de nodos (lease objects) |

---

## ConfigMap y Secret — Configuración

### ConfigMap — Configuración no sensible

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mi-config
data:
  APP_ENV: production
  LOG_LEVEL: info
  app.properties: |
    key1=value1
    key2=value2
```

```bash
# Crear desde archivo
kubectl create configmap mi-config --from-file=config.properties
kubectl create configmap mi-config --from-env-file=.env

# Usar en un pod
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: mi-pod
spec:
  containers:
  - name: app
    image: alpine
    env:
    - name: APP_ENV
      valueFrom:
        configMapKeyRef:
          name: mi-config
          key: APP_ENV
    volumeMounts:
    - name: config
      mountPath: /etc/config
  volumes:
  - name: config
    configMap:
      name: mi-config
EOF
```

### Secret — Configuración sensible

Los Secrets son similares a ConfigMaps pero sus valores van **base64** (no es cifrado real — solo ofuscación):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mi-secreto
type: Opaque
data:
  DB_PASSWORD: c3VwZXJzZWNyZXQ=          # base64 de "supersecret"
```

```bash
# Crear secret desde literal
kubectl create secret generic db-credentials \
  --from-literal=DB_USER=admin \
  --from-literal=DB_PASSWORD=supersecret

# Usar como variable de entorno
# spec.containers[].env:
# - name: DB_PASSWORD
#   valueFrom:
#     secretKeyRef:
#       name: db-credentials
#       key: DB_PASSWORD

# Ver secret (oculta el valor)
kubectl get secret db-credentials -o yaml
# Ver el valor decodificado:
kubectl get secret db-credentials -o jsonpath="{.data.DB_PASSWORD}" | base64 -d
```

**⚠️ Los Secrets no son seguros por defecto.** El base64 no es cifrado. Para seguridad real:
- Usa **Sealed Secrets** (Bitnami) que cifra los secrets con una clave del operador
- Usa **External Secrets Operator** para traer secrets de HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager
- Habilita **encryption at rest** en etcd

---

## StatefulSet — Aplicaciones con estado

Un **StatefulSet** es como un Deployment pero para apps **con estado** (bases de datos, colas, sistemas que necesitan identidad estable):

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres      # necesario para DNS estable
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:16
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:      # cada réplica tiene su propio PVC
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

**Diferencias clave con Deployment:**

| Característica | Deployment | StatefulSet |
|---|---|---|
| **Identidad** | Pods anónimos (nginx-7d8f9a) | Nombres estables (postgres-0, postgres-1, postgres-2) |
| **Almacenamiento** | Comparten un volumen (o ninguno) | Cada pod tiene su propio PVC persistente |
| **Orden** | Todos a la vez | Arranca en orden: 0, 1, 2... Muere en orden inverso |
| **DNS** | No hay garantía | `postgres-0.postgres.svc.cluster.local` |
| **Escalado** | Inmediato | Secuencial (el 3 espera al 2) |

---

## DaemonSet — Un pod por nodo

Un **DaemonSet** garantiza que **todos los nodos** (o un subconjunto) ejecuten una copia de un pod. Se usa para:

- **Agentes de logging**: fluentd, logstash (envían logs al exterior)
- **Monitoreo**: node_exporter, Prometheus Node Exporter, Datadog agent
- **Red**: CNI plugins (Calico, Cilium, Weave)
- **Almacenamiento**: CSI drivers (glusterfs, ceph)

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
spec:
  selector:
    matchLabels:
      name: fluentd
  template:
    metadata:
      labels:
        name: fluentd
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd:v1.16
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: dockerlogs
          mountPath: /var/lib/docker/containers
      tolerations:            # también se ejecuta en el control plane
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: dockerlogs
        hostPath:
          path: /var/lib/docker/containers
```

---

## Jobs y CronJobs — Tareas

### Job — Tarea única

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: backup-db
spec:
  parallelism: 1
  completions: 1
  template:
    spec:
      containers:
      - name: backup
        image: alpine
        command: ["sh", "-c", "pg_dump -h postgres -U admin mi_db > /backup/db.sql"]
      restartPolicy: Never    # OnFailure o Never (¡no Always!)
```

### CronJob — Tarea programada

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-diario
spec:
  schedule: "0 3 * * *"        # cron: 3 AM todos los días
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: alpine
            command: ["sh", "-c", "pg_dump ..."]
          restartPolicy: OnFailure
```

```bash
# Ver jobs
kubectl get jobs
kubectl get cronjobs

# Crear job manualmente
kubectl create job --from=cronjob/backup-diario backup-manual
```

| Recurso | Cuándo usarlo |
|---|---|
| **Job** | Tarea que se ejecuta una vez y termina (backup, migración, importación) |
| **CronJob** | Job que se ejecuta en un horario (limpieza nocturna, reportes periódicos) |

---

## Helm — El gestor de paquetes de Kubernetes

**Helm** es el equivalente a `apt`/`pacman` para Kubernetes. Empaqueta configuraciones YAML completas en **charts** que se instalan con un solo comando:

```bash
# Instalar Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Buscar charts
helm search hub nginx-ingress

# Añadir repositorio
helm repo add bitnami https://charts.bitnami.com/bitnami

# Instalar un chart (crea todo: Deployment, Service, PVC, Secrets...)
helm install mi-postgres bitnami/postgresql \
  --set auth.username=admin \
  --set auth.password=secret

# Ver releases instalados
helm list

# Actualizar
helm upgrade mi-postgres bitnami/postgresql --version 15.x

# Rollback
helm rollback mi-postgres 1

# Eliminar
helm uninstall mi-postgres
```

```bash
# Estructura típica de un chart Helm
mi-chart/
├── Chart.yaml          # metadatos (nombre, versión, dependencias)
├── values.yaml         # valores por defecto (override con --set o -f)
├── templates/          # templates Go + YAML
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── _helpers.tpl    # funciones auxiliares reutilizables
│   └── NOTES.txt       # instrucciones post-instalación
└── charts/             # dependencias (sub-charts)
```

> **Alternativas a Helm**: **Kustomize** (integrado en kubectl, sin templates, solo YAML puro con overlays) y **jsonnet** (lenguaje de config).

---

## RBAC — Control de acceso

Kubernetes tiene un sistema de **Role-Based Access Control (RBAC)** para gestionar permisos:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: mi-app-sa
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: default
  name: mi-app-pod-reader
subjects:
- kind: ServiceAccount
  name: mi-app-sa
  namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

```bash
# Ver permisos actuales
kubectl auth can-i create deployments
kubectl auth can-i delete pods --as system:serviceaccount:default:mi-app-sa
```

| Recurso | Ámbito | Descripción |
|---|---|---|
| **Role** | Namespace | Permisos dentro de un namespace específico |
| **ClusterRole** | Clúster | Permisos globales (nodos, PVs, cluster-wide resources) |
| **RoleBinding** | Namespace | Asigna un Role a usuarios/ServiceAccounts en un namespace |
| **ClusterRoleBinding** | Clúster | Asigna un ClusterRole a usuarios/ServiceAccounts globalmente |

> Por defecto, los ServiceAccounts tienen pocos permisos. Para que una app pueda listar pods o acceder a la API de Kubernetes, necesitas RBAC explícito.

---

## Volúmenes en Pods

Antes de llegar a PV/PVC, hay tipos de volumen básicos que se montan directamente en los pods:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mi-pod-con-volumenes
spec:
  containers:
  - name: app
    image: alpine
    volumeMounts:
    - name: temp        # efímero: desaparece con el pod
      mountPath: /tmp/cache
    - name: config      # monta un ConfigMap como archivos
      mountPath: /etc/config
    - name: secreto     # monta un Secret como archivos
      mountPath: /etc/credentials
      readOnly: true
    - name: host-log    # accede al sistema de archivos del nodo
      mountPath: /var/log/host
  volumes:
  - name: temp
    emptyDir: {}                # directorio temporal, mismo ciclo que el pod
  - name: config
    configMap:
      name: mi-config
  - name: secreto
    secret:
      secretName: db-credentials
  - name: host-log
    hostPath:                   # monta ruta del nodo (cuidado: acceso al host)
      path: /var/log
      type: Directory
```

| Tipo de volumen | Persistencia | Caso de uso |
|---|---|---|
| **emptyDir** | Efímero (vive con el pod) | Cache, archivos temporales, sidecars que comparten datos |
| **configMap** | Configurable | Montar config como archivos |
| **secret** | Configurable | Montar credenciales como archivos |
| **hostPath** | Persiste en el nodo | Logs del sistema, acceso al socket Docker |
| **PersistentVolumeClaim** | Persistente (independiente del pod) | Bases de datos, almacenamiento duradero |

---

## Almacenamiento persistente: PV, PVC, StorageClass

### PersistentVolume (PV) — Recurso de almacenamiento

Un PV es un recurso de almacenamiento en el clúster (como un nodo es un recurso de cómputo):

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-local
spec:
  capacity:
    storage: 10Gi
  accessModes:
  - ReadWriteOnce            # un solo pod puede montarlo RW
  hostPath:                  # solo para desarrollo local
    path: /mnt/data
```

### PersistentVolumeClaim (PVC) — Solicitud del usuario

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mi-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi          # reclama 8 GB del PV
```

### StorageClass — Provisión dinámica

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/gce-pd   # o ebs.csi.aws.com, disk.csi.azure.com
parameters:
  type: pd-ssd
```

```yaml
# PVC que usa StorageClass para aprovisionamiento dinámico
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mi-pvc-ssd
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: fast              # usa la StorageClass "fast"
  resources:
    requests:
      storage: 50Gi
```

| Access Mode | Significado |
|---|---|
| **ReadWriteOnce (RWO)** | Un solo nodo puede montarlo RW |
| **ReadOnlyMany (ROX)** | Muchos nodos pueden montarlo RO |
| **ReadWriteMany (RWX)** | Muchos nodos pueden montarlo RW (NFS, CephFS) |

---

## Health checks: Probes

Kubernetes usa **sondas** (probes) para determinar el estado de los contenedores:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mi-api
spec:
  containers:
  - name: api
    image: mi-api:latest
    ports:
    - containerPort: 8080
    livenessProbe:              # ¿está vivo el proceso?
      httpGet:
        path: /healthz
        port: 8080
      initialDelaySeconds: 5   # esperar 5s antes de la primera sonda
      periodSeconds: 10        # ejecutar cada 10s
      timeoutSeconds: 3        # considerar fallo si no responde en 3s
      failureThreshold: 3      # 3 fallos seguidos = reiniciar
    readinessProbe:            # ¿está listo para recibir tráfico?
      httpGet:
        path: /ready
        port: 8080
      initialDelaySeconds: 3
      periodSeconds: 5
    startupProbe:              # ¿arrancó el proceso? (apps lentas)
      httpGet:
        path: /startup
        port: 8080
      initialDelaySeconds: 1
      periodSeconds: 2
      failureThreshold: 30     # hasta 60s de gracia (30 intentos × 2s)
```

| Probe | Propósito | Si falla |
|---|---|---|
| **Liveness** | ¿El contenedor sigue vivo? | Reinicia el contenedor |
| **Readiness** | ¿Está listo para recibir tráfico? | Lo quita del Service |
| **Startup** | ¿Terminó de inicializar? | Desactiva liveness/readiness hasta que termine |

**Tipos de probe:**
```yaml
# HTTP (más común)
livenessProbe:
  httpGet:
    path: /health
    port: 8080

# TCP (para servicios que no hablan HTTP)
livenessProbe:
  tcpSocket:
    port: 5432               # PostgreSQL

# Exec (ejecuta comando dentro del contenedor)
livenessProbe:
  exec:
    command:
    - pg_isready
    - -h
    - localhost
```

---

## Recursos: Requests y Limits

Cada contenedor puede declarar cuánto CPU/memoria **solicita** (request) y cuánto **puede consumir como máximo** (limit):

```yaml
resources:
  requests:           # reserva garantizada para el contenedor
    cpu: "250m"       # 0.25 núcleos de CPU (250 millicores)
    memory: "128Mi"   # 128 mebibytes
  limits:             # máximo que puede consumir
    cpu: "500m"       # puede usar hasta 0.5 núcleos (si hay disponibles)
    memory: "256Mi"   # si excede, el pod puede ser terminado (OOMKilled)
```

| Escenario | Request | Limit | Comportamiento |
|---|---|---|---|
| Solo request | 250m | — | Garantiza 0.25 CPU, puede usar más si sobra |
| Request < Limit | 250m | 500m | Garantiza 0.25, puede usar hasta 0.5 |
| Request = Limit | 500m | 500m | Quality of Service: **Guaranteed** |
| Sin nada | — | — | QoS: **BestEffort** (prioridad más baja si hay presión) |

### Quality of Service (QoS) Classes

| Clase | Condición | Prioridad en OOM |
|---|---|---|
| **Guaranteed** | `limits.cpu == requests.cpu` y `limits.memory == requests.memory` en **todos** los contenedores | ❌ Último en morir |
| **Burstable** | Al menos un contenedor con request < limit (o solo request) | ⚠️ Medio |
| **BestEffort** | Sin requests ni limits en ningún contenedor | 🔴 Primero en morir |

---

## Labels y Selectors

Las **labels** son pares clave/valor que identifican recursos. Los **selectors** filtran recursos por labels:

```yaml
# Labels en un pod
metadata:
  labels:
    app: mi-api
    version: v2
    environment: production
    tier: backend
    track: stable
```

```bash
# Filtrar por labels
kubectl get pods -l app=mi-api
kubectl get pods -l 'environment=production,version=v2'
kubectl get pods -l 'environment=production,!version=v1'

# Selectors en Services y Deployments
selector:
  matchLabels:
    app: mi-api
    tier: backend
```

**Convenciones de labels** (recomendado por Kubernetes):

| Label | Ejemplo | Propósito |
|---|---|---|
| `app.kubernetes.io/name` | `mi-api` | Nombre de la aplicación |
| `app.kubernetes.io/component` | `frontend`, `backend` | Componente |
| `app.kubernetes.io/part-of` | `mi-sistema` | Sistema al que pertenece |
| `app.kubernetes.io/managed-by` | `helm`, `kustomize` | Herramienta que lo gestiona |
| `app.kubernetes.io/environment` | `production`, `staging` | Entorno |

---

## HorizontalPodAutoscaler (HPA)

Escala automáticamente el número de réplicas basándose en métricas:

```bash
# HPA por CPU
kubectl autoscale deployment mi-api --min=2 --max=10 --cpu-percent=70
```

```yaml
# HPA declarativo
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: mi-api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: mi-api
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  - type: Pods
    pods:
      metric:
        name: requests_per_second
      target:
        type: AverageValue
        averageValue: 1000
```

```bash
# Ver estado del HPA
kubectl get hpa -w                 # watch: ver escalado en tiempo real
kubectl describe hpa mi-api-hpa    # eventos de escalado
```

---

## Networking en Kubernetes

### Modelo de red

Kubernetes asume un modelo de red plano donde:

- **Cada pod tiene su propia IP** (única en el clúster)
- **Los pods pueden comunicarse con cualquier otro pod** sin NAT
- **Los nodos pueden comunicarse con todos los pods** sin NAT
- **El agente dentro del pod ve su IP como la suya propia**

Este modelo lo implementa un **CNI plugin** (Container Network Interface):

| Plugin | Características |
|---|---|
| **Calico** | NetworkPolicy, BGP, rendimiento, más usado en producción |
| **Cilium** | eBPF, muy rápido, NetworkPolicy avanzado, service mesh integrado |
| **Flannel** | Simple, overlay VXLAN, no soporta NetworkPolicy |
| **Weave** | Mesh, cifrado, fácil de configurar |

### NetworkPolicy

Las NetworkPolicies controlan el tráfico entre pods (firewall interno):

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-policy
spec:
  podSelector:
    matchLabels:
      app: mi-api
  policyTypes:
  - Ingress
  - Egress
  ingress:                       # tráfico entrante a los pods app=mi-api
  - from:
    - podSelector:
        matchLabels:
          app: frontend          # solo frontend puede llamar a la API
    - namespaceSelector:
        matchLabels:
          name: monitoring       # Prometheus puede scrape
    ports:
    - port: 3000
  egress:                        # tráfico saliente desde los pods app=mi-api
  - to:
    - podSelector:
        matchLabels:
          app: postgres          # la API solo puede hablar con postgres
    ports:
    - port: 5432
```

> ⚠️ **Solo funciona si el CNI plugin soporta NetworkPolicy** (Calico, Cilium, Weave). Flannel no.

---

## Nodos: Taints, Tolerations y Node Affinity

Controlan **dónde** se ejecutan los pods:

### Taints y Tolerations — Restricciones desde el nodo

```bash
# Añadir taint a un nodo (no programar pods aquí a menos que toleren)
kubectl taint nodes nodo1 gpu-only=true:NoSchedule

# Taints comunes
# node.kubernetes.io/unschedulable: nodo drenado
# node.kubernetes.io/unreachable: nodo no accesible
# node.role.kubernetes.io/control-plane: nodo del control plane
```

```yaml
# Pod que tolera el taint
spec:
  tolerations:
  - key: "gpu-only"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
```

### Node Affinity — Preferencias desde el pod

```yaml
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:  # obligatorio
        nodeSelectorTerms:
        - matchExpressions:
          - key: topology.kubernetes.io/zone
            operator: In
            values:
            - us-east-1a
      preferredDuringSchedulingIgnoredDuringExecution:  # opcional
      - weight: 100
        preference:
          matchExpressions:
          - key: disk-type
            operator: In
            values:
            - ssd
```

| Efecto | Significado |
|---|---|
| **NoSchedule** | No programar pods que no toleren el taint |
| **PreferNoSchedule** | Intentar no programar, pero no es obligatorio |
| **NoExecute** | Expulsar pods existentes que no toleren el taint |

---

## Resumen visual de objetos

```
Deployment                     Service (ClusterIP)
    │                               │
    │  gestiona                     │  balancea a
    ▼                               ▼
ReplicaSet ───► Pod ◄──► Pod ◄──► Pod ◄──► Pod
                  ▲        ▲        ▲        ▲
                  │        │        │        │
                 PVC      PVC      PVC      PVC
                 (volumen persistente por pod si es StatefulSet)

Ingress ──► Service ──► Pods
(NodePort/LB)

HPA ──► Deployment (escala réplicas según métricas)
```

---

## Comparativa: Kubernetes vs alternativas

| Aspecto | Kubernetes | Docker Swarm | Nomad (HashiCorp) |
|---|---|---|---|
| **Madurez** | Alta (estándar industria) | Media (menos features) | Alta |
| **Complejidad** | Muy alta | Baja | Media |
| **Alta disponibilidad** | Nativa (etcd, HA) | Necesita config extra | Nativa |
| **Autoescalado** | HPA (métricas CPU/mem/custom) | No nativo | Sí |
| **Service Mesh** | Istio, Linkerd, Cilium | No | Consul Connect |
| **Multi-cloud** | Sí | Sí | Sí |
| **Cluster management** | kOps, EKS, GKE, AKS | Swarm mode | Nomad Cloud |
| **Aprendizaje** | Curva muy pronunciada | Curva baja | Curva media |

---

## Dónde aprender Kubernetes localmente

```bash
# 1. Minikube (máquina virtual, más aislado)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --cpus=4 --memory=8G
minikube dashboard                         # UI web

# 2. Kind (Kubernetes IN Docker, más rápido)
#   Cada nodo es un contenedor Docker
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind create cluster --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF

# 3. K3s (Kubernetes ligero, ideal para edge/Raspberry Pi)
curl -sfL https://get.k3s.io | sh -
kubectl get nodes                          # K3s ya viene con kubectl
```

---

## Troubleshooting común

| Problema | Causa | Solución |
|---|---|---|
| `CrashLoopBackOff` | El contenedor arranca y crashea | `kubectl logs <pod> --previous`, revisar config/app |
| `ImagePullBackOff` | No puede descargar la imagen | Verificar nombre de imagen, `docker pull` local, credenciales del registry |
| `Pending` (pod no arranca) | Sin recursos suficientes | `kubectl describe pod <pod>` → eventos; verificar CPU/memoria de nodos |
| `ContainerCreating` (atascado) | Problema con volume mount o red | `kubectl describe pod <pod>`, verificar PVC/PV existen |
| `NodeNotReady` | Nodo caído o kubelet no responde | `kubectl get nodes`, `systemctl status kubelet` en el nodo |
| `OutOfDisk` o `DiskPressure` | Disco del nodo lleno | Limpiar imágenes no usadas: `docker image prune -a` en el nodo |
| Service no responde | Selector no coincide con labels | `kubectl describe svc <svc>` → Endpoints vacíos = selector incorrecto |
| Ingress no enruta | Ingress Controller no instalado | Verificar `kubectl get pods -n ingress-nginx` |
| HPA no escala | Metrics Server no instalado | `kubectl top pods` debe funcionar; instalar Metrics Server |
| `kubectl exec` no funciona | Pod en CrashLoopBackOff | No se puede exec en un pod que no está running. Para ver logs incluso cuando crasheó: `kubectl logs <pod> --previous` |

---

## Custom Resource Definitions (CRDs) y Operators

Kubernetes es **extensible** — puedes añadir tus propios tipos de recursos mediante CRDs. Un **Operator** es un controlador personalizado que gestiona un recurso CRD automatizando tareas operativas:

```yaml
# Ejemplo: un CRD que define un cluster de PostgreSQL personalizado
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: postgresclusters.postgresql.example.com
spec:
  group: postgresql.example.com
  names:
    kind: PostgresCluster
    plural: postgresclusters
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              replicas:
                type: integer
              version:
                type: string
```

```bash
# Una vez instalado el CRD + Operator:
kubectl apply -f - <<EOF
apiVersion: postgresql.example.com/v1
kind: PostgresCluster
metadata:
  name: mi-cluster
spec:
  replicas: 3
  version: "16"
EOF

# El Operator (un pod con lógica Go/Python) detecta el CRD y crea
# automáticamente StatefulSet, Services, PVCs, Secrets...
```

**Ejemplos de Operators conocidos:**
- **Prometheus Operator**: gestiona Prometheus, Alertmanager, ServiceMonitors
- **Cert-Manager**: emite y renueva certificados SSL automáticamente
- **Postgres Operator** (Crunchy, Zalando): crea y gestiona clusters PostgreSQL
- **Kafka Operator** (Strimzi): despliega y opera clusters Kafka

> CRDs y Operators son lo que diferencia a Kubernetes de un simple orquestador: convierten el conocimiento operativo en código, automatizando tareas que antes requerían un administrador de sistemas dedicado.

---

## Por qué importa

Kubernetes se ha convertido en el **sistema operativo de la nube**. Entender sus conceptos es esencial porque:

- **Es el estándar**: AWS (EKS), GCP (GKE), Azure (AKS), DigitalOcean (DOKS), y on-prem (kubeadm, OpenShift) todos usan Kubernetes
- **Portabilidad**: un `deployment.yaml` funciona igual en cualquier clúster K8s (local, cloud, datacenter)
- **GitOps**: herramientas como ArgoCD y Flux convierten Git en la fuente de verdad para el clúster
- **Ecosistema inmenso**: Helm (packaging), Istio (service mesh), Prometheus (monitoreo), Cert-Manager (SSL), Harbor (registry)
- **No es solo para microservicios**: también para ML (Kubeflow), batch (Argo Workflows), serverless (Knative)

## Ver también

- [[kubectl]] — la CLI para interactuar con Kubernetes
- [[Docker]] — contenedores, la base sobre la que corre Kubernetes
- [[Contenedores]] — concepto general de contenedores Linux
- [[cgroups (control de recursos)]] — mecanismo que usa Kubernetes para aislar recursos
- [[systemd-nspawn]] — alternativa ligera a contenedores
- [[LXC y Contenedores del Sistema]] — contenedores a nivel de sistema vs contenedores de aplicación

## Enlaces externos

- [Kubernetes — Documentación oficial](https://kubernetes.io/docs/home/)
- [Kubernetes — Tutorial interactivo](https://kubernetes.io/docs/tutorials/)
- [Kubernetes — Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes — Conceptos](https://kubernetes.io/docs/concepts/)
- [Kubernetes — Wikipedia](https://es.wikipedia.org/wiki/Kubernetes)
- [Minikube — K8s local](https://minikube.sigs.k8s.io/docs/)
- [Kind — K8s IN Docker](https://kind.sigs.k8s.io/)
- [K3s — K8s ligero](https://k3s.io/)
- [Play with Kubernetes — Sandbox online](https://labs.play-with-k8s.com/)
- [Kubernetes — Los 15 mejores prácticas](https://kubernetes.io/docs/concepts/configuration/overview/)

#programa #kubernetes
