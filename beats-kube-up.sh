#!/bin/bash
set -e

K8S_VERSION="v1.10.0"
MINIKUBE_VERSION="v0.28.0"
#TODO set beats version here
#BEATS_VERSION="6.3.0"
MEMORY_MB="8192"
BIN=./bin

case $(uname -s) in
   Darwin) OS=darwin ;;
   Linux) OS=linux ;;
   *)
     echo "This script only works on Linux and Mac"
     exit 1
     ;;
esac

case $(uname -m) in
    i?86) ARCH=i386 ;;
    x86_64) ARCH=amd64 ;;
    *)
      echo "Unknown arch"
      exit 1
      ;;
esac


mkdir -p $BIN
PATH=$BIN:$PATH

if [ ! -f $BIN/minikube ]; then
  echo "Downloading minikube..."
  curl -Lo $BIN/minikube https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-$OS-$ARCH
  chmod +x $BIN/minikube
  echo ""
fi

if [ ! -f $BIN/kubectl ]; then
  echo "Downloading kubectl..."
  curl -Lo $BIN/kubectl https://storage.googleapis.com/kubernetes-release/release/$K8S_VERSION/bin/$OS/$ARCH/kubectl
  chmod +x $BIN/kubectl
  echo ""
fi

$BIN/minikube start --kubernetes-version=$K8S_VERSION --memory $MEMORY_MB
echo ""

echo "Deploying services..."
echo "kube-sate-metrics..."
$BIN/kubectl create -f manifests/kube-state-metrics.yaml
echo ""

echo "elasticsearch..."
$BIN/kubectl create -f manifests/elasticsearch.yaml
echo ""

echo "kibana..."
$BIN/kubectl create -f manifests/kibana.yaml
echo ""

echo "filebeat..."
$BIN/kubectl create -f manifests/filebeat.yaml
echo ""

echo "Cluster is ready. Once deployments are done you can access:"
echo ""
echo "  Elasticsearch: http://$(minikube ip):9200"
echo "  Kibana: http://$(minikube ip):5601"
echo ""
echo "You can check the status by running: ./bin/kubectl get po"
echo ""
echo "To kill current deployments and stop the cluster just run:"
echo "  $BIN/minikube delete"