[![DOI](https://zenodo.org/badge/73183766.svg)](https://zenodo.org/badge/latestdoi/73183766)
 [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![Build Status](https://travis-ci.org/AAROC/CODE-RADE-build-containers.svg?branch=master)](https://travis-ci.org/AAROC/CODE-RADE-build-containers)

# CODE-RADE build containers

## Roles used
This repository contains the Ansible-Container code for building the CODE-RADE build slave containers. It uses the [`AAROC.CODE-RADE-container` role from Ansible Galaxy](https://galaxy.ansible.com/AAROC/CODE-RADE-container)

## Containers

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

## Running

These containers are designed to be provisioned automatically by a CI system. The default entrypoint is ssh on port 5200.

You can use them to check builds locally. In order to run them, do

```
ansible-container ansible-container --project-name code-rade run --roles-path /home/becker/Ops/AAROC/DevOps/Ansible/roles/
```

Then ssh into the running container :

```
ssh jenkins@172.17.0.2 -p 5200
```

# Deploy

As mentioned before, these containers are for provisioning from CI environments. If you really want to run a static build cluster, you can use the `--deploy` command of Ansible Container. See https://docs.ansible.com/ansible-container/reference/deploy.html for deployment options

# Citing

If you produce research or other output and these containers are a part of that workflow, please cite as  
Bruce Becker. (2017). AAROC/CODE-RADE-build-containers: CODE-RADE Foundation Release 3 - Build Containers [Data set]. Zenodo. http://doi.org/10.5281/zenodo.572275
