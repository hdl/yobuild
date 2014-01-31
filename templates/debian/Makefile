# This is not a general-purpose makefile; this is solely for
# the purpose of Debian packaging, 
# and is invoked via 'debuild',
# which invokes fakeroot make -f debian/rules binary,
# which invokes dh_auto_build,
# which sees a Makefile and decides to run 'make all'.

YB_WIDTH := 64
PREFIX := @PREFIX@
PKG := @YB_PKG@
UPKG := @YB_UPKG@

all:
	echo "FIXME: This build system does not yet install to DESTDIR, it installs to the real PREFIX during build"
	sudo mkdir -p $(PREFIX)
	sudo chown $$LOGNAME $(PREFIX)
	YB_WIDTH=$(YB_WIDTH) PREFIX=$(PREFIX) yb_buildone $(PKG)

# KLUDGE: exclude Gnu Info's dir node to avoid errors like
#  trying to overwrite '/opt/yobuild/share/info/dir', which is also in package yobuild-autoconf 0.1
# postinstall should create it, somehow.
# Have to remove first char of $PREFIX because tar stripped the leading slashes when building the archive.
install:
	REFIX=`echo $(PREFIX) | sed 's,^/,,'`; tar --exclude $$REFIX/share/info/dir -C debian/@YB_PKGNAME_PREFIX@-$(PKG) -xzvf outdir/$(UPKG)-*.tar.gz
