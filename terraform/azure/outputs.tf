# outputs.tf
output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "mysql_endpoint" {
  description = "The endpoint of the MySQL database"
  value       = azurerm_mysql_server.mysql.fqdn
}
