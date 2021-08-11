#!/usr/bin/env bash

set -e

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

set -x

. /etc/os-release

ARCHITECTURES="i386 amd64 arm arm64"

# Create the repo structure
mkdir -p deb_repo/deb
cp qmk/*.deb deb_repo/deb
cd deb_repo

# Sign the packages
dpkg-sig -s builder -k F464DFD46C4DA3FD4D06234691B06358D2CAE8AE deb/*.deb

# Build the repo metadata
for arch in $ARCHITECTURES; do
	mkdir -p main/binary-$arch
	apt-ftparchive packages deb | sed "s,^Filename: ,Filename: dists/${VERSION_CODENAME}/," > main/binary-${arch}/Packages
	gzip -k main/binary-${arch}/Packages
done

apt-ftparchive \
	-o APT::FTPArchive::Release::Origin="QMK" \
	-o APT::FTPArchive::Release::Label="QMK $ID Package" \
	-o APT::FTPArchive::Release::Suite="stable" \
	-o APT::FTPArchive::Release::Codename="$VERSION_CODENAME" \
	-o APT::FTPArchive::Release::Architectures="i386 amd64 arm arm64" \
	-o APT::FTPArchive::Release::Components="main" \
	release . > Release

# Sign the repo for security
gpg --default-key F464DFD46C4DA3FD4D06234691B06358D2CAE8AE -abs -o Release.gpg Release
gpg --default-key F464DFD46C4DA3FD4D06234691B06358D2CAE8AE --clearsign -o InRelease Release

# Debugging information
cd ..
find deb_repo -type f -ls
echo MD5: $(md5sum deb_repo/deb/*.deb)
echo SHA256: $(sha256sum deb_repo/deb/*.deb)
echo Packages:
cat deb_repo/main/binary-amd64/Packages
