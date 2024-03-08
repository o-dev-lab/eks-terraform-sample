module "alb_controller" {
  source   = "../../modules/alb_controller"


  vpc_id = var.vpc_id
  region = var.region
  prefix = var.prefix
  eks_cluster_id = var.eks_cluster_id
  alb_controller_iam_policy = file("../../iam_policy/alb_controller_iam_policy.json")
  cluster_oidc_issuer_url = var.cluster_oidc_issuer_url
}

