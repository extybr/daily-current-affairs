#!/bin/bash
# Добавляет записи в iptables для отброса icmp пакетов

iptables -A INPUT -p icmp -j DROP
iptables -A OUTPUT -p icmp -j ACCEPT

# WARNING: operating system dependency [deb/arch]
# sudo nano /etc/sysctl.conf
# net.ipv4.icmp_echo_ignore_all = 1

