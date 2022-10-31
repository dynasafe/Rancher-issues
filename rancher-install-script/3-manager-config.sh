#! /bin/bash
set -e

echo -e "\nStep1. Config helm repo"
echo "============================================================================="
helm repo add jetstack https://charts.jetstack.io

echo -e "\nStep2. Install cert-manager"
echo "============================================================================="
kubectl create namespace cert-manager

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager --version v1.7.1

echo -e "\nStep4. Install rancher"
echo "============================================================================="
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

kubectl create namespace cattle-system

helm upgrade --install rancher rancher-latest/rancher \
   --namespace cattle-system \
   --set hostname=rancher.cnsdomain.com \
   --set replicas=1 \
   --set ingress.tls.source=letsEncrypt 