FROM debian:buster

RUN apt-get update -y && \
    apt-get install -y mariadb-server mariadb-client procps
COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/script.sh /
RUN chmod +x /script.sh
CMD ["/script.sh"]