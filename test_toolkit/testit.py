import os
import sys
import string

args = sys.argv
#=============================parse_argument===========================================
versions = ['VERSION-1-SINGLECYCLE', 'VERSION-2-PIPELINING']

version = 'VERSION-1-SINGLECYCLE'
assembly = 'test.s'

for arg in args:
    if 'version' in arg:
        version = versions[int(arg.partition('=')[2]) - 1]
    if 'assembly' in arg:
        assembly = arg.partition('=')[2]

src_raw = f'./{assembly}'
dst_raw = './src/myprog'

src_hex = f'./src/myprog/{assembly}.hex'
dst_hex = f'./rtl/{version}/instruction_code.mem'

dst_rtl = f'./rtl/{version}/'
#=============================end_parse_argument=======================================

if os.name == 'nt':  # Windows
    cmd = 'copy ' + src_raw + " " + dst_raw
else:  # Unix/Linux
    cmd = 'cp ' + src_raw + " " + dst_raw
os.system('echo "==================Copy_.s_file===================="')
os.system(cmd)

os.system('echo "==================Make_hex_file==================="')
os.system("cd ./src \n make hexfile")

if os.name == 'nt':  # Windows
    cmd = 'copy ' + src_hex + " " + dst_hex
else:  # Unix/Linux
    cmd = 'cp ' + src_hex + " " + dst_hex
os.system('echo "==================Copy_hex_2_mem==================="')
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

os.system('echo "==================doit.sh=========================="')
os.system(f'cd {dst_rtl} \n . ./doit.sh')