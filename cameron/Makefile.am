AM_CPPFLAGS = -DGETTEXT_PACKAGE=\"$(PACKAGE)\"

AM_CFLAGS = \
	$(SUMMER_CFLAGS) \
	$(GLIB_CFLAGS) \
	$(LIBSOUP_CFLAGS) \
	$(GCONF_CFLAGS) \
	$(GTK_CFLAGS) \
	$(GEE_CFLAGS) \
	$(WEBKIT_CFLAGS) \
	$(LIBSEXY_CFLAGS)

AM_CPPFLAGS = \
	-DPACKAGE_LOCALEDIR=\""$(datadir)/locale"\" \
	-DPACKAGE_DATADIR=\""$(datadir)/cameron"\" \
	-include $(CONFIG_HEADER)

cameron_LDADD = \
	$(GCONF_LIBS) \
	$(GTK_LIBS) \
	$(SUMMER_LIBS) \
	$(LIBSOUP_LIBS) \
	$(GEE_LIBS) \
	$(WEBKIT_LIBS) \
	$(LIBSEXY_LIBS)

bin_PROGRAMS = cameron

vala_sources = \
	cameron-add.vala \
	cameron-cell-renderers.vala \
	cameron-config.vala \
	cameron-download-view.vala \
	cameron-info-window.vala \
	cameron-main.vala \
	cameron-subscription.vala \
	cameron-subscription-manager.vala \
	cameron-subscription-preferences.vala \
	cameron-subscription-view.vala \
	cameron-window.vala

c_sources = \
	$(vala_sources:.vala=.c) \
	$(vala_sources:.vala=.h)

BUILT_SOURCES = cameron.stamp $(c_sources)

cameron_SOURCES = $(vala_sources) $(c_sources)

cameron.stamp: $(vala_sources)
	$(VALAC) -C --thread \
		--pkg=libsummer-1.0 \
		--pkg=libxml-2.0 \
		--pkg=glib-2.0 \
		--pkg=gtk+-2.0 \
		--pkg=libsoup-2.4 \
		--pkg=gee-1.0 \
		--pkg=gconf-2.0 \
		--pkg=webkit-1.0 \
		--pkg=libsexy \
		--pkg=config \
		--vapidir=$(srcdir)/../vapi \
		$^
	touch $@

cameron_LDFLAGS = -export-dynamic

CLEANFILES = $(BUILT_SOURCES)
