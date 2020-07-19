FROM alpine:latest

RUN apk update && apk add --no-cache openrc influxdb bash
RUN apk add openrc --no-cache
RUN apk add telegraf influxdb --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache 

RUN openrc
RUN touch /run/openrc/softlevel
RUN rc-update add telegraf

RUN mkdir /etc/telegraf/
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf

EXPOSE 8086
ENTRYPOINT telegraf --config /etc/telegraf/telegraf.conf & influxd