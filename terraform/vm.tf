# NGINX instance
resource "aws_instance" "nginx" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.nginx_machine_type
  key_name      = var.key_data["name"]
  vpc_security_group_ids = [
    aws_security_group.nginx.id,
  ]
  subnet_id = aws_subnet.main.id
  user_data = <<EOF
#!/bin/sh
set -ex
apt update
apt install -y apt-transport-https ca-certificates lsb-release
mkdir /etc/ssl/nginx
cat > /etc/ssl/nginx/nginx-repo.crt << EOL
${file(var.nginx_plus_license["cert"])}
EOL
cat > /etc/ssl/nginx/nginx-repo.key << EOL
${file(var.nginx_plus_license["key"])}
EOL
wget https://cs.nginx.com/static/keys/nginx_signing.key
apt-key add nginx_signing.key
printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
apt update
apt install -y nginx-plus jq
service nginx start
EOF
  tags = {
    Name  = "nginx",
    Owner = var.owner,
    user  = "ubuntu",
  }
}

# Enable SSL on the NGINX instance
resource "null_resource" "tweak_nginx_config" {
  count = var.certbot ? 1 : 0
  provisioner "remote-exec" {
    inline = [
      "set -ex",
      "while [ ! -f /etc/nginx/nginx.conf ]; do sleep 5; done",
      "sudo snap install core",
      "sudo snap refresh core",
      "sudo snap install --classic certbot",
      "sudo ln -s /certbot /usr/bin/certbot",
      "sudo certbot --nginx --redirect --agree-tos --register-unsafely-without-email -d ${aws_instance.nginx.public_dns}",
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_data["location"])
    host        = aws_instance.nginx.public_ip
  }
  depends_on = [
    aws_instance.nginx,
  ]
}

# Upload NGINX configuration files to NGINX instance
resource "null_resource" "upload_nginx_proxy_cache_web_server_config_files" {
  count = var.upload_nginx_proxy_cache_web_server_config_files ? 1 : 0
  provisioner "remote-exec" {
    inline = [
      "set -ex",
      "while [ ! -f /etc/nginx/nginx.conf ]; do sleep 5; done",
    ]
  }
  provisioner "file" {
    source      = "../nginx_proxy_cache_web_server_config"
    destination = "/home/ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "set -ex",
      "sudo chmod +x /home/ubuntu/nginx_proxy_cache_web_server_config/deploy.sh",
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_data["location"])
    host        = aws_instance.nginx.public_ip
  }
  depends_on = [
    aws_instance.nginx,
  ]
}
