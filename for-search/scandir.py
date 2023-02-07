import os


def scan(path):
    try:
        for items in os.scandir(path):
            fullpath = os.path.abspath(os.path.join(path, items))
            print(fullpath)
            if os.path.isdir(items):
                scan(items)
    except BaseException as error:
        print(error)


scan(os.sep)
