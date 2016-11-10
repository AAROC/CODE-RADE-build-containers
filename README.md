[![Docker Repository on Quay](https://quay.io/repository/aaroc/code-rade-build-containers-build-slave/status "Docker Repository on Quay")](https://quay.io/repository/aaroc/code-rade-build-containers-build-slave) [![Build Status](https://ci.sagrid.ac.za/job/build-container/badge/icon)](https://ci.sagrid.ac.za/job/build-container)  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)



# CODE-RADE build containers

This repository contains the Ansible-Container code for building the CODE-RADE build slave containers

The containers are built with [Ansible Container](http://docs.ansible.com/ansible-container) and stored on [quay.io](https://quay.io).

## To build

`ansible-container --var-file vars.yml build`

The container adds a user, jdk and ssh daemon for jenkins. 
