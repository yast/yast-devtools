#
# spec file for package yast2-devtools
#
# Copyright (c) 2013 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           yast2-devtools
Version:        3.1.21
Release:        0
Url:            http://github.com/yast/yast-devtools

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source0:        %{name}-%{version}.tar.bz2

BuildRequires:  automake
BuildRequires:  docbook-xsl-stylesheets
BuildRequires:  fdupes
BuildRequires:  gcc-c++
BuildRequires:  libtool
BuildRequires:  libxslt
BuildRequires:  perl-XML-Writer
BuildRequires:  pkgconfig
BuildRequires:  sgml-skel
Requires:       yast2-buildtools

Summary:        YaST2 - Development Tools
License:        GPL-2.0+
Group:          System/YaST

BuildArch:      noarch

%description
Scripts and templates for developing YaST2 modules and components.

%package -n yast2-buildtools
Summary: Minimal set of tools needed to build yast module

Requires:       perl
Requires:       perl-XML-Writer
# we install our .pc under $prefix/share
Requires:       autoconf
Requires:       automake
Requires:       gettext-tools
Requires:       pkgconfig >= 0.16
# for building Ruby autodocs
Requires:       rubygem-yard

%if 0%{?suse_version} <= 1230
# extra package for yard Markdown formatting in openSUSE <= 12.3
Requires:       rubygem-redcarpet
%endif

Recommends:     cmake
# /usr/lib/YaST2/bin/ydoxygen needs it
Recommends:     doxygen
# for svn builds of binary packages
Recommends:     libtool
# for extracting translatable strings from *.rb files using "make pot" command
# weak dependency, "make pot" is usually not needed
Suggests:       rubygem-gettext


%description -n yast2-buildtools
Scripts and templates required for rebuilding the existing YaST2
modules and components (both ruby and C++).

%prep
%setup -n yast2-devtools-%{version}

%build
make -f Makefile.cvs all

./configure --prefix=%{_prefix} --libdir=%{_libdir}
make

%install
make install DESTDIR="$RPM_BUILD_ROOT"
[ -e "%{_prefix}/share/YaST2/data/devtools/NO_MAKE_CHECK" ] || Y2DIR="$RPM_BUILD_ROOT/%{_prefix}/share/YaST2" make check DESTDIR="$RPM_BUILD_ROOT"
for f in `find $RPM_BUILD_ROOT/%{_prefix}/share/applications/YaST2 -name "*.desktop"` ; do
    d=${f##*/}
    %suse_update_desktop_file -d ycc_${d%.desktop} ${d%.desktop}
done

%if 0%{?qemu_user_space_build}
# disable testsuite on QEMU builds, will fail
cat > "$RPM_BUILD_ROOT/%{_prefix}/share/YaST2/data/devtools/NO_MAKE_CHECK" <<EOF
Disabling testsuite on QEMU builds, as the userspace emulation
is not complete enough for yast2-core
EOF
%endif

# Change false to true in the following line when yast2 core is broken
false && cat > "$RPM_BUILD_ROOT/%{_prefix}/share/YaST2/data/devtools/NO_MAKE_CHECK" <<EOF
When yast2 core is broken and the interpreter does not work,
submitting yast2-devtools with the flag file existing will
prevent ycp developers being flooded by testsuite failures.
EOF

%fdupes %buildroot/%_prefix

%files
%defattr(-,root,root)
%dir %{_datadir}/emacs
%dir %{_datadir}/emacs/site-lisp
%{_datadir}/emacs/site-lisp/*ycp-mode.el
%dir %{_datadir}/vim
%dir %{_datadir}/vim/site
%dir %{_datadir}/vim/site/syntax
%{_datadir}/vim/site/syntax/ycp.vim
%dir %{_datadir}/vim/site/ftdetect
%{_datadir}/vim/site/ftdetect/ycp_filetype.vim
%dir %{_prefix}/lib/YaST2
%{_datadir}/cmake

%dir %{_datadir}/YaST2
%doc %{_datadir}/doc/packages/%{name}
%dir %{_prefix}/lib/YaST2/bin
%{_prefix}/lib/YaST2/bin/scrdoc
%{_prefix}/lib/YaST2/bin/ycp_puttext
%{_prefix}/lib/YaST2/bin/ydoxygen
%dir %{_datadir}/YaST2/clients/
%{_datadir}/YaST2/clients/ycp2yml.rb
%{_datadir}/YaST2/data/devtools/bin/check-textdomain
%{_datadir}/YaST2/data/devtools/bin/check_icons
%{_datadir}/YaST2/data/devtools/bin/find-unused-published
%{_datadir}/YaST2/data/devtools/bin/get-lib
%{_datadir}/YaST2/data/devtools/bin/pot-spellcheck
%{_datadir}/YaST2/data/devtools/bin/rny2rnc
%{_datadir}/YaST2/data/devtools/bin/showy2log
%{_datadir}/YaST2/data/devtools/bin/tagversion
%{_datadir}/YaST2/data/devtools/bin/y2makepot
%{_datadir}/YaST2/data/devtools/bin/gettextdomains
%{_datadir}/YaST2/data/devtools/bin/ycp_puttext
%dir %{_datadir}/YaST2/control/
%{_datadir}/YaST2/control/control_to_glade.xsl


%files -n yast2-buildtools
%defattr(-,root,root)
%{_sysconfdir}/rpm/macros.yast
%{_bindir}/y2tool
%{_datadir}/aclocal/*.m4
%{_datadir}/pkgconfig/yast2-devtools.pc
%{_datadir}/YaST2/data/docbook
%dir %{_datadir}/YaST2/data
%dir %{_datadir}/YaST2/data/devtools
%dir %{_datadir}/YaST2/data/devtools/bin
%{_datadir}/YaST2/data/devtools/admin
%{_datadir}/YaST2/data/devtools/Doxyfile
%if 0%{?qemu_user_space_build}
%{_datadir}/YaST2/data/devtools/NO_MAKE_CHECK
%endif
# needed for doxygen, not nice
%{_datadir}/YaST2/data/devtools/footer-notimestamp.html
%{_datadir}/YaST2/data/devtools/data
%{_datadir}/YaST2/data/devtools/bin/y2autoconf
%{_datadir}/YaST2/data/devtools/bin/y2automake




%changelog
