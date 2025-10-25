# Configuração Simples com Service Account Key

## 🚀 Método Mais Simples - Chave JSON

### 1. Executar script de configuração

```bash
./setup-service-account.sh SEU_PROJECT_ID
```

### 2. Configurar secret no GitHub

1. Vá para: https://github.com/eduardo239/project-base/settings/secrets/actions
2. Clique em "New repository secret"
3. Nome: **`GCP_SA_KEY`**
4. Valor: Cole o conteúdo do arquivo JSON gerado

### 3. Habilitar APIs necessárias

```bash
export PROJECT_ID="seu-project-id"

gcloud services enable run.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com
```

## 🔧 Configuração Manual (Alternativa)

### 1. Criar Service Account

```bash
export PROJECT_ID="seu-project-id"
export SA_NAME="github-actions-sa"

# Criar service account
gcloud iam service-accounts create $SA_NAME \
    --display-name="GitHub Actions Service Account" \
    --project=$PROJECT_ID

# Adicionar permissões
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

# Criar chave JSON
gcloud iam service-accounts keys create github-actions-key.json \
    --iam-account=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com
```

### 2. Configurar Secret

- Nome: `GCP_SA_KEY`
- Valor: Conteúdo completo do arquivo `github-actions-key.json`

## ✅ Vantagens desta abordagem

✅ **Simples**: Um script, uma configuração  
✅ **Rápido**: Funciona imediatamente  
✅ **Compatível**: Funciona com qualquer projeto GCP  
✅ **Sem dependências**: Não precisa configurar Workload Identity

## ⚠️ Segurança

- 🔒 **Mantenha a chave segura**: Delete o arquivo local após configurar
- 🔄 **Rotação**: Considere renovar as chaves periodicamente
- 👁️ **Monitoramento**: Monitore o uso do service account

## 🧹 Limpeza (Opcional)

Para voltar ao Workload Identity no futuro:

```bash
# Deletar chaves do service account
gcloud iam service-accounts keys list --iam-account=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts keys delete KEY_ID --iam-account=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com
```
