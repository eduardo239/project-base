#!/bin/bash

# Setup script for pre-commit hooks and development tools
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Setting up development environment...${NC}"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 is required but not installed.${NC}"
    exit 1
fi

# Check if pip is installed
if ! command -v pip &> /dev/null && ! command -v pip3 &> /dev/null; then
    echo -e "${RED}❌ pip is required but not installed.${NC}"
    exit 1
fi

# Install pre-commit if not already installed
echo -e "${YELLOW}📦 Installing pre-commit...${NC}"
if command -v pip3 &> /dev/null; then
    pip3 install pre-commit
else
    pip install pre-commit
fi

# Install terraform-docs if not already installed (optional)
if ! command -v terraform-docs &> /dev/null; then
    echo -e "${YELLOW}📦 Installing terraform-docs (optional)...${NC}"
    
    # Detect OS and install terraform-docs
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
        tar -xzf terraform-docs.tar.gz
        chmod +x terraform-docs
        sudo mv terraform-docs /usr/local/bin/
        rm terraform-docs.tar.gz
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OS
        if command -v brew &> /dev/null; then
            brew install terraform-docs
        else
            echo -e "${YELLOW}⚠️  Install Homebrew first, then run: brew install terraform-docs${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Please install terraform-docs manually from: https://terraform-docs.io/user-guide/installation/${NC}"
    fi
fi

# Install pre-commit hooks
echo -e "${YELLOW}🔧 Installing pre-commit hooks...${NC}"
pre-commit install
pre-commit install --hook-type pre-push

# Run pre-commit on all files to ensure everything works
echo -e "${YELLOW}✅ Running pre-commit on all files...${NC}"
pre-commit run --all-files || true

echo -e "${GREEN}✅ Development environment setup completed!${NC}"
echo ""
echo -e "${BLUE}📋 What was installed:${NC}"
echo -e "  • Pre-commit hooks (runs on git commit)"
echo -e "  • Pre-push hooks (runs on git push)"
echo -e "  • Terraform fmt (auto-format .tf files)"
echo -e "  • Terraform validate (validate configurations)"
echo -e "  • YAML/JSON syntax checking"
echo -e "  • Trailing whitespace removal"
echo ""
echo -e "${BLUE}🎯 Usage:${NC}"
echo -e "  • ${GREEN}make help${NC}           - Show available commands"
echo -e "  • ${GREEN}make fmt${NC}            - Format Terraform files"
echo -e "  • ${GREEN}make validate${NC}       - Validate Terraform files"
echo -e "  • ${GREEN}make check${NC}          - Format + validate"
echo -e "  • ${GREEN}git commit${NC}          - Automatically runs pre-commit hooks"
echo -e "  • ${GREEN}git push${NC}            - Automatically runs pre-push hooks"
echo ""
echo -e "${YELLOW}💡 Tip: Use 'git commit --no-verify' to skip hooks if needed${NC}"