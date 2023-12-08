import os
import sys
import string

arg = sys.argv

if len(arg) == 2:
    src_raw = f'./{arg[1]}'
else:
    src_raw = 'test.s'
dst_raw = './src/myprog'

if os.name == 'nt':  # Windows
    cmd = 'copy ' + src_raw + " " + dst_raw
else:  # Unix/Linux
    cmd = 'cp ' + src_raw + " " + dst_raw

os.system(cmd)

os.system("cd ./src \n make hexfile")

if len(arg) == 2:
    src_hex = f'./src/myprog/{arg[1]}.hex'
else:
    src_hex = './src/myprog/test.s.hex'

dst_hex = 'instruction_code.mem'

if os.name == 'nt':  # Windows
    cmd = 'copy ' + src_hex + " " + dst_hex
else:  # Unix/Linux
    cmd = 'cp ' + src_hex + " " + dst_hex

os.system(cmd)


s = ""
f = open(dst_hex, 'r')
for x in f:
    s += str(x)
s = s.split()

instr_tmp = []
instr = []
i = 0
while (i < len(s)):
    for j in range(4):
        instr_tmp += [s[i + j]]
    #instr_tmp.reverse()
    instr += instr_tmp
    instr_tmp = []
    i += 4
instr = ' '.join(instr)
instr += f'\n'
f.close()

f = open(dst_hex, 'w')
f.write(instr)
f.close()

os.system("source doit.sh")