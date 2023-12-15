#This is the version for plaground only, not the same as actual test one

import os
import sys
import string

args = sys.argv
#=============================parse_argument===========================================
versions = ['VERSION-1-F1', 'VERSION-1-reference', 'VERSION-2-F1', 'VERSION-2-reference', 'VERSION-3-F1', 'VERSION-3-reference', 'VERSION-4-F1', 'VERSION-4-reference',]
_versions = []
version_num = 1
version = 'VERSION-1-F1'
assembly = 'F1.s'
data = 'empty.mem'

for arg in args:
    if 'version' in arg:
        version_num = str(int(arg.partition('=')[2]))
    if 'assembly' in arg:
        assembly = arg.partition('=')[2]
    if 'data' in arg:
        data = arg.partition('=')[2]

for _version in versions:
    if version_num == _version.partition('-')[2][0]:
        _versions += [_version]

for __version in _versions:
    if assembly == 'F1_pipeline.s':
        version = f'VERSION-{version_num}-F1'
        break
    if assembly == 'pdf_pipeline.s':
        version = f'VERSION-{version_num}-reference'
        break
    
    if assembly == 'F1.s':
        if 'F1' in __version:
            version = __version
            break
    if assembly == 'pdf.s':
        if 'reference' in __version:
            version = __version
            break


src_raw = f'./{assembly}'
dst_raw = './src/myprog'

src_mem = f'./{data}'
dst_mem = f'./rtl/{version}/Data.mem'

src_hex = f'./src/myprog/{assembly}.hex'
dst_hex = f'./rtl/{version}/instruction_code.mem'

dst_rtl = f'./rtl/{version}/'

#=============================end_parse_argument=======================================

if os.name == 'nt':  # Windows
    cmd = 'copy ' + src_raw + " " + dst_raw
else:  # Unix/Linux
    cmd = 'cp ' + src_raw + " " + dst_raw
    
if os.name == 'nt':  # Windows
    cmd_mem = 'copy ' + src_mem + " " + dst_mem
else:  # Unix/Linux
    cmd_mem = 'cp ' + src_mem + " " + dst_mem
os.system('echo "==================Copy_.s_file===================="')
os.system(cmd)
os.system(cmd_mem)

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
    instr += f'\n'
    instr_tmp = []
    i += 4
instr = ' '.join(instr)
instr = instr.replace(' \n ', '\n')
f.close()

f = open(dst_hex, 'w')
f.write(instr)
f.close()

os.system('echo "==================doit.sh=========================="')
os.system(f'cd {dst_rtl} \n . ./doit.sh')
