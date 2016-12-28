#!/bin/bash -x
# Script to build and tag all images
#
# Log into quay
echo $QUAY_USER
echo $QUAY_PASS
docker login -p $QUAY_PASS -u $QUAY_USER quay.io
ansible-container --var-file vars-${base}.yml build
ansible-container --var-file vars-${base}.yml run -d
echo "running cluster"
for base in centos6 centos7 ubuntu1404 ubuntu1610  ; do
  docker tag code-rade-build-containers-build-slave-${base}:latest quay.io/aaroc/code-rade-build-containers-build-slave-${base}:latest
  docker push quay.io/aaroc/code-rade-build-containers-build-slave-${base}:latest
done
