
SHELL = /bin/sh

# V=0 quiet, V=1 verbose.  other values don't work.
V = 0
Q1 = $(V:1=)
Q = $(Q1:0=@)
ECHO1 = $(V:1=@:)
ECHO = $(ECHO1:0=@echo)

#### Start of system configuration section. ####

srcdir = .
topdir = /usr/include/ruby-2.1.0
hdrdir = $(topdir)
arch_hdrdir = /usr/include/ruby-2.1.0/x86_64-linux
PATH_SEPARATOR = :
VPATH = $(srcdir):$(arch_hdrdir)/ruby:$(hdrdir)/ruby
prefix = $(DESTDIR)/usr
rubysitearchprefix = $(rubylibprefix)/$(sitearch)
rubyarchprefix = $(rubylibprefix)/$(arch)
rubylibprefix = $(libdir)/$(RUBY_BASE_NAME)
exec_prefix = $(prefix)
vendorarchhdrdir = $(vendorhdrdir)/$(sitearch)
sitearchhdrdir = $(sitehdrdir)/$(sitearch)
rubyarchhdrdir = $(rubyhdrdir)/$(arch)
vendorhdrdir = $(rubyhdrdir)/vendor_ruby
sitehdrdir = $(rubyhdrdir)/site_ruby
rubyhdrdir = $(includedir)/$(RUBY_VERSION_NAME)
vendorarchdir = $(vendorlibdir)/$(sitearch)
vendorlibdir = $(vendordir)/$(ruby_version)
vendordir = $(rubylibprefix)/vendor_ruby
sitearchdir = $(sitelibdir)/$(sitearch)
sitelibdir = $(sitedir)/$(ruby_version)
sitedir = $(rubylibprefix)/site_ruby
rubyarchdir = $(rubylibdir)/$(arch)
rubylibdir = $(rubylibprefix)/$(ruby_version)
sitearchincludedir = $(includedir)/$(sitearch)
archincludedir = $(includedir)/$(arch)
sitearchlibdir = $(libdir)/$(sitearch)
archlibdir = $(libdir)/$(arch)
ridir = $(datarootdir)/$(RI_BASE_NAME)
mandir = $(DESTDIR)/usr/share/man
localedir = $(datarootdir)/locale
libdir = $(exec_prefix)/lib64
psdir = $(docdir)
pdfdir = $(docdir)
dvidir = $(docdir)
htmldir = $(docdir)
infodir = $(DESTDIR)/usr/share/info
docdir = $(DESTDIR)/usr/share/doc/ruby-2.1.5
oldincludedir = $(DESTDIR)/usr/include
includedir = $(prefix)/include
localstatedir = $(DESTDIR)/var/lib
sharedstatedir = $(prefix)/com
sysconfdir = $(DESTDIR)/etc
datadir = $(DESTDIR)/usr/share
datarootdir = $(prefix)/share
libexecdir = $(exec_prefix)/libexec
sbindir = $(exec_prefix)/sbin
bindir = $(exec_prefix)/bin
archdir = $(rubyarchdir)


CC = x86_64-pc-linux-gnu-gcc
CXX = x86_64-pc-linux-gnu-g++
LIBRUBY = $(LIBRUBY_SO)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)-static
empty =
OUTFLAG = -o $(empty)
COUTFLAG = -o $(empty)

RUBY_EXTCONF_H = 
cflags   =  $(optflags) $(debugflags) $(warnflags)
optflags = -O3 -fno-fast-math
debugflags = -ggdb3
warnflags = -Wall -Wextra -Wno-unused-parameter -Wno-parentheses -Wno-long-long -Wno-missing-field-initializers -Wunused-variable -Wpointer-arith -Wwrite-strings -Wdeclaration-after-statement -Wimplicit-function-declaration
CCDLFLAGS = -fPIC
CFLAGS   = $(CCDLFLAGS) -march=core-avx2 -O2 -pipe -fno-strict-aliasing -fPIC $(ARCH_FLAG)
INCFLAGS = -I. -I$(arch_hdrdir) -I$(hdrdir)/ruby/backward -I$(hdrdir) -I$(srcdir)
DEFS     = 
CPPFLAGS =   $(DEFS) $(cppflags)
CXXFLAGS = $(CCDLFLAGS) -march=core-avx2 -O2 -pipe -fno-strict-aliasing $(ARCH_FLAG)
ldflags  = -L. -Wl,-O1 -Wl,--sort-common -Wl,--as-needed -fstack-protector -rdynamic -Wl,-export-dynamic -Wl,--no-undefined
dldflags =  
ARCH_FLAG = 
DLDFLAGS = $(ldflags) $(dldflags) $(ARCH_FLAG)
LDSHARED = $(CC) -shared
LDSHAREDXX = $(CXX) -shared
AR = x86_64-pc-linux-gnu-ar
EXEEXT = 

RUBY_INSTALL_NAME = ruby21
RUBY_SO_NAME = ruby21
RUBYW_INSTALL_NAME = 
RUBY_VERSION_NAME = $(RUBY_BASE_NAME)-$(ruby_version)
RUBYW_BASE_NAME = rubyw
RUBY_BASE_NAME = ruby

arch = x86_64-linux
sitearch = $(arch)
ruby_version = 2.1.0
ruby = $(bindir)/ruby21
RUBY = $(ruby)
ruby_headers = $(hdrdir)/ruby.h $(hdrdir)/ruby/ruby.h $(hdrdir)/ruby/defines.h $(hdrdir)/ruby/missing.h $(hdrdir)/ruby/intern.h $(hdrdir)/ruby/st.h $(hdrdir)/ruby/subst.h $(arch_hdrdir)/ruby/config.h

RM = rm -f
RM_RF = $(RUBY) -run -e rm -- -rf
RMDIRS = rmdir --ignore-fail-on-non-empty -p
MAKEDIRS = /bin/mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp
TOUCH = exit >

#### End of system configuration section. ####

preload = 

libpath = . $(libdir)
LIBPATH =  -L. -L$(libdir)
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 
DISTCLEANDIRS = 

extout = 
extout_prefix = 
target_prefix = /skkserv
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED)  -lpthread -lgmp -ldl -lcrypt -lm   -lc
ORIG_SRCS = skkdic.c
SRCS = $(ORIG_SRCS) 
OBJS = skkdic.o
HDRS = 
TARGET = skkdic
TARGET_NAME = skkdic
TARGET_ENTRY = Init_$(TARGET_NAME)
DLLIB = $(TARGET).so
EXTSTATIC = 
STATIC_LIB = 

TIMESTAMP_DIR = .
BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR    = $(sitelibdir)$(target_prefix)
RUBYARCHDIR   = $(sitearchdir)$(target_prefix)
HDRDIR        = $(rubyhdrdir)/ruby$(target_prefix)
ARCHHDRDIR    = $(rubyhdrdir)/$(arch)/ruby$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).so 
CLEANOBJS     = *.o  *.bak

all:    $(DLLIB)
static: $(STATIC_LIB)
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-static clean-rb

clean-static::
clean-rb-default::
clean-rb::
clean-so::
clean: clean-so clean-static clean-rb-default clean-rb
		-$(Q)$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES) .*.time

distclean-rb-default::
distclean-rb::
distclean-so::
distclean-static::
distclean: clean distclean-so distclean-static distclean-rb-default distclean-rb
		-$(Q)$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		-$(Q)$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)
		-$(Q)$(RMDIRS) $(DISTCLEANDIRS) 2> /dev/null || true

realclean: distclean
install: install-so install-rb

install-so: $(DLLIB) $(TIMESTAMP_DIR)/.RUBYARCHDIR.-.skkserv.time
	$(INSTALL_PROG) $(DLLIB) $(RUBYARCHDIR)
clean-static::
	-$(Q)$(RM) $(STATIC_LIB)
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
pre-install-rb-default: $(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time
install-rb-default: $(RUBYLIBDIR)/cdbdic.rb
$(RUBYLIBDIR)/cdbdic.rb: $(srcdir)/lib/cdbdic.rb $(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/cdbdic.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/skkdic.rb
$(RUBYLIBDIR)/skkdic.rb: $(srcdir)/lib/skkdic.rb $(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/skkdic.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/ebdic.rb
$(RUBYLIBDIR)/ebdic.rb: $(srcdir)/lib/ebdic.rb $(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/ebdic.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/conf.rb
$(RUBYLIBDIR)/conf.rb: $(srcdir)/lib/conf.rb $(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/conf.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/nulldic.rb
$(RUBYLIBDIR)/nulldic.rb: $(srcdir)/lib/nulldic.rb $(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/nulldic.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/skkservdic.rb
$(RUBYLIBDIR)/skkservdic.rb: $(srcdir)/lib/skkservdic.rb $(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/skkservdic.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/googledic.rb
$(RUBYLIBDIR)/googledic.rb: $(srcdir)/lib/googledic.rb $(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/googledic.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/logger.rb
$(RUBYLIBDIR)/logger.rb: $(srcdir)/lib/logger.rb $(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/logger.rb $(@D)
pre-install-rb-default:
	$(ECHO) installing default skkdic libraries
$(TIMESTAMP_DIR)/.RUBYARCHDIR.-.skkserv.time:
	$(Q) $(MAKEDIRS) $(@D) $(RUBYARCHDIR)
	$(Q) $(TOUCH) $@
$(TIMESTAMP_DIR)/.RUBYLIBDIR.-.skkserv.time:
	$(Q) $(MAKEDIRS) $(@D) $(RUBYLIBDIR)
	$(Q) $(TOUCH) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .mm .cxx .cpp .C .o

.cc.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.mm.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.cxx.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.cpp.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.C.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.c.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $<

.m.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $<

$(DLLIB): $(OBJS) Makefile
	$(ECHO) linking shared-object skkserv/$(DLLIB)
	-$(Q)$(RM) $(@)
	$(Q) $(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)



###
rsslibdir = /usr/local/lib/ruby/2.1
rssarchdir = /usr/local/lib/ruby/2.1/x86_64-linux
rss-install: $(rssarchdir)$(target_prefix)/$(DLLIB)
$(rssarchdir)$(target_prefix)/$(DLLIB): $(DLLIB)
	@$(RUBY) -r fileutils -e 'FileUtils::makedirs(ARGV)' $(rsslibdir) $(rssarchdir)$(target_prefix)
	@$(RUBY) -r fileutils -e 'FileUtils::install(ARGV[0], ARGV[1], 0555, true)' $(DLLIB) $(rssarchdir)$(target_prefix)/$(DLLIB)

