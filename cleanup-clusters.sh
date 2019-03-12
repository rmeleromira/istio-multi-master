#!/bin/bash

gcloud compute firewall-rules delete istio-multicluster-test-pods --quiet
kubectl delete clusterrolebinding gke-cluster-admin-binding
echo Y | gcloud container clusters delete cluster-1 --zone europe-west1-b
echo Y | gcloud container clusters delete cluster-2 --zone southamerica-east1-b
