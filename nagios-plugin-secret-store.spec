Name:           nagios-plugin-secret-store
Version:        1.0.1
Release:        1
Summary:        Nagios probe script for Secret Store service

License:        MIT
URL:            https://github.com/IISAS/vault-nagios-probe
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch
#BuildRequires:  
Requires:       bash,bind-utils,curl

%description
This is a script for monitoring status of Secret Store service. The script
should detect various possible issues of the service during operation and 
give corresponding error or warning message.

%prep
%setup -q


%build


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/libexec/argo-monitoring/probes/nagios-plugin-secret-store/
cp usr/libexec/argo-monitoring/probes/nagios-plugin-secret-store/nagios-plugin-secret-store.sh  $RPM_BUILD_ROOT/usr/libexec/argo-monitoring/probes/nagios-plugin-secret-store/
chomd a+x $RPM_BUILD_ROOT/usr/libexec/argo-monitoring/probes/nagios-plugin-secret-store/nagios-plugin-secret-store.sh

%files
/usr/libexec/argo-monitoring/probes/nagios-plugin-secret-store/nagios-plugin-secret-store.sh

%clean
rm -rf $RPM_BUILD_ROOT


%changelog
* Mon May 22 2023 Viet Tran <tdviet@gmail.com>
- First release
