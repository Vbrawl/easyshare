#!/bin/python

import netifaces
import socket


def get_addresses(interface: str):
    all_addresses = netifaces.ifaddresses(interface)
    addresses = []

    ipv4_addresses = all_addresses.get(netifaces.AF_INET, [])
    for address in ipv4_addresses:
        ip = address.get("addr", "")
        if ip:
            addresses.append(ip)

    ipv6_addresses = all_addresses.get(netifaces.AF_INET6, [])
    for address in ipv6_addresses:
        ip = address.get("addr", "")
        if ip:
            addresses.append(ip)
    return addresses

def get_default_ip():
    try:
        gateways = netifaces.gateways()
    except PermissionError:
        gateways = {}
    def_gateway = gateways.get("default", {})

    # all ips reference gateway ips
    ip, interface = def_gateway.get(netifaces.AF_INET, (None, None))
    if ip is None or interface is None:
        ip, interface = def_gateway.get(netifaces.AF_INET6, (None, None))

    if ip is None or interface is None:
        data = gateways.get(netifaces.AF_INET, [(None, None, False)])
        if len(data) >= 1:
            ip, interface, _ = data[0]

    if ip is None or interface is None:
        data = gateways.get(netifaces.AF_INET6, [(None, None, False)])
        if len(data) >= 1:
            ip, interface, _ = data[0]

    if ip is None or interface is None:
        # only case where ip is actually our ip
        s = socket.socket()
        s.connect(("google.com", 80))
        ip = s.getsockname()
        s.close()
        return [ip[0]]

    return get_addresses(interface)


if __name__ == "__main__":
    import sys

    argc = len(sys.argv)
    if argc >= 3 and sys.argv[1] == "addr":
        interface = sys.argv[2]
        print(' '.join(get_addresses(interface)))
    elif argc >= 2 and sys.argv[1] == "route":
        print(' '.join(get_default_ip()))
