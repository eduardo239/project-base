# Using terraform.tfvars.json in GitHub Secrets

## 🔧 **Option 1: Single tfvars.json Secret (Current Implementation)**

### GitHub Secret Configuration:

- **Name**: `TFVARS_JSON`
- **Value**: Complete JSON content for all environments

### Example JSON Content:

```json
{
  "project_id": "my-gcp-project",
  "service_name": "my-app",
  "repository_id": "my-repo",
  "region": "us-central1",
  "cpu_limit": "1",
  "memory_limit": "512Mi",
  "min_instances": 1,
  "max_instances": 10,
  "environment_variables": {
    "NODE_ENV": "production",
    "API_URL": "https://api.example.com"
  },
  "allow_unauthenticated": true
}
```

## 🎯 **Option 2: Environment-Specific Secrets**

Update the workflow to use different secrets per environment:

```yaml
- name: Create terraform.tfvars.json
  working-directory: terraform/environments/${{ matrix.environment }}
  run: |
    if [ "${{ matrix.environment }}" = "dev" ]; then
      echo '${{ secrets.TFVARS_DEV_JSON }}' > terraform.tfvars.json
    elif [ "${{ matrix.environment }}" = "prod" ]; then
      echo '${{ secrets.TFVARS_PROD_JSON }}' > terraform.tfvars.json
    fi
```

### Required Secrets:

- `TFVARS_DEV_JSON` - Development environment variables
- `TFVARS_PROD_JSON` - Production environment variables

## 🔒 **Option 3: Individual Variable Secrets**

For maximum security, store sensitive values separately:

```yaml
- name: Create terraform.tfvars.json
  working-directory: terraform/environments/${{ matrix.environment }}
  run: |
    cat << EOF > terraform.tfvars.json
    {
      "project_id": "${{ secrets.GCP_PROJECT_ID }}",
      "service_name": "${{ secrets.SERVICE_NAME }}",
      "repository_id": "${{ secrets.REPOSITORY_ID }}",
      "region": "us-central1",
      "cpu_limit": "${{ matrix.environment == 'prod' && '2' || '1' }}",
      "memory_limit": "${{ matrix.environment == 'prod' && '1Gi' || '512Mi' }}",
      "min_instances": ${{ matrix.environment == 'prod' && 2 || 1 }},
      "max_instances": ${{ matrix.environment == 'prod' && 20 || 5 }},
      "environment_variables": {
        "NODE_ENV": "${{ matrix.environment }}",
        "DATABASE_URL": "${{ secrets.DATABASE_URL }}",
        "API_KEY": "${{ secrets.API_KEY }}"
      },
      "allow_unauthenticated": ${{ matrix.environment == 'dev' && 'true' || 'false' }}
    }
    EOF
```

## 🛡️ **Option 4: Base64 Encoded (Most Secure)**

For special characters and guaranteed encoding:

```yaml
- name: Create terraform.tfvars.json
  working-directory: terraform/environments/${{ matrix.environment }}
  run: echo '${{ secrets.TFVARS_JSON_BASE64 }}' | base64 -d > terraform.tfvars.json
```

### To create the secret:

```bash
# Encode your JSON file
base64 -w 0 terraform.tfvars.json
# Copy the output to GitHub secret: TFVARS_JSON_BASE64
```

## 📋 **Required GitHub Secrets Setup**

1. Go to: `https://github.com/eduardo239/project-base/settings/secrets/actions`
2. Click "New repository secret"
3. Add the required secrets based on your chosen option

### For Option 1 (Current):

- **`GCP_SA_KEY`**: Service account JSON key
- **`TFVARS_JSON`**: Complete terraform variables JSON

### Example TFVARS_JSON for dev environment:

```json
{
  "project_id": "my-project-dev",
  "service_name": "my-app",
  "repository_id": "my-repo",
  "region": "us-central1",
  "cpu_limit": "1",
  "memory_limit": "512Mi",
  "min_instances": 1,
  "max_instances": 5,
  "environment_variables": {
    "NODE_ENV": "development",
    "DEBUG": "true"
  },
  "allow_unauthenticated": true
}
```

### Example TFVARS_JSON for prod environment:

```json
{
  "project_id": "my-project-prod",
  "service_name": "my-app",
  "repository_id": "my-repo",
  "region": "us-central1",
  "cpu_limit": "2",
  "memory_limit": "1Gi",
  "min_instances": 2,
  "max_instances": 20,
  "environment_variables": {
    "NODE_ENV": "production",
    "DEBUG": "false"
  },
  "allow_unauthenticated": false
}
```

## ✅ **Benefits of This Approach**

✅ **Secure**: Sensitive values not in repository  
✅ **Flexible**: Easy to change without code changes  
✅ **Environment-specific**: Different values per environment  
✅ **No files in repo**: No risk of committing secrets

## 🔄 **File Cleanup**

The `terraform.tfvars.json` file is created temporarily and removed after the GitHub Actions job completes, ensuring no secrets remain in the runner.
