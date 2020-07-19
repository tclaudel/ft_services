FROM alpine:latest

RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --no-cache

RUN apk add openrc
COPY srcs/grafana.ini /etc/grafana/grafana.ini
COPY srcs/dashboards /var/lib/grafana/dashboards/
COPY srcs/provisioning/dashboards/dashboards.yaml /usr/share/grafana/conf/provisioning/dashboards/
COPY srcs/provisioning/datasources/influxdb.yaml /usr/share/grafana/conf/provisioning/datasources/
RUN apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache 

RUN openrc
RUN touch /run/openrc/softlevel

RUN mkdir /etc/telegraf/
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
EXPOSE 3000

ENTRYPOINT  telegraf --config /etc/telegraf/telegraf.conf &  /usr/sbin/grafana-server --config=/etc/grafana/grafana.ini --homepath=/usr/share/grafana