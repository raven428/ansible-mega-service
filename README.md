# Generic service maintenance

[![molecule](https://github.com/raven428/ansible-mega-service/actions/workflows/test-role.yaml/badge.svg)](https://github.com/raven428/ansible-mega-service/actions/workflows/test-role.yaml)

The role perform deploy packages or files of a service with configuration files from templates with ability to start, stop and destroy all of these with certain Ansible tags

## Role release to Ansible galaxy

- clone me:

  ```bash
  git clone --recursive \
  git@github.com:raven428/ansible-mega-service.git \
  ansible-mega-service
  ```

- make tag and send to release:

  ```bash
  git checkout master && git pull
  git tag -fm $(git branch --sho) 1.0.8 && git push --force origin $(git describe)
  ```
