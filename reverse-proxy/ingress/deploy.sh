#!/bin/bash

#
# Deploy Kong API Gateway as an Ingress Controller with Dynamic User Routing
#

#
# Tear down the existing instance if required
#
helm delete kong 2>/dev/null

#
# Get the Helm chart
#
helm repo add kong https://charts.konghq.com
helm repo update

#
# Create a config map for our custom plugin
#
kubectl delete configmap kong-zone-transfer 2>/dev/null
kubectl create configmap kong-zone-transfer --from-file=../kong/zone-transfer-plugin
if [ $? -ne 0 ];
then
  echo "Problem encountered creating the Kong config map for the zone transfer plugin"
  exit 1
fi

#
# Do the install from the values file
#
helm install kong kong/kong --values=kong-values.yaml

if [ $? -ne 0 ];
then
  echo "Problem encountered starting the Helm chart installation for Kong"
  exit 1
fi