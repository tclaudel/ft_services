#!/usr/bin/env bash

function nginx {
  local NGINX_STR=https://"$MINIKUBE_IP"
  NGINX_PORT=`kubectl get service nginx | grep "/TCP" | awk '{print $5}'`
  NGINX_STR+=`echo $NGINX_PORT | cut -c17-22`
  echo $NGINX_STR
}

function nginx_ssh {
  NGINX_SSH_STR="NGINX SSH : ssh admin@"$MINIKUBE_IP" -p "
  NGINX_PORT=`kubectl get service nginx-ssh | grep "/TCP" | awk '{print $5}'`
  NGINX_SSH_STR+=`echo $NGINX_PORT | cut -c4-8`
  echo $NGINX_SSH_STR
}

MINIKUBE_IP=`minikube ip`
SERVICES=(
  nginx
)

MINIKUBE_IP=`minikube ip`
#KGS=`kubectl get service`
declare -a INFO_TAB
for SERVICE in ${SERVICES[@]}
do
  STR="$SERVICE :\t\t"
  if [[ $SERVICE == "nginx" ]]; then
    STR+=`nginx`
    STR+="\n"
  fi
  INFO_TAB+=("$STR")
done

for info in ${INFO_TAB}
do
  printf $info
done

nginx_ssh