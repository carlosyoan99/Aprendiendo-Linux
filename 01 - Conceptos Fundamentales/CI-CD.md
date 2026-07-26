---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: concepto
prioridad: baja
---

# CI/CD

> Integración Continua (CI) y Despliegue Continuo (CD): automatización del pipeline de desarrollo, desde código hasta producción.

## Qué es

| Concepto | Definición |
|---|---|
| **CI** (Continuous Integration) | Fusionar código frequentemente, ejecutar tests automáticos en cada push |
| **CD** (Continuous Delivery) | CI + preparar artefactos para despliegue manual |
| **CD** (Continuous Deployment) | CI + despliegue automático a producción |

## Pipeline típico

```
Push → Lint → Build → Test → Artifact → Deploy (staging) → Deploy (prod)
  │                         │                          │
  └── CI ───────────────────┘                          └── CD ──┘
```

## Herramientas populares

| Herramienta | Tipo | Ventaja |
|---|---|---|
| **GitHub Actions** | Cloud (GitHub) | Integrado con GitHub, 2000 min/mes gratis |
| **GitLab CI/CD** | Cloud/Self-hosted | Todo-en-uno, runners gratuitos |
| **Jenkins** | Self-hosted | Extensible, 1800+ plugins |
| **Gitea Actions** | Self-hosted | Compatible con GitHub Actions, ligero |
| **Woodpecker CI** | Self-hosted | Ligero, Docker-native |

## Ejemplo: GitHub Actions

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm test
      - run: npm run lint

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: ./deploy.sh
```

## Ejemplo: GitLab CI

```yaml
# .gitlab-ci.yml
stages:
  - test
  - deploy

test:
  stage: test
  image: node:20
  script:
    - npm ci
    - npm test

deploy:
  stage: deploy
  script:
    - ./deploy.sh
  only:
    - main
```

## CI/CD en Linux

```bash
# Jenkins en Docker
docker run -d -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts

# Gitea + Drone CI
docker-compose up -d    # Gitea en :3000 + Drone en :80

# GitLab Runner (self-hosted)
sudo gitlab-runner register --url https://gitlab.com
```

## Ver también

- [[DevOps]]
- [[Docker]]
- [[Docker Compose]]
- [[Git]]

#concepto #devops #cicd #automatizacion #despliegue
