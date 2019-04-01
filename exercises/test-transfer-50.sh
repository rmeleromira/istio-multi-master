#!/bin/bash

set -x
source ./vars.sh

kubectl config use-context $context
export CLUSTER1_GW_ADDR=$(kubectl get svc --selector=app=istio-ingressgateway \
    -n istio-system -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
    
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: 
spec:
  hosts:
  - reviews.default.global
  location: MESH_INTERNAL
  ports:
  - name: http1
    number: 9080
    protocol: http
  resolution: DNS
  addresses:
  - 127.255.0.3
  endpoints:
  - address: ${CLUSTER2_GW_ADDR}
    labels:
      cluster: cluster2
    ports:
      http1: 15443 # Do not change this port value
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: reviews-global
spec:
  host: reviews.default.global
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
  subsets:
  - name: v2
    labels:
      cluster: cluster2
  - name: v3
    labels:
      cluster: cluster2
EOF
    
kubectl config use-context $context2
export CLUSTER2_GW_ADDR=$(kubectl get svc --selector=app=istio-ingressgateway \
    -n istio-system -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")