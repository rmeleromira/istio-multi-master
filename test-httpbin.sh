#!/bin/bash

kubectl config use-context gke_istio-234002_europe-west1-b_cluster-1
export SLEEP_POD=$(kubectl get -n foo pod -l app=sleep -o jsonpath={.items..metadata.name})
kubectl exec $SLEEP_POD -n foo -c sleep -- curl -I httpbin.bar.global:8000/headers