#!/usr/bin/env bash

set -e
set -x

. /etc/os-release

rm -rf deb_repo qmk *.deb

# Build the virtualenv
mkdir -p qmk/usr/bin qmk/usr/lib/udev/rules.d qmk/usr/share/python
python3 -m venv qmk/usr/share/python/qmk
qmk/usr/share/python/qmk/bin/pip install qmk

# Extract the version
QMK_VERSION=$(qmk/usr/share/python/qmk/bin/qmk --version)

# Make the virtualenv work in the final location
virtualenv-tools --update-path /usr/share/python/qmk qmk/usr/share/python/qmk
ln -s ../share/python/qmk/bin/qmk qmk/usr/bin/qmk

# Copy in some other files
cp 50-qmk.rules qmk/usr/lib/udev/rules.d/

# Build the debian package
fpm \
	--input-type dir \
	--name qmk \
	--version "${QMK_VERSION}-1" \
	--output-type deb \
	--license expat \
	--vendor QMK \
	--category devel \
	--architecture all \
	--maintainer 'QMK Firmware (Official QMK GPG Signing Key) <hello@qmk.fm>' \
	--deb-dist ${VERSION_CODENAME} \
	--depends build-essential \
	--depends clang-format \
	--depends diffutils \
	--depends gcc \
	--depends git \
	--depends unzip \
	--depends wget \
	--depends zip \
	--depends python3-pip \
	--depends binutils-avr \
	--depends gcc-avr \
	--depends avr-libc \
	--depends binutils-arm-none-eabi \
	--depends gcc-arm-none-eabi \
	--depends libnewlib-arm-none-eabi \
	--depends avrdude \
	--depends dfu-programmer \
	--depends dfu-util \
	--depends teensy-loader-cli \
	--depends libhidapi-hidraw0 \
	--depends libusb-dev \
	qmk
