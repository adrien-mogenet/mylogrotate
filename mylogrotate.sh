#!/bin/sh

# Author: Adrien Mogenet <adrien.mogenet@gmail.com>
# Description:
#   Perform file rotation thanks to a shell script. It's not as safe as original
#   logrotate but should do the job without blocking programs writing into the
#   rotated file.
#
#   This script is not working alone, you have to run it manually, basically
#   from a crontab.


# Display usage message
usage() {
  echo >&2 "Usage: `basename $0` <file> [options]"
  echo >&2 "Options:"
  echo >&2 "   --maxfiles <N>   : max number of files to save"
  echo >&2 "   --gz             : enable GZIP compression"
  exit 1
}

# Perform rotation
rotate_file() {
  local file=$1
  local num=$2
  local compression=$3
  if [ -f "$file" ]; then
    while [ "$num" -gt 1 ]; do
      prev=`expr $num - 1`
      [ -f "${file}.${prev}" ] && mv "${file}.${prev}" "${file}.${num}"
      [ -f "${file}.${prev}.gz" ] && mv "${file}.${prev}.gz" "${file}.${num}.gz"
      num="$prev"
    done
    cp "${file}" "${file}.${num}";
    test -n "${compression}" && gzip --best ${file}.${num}
    cat /dev/null > ${file}
  fi
}

FILE=
COMPRESSION=
MAX_FILES=5

# Process input parameters
while [ $# -gt 0 ]; do
  case "$1" in
    "--maxfiles") MAX_FILES="${2-'5'}"; shift ;;
    "--gz") COMPRESSION="GZ" ;;
    ("-h"|"--help") usage; exit 0 ;;
    *)
      if [ "${FILE}" == "" ]; then
        FILE=$1
      else
        echo >&2 "Unknown option: $1"
	usage; exit 1
      fi
  esac
  shift
done

# Check parameters values
if [[ $MAX_FILES != [0-9]* ]]; then
  echo >&2 "Invalid value for --maxfiles"
  exit 1
fi
test -z "${FILE}" && usage
test -f "${FILE}" || (echo >&2 "File not found: ${FILE}"; exit 2)

# Go!
rotate_file ${FILE} ${MAX_FILES} ${COMPRESSION}
exit 0
