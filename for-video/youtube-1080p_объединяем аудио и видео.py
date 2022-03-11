from pytube import YouTube
import subprocess

youtube = pytube.YouTube('https://youtu.be/4BEjkxK3OuI')

video = youtube.streams.filter(res='1080p').first()
audio = youtube.streams.filter(only_audio=True).first()

process_call_str = 'ffmpeg -i "{video.url}" -i "{audio.url}" -c:v copy -c:a aac "{video.title}".mp4'
subprocess.check_call(process_call_str, shell=True)
