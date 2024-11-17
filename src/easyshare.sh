#!/bin/sh

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
  IP_LIST=$(hostname -I 2>/dev/null)
  if [ "$?" -eq 0 ]
  then
    IP=$(echo "$IP_LIST" | awk '{printf($1);}')
  else
    #IP=$(ip -4 addr show | grep inet | tail -n1 | sed "s/\// /g" | awk '{printf($2);}')
    IP=$(ip route show default | grep src | head -n1 | sed "s/.*src\( *\)//g" | sed "s/\///g" | awk '{printf($1);}')
    if [ -z "$IP" ]
    then
      IP=$(ip route show | grep src | head -n1 | sed "s/.*src\( *\)//g" | sed "s/\///g" | awk '{printf($1);}')
    fi
  fi
  echo "$IP"
}

get_interface_ip() {
  INTERFACE="$1"
  INTERFACE_INET=$(ip addr show "$INTERFACE" | grep inet | head -n1)
  if [ "$?" -eq 0 ]
  then
    IP=$(echo "$INTERFACE_INET" | sed "s/.*inet.\? //g" | sed "s/\// /g" | awk '{printf($1);}')
  else
    echo "Interface ${INTERFACE} not found!"
    exit 1
  fi
  echo "$IP"
}

get_server_qr() {
  IP=$1
  PORT=$2
  FILE=$3

  if [ $IP = "0.0.0.0" ]
  then
    IP=$(get_default_ip)
  fi

  if [ -d "$FILE" ]
  then
    FILE=""
  else
    FILE=$(basename $FILE)
  fi

  qrencode -t utf8 "http://$IP:$PORT/$FILE"
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
fi

get_server_qr "$G_IP" "$G_PORT" "$G_FILE"
host_server "$G_IP" "$G_PORT" "$G_FILE"
