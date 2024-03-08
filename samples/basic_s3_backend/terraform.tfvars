
# 프로젝트용 Environment
env = "dev"
prefix = "2temp"
project = "2temp"


# default 값은 서울리전, 리전별 모든 가용역역
region = "ap-northeast-2"
azs = ["ap-northeast-2a","ap-northeast-2c"]

# VPC
vpc_cidr     = "100.0.0.0/16"


#ips for sg, 회사 ip 
company_ips_for_sg = ["200.0.0.2/32", "200.0.0.3/32"]


#bastion
bastion_iam_role_name = "bastion-role"
instance_type = "t3.small"
key_name = "pem_key_name"

# ECR
image_names = ["temp_img"]  
 
# eks cluster
eks_cluster_name = "tempcluster"
eks_cluster_version = "1.28"
namespace_names = []

#Iam user name for eks auth
aws_auth_users = [ "devops_" ]