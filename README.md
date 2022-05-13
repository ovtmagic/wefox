# Overview

This document describes the process to configure a minikube cluster and the deployment of the service *hello-wefox* based on image *docker.io/hashicorp/http-echo*, and the upgrade of this service to a new version

This process has been implemented in the scripts *deploy.sh* and *uplift.sh*.

Requirements. Following applications should be installed for executing the code:
- docker
- kubectl
- curl
- bash

The code has been implemented for OSX and Linux systems.

# Kubernetes setup

The minikube installation has been implemented in script *deploy.sh* following steps in https://docker.io/hashicorp/http-echo.

# Plan to enhance the cluster

You can consider using Vagrant to prepare and deploy a preprod framework. You can see some examples in https://github.com/ovtmagic/vagrant:
- minikube: https://github.com/ovtmagic/vagrant/tree/master/minikube
- 2 nodes cluster: https://github.com/ovtmagic/vagrant/tree/master/cks/2nodes

Benefits of using this approach:
- Low cost
- Easy to re-deploy environment from scratch. Only executing `vagrant destroy -f;vagrant up` you can re-deploy and have a new preprod environment.

# Deployment

## Version 0.2.1

This deployment has been implemented in script *deploy.sh*. This script also gets, install and configure minikube.

By default, the service is deployed in namespace *default*, but this could be configured in the environment variables at the top of the script:

NAMESPACE="default"
SVC_FQDN="hello.wefox.localhost"

You can also change the *hello.wefox.localhost* entry pointing to the minikube cluster IP.

## Version 0.2.3

Script *uplift.sh* has been implemented to uplift the version of the service to use the docker image *docker.io/hashicorp/http-echo:0.2.3*.