FROM gcr.io/cloud-builders/gcloud-slim@sha256:d4ca671e5764c0f8f494a2a7540ced1753fbbe62af249e74c2fc0bbac6fa94fc

LABEL "name"="kubernetes-deploy"
LABEL "version"="1.0.0"
LABEL "maintainer"="Tobias Schlottke <ts@omr.com"

LABEL "com.github.actions.name"="GitHub Action for Kubernetes-Deploy"
LABEL "com.github.actions.description"="Wraps the Kubernetes-Deploy commands."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="green"
COPY LICENSE README.md THIRD_PARTY_NOTICE.md /

ENV DOCKERVERSION=18.06.1-ce
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update && apt-get -y --no-install-recommends install curl \
  && apt-get -y install build-essential ruby2.6 ruby2.6-dev \
  && curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz \
  && rm -rf /var/lib/apt/lists/*

RUN /builder/google-cloud-sdk/bin/gcloud -q components install kubectl

RUN ruby2.6 --version

RUN gem2.6 install kubernetes-deploy

COPY kubectl.bash /builder/kubectl.bash

RUN chmod +x /builder/kubectl.bash

ENTRYPOINT ["/builder/kubectl.bash"]
