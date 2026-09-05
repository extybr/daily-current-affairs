#!/bin/bash

gnome-terminal --tab --title="DNS Monitor" -- bash -c "sudo -E uv run dns_monitor.py; exec bash"
gnome-terminal --tab --title="SNI Monitor" -- bash -c "sudo -E uv run sni_monitor.py; exec bash"
