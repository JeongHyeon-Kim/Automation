# 간단한 명령어를 통해 얻을 수 있음
# 예시
rpm -qa --queryformat '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH};%{BUILDHOST};%{VENDOR};%{PACKAGER}\n' | sort | tee vendor_check_list.xlsx
