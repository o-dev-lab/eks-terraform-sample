

data "aws_caller_identity" "current" {}


module "ecr" {
  source   = "../../../modules/ecr"
  for_each = toset(var.image_names)

  repository_name = "${var.eks_cluster_name}/${each.value}"

  repository_image_tag_mutability = "MUTABLE"

  repository_read_write_access_arns = [module.eks_cluster.cluster_iam_role_arn ]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  
}





data "aws_partition" "current" {}

# EKS Cluster (fargate)

module "eks_cluster" {
  source   = "../../../modules/eks"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  cluster_version = var.eks_cluster_version
  cluster_name    = var.eks_cluster_name


  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true


  create_cluster_security_group = false
  create_node_security_group    = false

  cluster_security_group_id = data.terraform_remote_state.vpc.outputs.eks_cluster_security_group_id


  cluster_addons = {
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    coredns = {
    }
  }

  

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 3
      desired_size = 2

    }
  }

  manage_aws_auth_configmap = true

  aws_auth_users = [
    for user in var.aws_auth_users : {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user}",
      username = user,
      groups   = ["system:masters"],
    }
  ]



}

