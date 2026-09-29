variable "network_cidr" {
  description = "CIDR de la red"
  type        = string
  default     = "10.10.0.0/24"
}

variable "web_ip" {
  description = "IP del servidor web"
  type        = string
  default     = "10.10.0.10"
}

variable "app_ip" {
  description = "IP del servidor de aplicaciones"
  type        = string
  default     = "10.10.0.20"
}

variable "db_ip" {
  description = "IP del servidor de base de datos"
  type        = string
  default     = "10.10.0.30"
}
