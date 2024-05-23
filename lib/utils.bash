#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/rancher/machine"
TOOL_NAME="rancher-machine"
TOOL_TEST="rancher-machine -v"
ASDF_PLUGIN_NAME="$TOOL_NAME"

fail() {
	echo -e "$ASDF_PLUGIN_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -V | awk '{print $2}'
}

function is_greater() {
	[[ "$(printf '%s\n' "$1" "$2" | sort_versions | head -n1)" == "$2" ]]
}

list_github_tags() {
	for version in $(git ls-remote --tags --refs "$REPO_URL" | grep -o 'refs/tags/.*' | cut -d/ -f3- | sed 's/^v//'); do
		if ! is_greater "0.15.0-rancher20" "$version" && [[ $version != docs* ]]; then
			echo "$version"
		fi
	done
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version url architecture release_file
	version="$1"

	case "$(uname -m)" in
	aarch64* | arm64) architecture="arm64" ;;
	x86_64*) architecture="amd64" ;;
	*)
		fail "Unsupported architecture ($architecture)"
		;;
	esac

	mkdir -p "$ASDF_DOWNLOAD_PATH"

	release_file="rancher-machine-$architecture.tar.gz"
	url="$REPO_URL/releases/download/v${version}/$release_file"

	echo "* Downloading $TOOL_NAME ($release_file) release $version to $ASDF_DOWNLOAD_PATH..."
	curl "${curl_opts[@]}" -o "$ASDF_DOWNLOAD_PATH/$release_file" -C - "$url" || fail "Could not download $url"

	echo "* Extracting $TOOL_NAME ($release_file)..."
	tar -xzf "$ASDF_DOWNLOAD_PATH/$release_file" -C "$ASDF_DOWNLOAD_PATH" || fail "Could not extract $release_file"

	echo "* Cleaning up..."
	rm "$ASDF_DOWNLOAD_PATH/$release_file"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "$ASDF_PLUGIN_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"

		chmod +x "$install_path/$tool_cmd"

		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
