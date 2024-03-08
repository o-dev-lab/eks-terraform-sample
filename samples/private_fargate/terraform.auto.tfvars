
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
company_ips_for_sg = ["211.60.50.190/32", "221.148.35.243/32"]


#bastion
bastion_iam_role_name = "bastion-role"

# ECR
image_names = ["temp"]  
 
# eks cluster
eks_cluster_name = "tempcluster"
eks_cluster_version = "1.28"
namespace_names = []

#Iam user name for eks auth
aws_auth_users = [ "dbg_devops_ykoh" ]