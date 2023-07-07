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
    docker

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install pivnet
RUN wget  https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.1/pivnet-linux-amd64-3.0.1
RUN chmod 777 pivnet-linux-amd64-3.0.1
RUN cp pivnet-linux-amd64-3.0.1 /usr/local/bin/pivnet
RUN echo $token
ARG token
RUN echo $token && pivnet login --api-token=$token

# download TAP from pivnet
RUN pivnet download-product-files --product-slug='tanzu-application-platform' --release-version=$tap_version --product-file-id=$framework_linux_md64
RUN pivnet download-product-files --product-slug='tanzu-application-platform' --release-version=$tap_version --product-file-id=$gui_blank_Catalog
RUN pivnet download-product-files --product-slug='tanzu-application-platform' --release-version=$tap_version --product-file-id=$gui_Yelb_Catalog

# download TAP cluster essential
RUN pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version='1.4.1' --product-file-id=$essential

RUN mkdir tanzu-cluster-essentials
RUN tar -xvf "tanzu-cluster-essentials-linux-amd64-1.4.1.tgz-"$tap_release".tgz" -C tanzu-cluster-essentials

RUN export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:5fd527dda8af0e4c25c427e5659559a2ff9b283f6655a335ae08357ff63b8e7f
RUN cd tanzu-cluster-essentials
RUN ./install.sh --yes

RUN cd ..
