import glob
import os
import re
import numpy as np

list_of_files = glob.glob('/mnt/d/TA/hasilSrac/SFT/*.SFT99.txt') # PATH KE SFT99
r = 0.6616  # RADIUS CELL DI SRAC
A = 4*r*r*0.000001
latest_file = max(list_of_files, key=os.path.getctime)
print(latest_file)

lookup = 'ZONE AVERAGE POWER'

i=0
with open(latest_file, "r") as myFile:
    for num, line in enumerate(myFile, 1):
        if lookup in line:
            a = next(myFile)
            ab = next(myFile)
            ac = a + ab
            ad = ac.split()
            ae = np.array([float(i) for i in ad])
            if i==0: 
                af = ae
            else: 
                af = np.vstack((af,ae))
            i = i+1

powerLVL = np.transpose(af)*A

print('-----------------------------------------------------')
for i in range(10):
    for j in range(5):
        print('{:.5e}'.format(powerLVL[i,j]), end = ' ')
    print()
    

fileBRN = '/mnt/d/TA/hasilSrac/zBRNPWRLVL'
with open(fileBRN, "w") as f:
    f.write('')
    for i in range(10):
        for j in range(5):
            print('{:.5e}'.format(powerLVL[i,j]), end = ' ',file=f)
        if i<9:
            print('',file=f)