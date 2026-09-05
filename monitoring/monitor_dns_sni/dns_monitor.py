# dns_monitor.py
# Запускать с sudo/правами администратора
# sudo resolvectl flush-caches && echo "DNS кеш очищен"  # очистка кеша dns

from scapy.all import sniff, DNS, DNSQR, IP, UDP

def packet_callback(packet):
    if packet.haslayer(DNS) and packet.getlayer(DNS).qr == 0:  # qr=0 значит запрос
        dns_layer = packet.getlayer(DNS)
        if dns_layer.qd:
            qname = dns_layer.qd.qname.decode('utf-8') if dns_layer.qd.qname else b''
            print(f"[DNS запрос] {qname} от {packet[IP].src}")

def main():
    print("Запущен мониторинг DNS-запросов... (нажмите Ctrl+C для выхода)")
    try:
        sniff(filter="udp port 53", prn=packet_callback, store=0)
    except KeyboardInterrupt:
        print("\nМониторинг остановлен.")

if __name__ == "__main__":
    main()
