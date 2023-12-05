import math
import string
f = open("sinerom.mem","w")
for i in range(256):
    v = int(math.cos(2*3.1416*i/256)*127+127)
    s = "00 00 00 {hex:2X}\n"
    f.write(s.format(hex=v))

f.close()