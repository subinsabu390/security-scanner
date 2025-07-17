#!/bin/bash

POPEYE_REPORT_DIR=$(pwd) popeye --save --out html --output-file popeye-report.html

az storage blob upload --account-name $STORAGE_ACCOUNT --container-name $CONTAINER_NAME \
  --file "popeye-report.html" --name "security-scan/$(date +'%d-%m-%Y')/popeye-report.html" \
  --account-key "$AZURE_STORAGE_KEY" --overwrite