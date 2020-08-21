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

function get_ip_values {
  MINIKUBE_IP=`minikube ip`
  MINIKUBE_IP_1_3=`echo $MINIKUBE_IP | cut -d '.' -f 1-3`
  START=`minikube ip | cut -d '.' -f 4`
  CLUSTER_IP_START="$MINIKUBE_IP_1_3".$((START+1))
  CLUSTER_IP_END="$MINIKUBE_IP_1_3".256
  echo $IP
}

function get_service_ip {
  let INDEX=${SERVICES[$1]}
  INDEX=`echo ${SERVICES[@]} | tr -s " " "\n" | grep -n $1 | cut -d":" -f 1`
  ((INDEX--))
  IP=`echo $CLUSTER_IP_START | cut -d '.' -f 1-3`.$((`echo $CLUSTER_IP_START | cut -d '.' -f 4` + $INDEX))
  echo $IP
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
  kubectl delete cm config -n metallb-system
  for SERVICE in ${SERVICES[@]}
  do
    kubectl delete svc $SERVICE
    kubectl delete deploy $SERVICE
  done
  kubectl delete pv mysql-pv
  kubectl delete pv influxdb-pv
  kubectl delete pvc mysql-pvc
  kubectl delete pvc influxdb-pvc

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
  sed "s/FTPS_IP/"`get_service_ip ftps`"/" srcs/ftps/srcs/template_vsftpd.conf > srcs/ftps/srcs/vsftpd.conf
  docker build -t ft_ftps $WORKING_DIR/srcs/ftps
  kubectl apply -f $WORKING_DIR/srcs/ftps/srcs/ftps.yaml
}

function wordpress_service {
  get_service_ip wordpress
  sed "s/WORDPRESS_IP/$(get_service_ip "wordpress")/" srcs/mysql/srcs/template_wordpress.sql > srcs/mysql/srcs/wordpress.sql
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

function influxdb_service {
  docker build -t ft_influxdb $WORKING_DIR/srcs/influxdb
  kubectl apply -f $WORKING_DIR/srcs/influxdb/srcs/influxdb.yaml
}

function grafana_service {
  docker build -t ft_grafana $WORKING_DIR/srcs/grafana
  kubectl apply -f $WORKING_DIR/srcs/grafana/srcs/grafana.yaml
}

function install_metallb {
  sed "s/IPADDRESSES/"$MINIKUBE_IP_1_3.$((START+1))-$MINIKUBE_IP_1_3.254"/" srcs/metallb/template_metallb.yaml > srcs/metallb/metallb.yaml
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
  kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
  kubectl apply -f $WORKING_DIR/srcs/metallb/metallb.yaml
}

function display_services_access {
  NGINX_IP=`get_service_ip nginx`
  WORDPRESS_IP=`get_service_ip wordpress`
  PHP_MY_ADMIN_IP=`get_service_ip phpmyadmin`
  FTPS_IP=`get_service_ip ftps`
  GRAFANA_IP=`get_service_ip grafana`
  printf "NGINX :\t\thttp://$NGINX_IP:80\n\t\thttps://$NGINX_IP:443\n\t\tssh admin@$NGINX_IP\tadmin/password\n"
  printf "WORDPRESS :\thttp://$WORDPRESS_IP:5050\n"
  printf "PHP_MY_ADMIN :\thttp://$PHP_MY_ADMIN_IP:5000\tadmin/password\n"
  printf "GRAFANA :\thttp://$GRAFANA_IP:3000\tadmin/password\n"
  printf "FTPS : \t\t$FTPS_IP\t\t\tadmin/password/21\n"
}

function @ {
  printf "[$I] $1\n" | tr '_' ' '
  ((I++))
  eval $1
  if [[ $? -ne 0 ]]; then
    printf "An error occurred, exiting ..."
    exit;
  fi
}

SERVICES=(
  nginx
  ftps
  wordpress
  phpmyadmin
  grafana
  influxdb
  mysql
)

MINIKUBE_IP=""
CLUSTER_IP_START=""
CLUSTER_IP_END=""
export SERVICES
if [[ $1 == "reset" ]]; then
  reset;
fi
WORKING_DIR=$PWD;
NAMESPACE=$USER;
I=0
eval $(minikube docker-env);
@ install_minikube;
@ starting_minikube;
@ get_ip_values;
@ install_kubectl;
@ create_namespace;
eval $(minikube docker-env);
@ get_ip_values;
@ install_metallb;
@ influxdb_service;
@ nginx_service;
@ ftps_service;
@ mysql_service;
@ wordpress_service;
@ phpmyadmin_service;
@ grafana_service;
@ display_services_access;
