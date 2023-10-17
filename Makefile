# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: 2023 Red Hat

VERSION = 1.0

NAME = byebyebios

MANPAGE = $(NAME:%=%.1)

DIST_NAME = $(NAME)-v$(VERSION)

prefix = /usr

datadir = $(prefix)/share
bindir = $(prefix)/bin
mandir = $(datadir)/man
man1dir = $(mandir)/man1

pkgdatadir = $(datadir)/$(NAME)

all: bootstub.bin $(MANPAGE)

bootstub.o: bootstub.S Makefile
	as -march i486 -mx86-used-note=no --32 -o $@ $<

bootstub.bin: bootstub.o
	ld -m elf_i386 --oformat binary -e bye_bye_bios -Ttext 0x7c00 -o $@ $<

test.img: bootstub.bin nouefi.txt
	dd if=/dev/zero of=$@ bs=1M count=10
	parted $@ mklabel gpt
	./byebyebios.py -b bootstub.bin -m nouefi.txt $@

$(MANPAGE): $(MANPAGE:%.1=%.rst)
	rst2man $< > $@

test: test.img
	qemu-system-i386 -pidfile test.pid -cpu qemu32 -display none -nodefaults -serial file:out.txt -drive file=$<,if=ide,format=raw &
	sleep 2
	kill `cat test.pid`
	diff out.txt nouefi.txt

clean:
	rm -f *.bin *.o *.tar.gz *.1 *~

dist: $(DIST_NAME).tar.gz

install: all
	install -d $(DESTDIR)$(pkgdatadir)
	install -d $(DESTDIR)$(bindir)
	install -d $(DESTDIR)$(man1dir)
	install -m 0644 nouefi.txt $(DESTDIR)$(pkgdatadir)/
	install -m 0644 bootstub.bin $(DESTDIR)$(pkgdatadir)/
	install -m 0755 $(NAME).py $(DESTDIR)$(bindir)/$(NAME)
	install -m 0644 $(MANPAGE) $(DESTDIR)$(man1dir)/

rpm: $(DIST_NAME).tar.gz
	rpmbuild --define "_sourcedir $(PWD)" -ba $(NAME).spec

$(DIST_NAME).tar.gz: Makefile
	git archive -o $@ --prefix=$(DIST_NAME)/ HEAD
