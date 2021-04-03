FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales language-pack-fr && rm -rf /var/lib/apt/lists/* \
    && localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8
ENV LANG fr_FR.utf8
