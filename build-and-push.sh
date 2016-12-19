#!/bin/bash
# Script to build and tag all images
for base in centos6 centos7 ubuntu1404 ubuntu1610  ; do
  echo "Building container for ${base}"
  ansible-container --var-file vars-${base}.yml build
  docker tag code-rade-build-containers-build-slave:latest quay.io/aaroc/code-rade-build-containers-build-slave:${base}
  docker push quay.io/aaroc/code-rade-build-containers-build-slave:${base}
done
