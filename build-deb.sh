#!/bin/sh

BUILD_DIRECTORY=$(mktemp -d)

DEBIAN_DIRECTORY="${BUILD_DIRECTORY}/DEBIAN"
BINARY_DIRECTORY="${BUILD_DIRECTORY}/usr/bin"
BUNDLE_DIRECTORY="${BUILD_DIRECTORY}/usr/share/easyshare"

mkdir -p "${DEBIAN_DIRECTORY}"
mkdir -p "${BINARY_DIRECTORY}"
mkdir -p "${BUNDLE_DIRECTORY}"

cp "src/easyshare.sh" "${BINARY_DIRECTORY}/easyshare"
chmod +x "${BINARY_DIRECTORY}/easyshare"

cp "src/easyshare_netinfo.py" "${BUNDLE_DIRECTORY}/easyshare_netinfo.py"
chmod +x "${BUNDLE_DIRECTORY}/easyshare_netinfo.py"

cp "src/easyshare_qrencode.py" "${BUNDLE_DIRECTORY}/easyshare_qrencode.py"
chmod +x "${BUNDLE_DIRECTORY}/easyshare_qrencode.py"

cat > "${DEBIAN_DIRECTORY}/control" << EOF
Package: easyshare
Version: 0.0.7
Section: web
Priority: optional
Architecture: all
Maintainer: Jim Konstantos <konstantosjim@gmail.com>
Description: Easily share files between computers and mobile devices through a QR code and wifi connectivity.
Depends: python3 (>= 3.0), python-is-python3, python3-netifaces, python3-pip, python3-qrcode
EOF

dpkg-deb --root-owner-group --build "$BUILD_DIRECTORY" ./easyshare.deb
