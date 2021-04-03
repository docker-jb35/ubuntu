Ubuntu focal 20.04
===================

Build issue du dépot docker [ubuntu:20.04](https://hub.docker.com/_/ubuntu?tab=description&page=1&ordering=last_updated)

Dockerfile d'origne : [Dockerfile ubuntu](https://github.com/tianon/docker-brew-ubuntu-core/blob/7145f9723125e6e4367dc0fb428ffd9f2bc00334/focal/Dockerfile)

Amélioration du dockerfile:
Ajout du language FR
```shell
$>localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8
```