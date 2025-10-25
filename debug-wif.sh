#!/bin/bash

# Script para diagnosticar problemas do Workload Identity
# Execute: ./debug-wif.sh SEU_PROJECT_ID

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}❌ Erro: Forneça o PROJECT_ID${NC}"
    echo "Uso: ./debug-wif.sh MEU_PROJECT_ID"
    exit 1
fi

PROJECT_ID="$1"
REPO="eduardo239/project-base"

echo -e "${BLUE}🔍 Diagnosticando Workload Identity para $PROJECT_ID${NC}"
echo ""

# Definir projeto
gcloud config set project $PROJECT_ID

# 1. Verificar se o projeto existe
echo -e "${YELLOW}1. Verificando projeto...${NC}"
if gcloud projects describe $PROJECT_ID &>/dev/null; then
    echo -e "${GREEN}✅ Projeto $PROJECT_ID encontrado${NC}"
    PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
    echo -e "   📊 Project Number: $PROJECT_NUMBER"
else
    echo -e "${RED}❌ Projeto $PROJECT_ID não encontrado ou sem acesso${NC}"
    exit 1
fi

echo ""

# 2. Verificar Workload Identity Pools
echo -e "${YELLOW}2. Verificando Workload Identity Pools...${NC}"
POOLS=$(gcloud iam workload-identity-pools list --location=global --format="value(name)" 2>/dev/null || echo "")
if [ -z "$POOLS" ]; then
    echo -e "${RED}❌ Nenhum Workload Identity Pool encontrado${NC}"
    echo -e "${BLUE}💡 Execute: ./setup-wif.sh $PROJECT_ID${NC}"
else
    echo -e "${GREEN}✅ Pools encontrados:${NC}"
    echo "$POOLS" | while read pool; do
        echo -e "   📁 $pool"
    done
fi

echo ""

# 3. Verificar Providers específicos
echo -e "${YELLOW}3. Verificando Provider github-provider...${NC}"
if gcloud iam workload-identity-pools providers describe github-provider \
   --workload-identity-pool=github-pool \
   --location=global &>/dev/null; then
    echo -e "${GREEN}✅ Provider github-provider encontrado${NC}"
    
    # Mostrar configuração do provider
    echo -e "${BLUE}📋 Configuração do Provider:${NC}"
    gcloud iam workload-identity-pools providers describe github-provider \
        --workload-identity-pool=github-pool \
        --location=global \
        --format="table(name,oidc.issuerUri,attributeMapping)"
else
    echo -e "${RED}❌ Provider github-provider não encontrado${NC}"
    echo -e "${BLUE}💡 Execute: ./setup-wif.sh $PROJECT_ID${NC}"
fi

echo ""

# 4. Verificar Service Accounts
echo -e "${YELLOW}4. Verificando Service Account github-actions-sa...${NC}"
if gcloud iam service-accounts describe github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com &>/dev/null; then
    echo -e "${GREEN}✅ Service Account encontrado${NC}"
    echo -e "   👤 github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com"
    
    # Verificar IAM bindings
    echo -e "${BLUE}🔐 Verificando permissões...${NC}"
    gcloud iam service-accounts get-iam-policy github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com \
        --format="table(bindings[].members,bindings[].role)" 2>/dev/null || echo "   ⚠️  Sem policies específicas"
else
    echo -e "${RED}❌ Service Account github-actions-sa não encontrado${NC}"
    echo -e "${BLUE}💡 Execute: ./setup-wif.sh $PROJECT_ID${NC}"
fi

echo ""

# 5. Mostrar valores corretos para os secrets
echo -e "${YELLOW}5. Valores corretos para os Secrets do GitHub:${NC}"
echo ""
echo -e "${GREEN}🔑 WIF_PROVIDER:${NC}"
echo "projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/providers/github-provider"
echo ""
echo -e "${GREEN}👤 WIF_SERVICE_ACCOUNT:${NC}"
echo "github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com"
echo ""

# 6. Verificar APIs habilitadas
echo -e "${YELLOW}6. Verificando APIs necessárias...${NC}"
REQUIRED_APIS=(
    "iam.googleapis.com"
    "iamcredentials.googleapis.com"
    "cloudresourcemanager.googleapis.com"
)

for api in "${REQUIRED_APIS[@]}"; do
    if gcloud services list --enabled --filter="name:$api" --format="value(name)" | grep -q "$api"; then
        echo -e "${GREEN}✅ $api habilitada${NC}"
    else
        echo -e "${RED}❌ $api não habilitada${NC}"
        echo -e "${BLUE}💡 Execute: gcloud services enable $api${NC}"
    fi
done

echo ""
echo -e "${BLUE}📍 Configure os secrets em: https://github.com/$REPO/settings/secrets/actions${NC}"