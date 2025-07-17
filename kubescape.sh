#!/bin/bash

# Run Kubescape scan for workloads
kubescape scan -v --format html --output kubescape/kubescape-report.html
kubescape scan framework DevOpsBest -v --format html --output kubescape/kubescape-devopsbest.html
kubescape scan framework cis-aks-t1.2.0 -v --format html --output kubescape/kubescape-cis.html



# Upload all reports to Azure Blob Storage
az storage blob upload-batch --account-name "$STORAGE_ACCOUNT" --destination "$CONTAINER_NAME/security-scan/$(date +'%d-%m-%Y')" \
  --source . --pattern "kubescape/kubescape-*.html" --account-key "$AZURE_STORAGE_KEY" --overwrite

echo "All reports uploaded successfully!"
