[![Build Container Repository on Quay](https://quay.io/repository/aaroc/code-rade-build-containers-build-slave/status "Docker Repository on Quay")](https://quay.io/repository/aaroc/code-rade-build-containers-build-slave) [![Data Container Repository on Quay](https://quay.io/repository/aaroc/code-rade-data/status "Docker Repository on Quay")](https://quay.io/repository/aaroc/code-rade-data) [![Build Status](https://ci.sagrid.ac.za/job/build-container/badge/icon)](https://ci.sagrid.ac.za/job/build-container)  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# CODE-RADE build containers

This repository contains the Ansible-Container code for building the CODE-RADE build slave containers

The containers are built with [Ansible Container](http://docs.ansible.com/ansible-container) and stored on [quay.io](https://quay.io).

The container adds a user, jdk and ssh daemon for jenkins, as well as some CODE-RADE secret sauce :

  * The `ci` modulefile which sets a few variables:
    * `$SOFT_DIR`: The software installation path for the CI environment
      `setenv        SOFT_DIR /data/ci-build/$::env(SITE)/$::env(OS)/$::env(ARCH)/$::env(NAME)/$::env(VERSION)`
    * `$REPO_DIR` : The built artefacts (in tarball) in the CI environment
      `setenv        REPO_DIR               /data/artefacts/$::env(SITE)/$::env(OS)/$::env(ARCH)/$::env(NAME)/$::env(VERSION)`
    * `$SRC_DIR` : The local cache for the source tarballs
      `setenv        SRC_DIR                /data/src/$::env(NAME)/$::env(VERSION)`
    * `$MODULES` : The path to the modulefiles for the CI environment
      `set           MODULES                /data/modules`
  * A data container (`CODE-RADE-data`) is used to persist the data from build to build, and to make the builds portable.

## The Data Container

We use the [data container pattern](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes) to provide persistence to the build artefacts, across jobs. This can be created by hand or pulled from Quay :

  1. `docker create -v /data  --name CODE-RADE-data alpine /bin/true`
  1. `docker pull quay.io/aaroc/code-rade-data`

Note that if you do this, the container will be empty (we  still  need to add a pots-process of pushing the updated container to Quay)

## To build

`ansible-container --var-file vars.yml build`

To build the container for differing base operating systems, use the `varsXXX.yml` files provided (or add your own), _e.g._ :

```
ansible-container --var-file vars-centos.yml build
```

## Pushing to the image registry

`container.yml` contains the specification of which registries are used. We use quay by default. In order to push the built image to a registry, so as to make it usable by another build site, do

```
ansible-container --var-file vars.yml push --push-to quay
```

Obviously, vary the vars file accordingly.

## Tagging images with OS name

Ansible-Container does not yet allow for you to tag images with your specified tags (See [this request](https://github.com/ansible/ansible-container/issues/125)), so if you want to build with name-tagged images (instead of time-tagged images), you need to use the docker CLI to add the tags you want:

  1. Build with a specified set of vars : `ansible-container --var-file vars-ubuntu1404.yml build`
  1. Check the name of the created image, from the SHA reported by ansible-container :

          Committing image...
          Exported code-rade-build-containers-build-slave with image ID sha256:fd0ce1c13f8c583f8f90d265d662b8da40eabf731be3c046242df6970c2ef5fe
          docker images | grep fd0ce1c13f8c
          code-rade-build-containers-build-slave                 20161219105249      fd0ce1c13f8c About a minute ago   1.179 GB
          code-rade-build-containers-build-slave                 latest                           fd0ce1c13f8c About a minute ago   1.179 GB

  1. The tag you want is the date tag : `20161219105249` (or `latest`, if you haven't done another build). Tag this with an OS-name : `docker tag code-rade-build-containers-build-slave:20161219105249 quay.io/aaroc/code-rade-build-containers-build-slave:ubuntu1404`
  1. Push the image to quay : `docker push quay.io/aaroc/code-rade-build-containers-build-slave:ubuntu1404`
