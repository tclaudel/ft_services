#!/usr/bin/env bash

function install_kubectl {
    minikube kubectl
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

function reset {
#  minikube stop;
#  rm -Rf ~/.minikube
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
  docker images ls
  kubectl apply -f $WORKING_DIR/srcs/nginx/srcs/nginx.yaml
}

function ftps_service {
  docker build -t ft_ftps $WORKING_DIR/srcs/ftps
  kubectl apply -f $WORKING_DIR/srcs/ftps/srcs/ftps.yaml
}

function wordpress_service {
  docker build -t ft_wordpress $WORKING_DIR/srcs/wordpress
  kubectl apply -f $WORKING_DIR/srcs/wordpress/srcs/wordpress.yaml
}

function mysql_service {
  docker build -t ft_wordpress $WORKING_DIR/srcs/mysql
  kubectl apply -f $WORKING_DIR/srcs/mysql/srcs/mysql.yaml
}

function install_metallb {
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
  kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
  kubectl apply -f $WORKING_DIR/srcs/metallb/metallb.yaml
}

SERVICES=(
  nginx
  ftps
  wordpress
  wordpress-mysql
)

MINIKUBE_IP=`minikube ip`

export SERVICES
if [[ $1 == "reset" ]]; then
  reset;
fi
#minikube -p minikube docker-env
WORKING_DIR=$PWD;
NAMESPACE=$USER;
eval $(minikube docker-env);
install_minikube;
starting_minikube;
install_kubectl;
create_namespace;
#setup_ingress_controller;
eval $(minikube docker-env);
install_metallb;
nginx_service;
ftps_service;
wordpress_service;
mysql_service;

