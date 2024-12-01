import itertools
import time

try:
    print('[', end="", flush=True)
    for i in itertools.cycle(range(10)):
        #print(f'{i:2d}', end="", flush=True)
        print('*', end="", flush=True)
        time.sleep(0.7)
        if i == 9:
            print(']', end="", flush=True)
            print('\nзагрузка завершена !!!')
            break
except KeyboardInterrupt:
    print(']\n... bye ... bye ...')
    exit(0)

