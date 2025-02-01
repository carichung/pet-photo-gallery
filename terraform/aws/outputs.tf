# outputs.tf
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS database"
  value       = module.rds.db_instance_endpoint
}
