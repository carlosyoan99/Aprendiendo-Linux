---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: concepto
prioridad: alta
---

# DevOps

> Cultura y práctica que unifica desarrollo (Dev) y operaciones (Ops). Automatiza la entrega de software mediante CI/CD, infraestructura como código, contenedores y monitoreo continuo.

## Definición

DevOps no es una herramienta — es una **filosofía de trabajo** que elimina los silos entre equipos de desarrollo y operaciones. El objetivo: entregar software más rápido, con menor riesgo, mediante automatización y retroalimentación continua.

| Pilar | Qué significa |
|---|---|
| **CI/CD** | Integración y entrega continua — build, test, deploy automatizados |
| **IaC** | Infraestructura como Código — Terraform, Ansible, Pulumi |
| **Contenedores** | Empaquetado estandarizado — Docker, Podman, containerd |
| **Orquestación** | Gestión de múltiples contenedores — Kubernetes, Docker Swarm |
| **Monitoreo** | Observabilidad en tiempo real — Prometheus, Grafana, ELK |
| **GitOps** | Git como fuente de verdad para infraestructura y despliegues |

## Por qué importa para un usuario de Linux

- **Linux es la base**: el 90%+ de servidores, contenedores y pipelines CI/CD corren en Linux
- **Habilidades transferibles**: bash, networking, systemd, permisos — todo lo que aprendes en Linux aplica directamente a DevOps
- **Demanda laboral**: DevOps engineer es uno de los roles mejor pagados en tech
- **Automatización personal**: los mismos conceptos (scripts, cron, monitoreo) sirven para automatizar tu propio equipo

## Ecosistema de herramientas

```
┌─────────────────────────────────────────────────────┐
│                    DEVOPS TOOLCHAIN                  │
├──────────────┬──────────────┬───────────────────────┤
│  CÓDIGO      │  BUILD       │  TEST                 │
│  Git         │  Make/Docker │  pytest, JUnit        │
│  GitHub      │  npm/maven   │  SonarQube            │
├──────────────┼──────────────┼───────────────────────┤
│  PACKAGE     │  DEPLOY      │  OPERATE              │
│  Docker/Helm │  K8s/Ansible │  Prometheus/Grafana   │
│  registries  │  Terraform   │  PagerDuty            │
├──────────────┼──────────────┼───────────────────────┤
│  MONITOR     │  ITERATE     │                       │
│  ELK/Datadog │  GitOps/Argo │                       │
│  Jaeger      │  Feature     │                       │
│              │  flags       │                       │
└──────────────┴──────────────┴───────────────────────┘
```

### Herramientas principales

| Categoría | Herramientas | Para qué |
|---|---|---|
| **Control de versiones** | Git, GitHub, GitLab | Código fuente |
| **CI/CD** | GitHub Actions, GitLab CI, Jenkins | Pipelines automatizados |
| **Contenedores** | Docker, Podman | Empaquetado de aplicaciones |
| **Orquestación** | Kubernetes, Docker Swarm | Gestión de contenedores |
| **IaC** | Terraform, Ansible, Pulumi | Infraestructura reproducible |
| **Configuration Mgmt** | Ansible, Chef, Puppet | Configuración de servidores |
| **Monitoring** | Prometheus, Grafana, Datadog | Métricas y alertas |
| **Logging** | ELK Stack, Loki, Fluentd | Logs centralizados |
| **Tracing** | Jaeger, Zipkin | Trazabilidad distribuida |
| **Secrets** | Vault, SOPS, sealed-secrets | Gestión de secretos |

## Relación con Linux sysadmin

| Sysadmin tradicional | DevOps |
|---|---|
| Scripts ad-hoc | Pipelines versionados |
| Config manual | IaC (Ansible, Terraform) |
| Monitoreo reactivo | Monitoreo proactivo (alertas) |
| Deploy manual | Deploy automatizado (CI/CD) |
| documentation wiki | Documentation as code |
| "funciona en mi máquina" | "funciona en cualquier lugar" (contenedores) |

## Casos prácticos

### Pipeline CI/CD mínimo
```yaml
# .github/workflows/deploy.yml
name: Build and Deploy
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: docker build -t myapp:${{ github.sha }} .
      - name: Run tests
        run: docker run myapp:${{ github.sha }} pytest
      - name: Deploy
        run: |
          docker push registry.example.com/myapp:${{ github.sha }}
          kubectl set image deployment/myapp myapp=registry.example.com/myapp:${{ github.sha }}
```

### Infraestructura como Código
```bash
# Terraform — provisioning de servidor
terraform init
terraform plan
terraform apply

# Ansible — configuración del servidor
ansible-playbook -i hosts deploy.yml
```

## Notas personales

- DevOps no reemplaza al sysadmin — lo evoluciona. Un sysadmin que aprende DevOps tiene una ventaja enorme.
- Empieza por lo básico: Git + Docker + un pipeline CI ya te ponen en el camino.
- Kubernetes es potente pero overkill para proyectos pequeños — Docker Compose suele ser suficiente.
- La clave de DevOps es la **retroalimentación rápida**: si algo falla, lo sabes en minutos, no en días.

## Enlaces externos

- [Wikipedia — DevOps](https://en.wikipedia.org/wiki/DevOps)
- [DevOps Roadmap](https://roadmap.sh/devops)
- [The Phoenix Project (libro)](https://itrevolution.com/the-phoenix-project/)
- [State of DevOps Report](https://dora.dev/)

## Ver también

- [[Docker]] — contenedores
- [[Docker Compose]] — orquestación local
- [[Kubernetes]] — orquestación en producción
- [[Ansible]] — configuración de servidores
- [[Entorno de desarrollo Linux]] — configurar tu estación de trabajo
- [[Monitorización (Prometheus node_exporter)]] — monitoreo

#concepto #devops
