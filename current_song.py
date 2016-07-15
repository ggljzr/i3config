#!/usr/bin/python3
import sys
import subprocess as sb

try:
    out = sb.check_output("xwininfo -tree -root | grep Spotify | head -n 1 | cut -d: -f1", shell=True)
except:
    out = "Some error"
else:
    if len(out) > 0:
        out = str(out)
        out = out.split('"')[1]
    else:
        out = None

if out != "Spotify" and out != None:
    sys.stdout.write(out)

