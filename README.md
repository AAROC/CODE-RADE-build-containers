[![Docker Repository on Quay](https://quay.io/repository/aaroc/code-rade-build-containers-build-slave/status "Docker Repository on Quay")](https://quay.io/repository/aaroc/code-rade-build-containers-build-slave) [![Build Status](https://ci.sagrid.ac.za/job/build-container/badge/icon)](https://ci.sagrid.ac.za/job/build-container)  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)



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
