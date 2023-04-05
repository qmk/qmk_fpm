#!/usr/bin/env bash

set -e
set -x

. /etc/os-release

rm -rf deb_repo qmk *.deb

# Build the virtualenv
mkdir -p qmk/usr/bin qmk/usr/share/python
python3 -m venv qmk/usr/share/python/qmk
source qmk/usr/share/python/qmk/bin/activate
pip install qmk wheel
deactivate

# Extract the version
QMK_VERSION=$(qmk/usr/share/python/qmk/bin/qmk --version)

# Make the virtualenv work in the final location
virtualenv-tools --update-path /usr/share/python/qmk qmk/usr/share/python/qmk
ln -s ../share/python/qmk/bin/qmk qmk/usr/bin/qmk

# Install the qmk_udev package
[ -d qmk_udev/.git ] || git clone https://github.com/qmk/qmk_udev.git
cd qmk_udev
make DESTDIR=../qmk PREFIX=/usr install
cd ..

# Build the debian package
cd qmk
fpm \
	--input-type dir \
	--name qmk \
	--version "${QMK_VERSION}-1" \
	--description "Quantum Mechanical Keyboard (QMK) Firmware.\n\nQMK is an open source keyboard firmware that can build a firmware and custom\nlayout for hundreds of keyboards, or your own custom design." \
	--url "https://qmk.fm/" \
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
	.
