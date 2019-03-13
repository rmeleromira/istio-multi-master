#!/bin/bash
kubectl apply -f <(istioctl kube-inject -f app/ConfigMap.yaml)
sleep 5
kubectl apply -f <(istioctl kube-inject -f app/Deployment.yaml)
sleep 5
kubectl apply -f <(istioctl kube-inject -f app/Service.yaml)
sleep 5
kubectl apply -f <(istioctl kube-inject -f app/Ingress.yaml)