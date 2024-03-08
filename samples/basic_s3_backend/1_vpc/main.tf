
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
  source = "../../../modules/vpc"

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




# # Endpoint


# module "endpoints" {
#   source = "../../../modules/vpc_endpoint"

#   vpc_id             = module.vpc.vpc_id
#   security_group_ids = [module.endpoint_sg.security_group_id]

#   endpoints = {
#     s3 = {
#       service_type = "Gateway"
#       service             = "s3"
#       route_table_ids     = module.vpc.private_route_table_ids
#       tags                = { Name = "s3-vpc-gw-endpoint" }
#     },
#     ec2 = {
#       service             = "ec2"
#       private_dns_enabled = true
#       subnet_ids          = [module.vpc.intra_subnets[0]]
#       tags                = { Name = "ec2-vpc-endpoint" }
#     },
#     ecr_api = {
#       service             = "ecr.api"
#       private_dns_enabled = true
#       subnet_ids          = [module.vpc.intra_subnets[0]]
#       tags                = { Name = "ecr.api-vpc-endpoint" }
#     },
#     ecr_dkr = {
#       service             = "ecr.dkr"
#       private_dns_enabled = true
#       subnet_ids          = [module.vpc.intra_subnets[0]]
#       tags                = { Name = "ecr.dkr-vpc-endpoint" }
#     }


#   }

# }



# # Security Group

# 공식 모듈의 복잡한 내용을 모두 포함할게 아니여서 만들어 둔 모듈 사용

module "eks_cluster_sg" {
  source = "../../../modules/sg"

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



# # vpc endpoint sg

# module "endpoint_sg" {
#   source = "../../../modules/sg"

#   name        = "${var.prefix}-eni-sg"
#   description = "Security group for vpc endpoint"
#   vpc_id      = module.vpc.vpc_id

#   ingress_lists = {
#     vpc_cidr = {
#       description = "vpc_cidr"
#       cidr_blocks = [var.vpc_cidr]
#     }
#     eks_cluster = {
#       description = "eks cluster sg"
#       from_port = 443
#       to_port = 443
#       protocol = "tcp"
#       source_security_group_id = module.eks_cluster_sg.security_group_id
#     }


#   }

#   egress_lists = {
#     egress = {
#       description = "all"
#       cidr_blocks = ["0.0.0.0/0"]
#     }

#   }

# }

module "bastion_sg" {
  source = "../../../modules/sg"

  name        = "${var.prefix}-bastion-sg"
  description = "Security group for bastion"
  vpc_id      = module.vpc.vpc_id

  ingress_lists = {
    vpc_cidr = {
      description = "vpc_cidr"
      cidr_blocks = [var.vpc_cidr]
    }
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
