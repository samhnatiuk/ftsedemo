#!/bin/bash

. .env

config_data=$(jq '.' "$CONFIG_FILE")
resource_group=$(echo "$config_data" | jq -r '.resource_group')
workspace_name=$(echo "$config_data" | jq -r '.workspace_name')

endpoint_yaml_content="\$schema: $SCHEMA_URL\nname: $ENDPOINT_NAME\nauth_mode: key"
echo -e "$endpoint_yaml_content" > endpoint.yaml

deploy_yaml_content=$(cat <<EOF
\$schema: $SCHEMA_URL
name: ftse100demodeployment
endpoint_name: $ENDPOINT_NAME
model:
  name: lstm
  version: 1
  path: models:/lstm/Production
  type: mlflow_model
instance_type: Standard_DS2_v2
instance_count: 1
EOF
)
echo "$deploy_yaml_data" > "deployment.yaml"

# Create endpoint
az ml online-endpoint create --name "$ep_name" -w "$workspace_name" -g "$resource_group" -f endpoint.yaml

# Create deployment for the endpoint
az ml online-deployment create -w "$workspace_name" -g "$resource_group" -f deployment.yaml --all-traffic