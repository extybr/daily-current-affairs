from playsound import playsound

try:
    playsound("I:\\Audio\\AUD-20210719-WA0003.mp3")
except Exception as error:
    print(error)