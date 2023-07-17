# Start from a base image
FROM alpine:3.14

# Install dependencies
RUN apk --no-cache add \
    curl \
    python3 \
    py3-pip \
    bash \
    libc6-compat \
    openssh-client \
    git \
    docker \
    gettext


# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install pivnet
RUN wget  https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.1/pivnet-linux-amd64-3.0.1
RUN chmod 777 pivnet-linux-amd64-3.0.1
RUN cp pivnet-linux-amd64-3.0.1 /usr/local/bin/pivnet
RUN echo $token

# set VARS from kaniko args
ARG token
ARG tap_release
ARG tap_namespace
ARG tap_version
ARG framework_linux_amd64
ARG essential
ARG VERSION
ARG tbs
ARG gui_blank_Catalog
ARG gui_Yelb_Catalog
ARG essential_ver

RUN echo $token && pivnet login --api-token=$token

# download TAP from pivnet
RUN pivnet download-product-files --product-slug='tanzu-application-platform' --release-version=$tap_release --product-file-id=$framework_linux_amd64

# download TAP cluster essential
RUN echo $tap_version
RUN echo $gui_blank_Catalog
RUN pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version=$essential_ver --product-file-id=$essential
RUN pivnet download-product-files --product-slug='tanzu-application-platform' --release-version=$tap_version --product-file-id=$gui_blank_Catalog
RUN pivnet download-product-files --product-slug='tanzu-application-platform' --release-version=$tap_version --product-file-id=$gui_Yelb_Catalog

## exreact essential
RUN mkdir tanzu-cluster-essentials
RUN tar -xvf tanzu-cluster-essentials-linux-amd64-$essential_ver.tgz -C tanzu-cluster-essentials

## install imgpkg
RUN pivnet download-product-files --product-slug='imgpkg' --release-version='0.29.0' --product-file-id=1219927
RUN chmod 777 imgpkg-linux-amd64-0.29.0
RUN cp imgpkg-linux-amd64-0.29.0 usr/bin/imgpkg

COPY ../template /
COPY tap.sh / 
