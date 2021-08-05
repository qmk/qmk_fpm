# QMK FPM

This repo exists to generate packages for the QMK cli.

# Usage instructions

## OS Specific

### Debian 10 (buster)

Add this to /etc/apt/sources.list:

    # QMK
    deb https://debian.qmk.fm/ buster main

### Ubuntu 20.04 (focal)

Add this to /etc/apt/sources.list:

    # QMK
    deb https://debian.qmk.fm/ focal main

## All distributions

Add the QMK GPG Key:

    curl https://debian.qmk.fm/gpg_pubkey.txt | sudo apt-key add -

Update apt:

    sudo apt update

Install QMK:

    sudo apt install qmk
