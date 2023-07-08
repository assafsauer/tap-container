
 
docker login -u ${INSTALL_REGISTRY_USERNAME} -p ${INSTALL_REGISTRY_PASSWORD} ${INSTALL_REGISTRY_HOSTNAME}
docker login -u ${HARBOR_USER} -p ${HARBOR_PWD} ${HARBOR_DOMAIN}

imgpkg copy \
    -b registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:a119cb90111379a5f91d27ae572a0de860dd7322179ab856fb32c45be95d78f5 \
    --to-tar cluster-essentials-bundle-1.4.2.tar \
    --include-non-distributable-layers

 imgpkg copy     --tar cluster-essentials-bundle-1.4.2.tar     --to-repo $HARBOR_DOMAIN/tap/cluster-essentials-bundle     --include-non-distributable-layers    

 
