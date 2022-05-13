# Overview

This document describes the process to configure a minikube cluster and the deployment of the service *hello-wefox* based on image *docker.io/hashicorp/http-echo*, and the upgrade of this service to a new version

This process has been implemented in the scripts [deploy.sh](deploy.sh) and [uplift.sh](uplift.sh).

Requirements. Following applications should be installed for executing the code:
- docker
- kubectl
- curl
- bash

The code has been implemented for OSX and Linux systems.

The goal of this project is to easy deployment of *hello-wefox* service and framework configuration to a teammate.

# Kubernetes setup

The minikube installation has been implemented in script [deploy.sh](deploy.sh) following steps in https://docker.io/hashicorp/http-echo.

# Plan to enhance the cluster

You can consider using Vagrant to prepare and deploy a preprod framework. You can see some examples in https://github.com/ovtmagic/vagrant:
- minikube: https://github.com/ovtmagic/vagrant/tree/master/minikube
- 2 nodes cluster: https://github.com/ovtmagic/vagrant/tree/master/cks/2nodes

Benefits of using this approach:
- Low cost
- Easy to re-deploy environment from scratch. Only executing `vagrant destroy -f;vagrant up` you can re-deploy and have a new preprod environment.

The time estimation for implementing this solution could be 2 days:
- first day is used for installing and testing the solution, that basically consists of installing Vagrant and Virtualbox in personal machine of teammates and cloning repo with Vagrant files for Kubernetes cluster and minikube.
- second day is used for troubleshooting and sharing knowledge with teammates.

# Deployment

The deployment of of service *hello-wefox* has been implemented in the Kubernetes manifest [deploy.yaml](deploy.yaml).

Both scripts [deploy.sh](deploy.sh) and [uplift.sh](uplift.sh) have been implemented to deploy the service and uplift the version of the service.

## Version 0.2.1

This deployment has been implemented in script [deploy.sh](deploy.sh). This script also gets, installs and configures minikube.

By default, the service is deployed in namespace *default*, but this could be configured in the environment variables at the top of the script:

    NAMESPACE="default"
    SVC_FQDN="hello.wefox.localhost"

You can also change the *hello.wefox.localhost* entry in */etc/hosts* file pointing to the minikube cluster IP. You can request the service with command:

    curl http://hello.wefox.localhost:8081

This is the output of the script execution and `curl` to service:

    vagrant@minikube:/vagrant/wefox$ ./deploy.sh
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    100 69.2M  100 69.2M    0     0  16.5M      0  0:00:04  0:00:04 --:--:-- 16.5M
    * [wefox-challenge-cluster] minikube v1.25.2 on Ubuntu 18.04 (vbox/amd64)
    * Using the docker driver based on user configuration
    * Starting control plane node wefox-challenge-cluster in cluster wefox-challenge-cluster
    * Pulling base image ...
    * Downloading Kubernetes v1.23.3 preload ...
        > preloaded-images-k8s-v17-v1...: 505.68 MiB / 505.68 MiB  100.00% 16.76 Mi
        > gcr.io/k8s-minikube/kicbase: 379.06 MiB / 379.06 MiB  100.00% 9.19 MiB p/
    * Creating docker container (CPUs=2, Memory=2200MB) ...
    * Preparing Kubernetes v1.23.3 on Docker 20.10.12 ...
    - apiserver.service-node-port-range=8000-32767
    - kubelet.housekeeping-interval=5m
    - Generating certificates and keys ...
    - Booting up control plane ...
    - Configuring RBAC rules ...
    * Verifying Kubernetes components...
    - Using image gcr.io/k8s-minikube/storage-provisioner:v5
    * Enabled addons: default-storageclass, storage-provisioner

    ! /usr/bin/kubectl is version 1.21.1, which may have incompatibilites with Kubernetes 1.23.3.
    - Want kubectl v1.23.3? Try 'minikube kubectl -- get pods -A'
    * Done! kubectl is now configured to use "wefox-challenge-cluster" cluster and "default" namespace by default
    192.168.49.2 hello.wefox.localhost
    deployment.apps/hello-wefox created
    service/hello-wefox created
    vagrant@minikube:/vagrant/wefox$ curl http://hello.wefox.localhost:8081
    'hello world'
    vagrant@minikube:/vagrant/wefox$


## Version 0.2.3

Script [uplift.sh](uplift.sh) has been implemented to uplift the version of the service to use the docker image *docker.io/hashicorp/http-echo:0.2.3*.

This is the output of the script execution:

    vagrant@minikube:/vagrant/wefox$ ./uplift.sh
    deployment.apps/hello-wefox image updated
    deployment.apps/hello-wefox
    REVISION  CHANGE-CAUSE
    1         <none>
    2         kubectl set image deployment hello-wefox http-echo=docker.io/hashicorp/http-echo:0.2.3 --record=true