#!/bin/python3
#######################################
# $> ./antizapret_proxy.py            #
# $> ./antizapret_proxy.py curl       #
# $> ./antizapret_proxy.py requests   #
#######################################

import sys
import subprocess
import re
import requests

proxy = 'curl' if len(sys.argv) != 2 else sys.argv[1]
URL = 'https://p.thenewone.lol:8443/proxy.pac'


def request_from_curl() -> str | None:
    # print('curl')
    cmd = (f"curl -s --location --max-time 7 {URL} "
           r"| tail -n 10 | grep PROXY | awk '{print $3}' | sed 's/;//g'")
    proxy = subprocess.getoutput(cmd)
    return proxy


def request_from_requests() -> str | None:
    # print('requests')
    try:
        request = requests.get(URL, timeout=7).text
        proxy = re.findall(r'PROXY.+', request)[0][6:-10]
        return proxy
    except Exception:
        pass


rq = {'curl': request_from_curl,
      'requests': request_from_requests}
print(rq.get(proxy, request_from_curl)())

