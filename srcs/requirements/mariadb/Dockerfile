FROM debian:buster

WORKDIR /home/akambou/Desktop/Inception/srcs/wordpress
WORKDIR /home/akambou/Desktop/Inception/srcs/mariadb

WORKDIR .

RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/


COPY ./tools/script.sh /


CMD ["/script.sh"]
