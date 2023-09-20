### Key Generation

```sh
gpg --full-generate-key
```

Real name: `QMK Firmware`

Email address: `hello@qmk.fm`

Comment: `Official QMK GPG Signing Key`

Key is valid for? `3y`

**No passphrase**

### Key Propagation

Export the public key:

```sh
gpg --export --armor 'QMK Firmware' | tee gpg_pubkey.txt
gpg --export-secret-keys --armor 'QMK Firmware' | tee gpg_private_key.txt
```

Update GitHub organization secrets:

* QMK_GPG_PUBLIC_KEY
* QMK_GPG_PRIVATE_KEY

Upload `gpg_pubkey.txt` to https://linux.qmk.fm/gpg_pubkey.txt (on DigitalOcean Spaces)
