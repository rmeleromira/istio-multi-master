#!/bin/bash 
kubectl delete -f <(istioctl kube-inject -f app/Deployment.yaml)
kubectl delete -f <(istioctl kube-inject -f app/Service.yaml)
kubectl delete -f <(istioctl kube-inject -f app/ConfigMap.yaml)
kubectl delete -f <(istioctl kube-inject -f app/Ingress.yaml)