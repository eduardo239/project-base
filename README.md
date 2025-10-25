# Project Structure

```
project-base/
├── .github/
│   └── workflows/
│       ├── terraform.yml    # CI/CD para infraestrutura
│       └── deploy.yml       # CI/CD para aplicação
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   │   ├── main.tf
│   │   │   ├── terraform.tfvars
│   │   │   └── backend.tf
│   │   └── prod/
│   │       ├── main.tf
│   │       ├── terraform.tfvars
│   │       └── backend.tf
│   ├── modules/
│   │   ├── cloud-run/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── artifact-registry/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── iam/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── networking/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   └── global/
│       ├── main.tf          # Recursos globais (projeto, APIs)
│       └── backend.tf
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

### 3. Deploy via CI/CD

```bash
# Push para main dispara o CI/CD
git add .
git commit -m "Initial setup with Terraform"
git push origin main
```
