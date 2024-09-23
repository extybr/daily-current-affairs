#!/bin/sh
#######################################
# $> ./short-link.sh t.me/extybr_bot  #
#######################################

curl -F url="https://$1" "https://shorta.link"

