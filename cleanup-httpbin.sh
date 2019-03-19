#!/bin/bash

kubectl config use-context gke_istio-234002_europe-west1-b_cluster-1
kubectl delete -n foo -f istio/samples/sleep/sleep.yaml
kubectl delete -n foo serviceentry httpbin-bar
kubectl delete ns foo

kubectl config use-context gke_istio-234002_southamerica-east1-b_cluster-2
kubectl delete -n bar -f istio/samples/httpbin/httpbin.yaml
kubectl delete ns bar

# source ./vars.sh
# cd istio
# 
# kubectl config use-context $context
# kubectl delete -f samples/sleep/sleep.yaml
# 
# 
# kubectl config use-context $context2
# kubectl delete -f samples/httpbin/httpbin.yaml