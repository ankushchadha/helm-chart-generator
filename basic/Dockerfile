FROM centos:7
LABEL maintainer=AnkushChadha

ARG HELM_VERSION=v2.8.1

RUN INSTALL_PKGS="git wget" && \
	yum install -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
	rpm -V $INSTALL_PKGS && \
	yum clean all

RUN wget https://kubernetes-helm.storage.googleapis.com/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
	tar -xvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
	mv linux-amd64/helm /bin/ && \ 
	curl -fL https://getcli.jfrog.io | sh && \
	mv jfrog /bin/ && \
	mkdir -p /opt/binary-generator 

ENV HOME=/opt/binary-generator
WORKDIR ${HOME}

RUN helm init --client-only

COPY ./scripts/ ${HOME}/
ENTRYPOINT ["./helm-generator.sh"]
CMD []
