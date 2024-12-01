import asyncio
import itertools
import sys


async def spin(msg):
    write, flush = sys.stdout.write, sys.stdout.flush
    status = ''
    for char in itertools.cycle('|/-\\'):
        status = char + ' ' + msg
        write(status)
        flush()
        write('\x08' * len(status))
        try:
            await asyncio.sleep(0.1)
        except asyncio.CancelledError:
            break
    write(' ' * len(status) + '\x08' * len(status))


async def slow_function():
    # pretend waiting a long time for I/O
    await asyncio.sleep(3)
    return 'hello'


async def supervisor():
    spinner_task = asyncio.create_task(spin('thinking!'))
    print('spinner task:', spinner_task)
    result = await slow_function()
    spinner_task.cancel()
    return result


def main():
    # Используем asyncio.run() для запуска главной асинхронной функции
    result = asyncio.run(supervisor())
    print('Answer:', result)


if __name__ == '__main__':
    main()

