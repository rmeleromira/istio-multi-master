#!/bin/bash
set -x
source ./vars.sh

if [ -d istio ]; then
  cd istio
else
  git clone git@github.com:istio/istio.git
  cd istio
  git checkout release-1.1
fi

cat install/kubernetes/helm/istio-init/files/crd-* > ../istio.yaml
helm template install/kubernetes/helm/istio --name istio --namespace istio-system \
    -f install/kubernetes/helm/istio/example-values/values-istio-multicluster-gateways.yaml >> ../istio.yaml
kubectl config use-context $context
kubectl create ns istio-system
kubectl create secret generic cacerts -n istio-system \
    --from-file=samples/certs/ca-cert.pem \
    --from-file=samples/certs/ca-key.pem \
    --from-file=samples/certs/root-cert.pem \
    --from-file=samples/certs/cert-chain.pem
kubectl apply -f ../istio.yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {"global": ["$(kubectl get svc -n istio-system istiocoredns -o jsonpath={.spec.clusterIP})"]}
EOF
kubectl label namespace default istio-injection=enabled --overwrite

kubectl config use-context $context2
kubectl create ns istio-system
kubectl create secret generic cacerts -n istio-system \
    --from-file=samples/certs/ca-cert.pem \
    --from-file=samples/certs/ca-key.pem \
    --from-file=samples/certs/root-cert.pem \
    --from-file=samples/certs/cert-chain.pem
kubectl apply -f ../istio.yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {"global": ["$(kubectl get svc -n istio-system istiocoredns -o jsonpath={.spec.clusterIP})"]}
EOF
kubectl label namespace default istio-injection=enabled --overwrite