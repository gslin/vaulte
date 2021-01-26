#
.DEFAULT:	all
.PHONY:		all build clean

#
all::
	@true

build:
	dpkg-buildpackage -uc -us

clean:
	rm -fr debian/.debhelper/ debian/debhelper-build-stamp debian/files debian/vaulte.substvars debian/vaulte/
	rm -f ../vaulte_*
