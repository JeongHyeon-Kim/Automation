#!/bin/bash
file=$1

while read line; do
        echo $(rpm -qa --queryformat '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH};%{BUILDHOST};%{VENDOR};%{GROUP};%{SUMMARY}\n' $line)
done < $file

# 이 때의 $line은 순수한 패키지 이름만 넣어주기(ex. acl(O), acl-2.2.51-14.el7.x86_64(X))
# 이름만 추출하기 : rpm -qa --queryformat '%{NAME}\n' | sort > test_list
# vendor_check.csv와 같은 파일로 만들고 구분자를 ;(세미콜론)으로 하기