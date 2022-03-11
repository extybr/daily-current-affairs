
# name = input('Название файла: ')
name = 'ls.txt'
text = open(name, 'r', encoding='utf-8')
image = open(name[:-4] + '_image' + name[-4:], 'w')
video = open(name[:-4] + '_video' + name[-4:], 'w')
arhive = open(name[:-4] + '_arhive' + name[-4:], 'w')
for line in text:
    if line.startswith('AAA') or line.startswith('BBB'):
        if line.endswith('.jpg\n') or line.endswith('.jpg') or line.endswith('.jpeg\n') or \
                line.endswith('.jpeg') or line.endswith('.png\n') or line.endswith('.png') or \
                line.endswith('.gif\n') or line.endswith('.gif'):
            image.write(line)
        elif line.endswith('.mp4\n') or line.endswith('.mp4') or line.endswith('.avi\n') or \
                line.endswith('.avi') or line.endswith('.mov\n') or line.endswith('.mov') or \
                line.endswith('.mkv\n') or line.endswith('.mkv') or line.endswith('.mpeg\n') or \
                line.endswith('.mpeg') or line.endswith('.3gp\n') or line.endswith('.3gp') or \
                line.endswith('.wmv\n') or line.endswith('.wmv') or line.endswith('.ts\n') or \
                line.endswith('.ts') or line.endswith('.m4v\n') or line.endswith('.m4v') or \
                line.endswith('.M4V\n') or line.endswith('.M4V') or line.endswith('.M2TS\n') or \
                line.endswith('.M2TS') or line.endswith('.mpg\n') or line.endswith('.mpg') or \
                line.endswith('.swf\n') or line.endswith('.swf') or line.endswith('.flv\n') or \
                line.endswith('.flv') or line.endswith('.webm\n') or line.endswith('.webm') or \
                line.endswith('.mxf\n') or line.endswith('.mxf'):
            video.write(line)
        elif line.endswith('.zip\n') or line.endswith('.zip') or line.endswith('.rar\n') or \
                line.endswith('.rar') or line.endswith('.7z\n') or line.endswith('.7z') or \
                line.endswith('.gzip\n') or line.endswith('.gzip'):
            arhive.write(line)
text.close()
image.close()
video.close()
arhive.close()
