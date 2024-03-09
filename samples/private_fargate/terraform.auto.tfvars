
# 프로젝트용 Environment
env = "dev"
prefix = "temp"
project = "temp"


# default 값은 서울리전, 리전별 모든 가용역역
region = "ap-northeast-2"
azs = ["ap-northeast-2a","ap-northeast-2c"]

# VPC
vpc_cidr     = "100.0.0.0/16"


#ips for sg, 회사 ip. bastion에 접근할 ip 로 필수로 수정 필요 
company_ips_for_sg = ["200.0.0.2/32", "200.0.0.3/32"]


#bastion
bastion_iam_role_name = "bastion-role"
instance_type = "t3.small"
key_name = "pem_key_name" # 계정에 존재하는 pem 키 이름 확인하여 넣기(필수)

# ECR
image_names = ["temp_img"]  
 
# eks cluster
eks_cluster_name = "tempcluster"
eks_cluster_version = "1.28"
namespace_names = [] # fargate 배포 시 namespace가 없으면 배포되지 않음. kube-system과 default ns 는 생성됨.

#Iam user name for eks auth
aws_auth_users = [ "devops_" ] # eks 모듈이 없데이트 되면서 내용이 변경됨. 현재 적용되지 않음. 이후 업데이트 예정