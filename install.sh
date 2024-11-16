#!/bin/sh

BINARY_DIR="/usr/bin"

usage() {
  echo "$0 <options>"
  echo
  echo "options:"
  echo "    -b BINARY_DIR    The directory in which to place the binary"
  echo "    -h               Display this help menu"
}

install_binary() {
  SOURCE="src/easyshare.sh"
  DESTINATION="${BINARY_DIR}/easyshare"

  echo "${SOURCE} -> ${DESTINATION}"
  cp "$SOURCE" "$DESTINATION"
  chmod +x "$DESTINATION"
}


while getopts ":hb:" arg
do
  case $arg in
    b)
      BINARY_DIR="$OPTARG"
      ;;
    h)
      usage
      exit
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

install_binary
