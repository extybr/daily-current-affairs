import qrcode

image = qrcode.make("https://github.com/extybr")

image.save("qr.png")