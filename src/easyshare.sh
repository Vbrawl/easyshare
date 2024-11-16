#!/bin/sh

help() {
  echo "$0 <options>"
  echo
  echo "options:"
  echo "    -i IP           The ip address for the server [Default: 0.0.0.0]"
  echo "    -p PORT         The port number for the server [Default: 8080]"
  echo "    -d DIRECTORY    The directory to host [Default: .]"
}

get_default_ip() {
  hostname -I | awk '{printf($1);}'
}

get_server_qr() {
  IP=$1
  PORT=$2

  if [ $IP = "0.0.0.0" ]
  then
    IP=$(get_default_ip)
  fi

  qrencode -t utf8 "http://$IP:$PORT/"
}

host_server() {
  IP=$1
  PORT=$2
  DIRECTORY=$3
  python -m http.server -d "$DIRECTORY" -b "$IP" "$PORT"
}


IP="0.0.0.0"
PORT="8080"
DIRECTORY="."


while getopts ":hi:p:d:" arg
do
  case "$arg" in
    i)
      IP="${OPTARG}"
      ;;
    p)
      PORT="${OPTARG}"
      ;;
    d)
      DIRECTORY="${OPTARG}"
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


get_server_qr "$IP" "$PORT"
host_server "$IP" "$PORT" "$DIRECTORY"
