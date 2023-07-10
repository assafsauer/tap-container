
### cluster eseential ###
docker login -u ${INSTALL_REGISTRY_USERNAME} -p ${INSTALL_REGISTRY_PASSWORD} ${INSTALL_REGISTRY_HOSTNAME}
docker login -u ${HARBOR_USER} -p ${HARBOR_PWD} ${HARBOR_DOMAIN}

imgpkg copy \
    -b registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:a119cb90111379a5f91d27ae572a0de860dd7322179ab856fb32c45be95d78f5 \
    --to-tar cluster-essentials-bundle-1.4.2.tar \
    --include-non-distributable-layers

 imgpkg copy     --tar cluster-essentials-bundle-1.4.2.tar     --to-repo $HARBOR_DOMAIN/tap/cluster-essentials-bundle     --include-non-distributable-layers    

 
### tap ###

## https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/install-offline-profile.html

export IMGPKG_REGISTRY_HOSTNAME_0=$INSTALL_REGISTRY_HOSTNAME
export IMGPKG_REGISTRY_USERNAME_0=$INSTALL_REGISTRY_USERNAME
export IMGPKG_REGISTRY_PASSWORD_0=$INSTALL_REGISTRY_PASSWORD 
export IMGPKG_REGISTRY_HOSTNAME_1=$HARBOR_DOMAIN
export IMGPKG_REGISTRY_USERNAME_1=$HARBOR_USER
export IMGPKG_REGISTRY_PASSWORD_1=$HARBOR_PWD
export TAP_VERSION=$tap_release
#export REGISTRY_CA_PATH=PATH-TO-CA

imgpkg copy \
  -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$TAP_VERSION \
  --to-tar tap-packages-$TAP_VERSION.tar \
  --include-non-distributable-layers

  imgpkg copy \
  --tar tap-packages-$TAP_VERSION.tar \
  --to-repo $IMGPKG_REGISTRY_HOSTNAME_1/tap/tap-packages \
  --include-non-distributable-layers \
  #--registry-ca-cert-path $REGISTRY_CA_PATH
