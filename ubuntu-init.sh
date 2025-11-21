#!/bin/bash

# 색상 변수 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== 우분투 통합 설정 스크립트 (시스템 + 개발환경) ===${NC}"

# 0. Root 권한 확인
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}관리자 권한(sudo)으로 실행해주세요.${NC}"
    exit 1
fi

# --- [시스템 기초 설정] ---

# 1. 미러 리스트 변경 (Kakao Mirror)
echo -e "${YELLOW}[1/7] 미러 서버를 Kakao 서버로 변경 중...${NC}"
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
echo -e "${GREEN}완료: 미러 서버 변경됨${NC}"

# 2. 패키지 리스트 업데이트 및 업그레이드
echo -e "${YELLOW}[2/7] 패키지 업데이트 및 업그레이드 진행 중...${NC}"
apt-get update && apt-get upgrade -y
# 개발 도구 설치를 위한 필수 패키지 사전 설치 (curl, git 등)
apt-get install -y curl wget git build-essential net-tools software-properties-common
echo -e "${GREEN}완료: 시스템 업데이트 및 필수 도구 설치${NC}"

# 3. 시간대 설정 (Asia/Seoul)
echo -e "${YELLOW}[3/7] 시간대(Timezone)를 Asia/Seoul로 설정 중...${NC}"
timedatectl set-timezone Asia/Seoul
echo -e "${GREEN}완료: 현재 시간 -> $(date)${NC}"

# 4. 한글 언어팩 및 폰트 설치
echo -e "${YELLOW}[4/7] 한글 언어팩, 폰트, 입력기 설치 중...${NC}"
apt-get install -y language-pack-ko
locale-gen ko_KR.UTF-8
update-locale LANG=ko_KR.UTF-8 LC_MESSAGES=POSIX
# 한글 폰트 (나눔, Noto Sans CJK)
apt-get install -y fonts-nanum fonts-nanum-coding fonts-noto-cjk
# 한글 입력기 (ibus-hangul)
apt-get install -y ibus-hangul
echo -e "${GREEN}완료: 한글 설정${NC}"

# --- [개발 환경 설정] ---

# 5. 런타임 환경 설치 (Node.js, Python, Java)
echo -e "${YELLOW}[5/7] 개발 언어 런타임 설치 중 (Node, Python, Java)...${NC}"

# (1) Node.js (LTS) & React 개발 환경
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs
npm install --global yarn
echo -e "${BLUE}> Node.js, NPM, Yarn 설치 완료${NC}"

# (2) Python 환경
apt-get install -y python3-pip python3-venv
echo -e "${BLUE}> Python3, Pip, Venv 설치 완료${NC}"

# (3) Java (JVM) - OpenJDK 17
apt-get install -y openjdk-17-jdk
echo -e "${BLUE}> OpenJDK 17 설치 완료${NC}"

echo -e "${GREEN}완료: 런타임 환경 설치${NC}"

# 6. IDE 설치 (VS Code, JetBrains Toolbox)
echo -e "${YELLOW}[6/7] IDE 설치 중 (VS Code, JetBrains Toolbox)...${NC}"

# (1) VS Code (Snap)
snap install code --classic
echo -e "${BLUE}> VS Code 설치 완료${NC}"

# (2) JetBrains Toolbox
# AppImage 실행을 위한 라이브러리 (Ubuntu 22.04+)
apt-get install -y libfuse2
# 다운로드 및 설치
JB_URL="https://data.services.jetbrains.com/products/download?code=TBA&platform=linux"
wget -O /tmp/jetbrains-toolbox.tar.gz "$JB_URL"
mkdir -p /opt/jetbrains-toolbox
tar -xzf /tmp/jetbrains-toolbox.tar.gz -C /opt/jetbrains-toolbox --strip-components=1
rm /tmp/jetbrains-toolbox.tar.gz
# 실행 심볼릭 링크
ln -sf /opt/jetbrains-toolbox/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox
echo -e "${BLUE}> JetBrains Toolbox 설치 완료 (터미널에 'jetbrains-toolbox' 입력하여 실행)${NC}"

echo -e "${GREEN}완료: IDE 설치${NC}"

# 7. 마무리 및 정리
echo -e "${YELLOW}[7/7] 불필요한 패키지 정리 중...${NC}"
apt-get autoremove -y
apt-get autoclean

echo -e "${GREEN}=== 모든 설정과 설치가 완료되었습니다! ===${NC}"
echo -e "${YELLOW}변경 사항(특히 한글 및 그룹 권한) 적용을 위해 재부팅이 필요합니다.${NC}"
echo -e "지금 재부팅 하시겠습니까? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi
