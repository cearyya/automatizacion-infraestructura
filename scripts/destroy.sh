#!/bin/bash

set -e

echo "========================================"
echo " DESTRUCCIÓN DE INFRAESTRUCTURA"
echo "========================================"

cd "$(dirname "$0")/../terraform"

echo "[1/2] Verificando configuración..."
terraform validate

echo ""
echo "[2/2] Destruyendo infraestructura..."
terraform destroy -auto-approve

echo ""
echo "========================================"
echo " INFRAESTRUCTURA DESTRUIDA"
echo "========================================"

