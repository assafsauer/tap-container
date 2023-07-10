# Dockerizing Tanzu Application Platform (TAP) Installation Pod for Air-Gapped Env.

This repository contains the necessary resources to create a Docker image that encapsulates all dependencies required for a complete installation of VMware Tanzu Application Platform (TAP) in an air-gapped environment.

The primary objective of this project is to simplify and potentially automate the deployment of TAP in environments with limited internet access.

## Building the Docker Image

The `kaniko.yaml` file is used to build the Docker image. It pulls all the necessary dependencies required for the TAP installation. 

Please note that the arguments provided to Kaniko will not persist in the image after the build process is complete (so no worry)

```yaml
args:
- "--context=git://github.com/assafsauer/tap-container.git#refs/heads/main"
- "--context-sub-path=image"
- "--destination=asauer/tap-install:latest"
- "--build-arg"
- "--tap_release=1.4.0"
```

## Configuration and Automation
Once the Docker image is ready, a ConfigMap is used to manage the environment variables required for the TAP installation.

```yaml
data:
  tap_release: '1.4.0'
  tap_namespace: 'dev'
  HARBOR_USER: 'tanzu'
```
In addition to the Docker image and ConfigMap, this repository will also contain automation scripts (currently under development) that will trigger the TAP installation process automatically.


