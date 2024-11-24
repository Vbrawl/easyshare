#!/bin/python

import qrcode

def show_ascii_qr(data: str):
    qr = qrcode.QRCode()
    qr.add_data(data)
    qr.print_ascii(invert=True)


if __name__ == "__main__":
    import sys

    argc = len(sys.argv)
    if argc >= 2:
        data = sys.argv[1]
        show_ascii_qr(data)
