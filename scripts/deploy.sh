#!/bin/bash

set -e

echo "========================================"
echo " DESPLIEGUE DE INFRAESTRUCTURA"
echo "========================================"

cd "$(dirname "$0")/../terraform"

echo "[1/3] Inicializando Terraform..."
terraform init

echo "[2/3] Validando configuración..."
terraform validate

echo "[3/3] Aplicando infraestructura..."
terraform apply -auto-approve

echo ""
echo "========================================"
echo " INFRAESTRUCTURA DESPLEGADA"
echo "========================================"

terraform output

