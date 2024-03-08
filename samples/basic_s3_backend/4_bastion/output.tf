output "cluster_id" {
  value = module.eks_cluster.cluster_id
}
# 놀랍게도 cluster_id 가 null 이 되면서 뽑히지 않는다. cluster_name 으로 대체하여 사용하도록 하자. 
# 참고 링크
# 1. https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/UPGRADE-19.0.md
# 2. https://github.com/hashicorp/terraform-provider-aws/issues/27560

output "cluster_oidc_issuer_url" {
  value = module.eks_cluster.cluster_oidc_issuer_url
}

output "cluster_name" {
    value = module.eks_cluster.cluster_name
}


output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks_cluster.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  value = module.eks_cluster.oidc_provider_arn
}

