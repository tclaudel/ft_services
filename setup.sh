#!/usr/bin/env bash

function install_kubectl {
    KUBECTL_CHECK=`kubectl version --client`;
    if [[ ! -n KUBECTL_CHECK ]]; then
      curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl;
      chmod +x ./kubectl;
      sudo mv ./kubectl /usr/local/bin/kubectl;
    fi
    kubectl version --client > /dev/null;
    check_fail "installation of kubectl";
}

function install_minikube {
  MINIKUBE_DIR=`ls | grep "minikube-linux-amd64"`;
  if [[ ! -n MINIKUBE_DIR ]]; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64;
    sudo install minikube-linux-amd64 /usr/local/bin/minikube;
  fi
  check_fail "installation of minikube"
}

function check_ssh {
  IS_SSH=`cat ~/.ssh/id_rsa.pub`
  if [[ ! -n IS_SSH ]]; then
    echo "I did not found ssh key, follow the guideline to create another"
    ssh-keygen -t rsa -b 4096 -C $USER"@42Lyon.fr"
    ssh-add -k ~/.ssh/id_rsa
  fi
}

function starting_minikube {
  minikube start;
  minikube status;
}

function create_namespace {
  kubectl create namespace $NAMESPACE;
}

function setup_ingress_controller {
  minikube addons enable ingress
  check_fail "setup ingress controller"
  kubectl apply -f ./srcs/ingress_controller/ingress_controller.yaml --namespace=$NAMESPACE > /dev/null
  kubectl get ingress --namespace=$NAMESPACE > /dev/null
  check_fail "apply ingress_controller.yaml"
}

function reset {
#  minikube stop;
#  kubectl delete svc nginx-ssh
  kubectl delete cm config-metallb -n metallb-system
  for SERVICE in ${SERVICES[@]}
  do
    kubectl delete svc $SERVICE
    kubectl delete deploy $SERVICE
  done
}

function check_fail {
  if [ $? -ne 0 ]; then
    echo $1" failed\nExiting...";
    exit 1;
  fi
}

function nginx_service {
  docker build -t ft_nginx $WORKING_DIR/srcs/nginx
  eval $(minikube docker-env);
  kubectl apply -f $WORKING_DIR/srcs/nginx/srcs/nginx.yaml
}

function install_metallb {
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
  kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
  kubectl apply -f $WORKING_DIR/srcs/metallb/metallb.yaml
}

SERVICES=(
  nginx
)

export SERVICES
if [[ $1 == "reset" ]]; then
  reset;
fi
#minikube -p minikube docker-env
WORKING_DIR=$PWD;
NAMESPACE=$USER;
install_kubectl;
install_minikube;
starting_minikube;
create_namespace;
#setup_ingress_controller;
install_metallb;
nginx_service;


