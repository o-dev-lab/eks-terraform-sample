
# s3 버킷 이름
tfstate_bucket_name = "test-tfstate-bucket-yk"

# 프로젝트용 Environment
env = "dev"
prefix = "2temp"
project = "2temp"


# VPC
vpc_cidr     = "100.0.0.0/16"


#ips for sg, 회사 ip 
company_ips_for_sg = ["211.60.50.190/32", "221.148.35.243/32"]

# default 값은 서울리전, 리전별 모든 가용역역
region = "ap-northeast-2"
azs = ["ap-northeast-2a","ap-northeast-2c"]


#Iam user name for eks auth
aws_auth_users = [ "tfc", "dbg_devops_ykoh"]

# ECR
image_names = ["temp"]  
 
# hidden cluster
eks_cluster_name = "tempcluster"
eks_cluster_version = "1.28"


#bastion
bastion_iam_role_name = "bastion-role"
instance_type = "t3.small"
key_name = "dbg-dev-bastion" # 존재하는 키 이름이여야 한다.

