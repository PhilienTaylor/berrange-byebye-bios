# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: 2023 Red Hat

# No one is attaching GDB to a boot sector
%global debug_package %{nil}

Name: byebyebios
Version: 1.0
Release: 1
Summary: Injects a x86 boot sector to inform of UEFI boot requirement
License: MIT-0
Source: https://gitlab.com/berrange/byebyebios/-/archive/v%{version}/%{name}-v%{version}.tar.gz
Url: https://gitlab.com/berrange/byebyebios
ExclusiveArch: x86_64
BuildArch: noarch

%description
The byebyebios package provides an x86 boot sector that should
be copied to any disk image that does not intend to support
use of BIOS firmware. It will display a message to the user,
on the first serial port and VGA console, informing them of
the requirement to boot using UEFI firmware.

%prep
%autosetup -n %{name}-v%{version}

%build
%__make

%install
%make_install \
    DESTDIR=$RPM_BUILD_ROOT \
    bindir=%{_bindir} \
    datadir=%{_datadir} \
    mandir=%{_mandir}

%files
%license LICENSES/MIT-0.txt
%{_bindir}/%{name}
%{_datadir}/%{name}/nouefi.txt
%{_datadir}/%{name}/bootstub.bin
%{_mandir}/man1/%{name}.1*
