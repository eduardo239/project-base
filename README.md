# Project Base - Terraform + GCP + Cloud Run

A complete infrastructure-as-code project template with automated CI/CD, pre-commit hooks, and best practices for Google Cloud Platform deployment.

## 🚀 Quick Start

```bash
# 1. Setup development environment (installs pre-commit hooks)
./setup-dev-env.sh

# 2. Or use Makefile for individual tasks
make setup                    # Complete setup
make help                    # Show all available commands
```

# Project Structure

```
project-base/
├── .github/
│ └── workflows/
│ ├── terraform.yml # CI/CD para infraestrutura
│ └── deploy.yml # CI/CD para aplicação
│ ├── environments/
│ │ ├── dev/
│ │ │ ├── main.tf
│ │ │ ├── terraform.tfvars
│ │ │ └── backend.tf
│ │ └── prod/
│ │ ├── main.tf
│ │ ├── terraform.tfvars
│ │ └── backend.tf
│ ├── modules/
│ │ ├── cloud-run/
│ │ │ ├── main.tf
│ │ │ ├── variables.tf
│ │ │ └── outputs.tf
│ │ ├── artifact-registry/
│ │ │ ├── main.tf
│ │ │ ├── variables.tf
│ │ │ └── outputs.tf
│ │ ├── iam/
│ │ │ ├── main.tf
│ │ │ ├── variables.tf
│ │ │ └── outputs.tf
│ │ └── networking/
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ └── global/
│ ├── main.tf # Recursos globais (projeto, APIs)
│ └── backend.tf
├── src/
│   ├── main.py
│   └── requirements.txt
├── tests/
│   └── test_main.py
├── .dockerignore
├── .gitignore
├── Dockerfile
└── README.md
```

## 🛠️ Development Setup

### Prerequisites

- Python 3.7+ (for pre-commit)
- Terraform 1.5+
- gcloud CLI
- Docker

### 1. Setup Development Environment

```bash
# Quick setup (recommended)
./setup-dev-env.sh

# Manual setup
pip install pre-commit
make install-hooks
```

### 2. Pre-commit Hooks

The project includes pre-commit hooks that run automatically on `git commit` and `git push`:

- ✅ **terraform fmt** - Auto-format Terraform files
- ✅ **terraform validate** - Validate Terraform syntax
- ✅ **YAML/JSON validation** - Check syntax
- ✅ **Trailing whitespace** - Remove extra spaces
- ✅ **End of file** - Ensure proper line endings

```bash
# Hooks run automatically on commit
git add .
git commit -m "feat: add new feature"  # <- Runs terraform fmt + validate

# Manual execution
make fmt                    # Format all .tf files
make validate              # Validate all configurations
make check                 # Format + validate
pre-commit run --all-files # Run all hooks manually

# Skip hooks (emergency only)
git commit --no-verify -m "emergency fix"
```

### 3. Available Make Commands

```bash
make help           # Show all available commands
make setup          # Complete project setup
make fmt            # Format Terraform files
make validate       # Validate Terraform files
make check          # Format + validate (quick check)
make plan-dev       # Plan dev environment
make plan-prod      # Plan prod environment
make apply-dev      # Apply dev environment
make apply-prod     # Apply prod environment
make clean          # Clean Terraform cache
```

## Setup Instructions

### 1. Create Terraform State Bucket

```bash
# Criar bucket para estado do Terraform
gsutil mb -p SEU-PROJECT-ID gs://SEU-PROJECT-ID-terraform-state
gsutil versioning set on gs://SEU-PROJECT-ID-terraform-state

# Ir para ambiente de produção
cd terraform/environments/prod

# Editar terraform.tfvars com seus valores
nano terraform.tfvars
```

### 2. Initialize and Apply Terraform

```bash
# Inicializar
terraform init

# Ver o que será criado
terraform plan

# Aplicar
terraform apply

# Salvar outputs importantes
terraform output
```

### 3. Upload Docker Image to Artifact Registry

```bash
# auth
gcloud auth configure-docker us-central1-docker.pkg.dev

# build
docker build -t my-app:latest .

# tag
docker tag my-app:latest us-central1-docker.pkg.dev/proj-b-475817/meu-repo/app1:latest

# push
docker push us-central1-docker.pkg.dev/proj-b-475817/meu-repo/app1:latest
```

#### 3.1. Automated CI/CD with GitHub Actions

The `.github/workflows/deploy.yaml` automatically:

1. Builds the Docker image
2. Tags it with the commit SHA
3. Pushes to Artifact Registry
4. Deploys to Cloud Run

```bash
# Simply push to trigger automated deployment
git add .
git commit -m "Update application code"
git push origin main  # Deploys to all environments
git push origin dev   # Deploys to dev only
```

#### 3.2. Manual Commands Quick Reference

```bash
# Get repository URL from Terraform
cd terraform/environments/[ENV]
export REPO_URL=$(terraform output -raw repository_url)

# Build, tag and push in one go
docker build -t temp-image . && \
docker tag temp-image $REPO_URL/my-app:$(git rev-parse --short HEAD) && \
docker push $REPO_URL/my-app:$(git rev-parse --short HEAD)

# List images in registry
gcloud artifacts docker images list $REPO_URL

# Delete old images (optional)
gcloud artifacts docker images delete $REPO_URL/my-app:old-tag --quiet
```

### 4. Deploy via CI/CD

```bash
# Push para main dispara o CI/CD
git add .
git commit -m "Initial setup with Terraform"
git push origin main
```

## Docker & Artifact Registry Troubleshooting

### Common Issues

#### 1. Authentication Errors

```bash
# Error: "permission denied" or "unauthorized"
# Solution: Re-authenticate and configure Docker
gcloud auth login
gcloud auth configure-docker us-central1-docker.pkg.dev
```

#### 2. Repository Not Found

```bash
# Error: "repository does not exist"
# Solution: Check if Terraform created the repository
cd terraform/environments/dev
terraform output repository_url

# If empty, run terraform apply
terraform apply
```

#### 3. Image Size Issues

```bash
# Error: "image too large"
# Solution: Use multi-stage builds and .dockerignore

# Example .dockerignore content:
node_modules
*.log
.git
README.md
```

### Docker Best Practices

#### Multi-stage Dockerfile Example

```dockerfile
# Build stage
FROM python:3.11-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Runtime stage
FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY src/ .
EXPOSE 8080
CMD ["python", "main.py"]
```

#### Image Tagging Strategy

```bash
# Tag with version and latest
docker tag my-app:latest $REPO_URL/my-app:v1.0.0
docker tag my-app:latest $REPO_URL/my-app:latest

# Tag with git commit (automated in CI)
docker tag my-app:latest $REPO_URL/my-app:$(git rev-parse --short HEAD)

# Push all tags
docker push $REPO_URL/my-app --all-tags
```

### Useful Commands

```bash
# Check Docker configuration
docker system info | grep -A 10 "Registry:"

# List local images
docker images | grep my-app

# Clean up local images
docker system prune -f

# Monitor Cloud Run deployments
gcloud run services describe my-app --region=us-central1 --format="table(metadata.name,status.url,status.latestRevision)"
```
