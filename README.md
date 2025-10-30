# Project Base - Terraform + GCP + Cloud Run

A complete infrastructure-as-code project template with automated CI/CD, pre-commit hooks, and best practices for Google Cloud Platform deployment.

## 🚀 Quick Start

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

## Setup Instructions

### 3. Create Terraform State Bucket

```bash
# Criar bucket para estado do Terraform
gsutil mb -p SEU-PROJECT-ID gs://SEU-PROJECT-ID-terraform-state
gsutil versioning set on gs://SEU-PROJECT-ID-terraform-state

# Ir para ambiente de produção
cd terraform/environments/prod

# Editar terraform.tfvars com seus valores
nano terraform.tfvars
```

### 4. Initialize and Apply Terraform

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

### 5. Upload Docker Image to Artifact Registry

```bash
# auth
gcloud auth configure-docker us-central1-docker.pkg.dev

# build
docker build -t my-app:latest .

# tag
docker tag my-app:latest us-central1-docker.pkg.dev/app-xyz-dev/meu-repo/app1:latest

# push
docker push us-central1-docker.pkg.dev/app-xyz-dev/meu-repo/app1:latest
```
