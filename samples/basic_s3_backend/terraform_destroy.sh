#!/bin/bash

# 에러가 발생하면 스크립트 실행 중단
set -e

# 현재 디렉토리의 하위 폴더들을 이름 순으로 내림차순 정렬하여 순회
for folder in $(find . -maxdepth 1 -type d | cut -c 3- | sort -r); do
    if [ "$folder" != "." ]; then  # 현재 디렉토리(.) 제외
        echo "Accessing folder: $folder"
        cd "$folder"  # 폴더로 이동

        terraform destory -var-file=../terraform.tfvars -var-file=../backend.tfvars -auto-approve

        cd ..  # 상위 폴더로 돌아감
    fi
done
