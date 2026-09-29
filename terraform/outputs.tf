output "network_name" {
  description = "Nombre de la red Docker"
  value       = docker_network.infra_network.name
}

output "network_id" {
  description = "ID de la red Docker"
  value       = docker_network.infra_network.id
}

output "web_ip" {
  description = "IP del servidor web"
  value       = var.web_ip
}

output "app_ip" {
  description = "IP del servidor de aplicaciones"
  value       = var.app_ip
}

output "db_ip" {
  description = "IP del servidor de base de datos"
  value       = var.db_ip
}

output "web_url" {
  description = "URL del servidor web"
  value       = "http://localhost:8082"
}
