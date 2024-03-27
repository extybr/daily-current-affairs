#!/bin/sh
sudo mount /dev/mapper/bitlk-b2ffde3b-37fd-423d-b6ea-e3b014202763 /run/media/tux/Samsung-500GB

#!/bin/sh
sudo mkdir -p /mnt/crypto
veracrypt --mount 'my-path/my-file'  --password 'my-pass' --explore -tc --slot=2

#!/bin/sh
sudo mkdir -p /mnt/crypto
veracrypt --mount $HOME'/passwd' '/mnt/crypto' --password 'my-pass' --explore --slot=1

