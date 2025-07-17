#!/bin/bash

set -e

# Define storage details
export REGISTRY=$(kubectl get secret dockerauth -o jsonpath='{.data.\.dockerconfigjson}' | base64 --decode | jq -r '.auths | keys[0]')
export USERNAME=$(kubectl get secret dockerauth -o jsonpath='{.data.\.dockerconfigjson}' | base64 --decode | jq -r '.auths."'$REGISTRY'".username')
export PASSWORD=$(kubectl get secret dockerauth -o jsonpath='{.data.\.dockerconfigjson}' | base64 --decode | jq -r '.auths."'$REGISTRY'".password')


# Get all deployments
DEPLOYMENTS=($(kubectl get deployments -o jsonpath="{.items[*].metadata.name}"))

# Download Trivy HTML template if not exists
TEMPLATE_PATH="html.tpl"
if [[ ! -f "$TEMPLATE_PATH" ]]; then
    echo "Downloading Trivy HTML template..."
    curl -sL -o "$TEMPLATE_PATH" https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl
fi

# Loop through deployments and scan each image
for DEPLOYMENT in "${DEPLOYMENTS[@]}"; do
  # Get the container image used in deployment
  IMAGE=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath="{.spec.template.spec.containers[0].image}")

  if [[ -n "$IMAGE" ]]; then
    echo "Scanning deployment: $DEPLOYMENT with image: $IMAGE"

    # Scan image with Trivy and output to an HTML report
    trivy image --username "$USERNAME" --password "$PASSWORD" --format template --template "@html.tpl" -o "trivy/trivy-${DEPLOYMENT}-report.html" "$IMAGE"
  else
    echo "No image found for deployment: $DEPLOYMENT"
  fi
done

# Upload all reports to Azure Blob Storage
echo "Uploading reports to Azure Blob Storage..."
az storage blob upload-batch --account-name "$STORAGE_ACCOUNT" --destination "$CONTAINER_NAME/security-scan/$(date +'%d-%m-%Y')" \
  --source . --pattern "trivy/trivy-*.html" --account-key "$AZURE_STORAGE_KEY" --overwrite

echo "All reports uploaded successfully!"

