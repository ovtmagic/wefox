#!/bin/bash

NEW_VERSION="0.2.3"

kubectl set image deployment hello-wefox http-echo=docker.io/hashicorp/http-echo:${NEW_VERSION} --record
kubectl rollout history deployment hello-wefox