#!/bin/sh

BUILD_DIRECTORY="$(mktemp -d)"

DEBIAN_DIRECTORY="${BUILD_DIRECTORY}/DEBIAN"
BINARY_DIRECTORY="${BUILD_DIRECTORY}/usr/bin"

mkdir -p "${DEBIAN_DIRECTORY}"
mkdir -p "${BINARY_DIRECTORY}"

./build-standalone.sh
cp easyshare.elf "${BINARY_DIRECTORY}/easyshare"

cat > "${DEBIAN_DIRECTORY}/control" << EOF
Package: easyshare
Version: 0.0.8
Section: web
Priority: optional
Architecture: all
Maintainer: Jim Konstantos <konstantosjim@gmail.com>
Description: Easily share files between computers and mobile devices through a QR code and wifi connectivity.
Depends: python3 (>= 3.0), python-is-python3, python3-netifaces, python3-pip, python3-qrcode
EOF

dpkg-deb --root-owner-group --build "$BUILD_DIRECTORY" ./easyshare.deb
