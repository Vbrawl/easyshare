#!/bin/sh

BUILD_DIRECTORY=$(mktemp -d)

DEBIAN_DIRECTORY="${BUILD_DIRECTORY}/DEBIAN"
BINARY_DIRECTORY="${BUILD_DIRECTORY}/usr/bin"

mkdir -p "${DEBIAN_DIRECTORY}"
mkdir -p "${BINARY_DIRECTORY}"

cp "src/easyshare.sh" "${BINARY_DIRECTORY}/easyshare"
chmod +x "${BINARY_DIRECTORY}/easyshare"

cat > "${DEBIAN_DIRECTORY}/control" << EOF
Package: easyshare
Version: 0.0.2
Section: web
Priority: optional
Architecture: all
Maintainer: Jim Konstantos <konstantosjim@gmail.com>
Description: Easily share files between computers and mobile devices through a QR code and wifi connectivity.
Depends: qrencode (>= 4.1.1-1), python3 (>= 3.0), python-is-python3
EOF


dpkg-deb --root-owner-group --build "$BUILD_DIRECTORY" ./easyshare.deb
