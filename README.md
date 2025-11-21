# Ubuntu Initial Setup Script (Korea)

우분투 설치 직후 **한글 깨짐 해결, 미러 서버 최적화, 시간 설정**을 자동으로 수행하는 스크립트입니다.

## 기능
1. **미러 서버 변경**: 느린 기본 서버를 `mirror.kakao.com`으로 변경하여 다운로드 속도 향상
2. **시스템 업데이트**: `apt update && upgrade` 자동화
3. **시간대 설정**: `Asia/Seoul` (KST)로 변경
4. **한글 지원**:
   - 한글 언어팩 설치 (`language-pack-ko`)
   - 한글 폰트 설치 (나눔고딕, Noto Sans CJK - 글자 깨짐 해결)
   - 로케일 `ko_KR.UTF-8` 설정

## 사용법 (Usage)

터미널을 열고 아래 명령어를 순서대로 입력하세요.

```bash
# 1. 저장소 클론 (또는 스크립트 다운로드)
git clone https://github.com/pudhy070/ubuntu-init-setup-kr.git
cd ubuntu-init-setup

# 2. 실행 권한 부여
chmod +x ubuntu-init.sh

# 3. 스크립트 실행 (sudo 필수)
sudo ./ubuntu-init.sh
```

### 팁: 한글 입력기 활성화 (재부팅 후)
스크립트 실행 및 재부팅 후, 우분투 설정(Settings) > 지역 및 언어(Region & Language) > 입력 소스(Input Sources)에 가서 `Korean (Hangul)`을 추가해주면 한영키 사용이 가능해집니다.
