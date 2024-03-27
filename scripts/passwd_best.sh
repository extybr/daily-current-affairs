#!/bin/sh
sudo mkdir -p /mnt/crypto
veracrypt --mount $HOME'/passwd' '/mnt/crypto' --password 'my-pass' --explore --slot=1

# truecrypt file
# veracrypt --mount 'my-path/my-file'  --password 'my-pass' --explore -tc --slot=2
