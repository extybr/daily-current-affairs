#!/bin/bash
# $> ./checking_dns_substitution.sh youtube.com 8
# Проверка подмены DNS запроса провайдером/DPI
# Сравниваем: провайдер/публичный DNS vs DoH (Cloudflare) - эталон
# FIXME: Временно / не очень высокая надежность, иногда ответы долгие, из-за [времени, TTL, географии] ответ может прийти разный

if [ "$#" -ne 2 ]; then
  echo -e "\033[31mExample:\033[0m ./checking_dns_substitution.sh youtube.com 8" && exit 1
fi

case $2 in
  0) dns=172.21.110.38  # local wan DNS
  ;;
  1) dns=1.1.1.1  # Cloudflare DNS
  ;;
  2) dns=1.0.0.1  # Cloudflare backup
  ;;
  4) dns=4.2.2.4  # Level3 DNS
  ;;
  7) dns=77.88.8.8  # Yandex DNS
  ;;
  8) dns=8.8.8.8  # Google DNS
  ;;
  9) dns=9.9.9.9  # Quad9 DNS
  ;;
  *) echo -e "\033[31mUnsupported DNS: $2\033[0m" && exit 1
  ;;
esac

echo -e "Checking $1 via $dns...\n"

# Получаем IP через обычный UDP и TCP
udp_ips=$(dig +udp $1 @$dns +timeout=2 | awk '/ANSWER SECTION/{flag=1; next} flag && /^$/{flag=0} flag {print $5}' | sort)
tcp_ips=$(dig +tcp $1 @$dns +timeout=2 | awk '/ANSWER SECTION/{flag=1; next} flag && /^$/{flag=0} flag {print $5}' | sort)

# Эталон через DoH (Cloudflare) — DPI может его детектить, но пока это лучший бесплатный эталон
doh_ip=$(curl -s -H 'accept: application/dns-json' "https://cloudflare-dns.com/dns-query?name=$1&type=A" \
         | jq -r '.Answer[].data' | sort)

# Проверяем, не пустой ли ответ от DoH (бывает, если Cloudflare заблокирован по IP)
if [[ -z "$doh_ip" ]]; then
  echo -e "\033[33m⚠️  No response from Cloudflare DoH (maybe blocked). Trying Google DoH...\033[0m"
  doh_ip=$(curl -s -H 'accept: application/dns-json' "https://dns.google/resolve?name=$1&type=A" \
           | jq -r '.Answer[].data' | sort)
fi

# Если вообще ничего не пришло — выходим
if [[ -z "$udp_ips" && -z "$tcp_ips" ]]; then
  echo -e "\033[31m❌ No response from DNS server $dns\033[0m"
  exit 1
fi

# Если DoH не ответил, пишем предупреждение
if [[ -z "$doh_ip" ]]; then
  echo -e "\033[33m⚠️  No response from DoH (Cloudflare/Google). Check your internet connection.\033[0m"
  doh_ip="(unavailable)"
fi

echo -e "\033[36mUDP ($dns):\033[0m\n$udp_ips\n"
echo -e "\033[36mTCP ($dns):\033[0m\n$tcp_ips\n"
echo -e "\033[36mDoH (Cloudflare/Google):\033[0m\n$doh_ip\n"

# --- АНАЛИЗ ---

# 1. Проверяем подмену (отличается ли ответ от DoH)
if [[ -n "$doh_ip" && "$doh_ip" != "(unavailable)" ]]; then
  if [[ "$udp_ips" != "$doh_ip" ]] || [[ "$tcp_ips" != "$doh_ip" ]]; then
    echo -e "\033[31m❌ DNS SPOOFING / DPI INTERFERENCE DETECTED!\033[0m"
    echo -e "   Ответ от $dns отличается от эталона (DoH)."
  else
    echo -e "\033[32m✅ OK - DNS ответы совпадают с эталоном (DoH)\033[0m"
  fi
else
  echo -e "\033[33m⚠️  Cannot verify against DoH (no response).\033[0m"
fi

# 2. Проверяем, не блокируется ли домен (пустой ответ от DoH, но не от провайдера — странно)
if [[ -z "$doh_ip" || "$doh_ip" == "(unavailable)" ]]; then
  if [[ -n "$udp_ips" || -n "$tcp_ips" ]]; then
    echo -e "\033[33m⚠️  Domain resolves via $dns but NOT via DoH. Possible censorship.\033[0m"
  fi
fi

# 3. Если UDP и TCP различаются — это тоже тревожный звонок (редко, но бывает при подмене)
if [[ "$udp_ips" != "$tcp_ips" ]]; then
  echo -e "\033[33m⚠️  UDP and TCP responses differ (possible MITM or round-robin).\033[0m"
fi
