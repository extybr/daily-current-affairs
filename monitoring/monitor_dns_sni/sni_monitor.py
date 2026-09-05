# sni_monitor.py
# Запускать с sudo/правами администратора

from scapy.all import sniff, IP, TCP
import struct

def parse_tls_sni(payload):
    """Извлекает SNI из TLS ClientHello, если он есть."""
    try:
        # Проверяем, что это TLS-запись (тип 0x16 = Handshake)
        if len(payload) < 6 or payload[0] != 0x16:
            return None
        
        tls_version = struct.unpack('>H', payload[1:3])[0]
        # TLS версии 1.0, 1.1, 1.2, 1.3
        if tls_version not in [0x0301, 0x0302, 0x0303, 0x0304]:
            return None
        
        # Длина записи
        record_len = struct.unpack('>H', payload[3:5])[0]
        if len(payload) < 5 + record_len:
            return None
        
        handshake = payload[5:5+record_len]
        if len(handshake) < 4 or handshake[0] != 0x01:  # ClientHello тип 0x01
            return None
        
        # Пропускаем длину handshake (3 байта), версию (2 байта) и random (32 байта)
        pos = 4 + 2 + 32
        if pos >= len(handshake):
            return None
        
        # Длина сессии (1 байт)
        session_len = handshake[pos]
        pos += 1 + session_len
        
        # Длина cipher suites (2 байта)
        if pos + 2 > len(handshake):
            return None
        cipher_len = struct.unpack('>H', handshake[pos:pos+2])[0]
        pos += 2 + cipher_len
        
        # Длина compression methods (1 байт)
        if pos >= len(handshake):
            return None
        comp_len = handshake[pos]
        pos += 1 + comp_len
        
        # Расширения: длина (2 байта)
        if pos + 2 > len(handshake):
            return None
        ext_len = struct.unpack('>H', handshake[pos:pos+2])[0]
        pos += 2
        
        end = pos + ext_len
        while pos + 4 <= end:
            ext_type = struct.unpack('>H', handshake[pos:pos+2])[0]
            ext_len = struct.unpack('>H', handshake[pos+2:pos+4])[0]
            pos += 4
            if ext_type == 0x0000:  # SNI Extension
                # SNI data length (2 байта)
                if pos + 2 > end:
                    return None
                sni_list_len = struct.unpack('>H', handshake[pos:pos+2])[0]
                pos += 2
                if pos + 2 > end:
                    return None
                sni_type = handshake[pos]  # Должно быть 0x00 (hostname)
                sni_len = struct.unpack('>H', handshake[pos+1:pos+3])[0]
                pos += 3
                if pos + sni_len <= end:
                    return handshake[pos:pos+sni_len].decode('utf-8', errors='ignore')
            pos += ext_len
    except Exception:
        pass
    return None

def packet_callback(packet):
    if packet.haslayer(TCP) and packet[TCP].dport == 443:
        payload = bytes(packet[TCP].payload)
        if len(payload) > 40:  # Минимальная длина для ClientHello
            sni = parse_tls_sni(payload)
            if sni:
                print(f"[SNI] {sni} от {packet[IP].src}:{packet[TCP].sport}")

def main():
    print("Запущен мониторинг SNI (TLS ClientHello)... (нажмите Ctrl+C для выхода)")
    try:
        sniff(filter="tcp port 443", prn=packet_callback, store=0)
    except KeyboardInterrupt:
        print("\nМониторинг остановлен.")

if __name__ == "__main__":
    main()
