from pathlib import Path
from tempfile import gettempdir


def temp_directory() -> str:
    name = 'tempfolder'
    try:
        path_temp = str(Path(gettempdir()) / name)
        return path_temp
    except Exception:
        return name


print(temp_directory())
