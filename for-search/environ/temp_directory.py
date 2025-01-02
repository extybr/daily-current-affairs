from pathlib import Path
from tempfile import gettempdir

print(type(gettempdir()))
print(gettempdir())

temp_dir = Path(gettempdir())
print(temp_dir.exists())

