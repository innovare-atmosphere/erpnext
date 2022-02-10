output "ip_address" {
  description = "IP Address of deployed server"
  value       = digitalocean_droplet.www-erpnext.ipv4_address
}

output "http_address" {
  description = "You can visit your installation at: "
  value       = "http://${var.domain != "" ? var.domain : digitalocean_droplet.www-erpnext.ipv4_address}/"
}

output "admin_password" {
  description = "Administrator password"
  value       = var.admin_password
  sensitive = true
}

output "admin_user" {
  description = "Administrator username"
  value       = "Administrator"
}