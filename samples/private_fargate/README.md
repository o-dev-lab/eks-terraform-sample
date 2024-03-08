# eks-terraform-sample 


- 백엔드 용 S3는 콘솔에서 직접 생성. 모든 것을 테라폼으로 구축하려 하지 말자!
- 그리고 s3 버킷의 기본 최대 수는 100개 이므로, 하나의 버킷에서 경로로 각 실행환경별 tfstate 파일을 관리하자. 각 실행환경 backend.tf 에서 key로 경로 나누기
- s3 버킷의 버전 관리 체크는 필수

*그 외 콘솔에서 직접 작업하는 게 편한 것 : pem-key, 배포를 위한 iam, api gw, route53 

<br>
## 테라폼 배포
권한을 가진 aws cli 계정으로 접근 후 배포한다.

~~~ bash
aws configure

terraform init 
terraform plan 
terraform apply 
~~~


모듈에서 main.tf 를 리소스 이름으로 표시 -> 실행환경에서 에러를 확인할 때, 모두 main.tf 로 되어 있는 경우 확인이 어려워 임의로 리소스 이름으로 변경해 두었다. 공식 terraform 모듈 예시를 보면 일반적으로 main.tf 으로 표시함. 

<br>
## private eks cluster - fargate only & bastion
fargate only 구성으로 예시를 위해 만든 용으로, 하나의 main.tf 모든걸 넣어버렸다.


<br>
### 배포 전 확인
- namespace와 ecr 경로 이름을 tfvars 에 맞추어서 입력했는지 다시 확인 후 배포하자.
- fargate의 경우, namespace 가 안맞으면 올라갈 pod 를 찾을 수 없어 배포가 실패한다.