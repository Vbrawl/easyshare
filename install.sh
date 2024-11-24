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

copy_file() {
  SOURCE="$1"
  DESTINATION="$2"

  echo "${SOURCE} -> ${DESTINATION}"
  cp "${SOURCE}" "${DESTINATION}"
  chmod +x "$DESTINATION"
}

install_binary() {
  mkdir -p "$1"
  copy_file "src/easyshare.sh" "$1/easyshare"
}

install_bundle() {
  mkdir -p "$1"
  copy_file "src/easyshare_netinfo.py" "$1/easyshare_netinfo.py"
  copy_file "src/easyshare_qrencode.py" "$1/easyshare_qrencode.py"
}


while getopts ":hb:B:" arg
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

install_binary "$BINARY_DIR"
install_bundle "$BUNDLE_DIR"
