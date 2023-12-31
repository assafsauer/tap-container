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
ARG HARBOR_USER
ARG HARBOR_PWD
ARG HARBOR_DOMAIN
ARG INSTALL_REGISTRY_HOSTNAME
ARG INSTALL_REGISTRY_USERNAME
ARG INSTALL_REGISTRY_PASSWORD
ARG tap_version
ARG framework_linux_amd64
ARG essential
ARG VERSION
ARG tbs


RUN echo $token && pivnet login --api-token=$token

# download TAP from pivnet
RUN pivnet download-product-files --product-slug='tanzu-application-platform' --release-version=$tap_release --product-file-id=$framework_linux_amd64
RUN pivnet download-product-files --product-slug='tanzu-application-platform' --release-version=$tap_release --product-file-id=$gui_blank_Catalog
RUN pivnet download-product-files --product-slug='tanzu-application-platform' --release-version=$tap_release --product-file-id=$gui_Yelb_Catalog

# download TAP cluster essential
RUN pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version=$tap_release --product-file-id=$essential

RUN mkdir tanzu-cluster-essentials
RUN tar -xvf tanzu-cluster-essentials-linux-amd64-1.4.1.tgz -C tanzu-cluster-essentials
RUN export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:2354688e46d4bb4060f74fca069513c9b42ffa17a0a6d5b0dbb81ed52242ea44
RUN cd tanzu-cluster-essentials
#RUN ./install.sh --yes

RUN pivnet download-product-files --product-slug='imgpkg' --release-version='0.29.0' --product-file-id=1219927
RUN chmod 777 imgpkg-linux-amd64-0.29.0
RUN cp imgpkg-linux-amd64-0.29.0 usr/bin/imgpkg
RUN docker login -u ${INSTALL_REGISTRY_USERNAME} -p ${INSTALL_REGISTRY_PASSWORD} ${INSTALL_REGISTRY_HOSTNAME}

RUN imgpkg copy \
    -b registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:a119cb90111379a5f91d27ae572a0de860dd7322179ab856fb32c45be95d78f5 \
    --to-tar cluster-essentials-bundle-1.4.2.tar \
    --include-non-distributable-layers

RUN imgpkg copy \
  -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$tap_release \
  --to-tar tap-packages-$tap_release.tar \
  --include-non-distributable-layers

RUN imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:$tbs \
  --to-tar=tbs-full-deps.tar

COPY ../template /

