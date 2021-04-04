#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

declare -A aliases=(
	#[suite]='tag1 tag2 ...'
)
aliases[$(< latest)]+=' latest'
#aliases[$(< rolling)]+=' rolling' # https://github.com/docker-library/official-images/issues/2323#issuecomment-284409446

develSuite="$(
	wget -qO- http://archive.ubuntu.com/ubuntu/dists/devel/Release \
		| awk -F ': ' '$1 == "Codename" { print $2; exit }' \
		|| true
)"
if [ "$develSuite" ]; then
	aliases[$develSuite]+=' devel'
fi

archMaps=( $(
	git ls-remote --heads https://github.com/docker-jb35/ubuntu.git \
		| awk -F '[\t/]' '$4 ~ /^dist-/ { gsub(/^dist-/, "", $4); print $4 "=" $1 }' \
		| sort
) )
arches=()
declare -A archCommits=()
for archMap in "${archMaps[@]}"; do
	arch="${archMap%%=*}"
	commit="${archMap#${arch}=}"
	arches+=( "$arch" )
	archCommits[$arch]="$commit"
done

versions=( */alias )
versions=( "${versions[@]%/alias}" )

cat <<-EOH
# see https://partner-images.canonical.com/core/
# see also https://wiki.ubuntu.com/Releases#Current

Maintainers: Julie Brindejont <julie.brindejont@gmail.com> (@julie35400)
GitRepo: https://github.com/docker-jb35/ubuntu.git
GitCommit: $(git log --format='format:%H' -1)
EOH
for arch in "${arches[@]}"; do
	cat <<-EOA
		# https://github.com/docker-jb35/ubuntu/tree/dist-${arch}
		${arch}-GitFetch: refs/heads/dist-${arch}
		${arch}-GitCommit: ${archCommits[$arch]}
	EOA
done

for version in "${versions[@]}"; do
	versionArches=()
	versionSerial=
	for arch in "${arches[@]}"; do
        echo $arch
    done

    [ -n "$versionSerial" ]

	versionAliases=()

	[ -s "$version/alias" ] && versionAliases+=( $(< "$version/alias") )

	versionAliases+=( $version-$versionSerial )

	versionAliases+=(
		$version
		${aliases[$version]:-}
	)

	# assert some amount of sanity
	[ "${#versionArches[@]}" -gt 0 ]

    echo
	cat <<-EOE
		# $versionSerial ($version)
		Tags: $(join ', ' "${versionAliases[@]}")
		Architectures: $(join ', ' "${versionArches[@]}")
		Directory: $version
	EOE
done