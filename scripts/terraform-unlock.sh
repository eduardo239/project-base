#!/bin/bash

# Terraform Lock Management Script
# Usage: ./scripts/terraform-unlock.sh [dev|prod] [force]

set -e

ENVIRONMENT=${1:-dev}
FORCE=${2:-false}

if [[ ! "$ENVIRONMENT" =~ ^(dev|prod)$ ]]; then
    echo "❌ Invalid environment. Use 'dev' or 'prod'"
    exit 1
fi

TERRAFORM_DIR="terraform/environments/$ENVIRONMENT"

if [ ! -d "$TERRAFORM_DIR" ]; then
    echo "❌ Directory $TERRAFORM_DIR not found"
    exit 1
fi

cd "$TERRAFORM_DIR"

echo "🔍 Checking Terraform state locks for environment: $ENVIRONMENT"
echo "📁 Working directory: $(pwd)"

# Initialize if needed
if [ ! -d ".terraform" ]; then
    echo "🚀 Initializing Terraform..."
    terraform init
fi

# Check current state
echo "📊 Current state status:"
terraform show -json 2>/dev/null | jq -r '.lock_id // "No active locks"' || echo "No state information available"

# List any terraform processes
echo "🔍 Active terraform processes:"
ps aux | grep terraform | grep -v grep || echo "No terraform processes found"

# Check for lock files
echo "🔍 Checking for lock files:"
find . -name "*.tfstate.lock*" -ls || echo "No lock files found"

if [ "$FORCE" = "force" ]; then
    echo "⚠️  Force unlock requested..."

    # Get lock ID if exists
    LOCK_ID=$(terraform show -json 2>/dev/null | jq -r '.lock_id // empty' 2>/dev/null || echo "")

    if [ ! -z "$LOCK_ID" ]; then
        echo "🔓 Forcing unlock of lock ID: $LOCK_ID"
        terraform force-unlock -force "$LOCK_ID" || true
    else
        echo "ℹ️  No lock ID found to unlock"
    fi

    # Clean up any local lock files
    find . -name "*.tfstate.lock*" -delete 2>/dev/null || true

    echo "✅ Force unlock completed"
else
    echo "ℹ️  To force unlock, run: $0 $ENVIRONMENT force"
fi

echo "✅ Lock check completed for $ENVIRONMENT environment"