#!/bin/bash

# 스크립트 실행 중 발생한 에러에 대해 즉시 종료
set -e

# 현재 디렉토리의 하위 폴더들을 이름 순으로 정렬하여 순회
for folder in $(find . -maxdepth 1 -type d | cut -c 3- | sort); do
    if [ "$folder" != "." ]; then  # 현재 디렉토리(.) 제외
        echo "Accessing folder: $folder"
        cd "$folder"  # 폴더로 이동
        
        # Terraform 실행

        terraform init -backend-config=../backend.tfvars 

        terraform plan -backend-config=../backend.tfvars 

        terraform apply -var-file=../terraform.tfvars -var-file=../backend.tfvars -auto-approve
        

        cd ..  # 상위 폴더로 돌아감
    fi
done
