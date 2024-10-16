#!/bin/bash

APPS_DIR="apps"

# Git 저장소 확인
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "오류: 현재 디렉토리가 Git 저장소가 아닙니다."
    exit 1
fi

# 프로젝트 목록 가져오기
PROJECTS=($(find $APPS_DIR -maxdepth 2 -name pubspec.yaml -exec dirname {} \; | xargs -n1 basename))

echo "프로젝트 목록:"
for i in "${!PROJECTS[@]}"; do
    echo "[$((i+1))] ${PROJECTS[$i]}"
done
echo "[q] 종료"

echo
read -p "Code genarate 할 프로젝트 번호를 입력하세요 (1-${#PROJECTS[@]}): " choice

if [ "$choice" = "q" ]; then
    exit 0
fi

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#PROJECTS[@]}" ]; then
    case "$choice" in
      1)
        cd "apps/${PROJECTS[$choice - 1]}" || exit
        dart run build_runner build --delete-conflicting-outputs
        ;;
    esac
else
    echo "잘못된 선택입니다. 1부터 ${#PROJECTS[@]} 사이의 숫자를 입력해주세요."
fi