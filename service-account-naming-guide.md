# Google Cloud Service Account Naming Examples

## ❌ **INCORRECT Examples (Will cause errors):**

```terraform
# Using underscores (NOT ALLOWED)
service_account_name = "my_service_dev_sa"     # ❌ Contains underscores
service_account_name = "Service-Name-Dev-SA"  # ❌ Contains uppercase
service_account_name = "service-name-dev-sa-with-very-long-name-that-exceeds-limits" # ❌ Too long (>30 chars)
service_account_name = "123-service-dev-sa"   # ❌ Starts with number
service_account_name = "-service-dev-sa"      # ❌ Starts with hyphen
service_account_name = "service-dev-sa-"      # ❌ Ends with hyphen
```

## ✅ **CORRECT Examples:**

```terraform
# Basic format
service_account_name = "my-service-dev-sa"    # ✅ Good
service_account_name = "app-dev-sa"           # ✅ Good  
service_account_name = "web-api-prod-sa"      # ✅ Good
service_account_name = "github-actions-sa"    # ✅ Good

# Using variables (recommended)
service_account_name = "${var.service_name}-${var.environment}-sa"

# Example variable values:
# var.service_name = "my-app"     (no underscores!)
# var.environment = "dev"
# Result: "my-app-dev-sa" ✅
```

## 🔧 **For your terraform.tfvars.json:**

```json
{
  "service_name": "my-app",        // ✅ Use hyphens, not underscores
  "service_name": "web-api",       // ✅ Good
  "service_name": "backend-svc",   // ✅ Good
  "service_name": "frontend",      // ✅ Good
}
```

## 📋 **Google Cloud Service Account Name Rules:**

1. **Length**: 6-30 characters
2. **Start**: Must start with lowercase letter (a-z)
3. **End**: Must end with lowercase letter or number
4. **Characters**: Only lowercase letters, numbers, and hyphens (-)
5. **No**: Underscores (_), uppercase letters, or special characters
6. **Pattern**: `^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$`

## 🎯 **Recommended Pattern:**

```
[service-name]-[environment]-sa
```

Examples:
- `my-app-dev-sa`
- `web-api-prod-sa` 
- `auth-service-staging-sa`
- `data-pipeline-test-sa`

## 🔄 **Fix in your tfvars.json:**

```json
{
  "project_id": "your-gcp-project",
  "service_name": "my-app",           // ← Change from "my_app" to "my-app"
  "repository_id": "docker-repo",
  "region": "us-central1"
}
```