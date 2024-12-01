import os
import time
import itertools

try:
    for i in itertools.cycle(range(10)):
        os.system('clear')
        [print(i, flush=True) for i in range(i)]
        time.sleep(0.7)
except KeyboardInterrupt:
    print('... bye ... bye ...')
    exit(0)

