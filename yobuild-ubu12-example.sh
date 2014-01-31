#!/bin/sh
# Script to build .deb packages for yobuild on ubuntu 12.04
set -e
set -x

export YB_PKGNAME_PREFIX=${YB_PKGNAME_PREFIX:-yobuilt}

# Known good build order
# FIXME: add dependency solver
pkgs="
autoconf
automake
cmake
doxygen
yasm
snappy
orc
GraphicsMagick
gmp
nettle
gnutls
glib
glib-networking
srtp
gstreamer
gst-plugins-base
gst-plugins-good
gst-plugins-bad
gst-libav
gst-rtsp-server
x264
gst-plugins-ugly
"

rm -rf pkgdir
mkdir pkgdir
cd pkgdir
for pkg in $pkgs
do
    ls -d */debian | sed 's,/debian,,' > oldnames
    yb_makedebian $pkg
    ls -d */debian | sed 's,/debian,,' > newnames
    pkgname=`cat oldnames newnames | sort | uniq -c | awk '$1 == 1 {print $2}'`
    echo $pkgname > $pkg.name
done

sudo apt-get remove -y "$YB_PKGNAME_PREFIX"'-*' || true

for pkg in $pkgs
do
    pkgd=`cat $pkg.name`
    cd $pkgd
    mk-build-deps
    # Debian package names are always lower-cased
    YB_PKG=`echo $pkg | tr A-Z a-z`
    sudo dpkg -i $YB_PKGNAME_PREFIX-$YB_PKG-build-deps*.deb || true   # expect dependency problem, fixed in next line
    sudo apt-get install -f -y
    debuild -b -us -uc
    cd ..

    # Now install it, since it might be a build dep of a package later in the list
    eval sudo dpkg -i $YB_PKGNAME_PREFIX-$YB_PKG*.deb
    sudo apt-get install -f -y

    sudo dpkg -r $YB_PKGNAME_PREFIX-$YB_PKG-build-deps
    sudo apt-get autoremove -y || true
done
