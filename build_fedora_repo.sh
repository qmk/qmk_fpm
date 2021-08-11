#!/usr/bin/env bash

set -e

rm -rf rpm_repo

if ! [ -e qmk ]; then
	echo
	echo '*** Building the qmk .rpm package:'
	echo
	./build_fedora_package.sh
fi

# Import the GPG key
if [ -n "$QMK_GPG_PRIVATE_KEY" ]; then
	echo '*** Importing GPG key...'
	echo "$QMK_GPG_PRIVATE_KEY" | gpg --batch --import
else
	echo -e '\n*** Warning: Could not import GPG key!\n'
fi

set -x

. /etc/os-release

ARCHITECTURES="i386 amd64 arm arm64"

# Create the repo structure
mkdir -p rpm_repo
cp qmk/*.rpm rpm_repo

# Sign the package
cp rpmmacros ~/.rpmmacros
rpm --addsign rpm_repo/*.rpm

# Build the repo metadata
createrepo -v -s md5 rpm_repo

# Debugging information
find rpm_repo -type f -ls
