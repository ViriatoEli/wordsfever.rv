import wave
import struct
import math
import random
import os

SAMPLE_RATE = 44100

def save_wav(filename, samples):
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(SAMPLE_RATE)
        for sample in samples:
            clamped = max(-1.0, min(1.0, sample))
            value = int(clamped * 32767)
            wav_file.writeframes(struct.pack('<h', value))

def generate_tone(freq, duration, volume=0.5, wave_type='sine'):
    samples = []
    num_samples = int(SAMPLE_RATE * duration)
    for i in range(num_samples):
        t = float(i) / SAMPLE_RATE
        if wave_type == 'sine':
            val = math.sin(2.0 * math.pi * freq * t)
        elif wave_type == 'square':
            val = 1.0 if math.sin(2.0 * math.pi * freq * t) > 0 else -1.0
        elif wave_type == 'saw':
            val = 2.0 * (t * freq - math.floor(t * freq + 0.5))
        elif wave_type == 'noise':
            val = random.uniform(-1.0, 1.0)
        
        # Envelope to avoid clicks
        env = 1.0
        if i < 441:
            env = i / 441.0
        elif i > num_samples - 441:
            env = (num_samples - i) / 441.0
            
        samples.append(val * volume * env)
    return samples

def append_samples(base, new_samples):
    base.extend(new_samples)

def mix_samples(base, new_samples):
    if len(new_samples) > len(base):
        base.extend([0] * (len(new_samples) - len(base)))
    for i in range(len(new_samples)):
        base[i] += new_samples[i]

def generate_indovina_bgm():
    # Simple calm arpeggio loop (C major)
    notes = [261.63, 329.63, 392.00, 523.25] # C4, E4, G4, C5
    samples = []
    for _ in range(8): # 8 iterations of arpeggio
        for f in notes:
            append_samples(samples, generate_tone(f, 0.25, 0.1, 'sine'))
    save_wav('assets/audio/indovina_bgm.wav', samples)

def generate_bomb_bgm():
    # Tense low drone + rhythmic pulse
    samples = []
    for i in range(16):
        drone = generate_tone(65.41, 0.5, 0.2, 'saw') # Low C
        pulse = generate_tone(130.81, 0.1, 0.1, 'square')
        pulse.extend([0] * int(SAMPLE_RATE * 0.4))
        mix = [d + p for d, p in zip(drone, pulse)]
        append_samples(samples, mix)
    save_wav('assets/audio/bomb_bgm.wav', samples)

def generate_tick():
    # Short sharp click
    samples = generate_tone(1000, 0.05, 0.3, 'square')
    # Filter/decay
    for i in range(len(samples)):
        samples[i] *= (1.0 - i/len(samples))**2
    save_wav('assets/audio/tick.wav', samples)

def generate_explosion():
    # Loud noise with exponential decay
    samples = generate_tone(0, 1.5, 0.8, 'noise')
    for i in range(len(samples)):
        samples[i] *= (1.0 - i/len(samples))**3
    save_wav('assets/audio/explosion.wav', samples)

def generate_correct():
    # Ding (high pitch)
    s1 = generate_tone(880, 0.1, 0.3, 'sine')
    s2 = generate_tone(1108.73, 0.3, 0.3, 'sine') # C#6
    for i in range(len(s2)):
         s2[i] *= (1.0 - i/len(s2))
    save_wav('assets/audio/correct.wav', s1 + s2)

def generate_pass():
    # Boop (low pitch)
    s1 = generate_tone(300, 0.2, 0.3, 'saw')
    for i in range(len(s1)):
         s1[i] *= (1.0 - i/len(s1))
    save_wav('assets/audio/pass.wav', s1)

print("Generating audio files...")
generate_indovina_bgm()
generate_bomb_bgm()
generate_tick()
generate_explosion()
generate_correct()
generate_pass()
print("Done!")
