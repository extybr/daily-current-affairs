#!/bin/bash
# Скрипт для отката

echo "# Экстренное отключение firewall (через консоль) / Полностью отключить firewall
sudo nft flush ruleset
sudo systemctl stop nftables

# Полная очистка (Полное удаление правил)
sudo nft delete table inet filter 2>/dev/null || true
sudo systemctl disable nftables

# Или разрешить SSH временно (для примера)
sudo nft add rule inet filter input tcp dport 22 accept
"

# Восстановление дефолтных правил

echo "🔄 Восстанавливаем стандартные правила..."

# Вариант 1: Разрешить ВСЁ (экстренный случай)
sudo nft flush ruleset
sudo nft add table inet filter
sudo nft add chain inet filter input { type filter hook input priority 0; policy accept; }
sudo nft add chain inet filter forward { type filter hook forward priority 0; policy accept; }
sudo nft add chain inet filter output { type filter hook output priority 0; policy accept; }

# Вариант 2:
echo "# Вариант: Восстановить из бэкапа
sudo nft -f $HOME/nftables-backup-20241201-120000.nft
"
echo "✅ Firewall отключен. Все разрешено."

