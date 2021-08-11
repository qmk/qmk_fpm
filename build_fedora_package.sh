#!/usr/bin/env bash

set -e
set -x

. /etc/os-release

rm -rf qmk

# Build the virtualenv
mkdir -p qmk/etc/yum.repos.d qmk/usr/bin qmk/usr/lib/udev/rules.d qmk/usr/share/python
python3 -m venv qmk/usr/share/python/qmk
qmk/usr/share/python/qmk/bin/pip install qmk

# Extract the version
QMK_VERSION=$(qmk/usr/share/python/qmk/bin/qmk --version)
sed -i s,/qmk-[0-9.]*-1.noarch.rpm,/qmk-${QMK_VERSION}-1.noarch.rpm, README.md
git commit -m"Update RPM version to ${QMK_VERSION}" README.md

# Make the virtualenv work in the final location
virtualenv-tools --update-path /usr/share/python/qmk qmk/usr/share/python/qmk
ln -s ../share/python/qmk/bin/qmk qmk/usr/bin/qmk

# Copy in some other files
cp 50-qmk.rules qmk/usr/lib/udev/rules.d/
sed "s,%VERSION_ID%,${VERSION_ID}," qmk.fedora.repo > qmk/etc/yum.repos.d/qmk-fedora-${VERSION_ID}.repo

# Build the fedora package
cd qmk
fpm \
	--input-type dir \
	--name qmk \
	--version "${QMK_VERSION}" \
	--description "Quantum Mechanical Keyboard (QMK) Firmware.

QMK is an open source keyboard firmware that can build a firmware and custom
layout for hundreds of keyboards, or your own custom design." \
	--url "https://qmk.fm/" \
	--output-type rpm \
	--license expat \
	--vendor QMK \
	--category devel \
	--architecture all \
	--maintainer 'QMK Firmware (Official QMK GPG Signing Key) <hello@qmk.fm>' \
	--depends clang \
	--depends diffutils \
	--depends git \
	--depends gcc \
	--depends glibc-headers \
	--depends kernel-devel \
	--depends kernel-headers \
	--depends make \
	--depends unzip \
	--depends wget \
	--depends zip \
	--depends python3 \
	--depends avr-binutils \
	--depends avr-gcc \
	--depends avr-libc \
	--depends arm-none-eabi-binutils-cs \
	--depends arm-none-eabi-gcc-cs \
	--depends arm-none-eabi-newlib \
	--depends avrdude \
	--depends dfu-programmer \
	--depends dfu-util \
	--depends hidapi \
	--depends which \
	. < /dev/null
