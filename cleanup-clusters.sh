#!/bin/bash
set -x
source ./vars.sh
gcloud compute firewall-rules delete istio --quiet
kubectl config use-context $context
kubectl delete clusterrolebinding gke-cluster-admin-binding
kubectl config use-context $context2
kubectl delete clusterrolebinding gke-cluster-admin-binding
echo Y | gcloud container clusters delete cluster-1 --zone europe-west1-b
echo Y | gcloud container clusters delete cluster-2 --zone southamerica-east1-b
