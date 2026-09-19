#!/bin/bash

sudo tshark -i $eth0 -Y 'tls.handshake.type == 1||dns'
