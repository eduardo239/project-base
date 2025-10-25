#!/bin/bash

# Script para criar service account com chave JSON
# Execute: ./setup-service-account.sh SEU_PROJECT_ID

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}❌ Erro: Forneça o PROJECT_ID${NC}"
    echo "Uso: ./setup-service-account.sh MEU_PROJECT_ID"
    exit 1
fi

PROJECT_ID="$1"
SA_NAME="github-actions-sa"
SA_EMAIL="$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"
KEY_FILE="$SA_NAME-key.json"

echo -e "${BLUE}🚀 Configurando Service Account para $PROJECT_ID${NC}"

# Definir projeto
gcloud config set project $PROJECT_ID

echo -e "${YELLOW}👤 Criando Service Account...${NC}"
gcloud iam service-accounts create $SA_NAME \
    --display-name="GitHub Actions Service Account" \
    --description="Service Account for GitHub Actions CI/CD" || true

echo -e "${YELLOW}🔐 Adicionando permissões...${NC}"
# Permissões mínimas necessárias para Terraform
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/editor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/iam.serviceAccountAdmin"

echo -e "${YELLOW}🔑 Criando chave JSON...${NC}"
gcloud iam service-accounts keys create $KEY_FILE \
    --iam-account=$SA_EMAIL

echo -e "${GREEN}✅ Service Account criado com sucesso!${NC}"
echo ""
echo -e "${YELLOW}📋 Configuração no GitHub:${NC}"
echo ""
echo -e "${BLUE}1. Vá para: https://github.com/eduardo239/project-base/settings/secrets/actions${NC}"
echo -e "${BLUE}2. Clique em 'New repository secret'${NC}"
echo -e "${BLUE}3. Nome: ${GREEN}GCP_SA_KEY${NC}"
echo -e "${BLUE}4. Valor: Cole o conteúdo do arquivo ${GREEN}$KEY_FILE${NC}"
echo ""
echo -e "${YELLOW}📄 Conteúdo da chave JSON:${NC}"
echo -e "${GREEN}$(cat $KEY_FILE)${NC}"
echo ""
echo -e "${RED}⚠️  IMPORTANTE: Mantenha este arquivo seguro e delete após configurar no GitHub!${NC}"
echo -e "${BLUE}💡 Para deletar: rm $KEY_FILE${NC}"
echo ""
echo -e "${YELLOW}🧹 APIs que podem ser necessárias:${NC}"
echo "gcloud services enable run.googleapis.com"
echo "gcloud services enable artifactregistry.googleapis.com" 
echo "gcloud services enable cloudbuild.googleapis.com"
echo "gcloud services enable compute.googleapis.com"
echo "gcloud services enable iam.googleapis.com"