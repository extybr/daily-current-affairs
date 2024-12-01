import os
import time

try:
	while True:
		for i in range(10):
		    os.system('clear')
		    [print(i, flush=True) for i in range(i)]
		    time.sleep(0.7)

		for i in range(10, 0, -1):
		    os.system('clear')
		    [print(i, flush=True) for i in range(i)]
		    time.sleep(0.7)
except KeyboardInterrupt:
    print('... bye ... bye ...')
    exit(0)
    
