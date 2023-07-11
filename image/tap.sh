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
export git_token=xxx
#export catalog_info="https://github.com/assafsauer/tap-catalog-2/blob/main/catalog-info.yaml"
export repo_owner=assafsauer
export  repo_name=spring-petclinic-accelerators 

kubectl create ns tap-install

envsubst <  git-secret.yml > git-secret.yaml 
kubectl apply -f git-secret.yaml -n $tap_namespace

kubectl create secret generic k8s-reader-overlay --from-file=rbac.overlay.yml -n tap-install

### install essential for GKE ###
### install essential for GKE ###

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:2354688e46d4bb4060f74fca069513c9b42ffa17a0a6d5b0dbb81ed52242ea44

export INSTALL_BUNDLE=$HARBOR_DOMAIN/tap/cluster-essentials-bundle@sha256:a119cb90111379a5f91d27ae572a0de860dd7322179ab856fb32c45be95d78f5

cd tanzu-cluster-essentials

./install --yes

cd ..

