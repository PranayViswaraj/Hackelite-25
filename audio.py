import pygame

def play_audio(file):
    pygame.mixer.init()
    pygame.mixer.music.load(file)
    pygame.mixer.music.play()
    while pygame.mixer.music.get_busy():
        continue

with open("sim_out.txt", "r") as f:
    for line in f:
        line = line.strip()
        if "PLAY AUDIO2" in line:
            play_audio("audio1.mp3")
        elif "PLAY AUDIO1" in line:
            play_audio("audio2.mp3")
