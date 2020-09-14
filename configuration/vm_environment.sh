#!/bin/bash

echo "1. cockpit 설치"
dnf install -y cockpit

echo "2. cockpit 사용 설정"
systemctl enable --now cockpit.socket
systemctl start cockpit

echo "3. cockpit 상태 확인 및 접속 확인(ex. https://{host_IP}:9090/)"
systemctl status cockpit

echo "4. KVM 설치"
dnf module install -y virt
dnf install -y virt-install virt-viewer

echo "5. KVM 사용 적합성 확인"
virt-host-validate

# QEMU: Checking if IOMMU is enabled by kernel : WARN 발생 시 확인
# vi /etc/default/grub
# GRUB_CMDLINE_LINUX="... intel_iommu=on" 추가
# grub2-mkconfig -o /boot/grub2/grub.cfg
# reboot
# QEMU: Checking if IOMMU is enabled by kernel : PASS

echo "4. KVM 사용 설정"
systemctl start libvirtd.service
systemctl enable libvirtd.service

echo "5. KVM 상태 확인"
systemctl status libvirtd.service
