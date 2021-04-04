#!/bin/bash
set -Eeuo pipefail

cd "$(dirname "$BASH_SOURCE")"
TZ="Europe/Paris"
versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

arch="$(arch)"
for v in "${versions[@]}"; do
    if ! grep -qE "^$arch\$" "$v/arches"; then
		continue
	fi
    cat > "$v/Dockerfile" <<EOF
FROM ubuntu:$v
ENV TZ $TZ
ENV LANG fr_FR.utf8
RUN apt-get update && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive TZ=$TZ apt-get install -y locales tzdata language-pack-fr && rm -rf /var/lib/apt/lists/* \
    && localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
    
EOF
done
