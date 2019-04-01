#!/bin/bash

set -x
source ./vars.sh

if [ -d microservices-demo ]; then
  cd microservices-demo
else
  git clone https://github.com/microservices-demo/microservices-demo
  cd microservices-demo
fi

if [ ! -f ../sock-shop-patch.applied ]; then
  git apply ../microservices-demo.patch
  touch ../sock-shop-patch.applied
fi

kubectl config use-context $context
kubectl apply -f deploy/kubernetes/manifests/sock-shop-ns.yaml
kubectl apply -f ../istio.patch
kubectl label namespace sock-shop istio-injection=enabled
kubectl apply -f deploy/kubernetes/complete-demo.yaml
kubectl apply -f ../gateway.yml
kubectl apply -f ../cluster-1-service-entries.yml


kubectl config use-context $context2
kubectl apply -f deploy/kubernetes/manifests/sock-shop-ns.yaml
kubectl apply -f ../istio.patch
kubectl label namespace sock-shop istio-injection=enabled
kubectl apply -f deploy/kubernetes/complete-demo.yaml
kubectl apply -f ../gateway.yml
kubectl apply -f ../cluster-2-service-entries.yml