import glob
import os
import re
import numpy as np
import subprocess

lookupkeff = '0K-EFFECTIVE'
fileBRN = '/mnt/d/TA/hasilSrac/zBRNPWRLVL'
lookup = 'ZONE AVERAGE POWER'

r = 0.65  # RADIUS CELL DI SRAC
A = 3.14159265359*r*r*0.000001

maxiter = 25
r = 1

iterr = 0
while(iterr < maxiter and r > 0.00005):
    print(f'================ iterasi ke {iterr+1} ==========================')
    #---------------- RUN SRAC SCRIPT------------------------------
    subprocess.run(['/mnt/d/TA/hasilSrac/TAiter1Copy4.sh']) 
    #--------------------------------------------------------------
    # GET LATEST SFT99 FILE
    list_of_files = glob.glob('/mnt/d/TA/hasilSrac/SFT/*.SFT99.txt') 
    latest_file = max(list_of_files, key=os.path.getctime)
    print(latest_file)
    
    latestSFT98 = max(glob.glob('/mnt/d/TA/hasilSrac/SFT/*.SFT98.txt'), key=os.path.getctime)
    print(latestSFT98)

    i=0
    j=0
    with open(latest_file, "r") as myFile:
        for num, line in enumerate(myFile, 1):
            if i < 5 and lookup in line :
                a = next(myFile)
                ab = next(myFile)
                ac = a + ab
                ad = ac.split()
                ae = np.array([float(ii) for ii in ad])
                if i==0: 
                    af = ae
                else: 
                    af = np.vstack((af,ae))
                i = i+1

            if lookupkeff in line:
                ba = line
                bb = float(ba.split()[2])
                if j==0:
                    keffnew = bb
                else: 
                    keffnew = np.append(keffnew,bb)
                j += 1
        if (r<0.0002):
            print(f'keffnew = {keffnew}')
    
    powerLVL = np.transpose(af)*A
    print('-----------------------------------------------------')
    for i in range(10):
        for j in range(5):
            print('{:.5e}'.format(powerLVL[i,j]), end = ' ')
        print()
    #UPDATE DENSITAS DAYA
    with open(fileBRN, "w") as f:
        f.write('')
        for i in range(10):
            for j in range(5):
                print('{:.5e}'.format(powerLVL[i,j]), end = ' ',file=f)
            if i<9:
                print('',file=f)

    if iterr == 0:
        keffold = keffnew
        powerLVLold = powerLVL
    if iterr > 0:
        r = max([abs(((keffnew[iii]-keffold[iii])/keffold[iii])) for iii in range(len(keffold))])
        print(f'r = {r}')

    keffold = keffnew
    iterr += 1   