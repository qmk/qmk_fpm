# QMK FPM

This repo exists to generate packages for the QMK cli.

# Usage instructions

## Debian-like, or Ubuntu-like distributions

Add the QMK source to your apt repositories list:

     # QMK
    echo "deb https://linux.qmk.fm/ $(lsb_release --codename --short) main" | sudo tee /etc/apt/sources.list.d/qmk.list

Add the QMK GPG Key:

    wget -qO - https://linux.qmk.fm/gpg_pubkey.txt | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/qmk-gpg-pubkey.gpg > /dev/null

Update apt:

    sudo apt update

Install QMK:

    sudo apt install qmk

## Fedora

First install the QMK pubkey:

    sudo rpm --import https://linux.qmk.fm/gpg_pubkey.txt

Install the package for your version:

    dnf install https://linux.qmk.fm/dists/fedora/$(lsb_release --short --release)/qmk-1.1.2-1.noarch.rpm

Make sure you replace `{VERSION_ID}` with the number you got from `/etc/os-release`.

