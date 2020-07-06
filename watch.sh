#! /bin/bash

watch -n 1 "kubectl get all --all-namespaces; minikube service --url nginx"