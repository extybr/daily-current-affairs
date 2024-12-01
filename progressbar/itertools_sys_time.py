import sys
import time
import itertools

CURSOR_UP_ONE = '\x1b[1A'
ERASE_LINE = '\x1b[2K'


def delete_last_lines(n=1):
    for _ in range(n):
        sys.stdout.write(CURSOR_UP_ONE)
        sys.stdout.write(ERASE_LINE)
       
        
def reverse():        
    for index in itertools.cycle(range(10, 0, -1)):
        print(f'{index}', flush=True)
        time.sleep(0.5)
        delete_last_lines()
        if index == 1:
            forward()


def forward():        
    for index in itertools.cycle(range(10)):
        print(f'{index}', flush=True)
        time.sleep(0.5)
        delete_last_lines()
        if index == 9:
            reverse()
    

try: 
    forward()
except KeyboardInterrupt:
    print('... bye ... bye ...')
    exit(0)

