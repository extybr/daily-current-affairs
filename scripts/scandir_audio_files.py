#!/bin/python3
######################################
# $> ./scan_audio_files.py ~/Music   #
######################################

import sys
from pathlib import Path


def search(path: str) -> None:
    folders = Path(path)
    exts = ['.mp3', '.flac', '.ape']
    for folder in folders.iterdir():
        if folder.is_dir():
            search(folder)
        for ext in exts:
            if str(folder).endswith(ext):
                with open(file='playlist.m3u', mode='a', encoding='utf-8') as playlist:
                    playlist.write(str(folder) + '\n')


with open(file='playlist.m3u', mode='w', encoding='utf-8') as playlist:
    playlist.write('#EXTM3U\n')
    
directory = sys.argv[1] if len(sys.argv) > 1 else '.'
search(directory)

