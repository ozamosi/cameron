SUBDIRS = \
	cameron \
	data \
	po

ACLOCAL_AMFLAGS = -I m4

EXTRA_DIST = \
	intltool-extract.in \
	intltool-merge.in \
	intltool-update.in \
	gen-changelog.py

DISTCLEANFILES = \
	intltool-extract \
	intltool-merge \
	intltool-update \
	po/.intltool-merge-cache

dist-hook:
	if test -d .git; then \
		python $(top_srcdir)/gen-changelog.py > $(distdir)/cl-t; \
		rm -f $(distdir)/ChangeLog; \
		mv $(distdir)/cl-t $(distdir)/ChangeLog; \
	fi
