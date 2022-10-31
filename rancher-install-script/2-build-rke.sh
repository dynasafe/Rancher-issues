#! /bin/bash
set -e

echo -e "\nStep1. Start build rke"
echo "============================================================================="
rke up --config install-config.yaml

echo -e "\nStep2. Check cluster"
echo "============================================================================="
mkdir ~/.kube
mv kube_config_install-config.yaml ~/.kube/config
chmod 400 ~/.kube/config

kubectl get node 