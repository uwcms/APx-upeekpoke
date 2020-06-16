all: upeek upoke

upoke: upoke.c
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

upeek: upeek.c
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	-rm -f upeek upoke *.rpm

ifneq (x,x$(wildcard .git))
RPM_PKGNAME := upeekpoke
RPM_TOPDIR  := $(shell rpmbuild --eval %{_topdir})
GIT_COMMIT_DATE := $(shell date -u +%Y%m%dT%H%M%S -d "$(shell git log --format=%ci -n1 HEAD | sed -re 's/(\S+) (\S+) (\S+)/\1T\2\3/')")
RPM_VERSION := $(shell git describe --match='v[0-9]*.[0-9]*.[0-9]*' HEAD | sed -re 's/^v//;s/-([0-9]+)-(g[0-9a-f]{7})/.\1_$(GIT_COMMIT_DATE)_\2/')
RPM_LIB_VERSION := $(shell git describe --match='v[0-9]*.[0-9]*.[0-9]*' HEAD | sed -re 's/^v//;s/-([0-9]+)-(g[0-9a-f]{7})//')
RPM_GENERATED_SPEC := $(shell mktemp -t $(RPM_PKGNAME).XXXXXX.spec)
rpm:
	rm -f $(RPM_TOPDIR)/SOURCES/$(RPM_PKGNAME)-$(RPM_VERSION).tar.gz
	mkdir -p $(RPM_TOPDIR)/SOURCES
	git archive -9 --prefix $(RPM_PKGNAME)-$(RPM_VERSION)/ -o $(RPM_TOPDIR)/SOURCES/$(RPM_PKGNAME)-$(RPM_VERSION).tar.gz HEAD
	echo '%define pkg_version $(RPM_VERSION)' > $(RPM_GENERATED_SPEC)
	cat $(RPM_PKGNAME).spec >> $(RPM_GENERATED_SPEC)
	rpmbuild -v -ba --sign --rmsource --clean -D 'pkg_version $(RPM_VERSION)' -D 'lib_version $(RPM_LIB_VERSION)' $(RPM_GENERATED_SPEC)
	rm -f $(RPM_GENERATED_SPEC)
	mv $(RPM_TOPDIR)/SRPMS/$(RPM_PKGNAME)-$(RPM_VERSION)-*.rpm ./
	mv $(RPM_TOPDIR)/RPMS/*/$(RPM_PKGNAME)-$(RPM_VERSION)-*.rpm ./
endif
