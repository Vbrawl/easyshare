#!/bin/sh

# EASYSHARE_SOURCE_PREFIX
if [ ! -n "$EASYSHARE_SOURCE_PREFIX" ]
then
  EASYSHARE_SOURCE_PREFIX="/usr/share/easyshare"
fi

help() {
  echo "$0 <options>"
  echo
  echo "options:"
  echo "    -I interface         The interface to use for the server."
  echo "    -i IP                The ip address for the server [Default: 0.0.0.0]"
  echo "    -p PORT              The port number for the server [Default: 8080]"
  echo "    -d FILE_OR_FOLDER    Same as -f"
  echo "    -f FILE_OR_FOLDER    The file or folder to host [Default: .]"
}

get_default_ip() {
  IP_LIST=$("$EASYSHARE_SOURCE_PREFIX"/easyshare_netinfo.py route 2>/dev/null)
  if [ "$?" -eq 0 ]
  then
    IP=$(echo "$IP_LIST" | awk '{printf($1);}')
  else
    return 1
  fi
  echo "$IP"
}

get_interface_ip() {
  INTERFACE="$1"
  INTERFACE_INET=$("$EASYSHARE_SOURCE_PREFIX"/easyshare_netinfo.py addr "$INTERFACE" 2>/dev/null)
  if [ "$?" -eq 0 ]
  then
    IP=$(echo "$INTERFACE_INET" | awk '{printf($1);}')
  else
    return 1
  fi
  echo "$IP"
}

get_server_qr() {
  IP=$1
  PORT=$2
  FILE=$3

  if [ "$IP" = "0.0.0.0" ]
  then
    IP=$(get_default_ip)
    if [ "$?" -ne 0 ]
    then
      return 1
    fi
  fi

  if [ -d "$FILE" ]
  then
    FILE=""
  else
    FILE=$(basename $FILE)
  fi

  "$EASYSHARE_SOURCE_PREFIX"/easyshare_qrencode.py "http://$IP:$PORT/$FILE"
}

host_server() {
  IP=$1
  PORT=$2
  FILE=$3
  DIRECTORY="$FILE"

  if [ ! -d "$DIRECTORY" ]
  then
    DIRECTORY=$(dirname $FILE)
  fi

  python -m http.server -d "$DIRECTORY" -b "$IP" "$PORT"
}


G_IP="0.0.0.0"
G_INTERFACE=""
G_PORT="8080"
G_FILE="."


while getopts ":hI:i:p:d:f:" arg
do
  case "$arg" in
    I)
      G_INTERFACE="${OPTARG}"
      ;;
    i)
      G_IP="${OPTARG}"
      ;;
    p)
      G_PORT="${OPTARG}"
      ;;
    d|f)
      G_FILE="${OPTARG}"
      ;;
    h)
      help
      exit
      ;;
    ?)
      help
      exit 1
      ;;
  esac
done

if [ -n "$G_INTERFACE" ]
then
  G_IP=$(get_interface_ip "$G_INTERFACE")
  if [ "$?" -ne 0 ]
  then
    echo "Interface ${G_INTERFACE} not found!"
    exit 1
  fi
fi

get_server_qr "$G_IP" "$G_PORT" "$G_FILE"
if [ "$?" -ne 0 ]
then
  echo "Couldn't generate QR code, this may also be a problem with finding your ip address!"
  exit 1
fi
host_server "$G_IP" "$G_PORT" "$G_FILE"
