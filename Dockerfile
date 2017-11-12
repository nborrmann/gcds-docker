FROM debian:jessie

MAINTAINER Nils Borrmann

ENV DOMAIN "example.com"
ENV LDAP_PW "secret"
ENV HOST localhost
ENV PORT 10389
ENV CRON_EXP "* * * * *"
ENV DRY_RUN "TRUE"

ADD scripts /usr/local/scripts

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y curl cron && \
    curl https://dl.google.com/dirsync/dirsync-linux64.sh > /usr/src/dirsync-linux64.sh && \
    chmod +x /usr/src/dirsync-linux64.sh && \
    (echo "o"; echo ""; echo "1"; echo ""; echo "y"; echo ""; echo "";) | /usr/src/dirsync-linux64.sh && \
    chmod +x /usr/local/scripts/*.sh

CMD ["/usr/local/scripts/setup.sh"]
