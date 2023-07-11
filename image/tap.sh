# /bin/bash


################## vars ##################
##########################################

export tap_namespace=dev
export HARBOR_USER=user
export HARBOR_PWD=xxx
export HARBOR_DOMAIN=registry.source-lab.io

export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=email
export INSTALL_REGISTRY_PASSWORD=xxx

export domain=source-lab.io

###  TAP Version ####
tap_release='1.4.0'
tap_version=1.4.1-build.3 #pivnet... release-version='1.3.1-build.4' --product-file-id=1310085
export VERSION=v0.25.0 #sudo install cli/core/$VERSION/tanzu-core-linux_amd64 /usr/local/bin/tanzu

### optional: TAP GUI ####
export git_token=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
#export catalog_info="https://github.com/assafsauer/tap-catalog-2/blob/main/catalog-info.yaml"
export repo_owner=assafsauer
export  repo_name=spring-petclinic-accelerators 

kubectl create ns tap-install

envsubst <  git-secret.yml > git-secret.yaml 
kubectl apply -f git-secret.yaml -n $tap_namespace

kubectl create secret generic k8s-reader-overlay --from-file=rbac.overlay.yml -n tap-install

### install essential for GKE ###
mkdir tanzu-cluster-essentials
