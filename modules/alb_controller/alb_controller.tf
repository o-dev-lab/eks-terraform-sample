################################################################################
# AWS Ingress Controller
################################################################################


module "lb_controller_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role = true

  role_name        = "AmazonEKSLBControllerRole-${var.prefix}"
  role_path        = "/"
  role_description = "Used by AWS Load Balancer Controller for EKS"

  role_permissions_boundary_arn = ""

  provider_url = replace(var.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:kube-system:aws-load-balancer-controller"
  ]
  oidc_fully_qualified_audiences = [
    "sts.amazonaws.com"
  ]
}


resource "aws_iam_role_policy" "controller" {
  name_prefix = "AWSLoadBalancerControllerIAMPolicy-${var.prefix}"
  policy      = var.alb_controller_iam_policy
  role        = module.lb_controller_role.iam_role_name
}

resource "helm_release" "release" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"

  dynamic "set" {
    for_each = {
      "clusterName"           = var.eks_cluster_id
      "serviceAccount.create" = "true"
      "serviceAccount.name"   = "aws-load-balancer-controller"
      "region"                = var.region
      "vpcId"                 = var.vpc_id
      "image.repository"      = "public.ecr.aws/eks/aws-load-balancer-controller"

      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.lb_controller_role.iam_role_arn
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}


