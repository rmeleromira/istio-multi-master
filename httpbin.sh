#!/bin/bash

kubectl config use-context gke_istio-234002_europe-west1-b_cluster-1
kubectl create namespace foo
kubectl label namespace foo istio-injection=enabled --overwrite
kubectl apply -n foo -f istio/samples/sleep/sleep.yaml
export SLEEP_POD=$(kubectl get -n foo pod -l app=sleep -o jsonpath={.items..metadata.name})

kubectl config use-context gke_istio-234002_southamerica-east1-b_cluster-2
kubectl create namespace bar
kubectl label namespace bar istio-injection=enabled --overwrite
kubectl apply -n bar -f istio/samples/httpbin/httpbin.yaml


export CLUSTER2_GW_ADDR=$(kubectl get svc --selector=app=istio-ingressgateway \
    -n istio-system -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")


kubectl config use-context gke_istio-234002_europe-west1-b_cluster-1
kubectl apply -n foo -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: httpbin-bar
spec:
  hosts:
  # must be of form name.namespace.global
  - httpbin.bar.global
  location: MESH_INTERNAL
  ports:
  - name: http1
    number: 8000
    protocol: http
  resolution: DNS
  addresses:
  - 127.255.0.2
  endpoints:
  - address: ${CLUSTER2_GW_ADDR}
    network: external
    ports:
      http1: 15443 # Do not change this port value
  - address: istio-egressgateway.istio-system.svc.cluster.local
    ports:
      http1: 15443
EOF










# set -x
# source ./vars.sh
# cd istio
# 
# kubectl config use-context $context
# kubectl apply -f samples/sleep/sleep.yaml
# sleep 10
# export SLEEP_POD=$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})
# 
# 
# kubectl config use-context $context2
# kubectl apply -f samples/httpbin/httpbin.yaml
# sleep 10
# export CLUSTER2_GW_ADDR=$(kubectl get svc --selector=app=istio-ingressgateway \
#     -n istio-system -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
# 
# 
# 
# 
# 
# kubectl config use-context $context
# kubectl apply -f - <<EOF
# apiVersion: networking.istio.io/v1alpha3
# kind: ServiceEntry
# metadata:
#   name: httpbin-bar
# spec:
#   hosts:
#   # must be of form name.namespace.global
#   - httpbin.bar.global
#   # Treat remote cluster services as part of the service mesh
#   # as all clusters in the service mesh share the same root of trust.
#   location: MESH_INTERNAL
#   ports:
#   - name: http1
#     number: 8000
#     protocol: http
#   resolution: DNS
#   addresses:
#   # the IP address to which httpbin.bar.global will resolve to
#   # must be unique for each remote service, within a given cluster.
#   # This address need not be routable. Traffic for this IP will be captured
#   # by the sidecar and routed appropriately.
#   - 127.255.0.2
#   endpoints:
#   # This is the routable address of the ingress gateway in cluster2 that
#   # sits in front of sleep.foo service. Traffic from the sidecar will be
#   # routed to this address.
#   - address: ${CLUSTER2_GW_ADDR}
#     ports:
#       http1: 15443 # Do not change this port value
# EOF