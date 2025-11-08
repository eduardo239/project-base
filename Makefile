.PHONY: help fmt validate plan apply unlock-dev unlock-prod clean

# Default environment
ENV ?= dev

help: ## Show this help message
	@echo "Terraform Management Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Environment Variables:"
	@echo "  ENV=dev|prod    Target environment (default: dev)"

fmt: ## Format all Terraform files
	@echo "🎨 Formatting Terraform files..."
	terraform fmt -recursive .
	@echo "✅ Formatting completed"

validate: ## Validate Terraform configuration for specified environment
	@echo "🔍 Validating Terraform configuration for $(ENV)..."
	cd terraform/environments/$(ENV) && \
		terraform init -upgrade && \
		terraform validate
	@echo "✅ Validation completed for $(ENV)"

plan: ## Run terraform plan for specified environment
	@echo "📋 Running Terraform plan for $(ENV)..."
	cd terraform/environments/$(ENV) && \
		terraform init -upgrade && \
		terraform plan -out=tfplan
	@echo "✅ Plan completed for $(ENV)"

apply: ## Apply terraform plan for specified environment (requires confirmation)
	@echo "🚀 Applying Terraform plan for $(ENV)..."
	@read -p "Are you sure you want to apply changes to $(ENV)? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		cd terraform/environments/$(ENV) && terraform apply tfplan; \
		echo "✅ Apply completed for $(ENV)"; \
	else \
		echo "❌ Apply cancelled"; \
	fi

unlock-dev: ## Force unlock Terraform state for dev environment
	@echo "🔓 Unlocking Terraform state for dev..."
	./scripts/terraform-unlock.sh dev force

unlock-prod: ## Force unlock Terraform state for prod environment
	@echo "🔓 Unlocking Terraform state for prod..."
	./scripts/terraform-unlock.sh prod force

clean: ## Clean up Terraform temporary files
	@echo "🧹 Cleaning up Terraform files..."
	find . -type f -name "*.tfplan" -delete
	find . -type f -name "terraform.tfstate.backup" -delete
	find . -type f -name ".terraform.lock.hcl" -delete
	find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Cleanup completed"

# Environment-specific shortcuts
plan-dev: ## Run plan for dev environment
	$(MAKE) plan ENV=dev

plan-prod: ## Run plan for prod environment
	$(MAKE) plan ENV=prod

apply-dev: ## Apply for dev environment
	$(MAKE) apply ENV=dev

apply-prod: ## Apply for prod environment
	$(MAKE) apply ENV=prod