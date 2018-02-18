FROM centos:7
LABEL maintainer=AnkushChadha

ARG HELM_VERSION=v2.8.1

RUN INSTALL_PKGS="wget" && \
	yum install -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
	rpm -V $INSTALL_PKGS && \
	yum clean all

RUN wget https://kubernetes-helm.storage.googleapis.com/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
	tar -xvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
	mv linux-amd64/helm /bin/ && \
	mkdir -p /var/opt/helm-data-generator

ENV HOME=/var/opt/helm-data-generator
WORKDIR ${HOME}
COPY ./scripts/ ${HOME}/

RUN helm init --client-only && chmod +x ${HOME}/helm-generator.sh

ENTRYPOINT ["/bin/sh", "-c", "${HOME}/helm-generator.sh"]
CMD []
