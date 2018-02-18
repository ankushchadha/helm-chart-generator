FROM centos:7
LABEL maintainer=AnkushChadha

RUN curl -fL https://getcli.jfrog.io | sh \
	&& mv jfrog /bin/ \
	&& mkdir -p /var/opt/helm-data-generator

ENV HOME=/var/opt/helm-data-generator
WORKDIR ${HOME}

COPY ./scripts/ ${HOME}/
ENTRYPOINT ["/bin/sh", "-c", "${HOME}/chart-upload.sh"]
CMD []
