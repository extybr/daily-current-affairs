import os


def f(b):
    try:
        for j in os.scandir(b):
            d = os.path.abspath(os.path.join(b, j))
            print(d)
            if os.path.isdir(d):
                f(d)
        return j
    except BaseException:
        print()


a = os.sep
for i in f(a):
    print(i)