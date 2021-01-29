#
.DEFAULT:	all
.PHONY:		all build clean

#
all::
	@true

build:
	debuild -S

clean:
	rm -fr debian/.debhelper/ debian/debhelper-build-stamp debian/files debian/vaulte.substvars debian/vaulte/
	rm -f ../vaulte_*
