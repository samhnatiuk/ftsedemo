#!/bin/bash
. .env

config_data=$(jq '.' "$CONFIG_FILE")
resource_group=$(echo "$config_data" | jq -r '.resource_group')
workspace_name=$(echo "$config_data" | jq -r '.workspace_name')

secret=$(az ml online-endpoint get-credentials -g $resource_group --n $ep_name -w $workspace_name)

#headers
content_type="Content-Type: application/json"
authorization="Authorization: Bearer $secret"
deployment_header="azureml-model-deployment: $deployment_name"

az ml online-endpoint invoke --name "$ENDPOINT_NAME" --deployment "$deployment_name" --request-file "$input_path" > "$output_path"