#!/bin/bash

set -e

echo "========================================"
echo " VERIFICACIÓN DE INFRAESTRUCTURA"
echo "========================================"

echo ""
echo "[1/4] Verificando Terraform..."
cd "$(dirname "$0")/../terraform"
terraform validate

echo ""
echo "[2/4] Verificando contenedores Docker..."
docker ps --filter "name=infra-web" \
          --filter "name=infra-app" \
          --filter "name=infra-db" \
          --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "[3/4] Verificando infraestructura con Ansible..."
cd ../ansible
ansible-playbook playbooks/estado_infra.yml

echo ""
echo "[4/4] Verificando conectividad..."
ansible-playbook playbooks/pruebas_conectividad.yml

echo ""
echo "========================================"
echo " VERIFICACIÓN COMPLETADA"
echo "========================================"
