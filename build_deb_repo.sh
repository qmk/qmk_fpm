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
mkdir -p deb_repo/deb deb_repo/main/binary-amd64 deb_repo/main/binary-arm deb_repo/main/binary-arm64
cp *.deb deb_repo/deb
cd deb_repo

# Build the repo metadata
for dir in deb_repo/main/binary-amd64 deb_repo/main/binary-arm deb_repo/main/binary-arm64; do
	apt-ftparchive packages deb > ${dir}/Packages
	gzip -k ${dir}/Packages
done

apt-ftparchive \
	-o APT::FTPArchive::Release::Origin="QMK" \
	-o APT::FTPArchive::Release::Label="QMK $ID Package" \
	-o APT::FTPArchive::Release::Suite="stable" \
	-o APT::FTPArchive::Release::Codename="$VERSION_CODENAME" \
	-o APT::FTPArchive::Release::Architectures="any" \
	-o APT::FTPArchive::Release::Components="main" \
	release . > Release

# Sign the repo for security
dpkg-sig -s builder -k F464DFD46C4DA3FD4D06234691B06358D2CAE8AE deb/*.deb
gpg --default-key F464DFD46C4DA3FD4D06234691B06358D2CAE8AE -abs -o Release.gpg Release
gpg --default-key F464DFD46C4DA3FD4D06234691B06358D2CAE8AE --clearsign -o InRelease Release
