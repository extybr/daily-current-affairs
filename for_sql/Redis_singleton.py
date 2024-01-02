# https://habr.com/ru/companies/sberbank/articles/736464/
# singleton with handle errors connect
import time
from multiprocessing import Pool
from redis.client import Redis
from redis.backoff import ExponentialBackoff
from redis.retry import Retry
from redis.exceptions import (
    BusyLoadingError,
    ConnectionError,
    TimeoutError
)

REQUESTS_COUNT = 100000
RETRY = 3
TIMEOUT = 2

class Singleton:
    _instance = None
    @staticmethod
    def get_connection():
        if not Singleton._instance:
            Singleton._instance = Redis(
                host='0.0.0.0', 
                port=6379, 
                socket_timeout=TIMEOUT,
                retry=Retry(ExponentialBackoff(), RETRY), 
                retry_on_error=[BusyLoadingError, ConnectionError, TimeoutError]
            )
        return Singleton._instance


def test(i):
    client = Singleton.get_connection()
    client.set(i, i)
    assert client.get(i) != i, 'wrong save'


start_time = time.time()

with Pool(16) as p:
    p.map(test, range(REQUESTS_COUNT))

sec = time.time() - start_time
print(f'time {sec:0.2f} seconds')

