#!/bin/bash

# Script para configurar Workload Identity de forma simples
# Execute: ./setup-wif.sh SEU_PROJECT_ID

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se project ID foi fornecido
if [ -z "$1" ]; then
    echo -e "${RED}❌ Erro: Forneça o PROJECT_ID${NC}"
    echo "Uso: ./setup-wif.sh MEU_PROJECT_ID"
    exit 1
fi

PROJECT_ID="$1"
REPO="eduardo239/project-base"
POOL_ID="github-pool"
PROVIDER_ID="github-provider"
SA_NAME="github-actions-sa"

echo -e "${YELLOW}🚀 Configurando Workload Identity para $PROJECT_ID${NC}"

# Verificar se gcloud está configurado
if ! gcloud config get-value project &>/dev/null; then
    echo -e "${RED}❌ Execute: gcloud auth login && gcloud config set project $PROJECT_ID${NC}"
    exit 1
fi

# Definir projeto
gcloud config set project $PROJECT_ID

echo -e "${YELLOW}📝 Criando Workload Identity Pool...${NC}"
gcloud iam workload-identity-pools create $POOL_ID \
    --location=global \
    --display-name="GitHub Actions Pool" || true

echo -e "${YELLOW}🔗 Criando Provider...${NC}"
gcloud iam workload-identity-pools providers create-oidc $PROVIDER_ID \
    --location=global \
    --workload-identity-pool=$POOL_ID \
    --display-name="GitHub Actions Provider" \
    --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
    --issuer-uri="https://token.actions.githubusercontent.com" || true

echo -e "${YELLOW}👤 Criando Service Account...${NC}"
gcloud iam service-accounts create $SA_NAME \
    --display-name="GitHub Actions Service Account" || true

echo -e "${YELLOW}🔐 Configurando permissões...${NC}"
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

# Obter project number
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

echo -e "${YELLOW}🔌 Conectando GitHub ao Service Account...${NC}"
gcloud iam service-accounts add-iam-policy-binding \
    $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$POOL_ID/attribute.repository/$REPO"

echo -e "${GREEN}✅ Configuração concluída!${NC}"
echo ""
echo -e "${YELLOW}📋 Secrets para configurar no GitHub:${NC}"
echo ""
echo "🔑 WIF_PROVIDER:"
echo "projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$POOL_ID/providers/$PROVIDER_ID"
echo ""
echo "👤 WIF_SERVICE_ACCOUNT:"
echo "$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"
echo ""
echo -e "${GREEN}📍 Configure em: https://github.com/$REPO/settings/secrets/actions${NC}"