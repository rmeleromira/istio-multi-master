#!/bin/bash
source ./vars.sh
gcloud container clusters list
kubectl config use-context $context
kubectl get pods --all-namespaces
kubectl config use-context $context2
kubectl get pods --all-namespaces