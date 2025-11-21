#!/bin/bash

# 색상 변수 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== 우분투 초기 설정 스크립트 시작 ===${NC}"

# 1. Root 권한 확인
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}관리자 권한(sudo)으로 실행해주세요.${NC}"
    exit 1
fi

# 2. 미러 리스트 변경 (Kakao Mirror)
echo -e "${YELLOW}[1/5] 미러 서버를 Kakao 서버로 변경 중...${NC}"
# 기존 sources.list 백업
cp /etc/apt/sources.list /etc/apt/sources.list.bak
# kr.archive.ubuntu.com 또는 archive.ubuntu.com 등을 mirror.kakao.com으로 변경
sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
echo -e "${GREEN}완료: 미러 서버 변경됨${NC}"

# 3. 패키지 리스트 업데이트 및 업그레이드
echo -e "${YELLOW}[2/5] 패키지 업데이트 및 업그레이드 진행 중... (시간이 소요될 수 있음)${NC}"
apt-get update && apt-get upgrade -y
echo -e "${GREEN}완료: 시스템 업데이트${NC}"

# 4. 시간대 설정 (Asia/Seoul)
echo -e "${YELLOW}[3/5] 시간대(Timezone)를 Asia/Seoul로 설정 중...${NC}"
timedatectl set-timezone Asia/Seoul
echo -e "${GREEN}완료: 현재 시간 -> $(date)${NC}"

# 5. 한글 언어팩 및 폰트 설치 (깨짐 방지)
echo -e "${YELLOW}[4/5] 한글 언어팩, 폰트, 입력기 설치 중...${NC}"
# 언어팩 설치
apt-get install -y language-pack-ko
# 로케일 생성
locale-gen ko_KR.UTF-8
# 시스템 로케일 설정
update-locale LANG=ko_KR.UTF-8 LC_MESSAGES=POSIX

# 한글 폰트 설치 (네모 깨짐 방지용 - 나눔폰트 & Noto Sans CJK)
apt-get install -y fonts-nanum fonts-nanum-coding fonts-noto-cjk

# 한글 입력기 (ibus-hangul) 설치 - 데스크탑 환경일 경우 유용
apt-get install -y ibus-hangul

echo -e "${GREEN}완료: 한글 설정${NC}"

# 6. 불필요한 패키지 정리
echo -e "${YELLOW}[5/5] 불필요한 패키지 정리 중...${NC}"
apt-get autoremove -y
apt-get autoclean

echo -e "${GREEN}=== 모든 설정이 완료되었습니다! ===${NC}"
echo -e "${YELLOW}변경 사항을 완벽하게 적용하려면 재부팅을 권장합니다.${NC}"
echo -e "지금 재부팅 하시겠습니까? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi
