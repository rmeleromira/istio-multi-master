#!/bin/bash
set -x
source ./vars.sh
kubectl config use-context $context
kubectl delete -f istio.yaml
kubectl delete ns istio-system
kubectl label namespace default istio-injection=disabled --overwrite
kubectl config use-context $context2
kubectl delete -f istio.yaml
kubectl delete ns istio-system
kubectl label namespace default istio-injection=disabled --overwrite