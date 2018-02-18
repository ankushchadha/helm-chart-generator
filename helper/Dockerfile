FROM alpine:3.6 as build

LABEL maintainer=ankushchadha
ARG HELM_VERSION=v2.8.1

WORKDIR /

RUN INSTALL_PKGS="ca-certificates openssl tar" \
 && apk add --update $INSTALL_PKGS && update-ca-certificates \
 && cd tmp \
 && wget https://kubernetes-helm.storage.googleapis.com/helm-${HELM_VERSION}-linux-amd64.tar.gz \
 && tar -xvf helm-${HELM_VERSION}-linux-amd64.tar.gz 
 
FROM alpine:3.6

RUN apk add --update --no-cache ca-certificates

COPY --from=build /tmp/linux-amd64/helm /bin/helm
WORKDIR /
RUN helm init --client-only

