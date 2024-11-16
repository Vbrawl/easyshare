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


G_IP="0.0.0.0"
G_PORT="8080"
G_DIRECTORY="."


while getopts ":hi:p:d:" arg
do
  case "$arg" in
    i)
      G_IP="${OPTARG}"
      ;;
    p)
      G_PORT="${OPTARG}"
      ;;
    d)
      G_DIRECTORY="${OPTARG}"
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


get_server_qr "$G_IP" "$G_PORT"
host_server "$G_IP" "$G_PORT" "$G_DIRECTORY"
