# QMK FPM

This repo exists to generate packages for the QMK cli.

# Usage instructions

## Debian-like

### Debian 10 (buster)

Add this to /etc/apt/sources.list:

    # QMK
    deb https://debian.qmk.fm/ buster main

Then follow the instructions under [All Debian-like distributions](all-debian-like-distributions).

### Ubuntu 20.04 (focal)

Add this to /etc/apt/sources.list:

    # QMK
    deb https://debian.qmk.fm/ focal main

Then follow the instructions under [All Debian-like distributions](all-debian-like-distributions).

### All Debian-like distributions

Add the QMK GPG Key:

    curl https://debian.qmk.fm/gpg_pubkey.txt | sudo apt-key add -

Update apt:

    sudo apt update

Install QMK:

    sudo apt install qmk

## Fedora

First install the QMK pubkey:

    curl https://debian.qmk.fm/gpg_pubkey.txt > qmk.pubkey
    sudo rpm --import qmk.pubkey

Next identify the Version ID for your Fedora, this will be 32, 33, or 34:

    grep VERSION_ID /etc/os-release

Install the package for your version:

    dnf install https://debian.qmk.fm/dists/fedora/{VERSION_ID}/qmk-0.3.3-1.noarch.rpm

Make sure you replace `{VERSION_ID}` with the number you got from `/etc/os-release`.

Note: We do not support Fedora 35 yet.
