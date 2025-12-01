#!/bin/bash
# Скрипт настройки firewall для nftables
# Правила: локальный трафик разрешён, исходящий ping разрешён, входящий ping запрещён
# Разрешены: Docker, Nginx, SSH

#✅ Что будет работать:
#    Входящий ping — запрещён ❌
#    Исходящий ping — разрешён ✅
#    SSH — разрешён ✅
#    HTTP/HTTPS — разрешён ✅
#    Docker — работает ✅
#    Логирование заблокированных пакетов — работает ✅

set -e

# Автобэкап текущих правил
sudo nft list ruleset > $HOME/nftables-backup-$(date +%Y%m%d-%H%M%S).nft

echo "🔥 Настройка nftables firewall..."

# Создаем файл конфигурации
sudo tee /etc/nftables.conf > /dev/null << 'EOF'
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        
        # Разрешить весь трафик на localhost
        iifname "lo" accept
        ip saddr 127.0.0.0/8 accept
        ip6 saddr ::1/128 accept
        
        # Разрешить established/related соединения
        ct state established,related accept
        
        # ⚠️ ЗАПРЕТИТЬ входящий ping (echo-request)
        icmp type echo-request drop
        icmpv6 type echo-request drop
        
        # Разрешить остальной ICMP (БЕЗ echo-request!)
        icmp type { echo-reply, destination-unreachable, time-exceeded } accept
        icmpv6 type { echo-reply, destination-unreachable, time-exceeded } accept
        
        # Разрешить SSH (измените порт если нужно)
        tcp dport 22 accept
        
        # Разрешить HTTP/HTTPS для Nginx
        tcp dport {80, 443} accept
        
        # Разрешить Docker (все docker-интерфейсы)
        iifname "docker*" accept
        
        # Log rejected packets
        log prefix "nftables denied: " counter drop
    }
    
    chain forward {
        type filter hook forward priority 0; policy drop;
        
        # Разрешить форвардинг для Docker
        iifname "docker*" accept
        oifname "docker*" accept
        
        # Разрешить established/related
        ct state established,related accept
    }
    
    chain output {
        type filter hook output priority 0; policy accept;
        
        # Разрешить Docker в исходящих
        oifname "docker*" accept
    }
}
EOF

# Применяем правила
echo "🔄 Применяем правила nftables..."
sudo nft -f /etc/nftables.conf

# Включаем автозагрузку
echo "🚀 Включаем автозагрузку nftables..."
sudo systemctl enable --now nftables

# Проверяем правила
echo "📋 Проверяем applied правила:"
sudo nft list ruleset

echo "✅ Готово! Firewall настроен."
echo "📌 Правила:"
echo "   - Localhost: ✅ разрешён"
echo "   - Исходящий ping: ✅ разрешён" 
echo "   - Входящий ping: ❌ запрещён"
echo "   - SSH: ✅ разрешён"
echo "   - Nginx: ✅ разрешён"
echo "   - Docker: ✅ разрешён"

# Если docker не включил NAT / NAT для Docker контейнеров
# table ip nat {
#    chain postrouting {
#        type nat hook postrouting priority 100; policy accept;
#        ip saddr 172.17.0.0/16 oifname "enp4s0" masquerade
#    }
#}

