#!/bin/bash

# Convert between .tfvars and .tfvars.json formats
# Usage: ./convert-tfvars.sh [tfvars-to-json|json-to-tfvars] <input-file> <output-file>

convert_tfvars_to_json() {
    local input_file="$1"
    local output_file="$2"
    
    echo "Converting $input_file to JSON format..."
    
    # Create JSON object start
    echo "{" > "$output_file"
    
    # Process each line in the tfvars file
    local first_line=true
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        
        # Extract variable name and value
        if [[ "$line" =~ ^[[:space:]]*([^=]+)[[:space:]]*=[[:space:]]*(.+)$ ]]; then
            var_name="${BASH_REMATCH[1]// /}"
            var_value="${BASH_REMATCH[2]}"
            
            # Remove leading/trailing whitespace from value
            var_value=$(echo "$var_value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            
            # Add comma if not first line
            if [ "$first_line" = false ]; then
                echo "," >> "$output_file"
            fi
            first_line=false
            
            # Write JSON key-value pair (without trailing comma for last item)
            echo -n "  \"$var_name\": $var_value" >> "$output_file"
        fi
    done < "$input_file"
    
    # Close JSON object
    echo "" >> "$output_file"
    echo "}" >> "$output_file"
    
    echo "✅ Conversion complete: $output_file"
}

convert_json_to_tfvars() {
    local input_file="$1"
    local output_file="$2"
    
    echo "Converting $input_file to .tfvars format..."
    
    # Add header comment
    echo "# Terraform Variables File (converted from JSON)" > "$output_file"
    echo "# Generated on $(date)" >> "$output_file"
    echo "" >> "$output_file"
    
    # Use Python to parse JSON and convert to tfvars format
    python3 -c "
import json
import sys

try:
    with open('$input_file', 'r') as f:
        data = json.load(f)
    
    with open('$output_file', 'a') as f:
        for key, value in data.items():
            if isinstance(value, str):
                f.write(f'{key} = \"{value}\"\n')
            elif isinstance(value, bool):
                f.write(f'{key} = {str(value).lower()}\n')
            elif isinstance(value, (int, float)):
                f.write(f'{key} = {value}\n')
            elif isinstance(value, list):
                # Handle arrays
                items = ', '.join([f'\"{item}\"' if isinstance(item, str) else str(item) for item in value])
                f.write(f'{key} = [{items}]\n')
            else:
                f.write(f'{key} = {json.dumps(value)}\n')
except Exception as e:
    print(f'Error: {e}')
    sys.exit(1)
"
    
    echo "✅ Conversion complete: $output_file"
}

# Main script logic
case "$1" in
    "tfvars-to-json")
        if [[ -z "$2" || -z "$3" ]]; then
            echo "Usage: $0 tfvars-to-json <input.tfvars> <output.tfvars.json>"
            exit 1
        fi
        convert_tfvars_to_json "$2" "$3"
        ;;
    "json-to-tfvars")
        if [[ -z "$2" || -z "$3" ]]; then
            echo "Usage: $0 json-to-tfvars <input.tfvars.json> <output.tfvars>"
            exit 1
        fi
        convert_json_to_tfvars "$2" "$3"
        ;;
    *)
        echo "Usage: $0 [tfvars-to-json|json-to-tfvars] <input-file> <output-file>"
        echo ""
        echo "Examples:"
        echo "  $0 tfvars-to-json terraform.tfvars terraform.tfvars.json"
        echo "  $0 json-to-tfvars terraform.tfvars.json terraform.tfvars"
        exit 1
        ;;
esac