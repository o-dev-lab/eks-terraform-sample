module "alb_controller" {
  source   = "../../../modules/alb_controller"


  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  region = var.region
  prefix = var.prefix
  eks_cluster_id = data.terraform_remote_state.eks.outputs.cluster_name
  alb_controller_iam_policy = file("../../../iam_policy/alb_controller_iam_policy.json")
  cluster_oidc_issuer_url = data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url
}

