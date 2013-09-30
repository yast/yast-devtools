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
Version:        3.1.1
Release:        0

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source0:        %{name}-%{version}.tar.bz2

BuildRequires:  automake
BuildRequires:  docbook-xsl-stylesheets
BuildRequires:  gcc-c++
BuildRequires:  libtool
BuildRequires:  libxslt
BuildRequires:  perl-XML-Writer
BuildRequires:  pkgconfig
BuildRequires:  sgml-skel
Requires:       libxslt
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

Provides:       ycpdoc
Provides:       ydoc
Obsoletes:      ycpdoc
Obsoletes:      ydoc
Provides:       yast2-config-newmodule
Provides:       yast2-trans-newmodule
Obsoletes:      yast2-config-newmodule
Obsoletes:      yast2-trans-newmodule

Summary:        YaST2 - Development Tools
License:        GPL-2.0+
Group:          System/YaST

BuildArch:      noarch

%description
Scripts and templates for developing YaST2 modules and components.
Required for rebuilding the existing YaST2 modules and components (both
YCP and C++).

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

%files
%defattr(-,root,root)
/etc/rpm/macros.yast
%{_prefix}/bin/y2tool
%{_prefix}/bin/yastdoc
%dir %{_prefix}/share/emacs
%dir %{_prefix}/share/emacs/site-lisp
%{_prefix}/share/emacs/site-lisp/*ycp-mode.el
%dir %{_prefix}/share/vim
%dir %{_prefix}/share/vim/site
%dir %{_prefix}/share/vim/site/syntax
%{_prefix}/share/vim/site/syntax/ycp.vim
%dir %{_prefix}/share/vim/site/ftdetect
%{_prefix}/share/vim/site/ftdetect/ycp_filetype.vim
%dir %{_prefix}/lib/YaST2
%{_prefix}/share/cmake
%{_prefix}/lib/YaST2/bin
%dir %{_prefix}/share/YaST2
%{_prefix}/share/YaST2/data
%dir %{_prefix}/share/YaST2/clients
%{_prefix}/share/YaST2/clients/*.rb
%{_prefix}/share/aclocal/*.m4
%{_prefix}/share/pkgconfig/yast2-devtools.pc
%doc %{_prefix}/share/doc/packages/%{name}

%changelog
