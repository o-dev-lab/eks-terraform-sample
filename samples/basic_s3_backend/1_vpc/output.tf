# output "azs" {
#   value = data.aws_availability_zones.azs.all_availability_zones
# }
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "eni_route_table_ids" {
  value = module.vpc.intra_route_table_ids
}

output "eks_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "eni_subnet_ids" {
  value = module.vpc.intra_subnets[0]
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "eni_security_group_id" {
  value = module.endpoint_sg.security_group_id
}

output "eks_cluster_security_group_id" {
  value = module.eks_cluster_sg.security_group_id
}










