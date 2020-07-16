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
  USER_NAMESPACE=`kubectl get namespaces | grep $USER`
  if [ -z "$USER_NAMESPACE" ]; then
    kubectl create namespace $NAMESPACE;
  fi
}

function reset {
#  minikube stop;
#  rm -Rf ~/.minikube
  kubectl delete cm config -n metallb-system
  for SERVICE in ${SERVICES[@]}
  do
    kubectl delete svc $SERVICE
    kubectl delete deploy $SERVICE
  done
  kubectl delete pv mysql-pv
  kubectl delete pvc mysql-pvc
}

function check_fail {
  if [ $? -ne 0 ]; then
    echo $1" failed\nExiting...";
    exit 1;
  fi
}

function volumes_setup {
  kubectl apply -f $WORKING_DIR/srcs/volumes/volume_mysql.yaml
}

function nginx_service {
  docker build -t ft_nginx $WORKING_DIR/srcs/nginx
  docker images ls
  kubectl apply -f $WORKING_DIR/srcs/nginx/srcs/nginx.yaml
}

function ftps_service {
  sed "s/FTPS_IP/"$MINIKUBE_IP.$((START+1))"/" srcs/ftps/srcs/template_vsftpd.conf > srcs/ftps/srcs/vsftpd.conf
  docker build -t ft_ftps $WORKING_DIR/srcs/ftps
  kubectl apply -f $WORKING_DIR/srcs/ftps/srcs/ftps.yaml
}

function wordpress_service {
  docker build -t ft_wordpress $WORKING_DIR/srcs/wordpress
  kubectl apply -f $WORKING_DIR/srcs/wordpress/srcs/wordpress.yaml
}

function mysql_service {
  docker build -t ft_mysql $WORKING_DIR/srcs/mysql
  kubectl apply -f $WORKING_DIR/srcs/mysql/srcs/mysql.yaml
}

function phpmyadmin_service {
  docker build -t ft_phpmyadmin $WORKING_DIR/srcs/phpmyadmin
  kubectl apply -f $WORKING_DIR/srcs/phpmyadmin/srcs/phpmyadmin.yaml
}

function install_metallb {

  sed "s/IPADDRESSES/"$MINIKUBE_IP.$START-$MINIKUBE_IP.254"/" srcs/metallb/template_metallb.yaml > srcs/metallb/metallb.yaml
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
  kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
  kubectl apply -f $WORKING_DIR/srcs/metallb/metallb.yaml
}

function @ {
  printf "[$I] $1\n" | tr '_' ' '
  ((I++))
  eval $1
  if [[ $? -ne 0 ]];then
    printf "An error occurred, exiting ..."
    exit;
  fi
}

SERVICES=(
  nginx
  ftps
  wordpress
  mysql
  phpmyadmin
)



export SERVICES
if [[ $1 == "reset" ]]; then
  reset;
fi
#minikube -p minikube docker-env
WORKING_DIR=$PWD;
NAMESPACE=$USER;
I=0
eval $(minikube docker-env);
@ install_minikube;
@ starting_minikube;
MINIKUBE_IP=`minikube ip | cut -d '.' -f 1-3`
START=`minikube ip | cut -d '.' -f 4`
@ install_kubectl;
@ create_namespace;
#setup_ingress_controller;
eval $(minikube docker-env);
@ install_metallb;
@ nginx_service;
@ ftps_service;
#@ volumes_setup;
@ mysql_service;
@ wordpress_service;
@ phpmyadmin_service;
