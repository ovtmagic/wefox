#!/bin/bash

DARWING_MINIKUBE="https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64"
Linux_MINIKUBE="https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
NAMESPACE="default"
SVC_FQDN="hello.wefox.localhost"

function _exit(){
    local msg=$1
    local exit_code=${2:-0}
    echo -e "${msg}"
    exit ${exit_code}
}

function install_minikube(){
    which minikube && return 0
    if [[ "$(uname)" =~ "Linux" ]]; then
        curl -LO ${Linux_MINIKUBE}
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
    elif [[ "$(uname)" =~ "DARWIN" ]]; then
        curl -LO ${DARWING_MINIKUBE}
        sudo install minikube-darwin-amd64 /usr/local/bin/minikube
    else
        _exit 1 "$(uname) is not supported" 1
    fi
    #sudo -i minikube start --vm-driver=none --extra-config=apiserver.service-node-port-range=8000-32767 --profile=wefox-challenge-cluster && _exit "Error startting minikube" 1
    sudo -i minikube start --vm-driver=none --extra-config=apiserver.service-node-port-range=8000-32767
    return $?
}

function prepare_environment(){
    install_minikube || _exit "Error startting minikube" 1
    grep -q "${SVC_FQDN}" /etc/hosts || echo "127.0.0.1 ${SVC_FQDN}" | sudo tee -a /etc/hosts
    sudo -i kubectl config view --flatten > /tmp/config
    mkdir -p ${HOME}/.kube
    sudo cp /tmp/config ${HOME}/.kube
    chown $(id -u):$(id -g) ${HOME}/.kube/config
}

function deploy(){
    kubectl -n ${NAMESPACE} apply -f deploy.yaml
}


# Main
prepare_environment
deploy