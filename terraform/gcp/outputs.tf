# outputs.tf
output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.gke.name
}

output "mysql_endpoint" {
  description = "The connection name of the MySQL database"
  value       = google_sql_database_instance.mysql.connection_name
}
