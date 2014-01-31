COMMANDS = `ls yb_* | grep -v '\.[0-9]$$'`
MANFILES = `ls yb_*.1`
EXTRADOCFILES = `ls yobuild*example.sh`
PREFIX = /usr

all:
	echo No build needed.

install:
	rm -rf $(DESTDIR)$(PREFIX)/share/yobuild
	install -m 755 -d $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 644 $(MANFILES) $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 755 -d $(DESTDIR)$(PREFIX)/share/doc/yobuild
	install -m 644 $(EXTRADOCFILES) $(DESTDIR)$(PREFIX)/share/doc/yobuild
	install -m 755 -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 $(COMMANDS) $(DESTDIR)$(PREFIX)/bin
	for dir in templates recipes; do \
		install -m 755 -d $(DESTDIR)$(PREFIX)/share/yobuild/$$dir; \
		cp -a $$dir/* $(DESTDIR)$(PREFIX)/share/yobuild/$$dir; \
	done
	find $(DESTDIR)$(PREFIX)/share/yobuild -type d | xargs chmod a+rx
	find $(DESTDIR)$(PREFIX)/share/yobuild -type f | xargs chmod a+r
	chmod +x $(DESTDIR)$(PREFIX)/share/yobuild/recipes/*/*.recipe

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/share/yobuild $(DESTDIR)$(PREFIX)/share/doc/yobuild
	for f in $(MANFILES); do rm -f $(DESTDIR)$(PREFIX)/share/man/man1/$$f; done
	for f in $(COMMANDS); do rm -f $(DESTDIR)$(PREFIX)/bin/$$f; done
