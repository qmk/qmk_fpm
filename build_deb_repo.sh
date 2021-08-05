#!/usr/bin/env bash

set -e

. /etc/os-release

rm -rf deb_repo

if ! [ -e qmk ]; then
	echo
	echo '*** Building the qmk .deb package:'
	echo
	./build_deb_package.sh
fi

# Import the GPG key
if [ -n "$QMK_GPG_PRIVATE_KEY" ]; then
	echo '*** Importing GPG key...'
	echo "$QMK_GPG_PRIVATE_KEY" | gpg --batch --import
else
	echo -e '\n*** Warning: Could not import GPG key!\n'
fi

# Create the repo structure
mkdir -p deb_repo/deb deb_repo/main
cp *.deb deb_repo/deb
cd deb_repo

# Build the repo metadata
apt-ftparchive packages deb > main/Packages
gzip -k main/Packages
apt-ftparchive release . > Release

# Sign the repo for security
dpkg-sig -s builder -k F464DFD46C4DA3FD4D06234691B06358D2CAE8AE deb/*.deb
gpg --default-key F464DFD46C4DA3FD4D06234691B06358D2CAE8AE -abs -o Release.gpg Release
gpg --default-key F464DFD46C4DA3FD4D06234691B06358D2CAE8AE --clearsign -o InRelease Release
