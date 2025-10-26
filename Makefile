.PHONY: help install-hooks fmt validate plan apply clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install-hooks: ## Install pre-commit hooks
	@echo "Installing pre-commit hooks..."
	@command -v pre-commit >/dev/null 2>&1 || { echo "Installing pre-commit..."; pip install pre-commit; }
	@pre-commit install
	@pre-commit install --hook-type pre-push
	@echo "✅ Pre-commit hooks installed successfully!"

fmt: ## Format all Terraform files
	@echo "Formatting Terraform files..."
	@find . -name "*.tf" -not -path "./.terraform/*" -exec terraform fmt {} \;
	@echo "✅ Terraform formatting completed!"

validate: ## Validate all Terraform configurations  
	@echo "Validating Terraform configurations..."
	@for dir in $$(find . -name "*.tf" -exec dirname {} \; | sort -u | grep -v ".terraform"); do \
		echo "Validating $$dir..."; \
		(cd "$$dir" && terraform init -backend=false >/dev/null 2>&1 && terraform validate) || exit 1; \
	done
	@echo "✅ Terraform validation completed!"

plan-dev: ## Run terraform plan for dev environment
	@cd terraform/environments/dev && terraform plan

plan-prod: ## Run terraform plan for prod environment  
	@cd terraform/environments/prod && terraform plan

apply-dev: ## Run terraform apply for dev environment
	@cd terraform/environments/dev && terraform apply

apply-prod: ## Run terraform apply for prod environment
	@cd terraform/environments/prod && terraform apply

clean: ## Clean Terraform cache files
	@echo "Cleaning Terraform cache files..."
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.tfstate*" -not -path "./terraform/environments/*" -delete 2>/dev/null || true
	@find . -name ".terraform.lock.hcl" -not -path "./terraform/environments/*" -delete 2>/dev/null || true
	@echo "✅ Terraform cache cleaned!"

setup: install-hooks fmt validate ## Complete project setup (hooks + format + validate)
	@echo "🚀 Project setup completed successfully!"

pre-commit-all: ## Run pre-commit on all files
	@pre-commit run --all-files

check: fmt validate ## Quick format and validate check
	@echo "✅ All checks passed!"