
locals {
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                  = 1
    }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
    }
}

# VPC


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name = "${var.prefix}-vpc"
  azs  = var.azs
  cidr = var.vpc_cidr


  # Enable DNS resolution
  enable_dns_support   = true

  # Enable DNS hostnames 
  enable_dns_hostnames = true

  # NAT게이트웨이를 생성
  enable_nat_gateway = true
  # NAT게이트웨이를 1개만 생성합니다.
  single_nat_gateway = true


  public_subnets = [for index in range(length(var.azs)): cidrsubnet(var.vpc_cidr, 6, index)]
  public_subnet_names = [for index in range(length(var.azs)) : "${var.prefix}-alb-pub-sub-${substr(var.azs[index], -1, -1)}"]
  public_route_table_tags = { Name = "${var.prefix}-alb-pub-sub-rt"}


  private_subnets = [for index in range(length(var.azs)): cidrsubnet(var.vpc_cidr, 6, index + length(var.azs))]
  private_subnet_names = [for index in range(length(var.azs)) : "${var.prefix}-eks-pri-sub-${substr(var.azs[index], -1, -1)}"]
  private_route_table_tags = { Name = "${var.prefix}-eks-pri-sub-rt"}

                                         
  intra_subnets = [for index in range(length(var.azs)): cidrsubnet(var.vpc_cidr, 6, index + length(var.azs)*3)]
  intra_subnet_names = [for index in range(length(var.azs)) : "${var.prefix}-eni-pri-sub-${substr(var.azs[index], -1, -1)}"]
  intra_route_table_tags = { Name = "${var.prefix}-eni-prisub-rt"}


  igw_tags = { Name = "${var.prefix}-vpc-igw" }
  nat_gateway_tags = { Name = "${var.prefix}-vpc-ngw" }

  tags = var.tags


  #eks - alb ingress controller 를 위한 태깅

  private_subnet_tags = local.private_subnet_tags
  public_subnet_tags = local.public_subnet_tags

  enable_flow_log                                 = true
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_cloudwatch_log_group_retention_in_days = 7
  flow_log_traffic_type                           = "REJECT"



}




# Endpoint


module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.5.2"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.endpoint_sg.security_group_id]

  endpoints = {
    s3 = {
      service_type = "Gateway"
      service             = "s3"
      route_table_ids     = module.vpc.private_route_table_ids
      tags                = { Name = "s3-vpc-gw-endpoint" }
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = [module.vpc.intra_subnets[0]]
      tags                = { Name = "ec2-vpc-endpoint" }
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = [module.vpc.intra_subnets[0]]
      tags                = { Name = "sts-vpc-endpoint" }
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = [module.vpc.intra_subnets[0]]
      tags                = { Name = "ecr.api-vpc-endpoint" }
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = [module.vpc.intra_subnets[0]]
      tags                = { Name = "ecr.dkr-vpc-endpoint" }
    }


  }

}



# # Security Group
# 공식 모듈의 복잡한 내용을 모두 포함할게 아니여서 만들어 둔 모듈 사용

module "eks_cluster_sg" {
  source = "../../modules/sg"

  name        = "${var.prefix}-eks-cluster-sg"
  description = "Security group for eks cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_lists = {
    vpc_cidr = {
      description = "vpc_cidr"
      cidr_blocks = [var.vpc_cidr]
    }
    self = {
      description = "eks cluster sg"
      self = true
    }
    bastion = {
      description = "eks cluster sg"
      source_security_group_id = module.bastion_sg.security_group_id
    }
  }

  egress_lists = {
    egress = {
      description = "all"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}



# vpc endpoint sg

module "endpoint_sg" {
  source = "../../modules/sg"

  name        = "${var.prefix}-eni-sg"
  description = "Security group for vpc endpoint"
  vpc_id      = module.vpc.vpc_id

  ingress_lists = {
    vpc_cidr = {
      description = "vpc_cidr"
      cidr_blocks = [var.vpc_cidr]
    }
    eks_cluster = {
      description = "eks cluster sg"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      source_security_group_id = module.eks_cluster_sg.security_group_id
    }


  }

  egress_lists = {
    egress = {
      description = "all"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

}

module "bastion_sg" {
  source = "../../modules/sg"

  name        = "${var.prefix}-bastion-sg"
  description = "Security group for bastion"
  vpc_id      = module.vpc.vpc_id

  ingress_lists = {
    vpc_cidr = {
      description = "vpc_cidr"
      cidr_blocks = [var.vpc_cidr]
    }
    # eks_cluster = {
    #   description = "eks cluster sg"
    #   from_port = 443
    #   to_port = 443
    #   protocol = "tcp"
    #   source_security_group_id = module.eks_cluster_sg.security_group_id
    # }
    company_ips = {
      description = "company_ips_for_sg"
      cidr_blocks = var.company_ips_for_sg
      from_port = 22
      to_port = 22
      protocol = "tcp"
    }


  }

  egress_lists = {
    egress = {
      description = "all"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
}


# 작업 노드

module "bastion" {
  source = "../../modules/eks_bastion"
  
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnets[0]
  key_name = var.key_name
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  iam_role_name = var.bastion_iam_role_name
  create_iam_instance_profile = true
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }


}




data "aws_caller_identity" "current" {}


# 프라이빗 ecr
# repository_type : privat가 기본 값

module "ecr" {
  source   = "terraform-aws-modules/ecr/aws"
  for_each = toset(var.image_names)

  repository_name = "${var.eks_cluster_name}/${each.value}"

  repository_image_tag_mutability = "MUTABLE"

  repository_read_write_access_arns = [ module.eks_cluster.cluster_iam_role_arn ]

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


data "aws_iam_instance_profile" "bastion_role_arn" {
  name = var.bastion_iam_role_name
}

# EKS Cluster (fargate)

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.5.1"

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_version = var.eks_cluster_version
  cluster_name    = var.eks_cluster_name


  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false


  create_cluster_security_group = false
  create_node_security_group    = false

  cluster_security_group_id = module.eks_cluster_sg.security_group_id

  enable_cluster_creator_admin_permissions = true
  access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = []
      principal_arn     = data.aws_iam_instance_profile.bastion_role_arn.arn

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

  cluster_addons = {
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    # coreDNS 는 fargate 위에 올라가지 않으므로 설정이 필요함
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
  }


  # Fargate Profile(s)
  fargate_profiles = merge(
    {
      default = {
      name = "fargate-default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }
    kubesystem = {
        name = "fargate-kubesystem"
      selectors = [
        {
          namespace = "kube-system"
        }
      ]
    }
    },
    {
      for ns in var.namespace_names :
      "${ns}" =>
      {
        name      = "${ns}"
        selectors = [{ namespace = "${ns}" }]
        # labels    = var.namespace_labels  ### 라벨 어떻게 할건지
      }
    },
     
  )

  






}