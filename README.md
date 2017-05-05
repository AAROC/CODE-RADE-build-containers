[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![Build Status](https://travis-ci.org/AAROC/CODE-RADE-build-containers.svg?branch=master)](https://travis-ci.org/AAROC/CODE-RADE-build-containers)

# CODE-RADE build containers

This repository contains the Ansible-Container code for building the CODE-RADE build slave containers

The containers are built with [Ansible Container](http://docs.ansible.com/ansible-container) and stored on [quay.io](https://quay.io). We build  the following base images :

| Image | Status |
| :---------:| :---------:|
| CentOS 6 |  [![Docker Repository on Quay](https://quay.io/repository/aaroc/code-rade-centos6/status "Docker Repository on Quay")](https://quay.io/repository/aaroc/code-rade-centos6) |
| Ubuntu 14.04 | [![Docker Repository on Quay](https://quay.io/repository/aaroc/code-rade-ubuntu1404/status "Docker Repository on Quay")](https://quay.io/repository/aaroc/code-rade-ubuntu1404) |
| CentOS 7 | [![Docker Repository on Quay](https://quay.io/repository/aaroc/code-rade-centos7/status "Docker Repository on Quay")](https://quay.io/repository/aaroc/code-rade-centos7) |
| Ubuntu 16.10 | [![Docker Repository on Quay](https://quay.io/repository/aaroc/code-rade-ubuntu1610/status "Docker Repository on Quay")](https://quay.io/repository/aaroc/code-rade-ubuntu1610) |

The containers can be used by pulling them from quay.io _e.g._ :

```
docker pull quay.io/aaroc/code-rade-ubuntu1610
```

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
  * The `deploy` modulefile which sets the same variables except the root of `$SOFT_DIR` is under `/cvmfs`
  * A data container (`CODE-RADE-data`) is used to persist the data from build to build, and to make the builds portable.

## The Data Containers

We use the [data container pattern](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes) to provide persistence to the build artefacts, across jobs.  These are expressed in the `container.yml` for Docker only.

## To build

In order to build the containers, you can simply do :

```
ansible-container --project-name code-rade build --roles-path /home/becker/Ops/AAROC/DevOps/Ansible/roles/ --use-local-python
```

## Pushing to the image registry

`container.yml` contains the specification of which registries are used. We use quay by default. In order to push the built image to a registry, so as to make it usable by another build site, do

```
ansible-container --project-name code-rade push --roles-path /home/becker/Ops/AAROC
/DevOps/Ansible/roles/ --push-to quay --tag latest
```


## ~~Tagging images with OS name~~

(obsolete with Ansible-Container 0.9.x)

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
