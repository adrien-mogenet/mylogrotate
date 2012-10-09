mylogrotate
===========

logrotate-like program... but in shell script, for those who can't use logrotate

Perform file rotation thanks to a shell script. It's not as safe as original
logrotate but should do the job without blocking programs writing into the
rotated file.

## Usage
`
Options:
   --maxfiles <N>   : max number of files to save
   --gz             : enable GZIP compression
`

## Running...
This script is not working alone, you have to run it manually, basically
from a crontab.
