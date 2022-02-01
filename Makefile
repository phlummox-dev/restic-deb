
.PHONY: build-deb clean

.DELETE_ON_ERROR:

VERSION=0.12.1
RESTIC_URL = https://github.com/restic/restic/releases/download/v$(VERSION)/restic_$(VERSION)_linux_amd64.bz2

RESTIC=usr/bin/restic
RESTIC_MAN=usr/share/man/man1/restic.1
RESTIC_BASH_COMPLETION=usr/share/bash-completion/completions/restic
DEB_CONTROL=restic-$(VERSION)/debian/control
RESTIC_DEB=restic_$(VERSION)-2_all.deb

print-version:
	@echo $(VERSION)

print-deb-file:
	@echo $(RESTIC_DEB)

$(RESTIC):
	mkdir -p `dirname $@`
	curl -L $(RESTIC_URL) | bunzip2 > $@
	chmod a+rx $@

$(RESTIC_BASH_COMPLETION): $(RESTIC)
	mkdir -p `dirname $@`
	$(RESTIC) generate --bash-completion $@

$(RESTIC_MAN): $(RESTIC)
	mkdir -p `dirname $@`
	$(RESTIC) generate --man `dirname $@`

restic-$(VERSION).tgz: $(RESTIC_MAN) $(RESTIC_BASH_COMPLETION)
	fakeroot tar cf $@ --gzip ./usr

# generate dirs + files directly needed to build .deb
restic-$(VERSION): restic-$(VERSION).tgz
	fakeroot alien --generate --to-deb \
		--description "restic backup program" \
		$<

$(RESTIC_DEB): restic-$(VERSION)
	sed -i 's|^Maintainer:.*|Maintainer: https://github.com/phlummox-dev/restic-deb/|' $(DEB_CONTROL)
	sed -i 's/^Architecture:.*/Architecture: amd64/' $(DEB_CONTROL)
	sed -i 's/^Section:.*/Section: utils/' $(DEB_CONTROL)
	echo "Homepage: https://github.com/restic/restic" >> $(DEB_CONTROL)
	cd $< && fakeroot ./debian/rules binary

build-deb: $(RESTIC_DEB)

clean:
	-rm -rf restic* usr

