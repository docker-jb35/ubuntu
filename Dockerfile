FROM ubuntu:20.04
ENV TZ Europe/Paris
ENV LANG fr_FR.utf8
RUN apt-get update && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive TZ=Europe/Paris apt-get install -y locales tzdata language-pack-fr && rm -rf /var/lib/apt/lists/* \
    && localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8 \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
