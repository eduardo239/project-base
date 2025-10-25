# Configuração Simples do Workload Identity

## ⚡ Método Mais Simples - Um Comando

```bash
# Substitua pelos seus valores reais
export PROJECT_ID="seu-project-id"
export REPO="eduardo239/project-base"

# Comando único que faz tudo
gcloud iam workload-identity-pools create-cred-config \
    projects/$PROJECT_ID/locations/global/workloadIdentityPools/github-pool/providers/github-provider \
    --service-account=github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com \
    --output-file=credentials.json \
    --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
    --attribute-condition="assertion.repository=='$REPO'"
```

## 🔧 Configuração Passo a Passo

### 1. Definir variáveis

```bash
export PROJECT_ID="seu-project-id"  # Substitua pelo seu project ID
export REPO="eduardo239/project-base"
```

### 2. Criar tudo de uma vez

```bash
# Criar pool e provider
gcloud iam workload-identity-pools create github-pool \
    --project=$PROJECT_ID \
    --location=global \
    --display-name="GitHub Actions"

gcloud iam workload-identity-pools providers create-oidc github-provider \
    --project=$PROJECT_ID \
    --location=global \
    --workload-identity-pool=github-pool \
    --display-name="GitHub" \
    --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
    --issuer-uri="https://token.actions.githubusercontent.com"

# Criar service account
gcloud iam service-accounts create github-actions-sa \
    --display-name="GitHub Actions"

# Dar permissões
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

# Conectar GitHub ao service account
gcloud iam service-accounts add-iam-policy-binding \
    github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/projects/$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')/locations/global/workloadIdentityPools/github-pool/attribute.repository/$REPO"
```

### 3. Obter os valores para os secrets

```bash
# WIF_PROVIDER
echo "projects/$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')/locations/global/workloadIdentityPools/github-pool/providers/github-provider"

# WIF_SERVICE_ACCOUNT
echo "github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com"
```

## 🚀 Alternativa SUPER Simples - Usar Service Account Existente

Se você já tem um service account que o Terraform usa:

### 1. Usar service account existente

```bash
export PROJECT_ID="seu-project-id"
export REPO="eduardo239/project-base"
export EXISTING_SA="terraform@$PROJECT_ID.iam.gserviceaccount.com"  # ou qualquer SA existente

# Só criar o pool/provider e conectar ao SA existente
gcloud iam workload-identity-pools create github-pool \
    --project=$PROJECT_ID --location=global --display-name="GitHub Actions"

gcloud iam workload-identity-pools providers create-oidc github-provider \
    --project=$PROJECT_ID --location=global --workload-identity-pool=github-pool \
    --display-name="GitHub" --issuer-uri="https://token.actions.githubusercontent.com" \
    --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository"

# Permitir GitHub usar o SA existente
gcloud iam service-accounts add-iam-policy-binding $EXISTING_SA \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/projects/$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')/locations/global/workloadIdentityPools/github-pool/attribute.repository/$REPO"
```

### 2. Secrets para GitHub

```bash
# WIF_PROVIDER
echo "projects/$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')/locations/global/workloadIdentityPools/github-pool/providers/github-provider"

# WIF_SERVICE_ACCOUNT (usar o existente)
echo "$EXISTING_SA"
```

## 📋 Configurar Secrets no GitHub

Vá para: https://github.com/eduardo239/project-base/settings/secrets/actions

1. **`WIF_PROVIDER`**: Cole o valor do primeiro comando acima
2. **`WIF_SERVICE_ACCOUNT`**: Cole o email do service account

## ✅ Pronto!

Depois disso, o GitHub Actions funcionará sem erros de autenticação.
