variable "region" {
  description = "Your target AWS region"
  default     = "us-west-1"
  type        = string
}

variable "owner" {
  description = "Owner of resources"
  # default     = "johndoe"
  type        = string
}

variable "key_data" {
  description = "The key used to ssh into your AWS instance"
  # default = {
  #   name     = "johndoe"
  #   location = "~/.ssh/johndoe.pem"
  # }
  type = map(string)
}

variable "nginx_machine_type" {
  description = "The AWS machine type for the NGINX instance"
  default     = "t2.medium"
  type        = string
}

variable "certbot" {
  description = "Use certbot to automate cert generation for the NGINX instance"
  default     = false
  type        = bool
}

variable "nginx_plus_license" {
  description = "Location of NGINX Plus license to be used in the NGINX instance"
  # default = {
  #   key  = "nginx_license/nginx-repo.key"
  #   cert = "nginx_license/nginx-repo.crt"
  # }
  type = map(string)
}

variable "upload_nginx_proxy_cache_web_server_config_files" {
  description = "Upload NGINX Proxy Cache Web Server files"
  default     = true
  type        = bool
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]
}
