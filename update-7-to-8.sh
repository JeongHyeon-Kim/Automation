#!/bin/bash

# 버전 업데이트 (CentOS 7.5 기준)
# 1. 버전 업그레이드에 앞서 전체 환경을 최신 상태로 업데이트 진행
yum update -y

# 2. 빠른 미러 서버를 사용하기 위해 설치
yum install -y yum-plugin-fastestmirror

# 3. epel 저장소 설치
yum install -y epel-release

# 4. 진행 시 필요한 추가 패키지 설치 (epel repository 설치 필요)
yum install -y yum-utils
yum install -y rpmconf

# 5. 패키지들의 설정 파일 체크
yes "" | rpmconf -a

# 6. 필요하지 않은 모든 패키지 정리
package-cleanup --leaves
package-cleanup --orphans

# 7. dnf 패키지 설치(extras에 존재)
yum install -y dnf

# 8. 충돌 방지를 위해 Python 관련 패키지 업데이트 및 설치 진행
yum update -y python*
yum install -y dnf-data dnf-plugins-core libdnf-devel libdnf python2-dnf-plugin-migrate dnf-automatic

# 9. yum 관련 패키지들 삭제
dnf remove -y yum yum-metadata-parser

# 10. dnf 업그레이드 (epel 업그레이드)
dnf upgrade -y

# 11. yum 디렉토리 삭제
rm -Rf /etc/yum

# 12. 8.x 레포 관련 패키지 설치 (레포 변경)
dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-repos-8.2-2.2004.0.1.el8.x86_64.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-release-8.2-2.2004.0.1.el8.x86_64.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-gpg-keys-8.2-2.2004.0.1.el8.noarch.rpm

# 13. epel을 8버전 최신을 바라보도록 dnf 명령어로 업그레이드
dnf upgrade -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# 14. dnf 정리
dnf clean all

# 15. kernel 및 관련 패키지 제거
rpm -e `rpm -q kernel`
rpm -e --nodeps sysvinit-tools

# 16. 충돌되는 패키지들 미리 삭제
dnf remove -y python36-rpmconf

# 17. 8.x 패키지들 설치 (8버전에 대고 실행)
dnf --releasever=8 --allowerasing --setopt=deltarpm=false -y distro-sync

# 18. kernel-core 설치
dnf install -y kernel-core

# 19. groupinstall 진행
dnf groupupdate -y "Core" "Minimal Install"
