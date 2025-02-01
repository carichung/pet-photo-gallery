# main.tf
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Create a VPC
resource "google_compute_network" "vpc" {
  name                    = "pet-photo-gallery-vpc"
  auto_create_subnetworks = false
}

# Create Subnets
resource "google_compute_subnetwork" "private" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc.name
}

resource "google_compute_subnetwork" "public" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.101.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc.name
}

# Create a GKE Cluster
resource "google_container_cluster" "gke" {
  name     = "pet-photo-gallery-gke"
  location = var.gcp_region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.private.name
}

resource "google_container_node_pool" "nodes" {
  name       = "pet-photo-gallery-node-pool"
  location   = var.gcp_region
  cluster    = google_container_cluster.gke.name
  node_count = 2

  node_config {
    machine_type = "e2-medium"
  }
}

# Create a Cloud SQL MySQL instance
resource "google_sql_database_instance" "mysql" {
  name             = "pet-photo-gallery-mysql"
  database_version = "MYSQL_8_0"
  region           = var.gcp_region

  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = "pet_photo_gallery"
  instance = google_sql_database_instance.mysql.name
}

resource "google_sql_user" "user" {
  name     = var.db_username
  instance = google_sql_database_instance.mysql.name
  password = var.db_password
}

# Output the GKE cluster name and MySQL endpoint
output "gke_cluster_name" {
  value = google_container_cluster.gke.name
}

output "mysql_endpoint" {
  value = google_sql_database_instance.mysql.connection_name
}
