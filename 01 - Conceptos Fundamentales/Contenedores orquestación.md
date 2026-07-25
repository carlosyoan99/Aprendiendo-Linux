---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: concepto
prioridad: alta
---

# Contenedores — Orquestación

## Definición

La **orquestación de contenedores** es la automatización del despliegue, escalado, redes y gestión de contenedores en múltiples servidores. Si Docker/Podman gestionan un contenedor individual, la orquestación gestiona **flotas enteras de contenedores** coordinándolos como un sistema único.

```
┌─────────────────────────────────────────────────────────────┐
│                 ORQUESTACIÓN DE CONTENEDORES                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ App A    │  │ App B    │  │ App A    │  │ App C    │   │
│  │ v1.2.3   │  │ v2.0.1   │  │ v1.2.3   │  │ v1.0.0   │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
│       │             │             │             │          │
│  ┌────┴─────────────┴─────────────┴─────────────┴────┐     │
│  │              ORQUESTADOR (K8s/Swarm)              │     │
│  │  - Desired state → actual state                   │     │
│  │  - Service discovery + load balancing             │     │
│  │  - Health checks → auto-restart                   │     │
│  │  - Rolling updates + rollbacks                    │     │
│  │  - Scaling up/down según demanda                  │     │
│  └────────────────────┬──────────────────────────────┘     │
│                       │                                     │
│  ┌────────────────────┴──────────────────────────────┐     │
│  │  Nodo 1           Nodo 2            Nodo 3         │     │
│  │  (servidor físico o VM)                           │     │
│  └───────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

## Por qué importa

Sin orquestación, gestionar contenedores en producción requiere hacerlo todo a mano:

| Sin orquestación | Con orquestación |
|---|---|
| SSH a cada servidor para desplegar | `kubectl apply -f deployment.yaml` |
| Crear balanceadores manualmente | Service discovery automático |
| Monitorear procesos con scripts | Health checks + auto-reinicio |
| Reescalar a mano cuando hay carga | Auto-scaling por CPU/memoria/métricas |
| Actualizar app: tiempo de inactividad | Rolling updates sin downtime |
| Rollback manual si algo falla | Rollback automático con `kubectl rollout undo` |

**¿Qué pasaría si no existiera?** Estaríamos donde estábamos en 2015: deploys manuales, scripts de shell frágiles, servidores apache configurados a mano, y el famoso "en mi máquina funciona".

## Conceptos universales de orquestación

| Concepto | Qué es | Docker Compose | Docker Swarm | Kubernetes |
|---|---|---|---|---|
| **Desired state** | Declaras cómo quieres que sea el sistema; el orquestador lo mantiene | `docker compose up` | `docker stack deploy` | `kubectl apply -f` |
| **Service** | Una app replicada, accesible por nombre | `services:` | `services:` en stack | `kind: Service` |
| **Replicas** | Cuántas copias de un servicio corren | — | `replicas: 3` | `replicas: 3` |
| **Load balancer** | Distribuye tráfico entre réplicas | Puerto mapeado | Ingress mesh | Service type LB |
| **Health check** | Monitorea si el servicio responde | `healthcheck:` | `healthcheck:` | `livenessProbe` |
| **Rolling update** | Actualizar sin downtime | `--no-deps` implícito | `update_config:` | `strategy: RollingUpdate` |
| **Secrets** | Datos sensibles | `secrets:` (v2.1+) | `secrets:` | `kind: Secret` |
| **Config maps** | Config no sensible | Variables env | `configs:` | `kind: ConfigMap` |
| **Volumes** | Datos persistentes | `volumes:` | `volumes:` | `kind: PersistentVolumeClaim` |
| **Networking** | Comunicación entre servicios | Red interna automática | Overlay network | CNI (Calico, Flannel, Cilium) |

---

## 1. Docker Compose — Orquestación local / single-host

Docker Compose permite definir y ejecutar múltiples contenedores **en un solo host** usando un archivo YAML. No es un orquestador de producción, sino la herramienta ideal para desarrollo local, CI/CD, y entornos monohost.

```yaml
# docker-compose.yml (v3.8)
services:
  api:
    build: ./api
    ports:
      - "3000:3000"
    environment:
      DB_HOST: db
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      retries: 3

  db:
    image: postgres:16-alpine
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD:-secret}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s

  redis:
    image: redis:7-alpine

volumes:
  pgdata:

networks:
  default:
    name: mi-app-network
```

### Comandos esenciales

```bash
# Iniciar todos los servicios
docker compose up -d

# Ver logs de todos los servicios
docker compose logs -f

# Ver logs de un servicio específico
docker compose logs -f api

# Escalar un servicio (v2+)
docker compose up -d --scale api=3

# Reconstruir y reiniciar un servicio
docker compose up -d --build api

# Ejecutar un comando en un servicio en ejecución
docker compose exec api bash

# Ejecutar un comando en un servicio nuevo (útil para migraciones)
docker compose run --rm api npx prisma migrate deploy

# Detener sin eliminar
docker compose stop

# Detener y eliminar contenedores, redes, pero NO volúmenes
docker compose down

# Detener y eliminar TODO, incluidos volúmenes (¡borra datos!)
docker compose down -v

# Ver estado
docker compose ps
```

### Perfiles (profiles) — Servicios opcionales

Puedes definir servicios que solo se inicien cuando se solicite explícitamente:

```yaml
services:
  app:
    image: myapp:latest

  adminer:              # Solo para desarrollo
    profiles: ["dev"]
    image: adminer:latest
    ports: ["8080:8080"]

  prometheus:           # Solo para producción
    profiles: ["prod"]
    image: prom/prometheus:latest
```

```bash
docker compose --profile dev up -d     # app + adminer
docker compose --profile prod up -d    # app + prometheus
docker compose up -d                   # solo app
```

### Variables de entorno

```bash
# .env (cargado automáticamente por docker compose)
DB_PASSWORD=secret
API_PORT=3000
LOG_LEVEL=debug
```

```yaml
# docker-compose.yml usa ${VAR:-default}
services:
  api:
    environment:
      - LOG_LEVEL=${LOG_LEVEL:-info}
```

### watch (docker compose v2.24+)

Sincronización de código en caliente sin reconstruir la imagen:

```yaml
services:
  api:
    build: ./api
    develop:
      watch:
        - action: sync
          path: ./api/src
          target: /app/src
        - action: rebuild
          path: ./api/package.json
```

```bash
docker compose up --watch   # vigila cambios y sincroniza automáticamente
```

### Limitaciones de Docker Compose

- **Un solo host**: no escala a múltiples servidores
- **Sin auto-healing real**: si un contenedor falla, no se reinicia automáticamente a menos que se use `restart: always`
- **Sin load balancing nativo**: el puerto mapeado va a un solo contenedor escalado (salvo con `scale`)
- **No apto para producción**: aunque se puede usar, no tiene la madurez de Swarm o Kubernetes

---

## 2. Docker Swarm — Orquestación nativa de Docker

Swarm está **integrado en Docker** desde la versión 1.12. Convierte un grupo de servidores Docker en un solo cluster lógico. Es más simple que Kubernetes pero con menos funcionalidades.

### Arquitectura

```
┌──────────────────────────────────────────────────┐
│                    SWARM                          │
│                                                    │
│   ┌─────────────────┐     ┌─────────────────┐    │
│   │  MANAGER (líder) │────│  MANAGER (resp)  │    │
│   │  - API endpoint  │     │  - Backup        │    │
│   │  - Scheduling    │     │  - Raft quorum   │    │
│   └────────┬────────┘     └────────┬────────┘    │
│            │                       │              │
│   ┌────────┴────────┐     ┌────────┴────────┐    │
│   │   WORKER 1      │     │   WORKER 2      │    │
│   │  - Corre tareas  │     │  - Corre tareas  │    │
│   └─────────────────┘     └─────────────────┘    │
└──────────────────────────────────────────────────┘
```

### Inicializar Swarm

```bash
# En el nodo manager:
docker swarm init --advertise-addr 192.168.1.10

# Obtener token para workers:
docker swarm join-token worker
# → docker swarm join --token SWMTKN-... 192.168.1.10:2377

# En cada worker, ejecutar el comando del token:
docker swarm join --token SWMTKN-... 192.168.1.10:2377

# Ver nodos del cluster
docker node ls
```

### Desplegar un stack

```yaml
# stack.yml
version: "3.8"
services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    deploy:
      replicas: 3
      update_config:
        parallelism: 1      # actualizar 1 contenedor a la vez
        delay: 10s          # esperar 10s entre cada uno
        order: start-first  # arrancar nuevo antes de detener viejo
      restart_policy:
        condition: any
        max_attempts: 3
      resources:
        limits:
          cpus: "0.5"
          memory: 256M

  api:
    image: myapi:latest
    environment:
      DB_HOST: db
    depends_on:
      - db
    deploy:
      replicas: 2
      placement:
        constraints:
          - node.role == worker   # solo correr en workers

  db:
    image: postgres:16-alpine
    volumes:
      - pgdata:/var/lib/postgresql/data
    deploy:
      placement:
        constraints:
          - node.hostname == storage-01
    # ⚠️ No replicar bases de datos sin replicación externa

volumes:
  pgdata:
```

```bash
# Desplegar
docker stack deploy -c stack.yml mi-app

# Ver servicios
docker stack services mi-app

# Ver tareas (contenedores)
docker stack ps mi-app

# Escalar
docker service scale mi-app_api=5

# Ver logs
docker service logs -f mi-app_api

# Actualizar imagen
docker service update --image myapi:2.0.0 mi-app_api

# Rollback
docker service rollback mi-app_api

# Eliminar stack
docker stack rm mi-app
```

### Cuándo usar Swarm

| ✅ Ideal para | ❌ No ideal para |
|---|---|
| Equipos pequeños que ya usan Docker | Clusters grandes (>50 nodos) |
| Aplicaciones monolíticas o pocos servicios | Microservicios complejos con malla de servicios |
| Entornos on-premise simples | Casos que necesitan auto-scaling avanzado |
| Migración rápida de Docker Compose a multi-host | Si ya tienes experiencia con Kubernetes |

Swarm es perfecto como **primer paso** hacia la orquestación: el mismo `docker-compose.yml` con algunas secciones `deploy:` extra y estás en producción multi-host.

---

## 3. Kubernetes (K8s) — El estándar de la industria

Kubernetes (K8s) es el orquestador dominante, originalmente creado por Google y ahora de la CNCF. Gestiona clusters de cientos o miles de nodos con auto-escalado, auto-reparación y rolling updates avanzados.

> **Nota**: Esta sección es un resumen conceptual de K8s como orquestador. La nota [[Kubernetes]] del vault cubre la instalación, kubectl, pods, deployments, services, namespaces y troubleshooting en profundidad.

### Conceptos clave de K8s

```
┌─────────────────────────────────────────────────────────┐
│                    CLUSTER KUBERNETES                     │
├─────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────┐      │
│  │               CONTROL PLANE                  │      │
│  │  API Server  │  Scheduler  │  Controller Mgr │      │
│  │  etcd (key-value store — cerebro del cluster) │      │
│  └──────────────────┬───────────────────────────┘      │
│                      │                                   │
│  ┌──────────────────┴───────────────────────────┐      │
│  │               WORKER NODES                    │      │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐     │      │
│  │  │  Pod A  │  │  Pod B  │  │  Pod C  │     │      │
│  │  │ ┌─────┐ │  │ ┌─────┐ │  │ ┌─────┐ │     │      │
│  │  │ │ctn1 │ │  │ │ctn1 │ │  │ │ctn1 │ │     │      │
│  │  │ └─────┘ │  │ └─────┘ │  │ └─────┘ │     │      │
│  │  └─────────┘  └─────────┘  └─────────┘     │      │
│  │  Kubelet │  kube-proxy │  CNI (Cilium)      │      │
│  └──────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────┘
```

| Recurso K8s | Análogo en Compose/Swarm | Descripción |
|---|---|---|
| **Pod** | Contenedor | Unidad mínima de cómputo (1+ contenedores) |
| **Deployment** | `deploy:` + `replicas:` | Gestión de réplicas + rolling updates |
| **Service** | `ports:` | IP estable + DNS + load balancing |
| **Ingress** | — | Enrutamiento HTTP/HTTPS al Service |
| **ConfigMap** | `environment:` | Config no sensible |
| **Secret** | `secrets:` | Datos sensibles (base64) |
| **PersistentVolumeClaim** | `volumes:` | Almacenamiento persistente |
| **HorizontalPodAutoscaler** | — | Auto-escalado por métricas |

### Comandos básicos de K8s (kubectl)

```bash
# Ver estado del cluster
kubectl cluster-info
kubectl get nodes
kubectl get pods -A          # -A = todos los namespaces

# Desplegar una app
kubectl create deployment mi-app --image nginx:alpine --replicas 3

# Exponer la app
kubectl expose deployment mi-app --port 80 --type LoadBalancer

# Ver recursos
kubectl get deployments,services,pods

# Escalar
kubectl scale deployment mi-app --replicas 5

# Actualizar imagen
kubectl set image deployment/mi-app nginx=nginx:1.25-alpine

# Rollback si algo falla
kubectl rollout undo deployment/mi-app

# Ver logs
kubectl logs -l app=mi-app --tail=100

# Port forwarding (túnel a un pod específico)
kubectl port-forward pod/mi-app-xxx 8080:80

# Ejecutar comando en un pod
kubectl exec -it pod/mi-app-xxx -- sh
```

> Para mucho más detalle (instalación de K8s, minikube, k3s, configmap, secrets, ingress, namespaces, RBAC, troubleshooting), ver [[Kubernetes]].

---

## 4. Comparativa: Compose vs Swarm vs Kubernetes

| Aspecto | Docker Compose | Docker Swarm | Kubernetes |
|---|---|---|---|
| **Curva de aprendizaje** | Baja | Media | Alta |
| **Setup** | `apt install docker-compose` | Integrado en Docker | minikube, k3s, kind, kubeadm |
| **Cluster multi-host** | ❌ No | ✅ Sí | ✅ Sí |
| **Auto-escalado** | ❌ Manual (`--scale`) | ⚠️ Manual (`service scale`) | ✅ HPA automático por métricas |
| **Rolling updates** | ⚠️ Con `--no-deps` | ✅ Configurable | ✅ Avanzado (maxSurge, maxUnavailable) |
| **Health checks** | ✅ `healthcheck:` | ✅ + restart_policy | ✅ liveness + readiness + startup |
| **Service discovery** | DNS interno | DNS + mesh (ingress) | DNS + ClusterIP + ExternalDNS |
| **Load balancing** | Puerto único | Ingress + mesh | Service LB + Ingress + Gateway API |
| **Storage** | Volúmenes locales | Volúmenes + NFS | CSI (Ceph, Longhorn, EBS, etc.) |
| **Secrets management** | `.env` + secrets | secrets | Secrets + External Secrets + Vault |
| **Malla de servicios** | ❌ | ❌ | ✅ Istio, Linkerd, Cilium, Consul |
| **Multi-cloud** | ❌ | ❌ | ✅ (kubeadm, EKS, AKS, GKE) |
| **Comunidad / Ecosistema** | Pequeña | Pequeña | Enorme (CNCF, 100k+ estrellas) |
| **Mejor para** | Desarrollo local, CI/CD simple | Equipos pequeños, on-premise simple | Producción seria, microservicios, cloud |

### Árbol de decisión

```
¿Dónde vas a ejecutar?
│
├─ Un solo servidor
│  ├─ ¿Desarrollo local o CI?          → Docker Compose
│  └─ ¿Producción pequeña?              → Swarm o Docker Compose + restart: always
│
├─ Varios servidores, equipo pequeño
│  ├─ ¿Ya usas Docker?                  → Docker Swarm
│  └─ ¿Quieres aprender lo estándar?    → Kubernetes
│
├─ Producción seria, muchos servicios
│  └─ Kubernetes (EKS, AKS, GKE, k3s)
│
└─ ¿No sabes por dónde empezar?
   └─ Empieza con Compose → Swarm → K8s
```

---

## 5. Alternativas a Kubernetes

| Alternativa | Descripción | Ideal para |
|---|---|---|
| **Nomad** (HashiCorp) | Orquestador simple que soporta contenedores + apps nativas. Un solo binario | Equipos que quieren SIMPLICIDAD sobre features |
| **Mesos** (Apache, legacy) | Orquestador de recursos general (no solo contenedores). Murió en popularidad | Casos legacy muy específicos |
| **Amazon ECS** | Orquestador nativo de AWS, más simple que EKS | Equipos solo AWS que no quieren gestionar K8s |
| **Azure Container Instances** | Serverless containers de Azure | Apps simples en Azure |
| **Google Cloud Run** | Serverless containers de GCP | Apps stateless que escalan a cero |

---

## 6. Servicios gestionados de Kubernetes (cloud)

Si no quieres gestionar el control plane de K8s:

| Proveedor | Servicio | Notas |
|---|---|---|
| AWS | **EKS** (Elastic Kubernetes Service) | El estándar en AWS. Paga por cluster (~$0.10/hora) |
| Azure | **AKS** (Azure Kubernetes Service) | Control plane gratis, pagas workers |
| GCP | **GKE** (Google Kubernetes Engine) | Primero de su clase, AutoPilot, nodos spot |
| DigitalOcean | **DOKS** | Simple, económico, $12/mes mínimo |
| Civo | **Civo Kubernetes** | K8s nativo en UK, muy rápido, económico |
| Talos | **Talos Linux** | OS Linux mínimo especializado para K8s |

---

## 7. Flujo completo: de Compose a producción con K8s

```bash
# ── 1. Desarrollo local con Docker Compose ──
docker compose up -d
# Iteras código, pruebas, todo funciona

# ── 2. Tests CI/CD con Compose ──
docker compose -f docker-compose.test.yml up --abort-on-container-exit

# ── 3. Stack multi-host con Swarm (opcional) ──
docker swarm init
docker stack deploy -c docker-compose.yml mi-app

# ── 4. Migrar a Kubernetes ──
# Convertir docker-compose.yml a manifests K8s:
docker compose convert                          # genera YAML
# O usar kompose (herramienta de conversión):
kompose convert -f docker-compose.yml           # genera deployments, services, etc.
kubectl apply -f .

# ── 5. Producción en K8s ──
kubectl create deployment app --image=myapp:1.0 --replicas=3
kubectl expose deployment app --port=80 --type=LoadBalancer
kubectl autoscale deployment app --min=3 --max=10 --cpu-percent=70
```

---

## 8. Troubleshooting de orquestación

| Problema | Causa | Solución |
|---|---|---|
| `Container keeps restarting` | Crash loop — app falla al iniciar | `docker logs <container>` / `kubectl logs <pod>` |
| `ImagePullBackOff` | Imagen no encontrada o error de autenticación | Verificar nombre/tag, `docker login`, `imagePullSecrets` |
| `CrashLoopBackOff` (K8s) | El pod falla repetidamente | `kubectl describe pod`, revisar eventos y logs |
| `Pending` (K8s) | Pod no se asigna a ningún nodo | `kubectl describe pod`: recursos insuficientes, taints, PVC no disponible |
| `No route to host` | Red entre servicios mal configurada | Verificar service names, DNS, network policies |
| `docker stack deploy` no encuentra el archivo | Ruta relativa incorrecta | Usar ruta absoluta o ejecutar desde el directorio del stack |
| Swarm: nodo manager pierde quorum | Muy pocos managers (deben ser 3 o 5) | `docker node promote` otro nodo a manager |
| `kubectl: command not found` | kubectl no instalado | Ver [[kubectl]] para instalación |
| Namespace default en K8s con recursos | No hay namespaces aislados | Usar `kubectl create namespace` + contextos |

---

## Relación con otros conceptos

- [[Contenedores]] — concepto general de contenedores
- [[Docker]] — Docker, el motor de contenedores base
- [[Kubernetes]] — orquestador K8s en detalle (instalación, kubectl, recursos, troubleshooting)
- [[kubectl]] — comando kubectl (atajos, contexto, recursos)
- [[Namespaces (Linux)]] — los namespaces de Linux: base técnica de los contenedores
- [[cgroups (control de recursos)]] — cgroups limitan CPU/RAM que usa cada contenedor
- [[Contenedores - Comparativa]] — LXC, LXD, Incus, Docker, Podman, systemd-nspawn
- [[Entorno de desarrollo Linux]] — contenedores para desarrollo (Dev Containers, Docker)
- [[systemd-nspawn]] — contenedores ligeros nativos de systemd

## Enlaces externos

- [Docker Compose — Documentación oficial](https://docs.docker.com/compose/)
- [Docker Swarm — Documentación oficial](https://docs.docker.com/engine/swarm/)
- [Kubernetes — Documentación oficial](https://kubernetes.io/docs/)
- [Kompose — Convertir docker-compose.yml a K8s](https://kompose.io/)
- [CNCF Cloud Native Landscape](https://landscape.cncf.io/)
- [K3s — Kubernetes ligero para IoT/Edge](https://k3s.io/)
- [KIND — Kubernetes in Docker (testing local)](https://kind.sigs.k8s.io/)
- [Minikube — K8s local en una VM](https://minikube.sigs.k8s.io/)
- [HashiCorp Nomad](https://www.nomadproject.io/)

#concepto #contenedores #orquestacion
