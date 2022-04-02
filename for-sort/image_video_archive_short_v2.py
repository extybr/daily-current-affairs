# name = input('Название файла: ')
name = 'ls.txt'
image_file = ['.jpg', '.jpeg', '.png', '.gif']
video_file = ['.mp4', '.mov', '.avi', '.mkv', '.mpeg', '.3gp', '.wmv', '.ts', '.m4v', '.m2ts',
              '.mpg', '.swf', '.flv', '.webm', '.mxf']
archive_file = ['.zip', '.7z', '.gzip', '.rar']

with open(name, 'r', encoding='utf-8') as text:
    image = open(f'{name[:-4]}_image{name[-4:]}', 'w')
    video = open(f'{name[:-4]}_video{name[-4:]}', 'w')
    archive = open(f'{name[:-4]}_archive{name[-4:]}', 'w')
    for line in text:
        if line.startswith('AAA') or line.startswith('BBB'):
            if [i for i in image_file if line.strip().endswith(i) or line.strip().endswith(i.upper())]:
                image.write(line)
            if [i for i in video_file if line.strip().endswith(i) or line.strip().endswith(i.upper())]:
                video.write(line)
            if [i for i in archive_file if line.strip().endswith(i) or line.strip().endswith(i.upper())]:
                archive.write(line)
    image.close(), video.close(), archive.close()
