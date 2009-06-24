m4_define([cameron_major_version], [0])
m4_define([cameron_minor_version], [1])
m4_define([cameron_micro_version], [0])
m4_define([cameron_version],
          [cameron_major_version.cameron_minor_version.cameron_micro_version])


AC_INIT([cameron], [cameron_version], [http://wrya.net/services/trac/cameron])
AM_INIT_AUTOMAKE()
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADER(config.h)
AM_MAINTAINER_MODE
AC_CONFIG_MACRO_DIR([m4])

AC_PROG_CC
AC_PROG_LIBTOOL

GETTEXT_PACKAGE=cameron
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE", [GETTEXT package name])

IT_PROG_INTLTOOL([0.35.0])
AM_GLIB_GNU_GETTEXT

GNOME_COMMON_INIT
GNOME_DOC_INIT
GNOME_MAINTAINER_MODE_DEFINES
GNOME_COMPILE_WARNINGS
GNOME_CXX_WARNINGS

AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

GTK_DOC_CHECK([1.8])

VALA_REQUIRED=0.5.0
GLIB_REQUIRED=2.18.0
SUMMER_REQUIRED=0.2.0
GCONF_REQUIRED=2.0
GTK_REQUIRED=2.14
GEE_REQUIRED=0.1.0
WEBKIT_REQUIRED=1.0
SEXY_REQUIRED=0.1

PKG_CHECK_MODULES(VALA, vala-1.0 >= $VALA_REQUIRED)
PKG_CHECK_MODULES(SUMMER, libsummer-1.0 >= $SUMMER_REQUIRED)
PKG_CHECK_MODULES(GTK, gtk+-2.0 >= $GTK_REQUIRED)
PKG_CHECK_MODULES(GEE, gee-1.0 >= $GEE_REQUIRED)
PKG_CHECK_MODULES(WEBKIT, webkit-1.0 >= $WEBKIT_REQUIRED)
PKG_CHECK_MODULES(LIBSEXY, libsexy >= $SEXY_REQUIRED)
PKG_CHECK_MODULES(GCONF, gconf-2.0 >= $GCONF_REQUIRED)
AM_GCONF_SOURCE_2
AM_PATH_GLIB_2_0($GLIB_REQUIRED,,,gobject)
if test "$GLIB_LIBS" = ""; then
	AC_MSG_ERROR(GLIB $GLIB_REQUIRED or later is required to build libsummer)
fi
GLIB_CFLAGS="$GLIB_CFLAGS -DG_DISABLE_SINGLE_INCLUDES"

AC_PATH_PROG(VALAC, valac, no)
if test "x$VALAC" = "xno"; then
	AC_MSG_ERROR([Cannot find the valac compiler in your PATH])
fi
VAPIDIR=`pkg-config --variable=vapidir vala-1.0`
AC_SUBST(VAPIDIR)

AC_CONFIG_FILES([ README
	po/Makefile.in
	Makefile
	cameron/Makefile
	data/Makefile
])

AC_OUTPUT
