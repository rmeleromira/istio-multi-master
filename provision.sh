#!/bin/bash
set -x



gcloud container clusters create cluster-1 --zone $zone --username "admin" \
--cluster-version "1.11.7-gke.4" --machine-type "n1-standard-1" --image-type "COS" --disk-size "50" \
--scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only",\
"https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring",\
"https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly",\
"https://www.googleapis.com/auth/trace.append" \
--num-nodes "3" --network "default" --enable-cloud-logging --enable-cloud-monitoring --enable-ip-alias --no-enable-autorepair --async


gcloud container clusters create cluster-2 --zone $zone2 --username "admin" \
--cluster-version "1.11.7-gke.4" --machine-type "n1-standard-1" --image-type "COS" --disk-size "50" \
--scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only",\
"https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring",\
"https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly",\
"https://www.googleapis.com/auth/trace.append" \
--num-nodes "3" --network "default" --enable-cloud-logging --enable-cloud-monitoring --enable-ip-alias --no-enable-autorepair

gcloud container clusters list

gcloud container clusters get-credentials cluster-1 --zone $zone
gcloud container clusters get-credentials cluster-2 --zone $zone2
kubectl config use-context "gke_{$project}_{$zone_}cluster-1"
kubectl get pods --all-namespaces

kubectl create clusterrolebinding gke-cluster-admin-binding --clusterrole=cluster-admin --user="$user"

kubectl config use-context "gke_{$project}_{$zone2}_cluster-2"
kubectl get pods --all-namespaces

kubectl create clusterrolebinding gke-cluster-admin-binding --clusterrole=cluster-admin --user="$user"
