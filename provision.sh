#!/bin/bash
set -x
source ./vars.sh
gcloud container clusters create cluster-1 --zone $zone --username "admin" \
--cluster-version "1.12.5-gke.10" --machine-type "n1-standard-2" --image-type "COS" --disk-size "50" \
--scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only",\
"https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring",\
"https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly",\
"https://www.googleapis.com/auth/trace.append" \
--num-nodes "3" --network "default" --enable-cloud-logging --enable-cloud-monitoring --enable-ip-alias --no-enable-autorepair --async


gcloud container clusters create cluster-2 --zone $zone2 --username "admin" \
--cluster-version "1.12.5-gke.10" --machine-type "n1-standard-2" --image-type "COS" --disk-size "50" \
--scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only",\
"https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring",\
"https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly",\
"https://www.googleapis.com/auth/trace.append" \
--num-nodes "3" --network "default" --enable-cloud-logging --enable-cloud-monitoring --enable-ip-alias --no-enable-autorepair

gcloud container clusters get-credentials cluster-1 --zone $zone
gcloud container clusters get-credentials cluster-2 --zone $zone2
kubectl config use-context $context
kubectl create clusterrolebinding gke-cluster-admin-binding --clusterrole=cluster-admin --user="$user"
kubectl config use-context $context2
kubectl create clusterrolebinding gke-cluster-admin-binding --clusterrole=cluster-admin --user="$user"
source ./vars.sh
gcloud compute firewall-rules create istio \
  --allow=tcp,udp,icmp,esp,ah,sctp \
  --direction=INGRESS \
  --priority=900 \
  --source-ranges="${ALL_CLUSTER_CIDRS}" \
  --target-tags="${ALL_CLUSTER_NETTAGS}" --quiet