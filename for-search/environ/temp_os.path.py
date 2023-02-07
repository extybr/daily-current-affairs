import os.path
from platform import system


def temp_directory() -> str:
    name = 'tempfolder'
    if system() == 'Windows':
        path_temp = os.environ.get('TEMP', 0)
        if path_temp == 0:
            path_temp = os.environ.get('TMP', 0)
        else:
            if path_temp == 0:
                return name
        return os.path.join(path_temp, name)
    else:
        return name


print(temp_directory())
