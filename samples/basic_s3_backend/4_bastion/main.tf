# 작업 노드
# k8s 관한 패키지들을 설치함
# alias k=kubectl 적용
# ssh root@pubip 로 접근 가능
# password = qwe123


module "bastion" {
  source = "../../modules/eks_bastion"
  
  instance_type = var.instance_type
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  key_name = var.key_name
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.bastion_security_group_id]
  iam_role_name = var.bastion_iam_role_name
  create_iam_instance_profile = true
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }


}