# /bin/bash


################## vars ##################
##########################################


#export tap_namespace=dev
#export HARBOR_USER=asauer
#export HARBOR_PWD="xxxx"
#export HARBOR_DOMAIN="index.docker.io/asauer"
#export tbs=1.9.6
#export INSTALL_REGISTRY_HOSTNAME="registry.tanzu.vmware.com"
#export INSTALL_REGISTRY_USERNAME="sauera@vmware.com
#export INSTALL_REGISTRY_PASSWORD="xxxx"

#export domain=source-lab.io
##  TAP Version ####
tap_release='1.4.0'
tap_version=1.4.1-build.3 #pivnet... release-version='1.3.1-build.4' --product-file-id=1310085
export VERSION=v0.25.4.4 #sudo install cli/core/$VERSION/tanzu-core-linux_amd64 /usr/local/bin/tanzu

### optional: TAP GUI ####
#export git_token=xxx
#export catalog_info="https://github.com/assafsauer/tap-catalog-2/blob/main/catalog-info.yaml"
export repo_owner=assafsauer
export  repo_name=spring-petclinic-accelerators 

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:a119cb90111379a5f91d27ae572a0de860dd7322179ab856fb32c45be95d78f5
################## Install ##################
##########################################

kubectl create ns tap-install

envsubst <  git-secret.yml > git-secret.yaml 
kubectl apply -f git-secret.yaml -n $tap_namespace

kubectl create secret generic k8s-reader-overlay --from-file=rbac.overlay.yml -n tap-install

### install essential for GKE ###

cd tanzu-cluster-essentials

./install.sh --yes

cd ..

################## update tap plugins ##################
###########################################################

rm -r tanzu
mkdir tanzu

## Linux OS ##
tar -xvf tanzu-framework-linux-amd64-v*.tar -C tanzu
cd tanzu
export TANZU_CLI_NO_INIT=true
install cli/core/v*/tanzu-core-linux_amd64 /usr/local/bin/tanzu
tanzu plugin install --local cli all
cd ..



kubectl create ns tap-install
kubectl create ns dev

kubectl apply -f serviceacount.yml -n $tap_namespace

lidating access /exist script if login fail #####

################## Secrets ##################
##########################################

echo "#####  checking credentials for Tanzu Network and Regsitry ######"

if docker login -u ${HARBOR_USER} -p ${HARBOR_PWD} ${HARBOR_DOMAIN}; then
  echo "login successful to" ${HARBOR_DOMAIN}  >&2
else
  ret=$?
  echo "########### exist installation , please change credentials for  ${HARBOR_DOMAIN} $ret" >&2
  exit $ret
fi



tanzu secret registry add tap-registry \
  --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
  --server ${INSTALL_REGISTRY_HOSTNAME} \
  --export-to-all-namespaces --yes --namespace tap-install

tanzu secret registry add harbor-registry -y \
--username ${HARBOR_USER} --password ${HARBOR_PWD} \
--server ${HARBOR_DOMAIN}/v1  \
 --export-to-all-namespaces --yes --namespace tap-install


################## Install ##################
##########################################

### temp workaround for the "ServiceAccountSecretError" issue
kubectl create secret docker-registry registry-credentials --docker-server=${HARBOR_DOMAIN} --docker-username=${HARBOR_USER} --docker-password=${HARBOR_PWD} -n tap-install

kubectl create secret docker-registry registry-credentials --docker-server=${HARBOR_DOMAIN} --docker-username=${HARBOR_USER} --docker-password=${HARBOR_PWD} -n $tap_namespace

envsubst < gke-tap-values.yml > tap-base-final.yml

#tanzu package repository add tbs-full-deps-repository \
  --url $HARBOR_DOMAIN/tap/tbs-full-deps:$tbs \
  --namespace tap-install

tanzu package repository add tanzu-tap-repository --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$tap_version --namespace tap-install

sleep 50

tanzu package install tap -p tap.tanzu.vmware.com -v $tap_version --values-file tap-base-final.yml -n tap-install


#tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.5.3  --values-file tap-base-final.yml -n tap-install


