variable "database_password" {
    default = ""
}

variable "admin_password" {
    description = "This is the password you will use to log into ERPNext once it is installed."
}

variable "domain" {
    default = ""
}

variable "webmaster_email" {
    default = ""
}

resource "random_password" "database_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}


resource "digitalocean_droplet" "www-erpnext" {
  #This has pre installed docker
  image = "docker-20-04"
  name = "www-erpnext"
  region = "nyc3"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    digitalocean_ssh_key.terraform.id
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = var.pvt_key != "" ? file(var.pvt_key) : tls_private_key.pk.private_key_pem
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # create erpnext installation directory
      "mkdir /root/erpnext",
    ]
  }

  provisioner "file" {
    source      = "docker-compose.yml.tpl"
    destination = "/root/erpnext/docker-compose.yml"
  }

  provisioner "file" {
    content      = templatefile("env-production.tpl", {
      admin_password = var.admin_password,
      webmaster_email = var.webmaster_email != "" ? var.webmaster_email : "email@example.com",
      server_name = var.domain != "" ? var.domain : "0.0.0.0",
      database_password = var.database_password != "" ? var.database_password : random_password.database_password.result
    })
    destination = "/root/erpnext/.env"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # run compose
      "cd /root/erpnext",
      "ufw allow http",
      "ufw allow https",
      "docker-compose up -d",
    ]
  }
}