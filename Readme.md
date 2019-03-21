# Istio Multi Cluster Exercise

This repo is an example for using [istio](https://istio.io/) to host microservices across two clusters. It includes scripts to provision kubernetes, install istio, and an example app with exercises to test the multi cluster functionality.

# Requirements

[awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) - Amazon Web Service CLI tool

[gcloud](https://cloud.google.com/sdk/docs/quickstarts) -  Google Cloud Platform CLI tool

[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - Kubernetes CLI tool

Google Cloud & AWS account

# Exercises 

## test-app-cluster-1.sh

This exercise will simply pull the webpage that is hosted. Two copies of the application exists, on both clusters, 100% of traffic is directed towards cluster-1. 

## test-app-cluster-2.sh

This exercise will simply pull the webpage that is hosted. Two copies of the applications exist on both clusters, 100% of traffic is directed towards cluster-2. 

## test-transfer-50.sh

This exercise will transfer 50% of traffic into one cluster, and %50 of traffic into the other cluster.

## test-transfer-80-20.sh

This exercise will transfer 80% of traffic into on cluster and 20% of traffic into the other cluster.

## test-rush-hour.sh

This exercise will put start a pod that will put a load on the web app and simulate a burst of traffic. 

## test-https.sh

This exercise will test whether https is being used for inter-service communication.

# Instructions

1. Clone repo and move into directory
```
git clone https://github.com/rmeleromira/istio-multi-master
cd istio-multi-master
```

2. Run provision script to create kubernetes clusters
```
./provision.sh
```

3. Run Istio install script
```
./install-istio.sh
```

4. Install example applications
```
./install-app.sh
```

# What each script does



## provision.sh

Creates two kubernetes clusters, one in AWS and one in GCP

## install-istio.sh

Installs Istio 1.1 that supports multi master control planes into both kubernetes clusters

## install-app.sh

Installs example application for running exercises into both clusters

## vars.sh

Gathers necessary variables to perform actions against the two clusters

## start-forwards.sh

Starts port forwards from k8s cluster to local environment

## stop-forwards.sh

Stops port forwards from k8s cluster to local environment

## context1.sh

Changes your kubernetes context to cluster-1

## context2.sh

Changes your kubernetes context to cluster-2

## cleanup-istio.sh

Decomissions istio control plane

## cleanup-app.sh

Remove test application

## cleanup-clusters.sh

Decommissions the kubernetes clusters 

# Port forwards