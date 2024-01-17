
# 프로젝트용 Environment
env = "dev"
prefix = "2temp"
project = "2temp"


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