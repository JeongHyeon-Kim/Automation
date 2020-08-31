#!/bin/bash

echo "HA 설정 (OracleLinux 8.1 기준)"

echo "레포 추가"
dnf config-manager --enable ol8_appstream ol8_baseos_latest ol8_addons

echo "패키지 설치"
dnf install -y pcs pacemaker resource-agents fence-agents-all

echo "방화벽 서비스로 HA 등록"
firewall-cmd --add-service=high-availability

echo "HA cluster용 비밀번호 설정"
passwd hacluster

echo "pcs 데몬 활성화"
systemctl enable --now pcsd.service
