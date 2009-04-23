pkgdata_DATA = cameron.ui

schemadir = @GCONF_SCHEMA_FILE_DIR@
schema_DATA = cameron.schemas


EXTRA_DIST = \
	$(pkgdata_DATA)
	$(schema_DATA)

install-data-local: $(schema_DATA)
    GCONF_CONFIG_SOURCE=$(GCONF_SCHEMA_CONFIG_SOURCE) $(GCONFTOOL) --makefile-install-rule $(srcdir)/$(schema_DATA);
