from PIL import Image, ImageGrab
from time import sleep

sleep(5)
screen1 = ImageGrab.grab(bbox=None, all_screens=True)
screen2 = ImageGrab.grab(bbox=(0, 0, 1680, 1050), all_screens=False)
screen1.save('screenshot.png')
screen2.save('screenshot.jpg')
screen1 = Image.open('screenshot.png')
screen2 = Image.open('screenshot.jpg')
# screen1.show()
print(screen1.format, screen1.size, screen1.mode)
print(screen2.format, screen2.size, screen2.mode)
