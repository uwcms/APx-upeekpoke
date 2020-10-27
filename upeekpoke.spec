# Build this using apx-rpmbuild.
%define name upeekpoke

Name:           %{name}
Version:        %{version_rpm_spec_version}
Release:        %{version_rpm_spec_release}%{?dist}
Summary:        A simple UIO based peek/poke command.

License:        Reserved
URL:            https://github.com/uwcms/APx-%{name}
Source0:        %{name}-%{version_rpm_spec_version}.tar.gz

%global debug_package %{nil}

%description
This package provides a simple UIO based peek/poke command.


%prep
%setup -q


%build
##configure
make %{?_smp_mflags} LIB_VERSION=%{version_sofile}


%install
rm -rf $RPM_BUILD_ROOT
install -D -m 0755 upeek %{buildroot}/%{_bindir}/upeek
install -D -m 0755 upoke %{buildroot}/%{_bindir}/upoke


%files
%{_bindir}/upeek
%{_bindir}/upoke

%changelog
* Tue Nov 26 2019 Jesra Tikalsky <jtikalsky@hep.wisc.edu>
- Initial spec file
