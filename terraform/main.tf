terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "infra_network" {
  name   = "infra-network"
  driver = "bridge"

  ipam_config {
    subnet  = var.network_cidr
    gateway = "10.10.0.1"
  }
}

resource "docker_container" "web" {
  name  = "infra-web"
  image = "nginx:alpine"

  networks_advanced {
    name         = docker_network.infra_network.name
    ipv4_address = var.web_ip
  }

  ports {
    internal = 80
    external = 8082
  }
}

resource "docker_container" "app" {
  name  = "infra-app"
  image = "httpd:alpine"

  networks_advanced {
    name         = docker_network.infra_network.name
    ipv4_address = var.app_ip
  }
}

resource "docker_container" "db" {
  name  = "infra-db"
  image = "mariadb:11"

  env = [
    "MARIADB_ROOT_PASSWORD=terraform123",
    "MARIADB_DATABASE=appdb"
  ]

  networks_advanced {
    name         = docker_network.infra_network.name
    ipv4_address = var.db_ip
  }
}
