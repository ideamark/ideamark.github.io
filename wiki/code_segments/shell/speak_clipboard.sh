#!/bin/bash
# This script can listen the clipboard and read the string in the clipboard
# You must install xclip, ekho first, use apt-get. and install the python module called pyperclip
# It will read when you select the string then press ctrl+c
# Use ctrl+c to quit
python << endpython
import os,time
import pyperclip
pyperclip.copy('')
print 'readit start...'
while True:
    clip = pyperclip.paste()
    if clip != '':
        print clip
        f = open(os.path.realpath("~/")[:-1]+'tmp','w')
        f.truncate()
        f.write(clip)
        f.close()
        os.system('ekho -s 300 -r -25 -f ~/tmp')
        pyperclip.copy('')
        print 'listening...'
    time.sleep(1)
endpython
