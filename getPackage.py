#!/usr/bin/env python3

import sys
import re
from subprocess import check_output

installed = str(check_output(["R", "-e installed.packages()[,1]"]))
installed = re.findall('"[A-Za-z0-9\.]*"', installed)
installed = [name.strip('"') for name in installed]
'''installed = []'''

try:
    sys.argv[1]
except IndexError:
    fname = str(input("Filename: "))
else:
    fname = str(sys.argv[1])
    
rfile = open(fname, 'r')
ftext = rfile.read()
rfile.close()

'''Got the options from 
https://github.com/rstudio/packrat/blob/master/R/dependencies.R'''

rDirect = re.findall('[A-Za-z0-9\.]*\s*:{2,3}(?!:)', ftext)
rDirect = [name.strip(':{2,3}') for name in rDirect]
rLibs = re.findall('(?<=library)\s*\(\s*["\'A-Za-z0-9\.]*', ftext)
rReq = re.findall('(?<=require)\s*\(\s*["\'A-Za-z0-9\.]*', ftext)
rName = re.findall('(?<=loadNamespace)\s*\(\s*[\s"\'A-Za-z0-9\.]*', ftext)
rReqname = re.findall('(?<=requireNamespace)\s*\(\s*[\s"\'A-Za-z0-9\.]*', ftext)
rLibs = rLibs + rReq + rName + rReqname + rDirect
rLibs = [re.sub('[\s\(]*', '', name) for name in rLibs]
rLibs = [name.strip("'") for name in rLibs]
rLibs = [name.strip('"') for name in rLibs]
rLibs = list(set(rLibs) - set(installed))
command = '", "'.join(rLibs)
command = command.lstrip('", ')
command = 'install.packages(c("' + command + '"))'
print("Run: \n")
print(command + "\n")

try:
    import pyperclip
except ModuleNotFoundError:
    print('Cannot copy to clipboard. Run: \n')
    print('pip install pyperclip \n')
    print('OR \n')
    print('conda install -c conda-forge pyperclip \n') 
    print('to enable this functionality')
else:
    pyperclip.copy(command)
    print('Command copied to clipboard')
