# Maintainer: Vbrawl <konstantosjim@gmail.com>
pkgname=easyshare-git
pkgver=0.0.7
pkgrel=1
epoch=
pkgdesc=""
arch=('any')
url="https://github.com/Vbrawl/easyshare.git"
license=('MIT')
options=(!strip)
source=("git+https://github.com/Vbrawl/easyshare.git"
        "git+https://github.com/Vbrawl/easypack.git")
sha256sums=('SKIP' 'SKIP')

build() {
	cd "$srcdir/easypack"
    cmake -Bbuild -DCMAKE_BUILD_TYPE=Release
    cd build
	make

    PATH=${PATH}:$(pwd)

    cd "$srcdir/easyshare"
    ./build-standalone.sh
}

package() {
	cd "$srcdir/easyshare"
    install -v -D easyshare.elf "$pkgdir/usr/bin/easyshare"
}
