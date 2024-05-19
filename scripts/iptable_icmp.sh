#!/bin/bash

iptables -A INPUT -p icmp -j DROP
iptables -A OUTPUT -p icmp -j ACCEPT

# sudo nano /etc/sysctl.conf
# net.ipv4.icmp_echo_ignore_all = 1

