#!/bin/sh

BINARY_DIR="/usr/bin"
BUNDLE_DIR="/usr/share/easyshare"

usage() {
  echo "$0 <options>"
  echo
  echo "options:"
  echo "    -B BUNDLE_DIR    The directory in which to place the rest of the source"
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

install_bundle() {
  SOURCE="src/easyshare_netinfo.py"
  DESTINATION="${BUNDLE_DIR}/easyshare_netinfo.py"

  mkdir -p "${BUNDLE_DIR}"
  echo "${SOURCE} -> ${DESTINATION}"
  cp "$SOURCE" "$DESTINATION"
  chmod +x "$DESTINATION"
}


while getopts ":hb:" arg
do
  case $arg in
    B)
      BUNDLE_DIR="$OPTARG"
      ;;
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
install_bundle
