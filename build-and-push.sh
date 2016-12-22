#!/bin/bash -x
# Script to build and tag all images
#
# Log into quay
echo $QUAY_USER
echo $QUAY_PASS
docker login -p $QUAY_PASS -u $QUAY_USER quay.io
for base in centos6 centos7 ubuntu1404 ubuntu1610  ; do
  echo "Building container for ${base}"
  ansible-container --var-file vars-${base}.yml build
  echo "running container for ${base}"
  ansible-container --var-file vars-${base}.yml run -d
  docker tag code-rade-build-containers-build-slave:latest quay.io/aaroc/code-rade-build-containers-build-slave:${base}
  docker push quay.io/aaroc/code-rade-build-containers-build-slave:${base}
done
echo "pushing data container"
docker push quay.io
