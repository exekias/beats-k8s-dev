# beats-k8s-dev

Easily bootstrap Kubernetes with Elasticsearch, Kibana and Beats for development. This set of script and manifests
will deploy a local Kubernetes cluster using [Minikube](https://kubernetes.io/docs/setup/minikube/), then deploy
Elasticsearch, Kibana and Beats on it, with the proper configurations to make them work together.


## Requirements

In order to run this script you will need to make sure [VirtualBox](https://www.virtualbox.org/wiki/Downloads) is installed. Running the script will launch a new VirtualBox machine, using 8GB of RAM.

## Start

Clone this repo and run the `beats-kube-up.sh` script:

```console
$ ./beats-kube-up.sh
```

Once done, services will start their deploy, you can check the status with the `kubectl` command:

```console
$ ./bin/kubectl get po
```

## In progress

- [ ] Allow to set Elastic stack version in the script
- [ ] Add Auditbeat
- [ ] Add Packetbeat
