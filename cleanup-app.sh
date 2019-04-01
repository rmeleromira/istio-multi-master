#!/bin/bash 
set -x
source ./vars.sh

cd microservices-demo

kubectl config use-context $context
kubectl delete -n sock-shop -f deploy/kubernetes/complete-demo.yaml
kubectl delete namespace sock-shop

kubectl config use-context $context2
kubectl delete -n sock-shop -f deploy/kubernetes/complete-demo.yaml
kubectl delete namespace sock-shop