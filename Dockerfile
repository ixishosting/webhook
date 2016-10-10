# Dockerfile for https://github.com/adnanh/webhook

FROM        alpine

ENV         GOPATH /go
ENV         SRCPATH ${GOPATH}/src/github.com/adnanh
ENV         WEBHOOK_VERSION 2.3.8

RUN         apk add --update -t build-deps curl go git libc-dev gcc libgcc ansible util-linux sqlite bash curl mysql-client jq openssh openssl wget git && \
            curl -L -o /tmp/webhook-${WEBHOOK_VERSION}.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz && \
            mkdir -p ${SRCPATH} && tar -xvzf /tmp/webhook-${WEBHOOK_VERSION}.tar.gz -C ${SRCPATH} && \
            mv -f ${SRCPATH}/webhook-* ${SRCPATH}/webhook && \
            cd ${SRCPATH}/webhook && go get -d && go build -o /usr/local/bin/webhook 
RUN 	    cd ~/ && wget --no-check-certificate https://github.com/rancher/rancher-compose/releases/download/v0.8.5-rc2/rancher-compose-linux-amd64-v0.8.5-rc2.tar.gz && tar -xzf rancher-compose-linux-amd64-v0.8.5-rc2.tar.gz && \
    	    mv rancher-compose-v0.8.5-rc2/rancher-compose /usr/bin/ && \
    	    rm -Rf /tmp/*
RUN         rm -rf /var/cache/apk/* && \
            rm -rf ${GOPATH}
EXPOSE      9000

ENTRYPOINT  ["/usr/local/bin/webhook"]
