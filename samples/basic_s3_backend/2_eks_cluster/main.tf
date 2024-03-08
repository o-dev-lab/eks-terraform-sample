

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




# ssm policy 

data "aws_iam_policy_document" "assume_role_policy" {

  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {

  name        = var.bastion_iam_role_name
  description = "ec2 ssm role"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = true

}


resource "aws_iam_role_policy_attachment" "this" {

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.this.name
}

resource "aws_iam_instance_profile" "this" {

  role = aws_iam_role.this.name
  name        = var.bastion_iam_role_name


}





data "aws_partition" "current" {}

# EKS Cluster (fargate)

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.5.1"

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

  enable_cluster_creator_admin_permissions = true
  
  # 권한 추가 


  access_entries = {
    # One access entry with a policy associated

    example = {
      kubernetes_groups = []
      principal_arn     = aws_iam_role.this.arn

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }



}




