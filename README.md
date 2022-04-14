# NGINX Proxy Cache Web Server Demo

## Overview

This demo uses Terraform to automate the setup of an NGINX Proxy Cache Web Server pseudo-production environment.

A PDF containing accompanying slides for this demo can also be found under the name of <TODO>.

## Requirements

### Terraform

This demo has been developed and tested with Terraform `0.13` through `1.1.5`.

Instructions on how to install Terraform can be found in the [Terraform website](https://www.terraform.io/downloads.html).

### NGINX Plus

You will need to download the NGINX Plus license to a known location. You can specify the location of the license in the corresponding Terraform variables.

## Deployment

To use the provided Terraform scripts, you need to:

1. Export your AWS credentials as environment variables (or alternatively, tweak the AWS provider in [`terraform/provider.tf`](terraform/provider.tf)).
2. Set up default values for variables missing a value in [`terraform/variables.tf`](terraform/variables.tf) (you can find example values commented out in the file). Alternatively, you can input those variables at runtime (beware of dictionary values if you do the latter).

Once you have configured your Terraform environment, you can either:

* Run [`./setup.sh`](setup.sh) to initialize the AWS Terraform provider and start a Terraform deployment on AWS.
* Run `terraform init` and `terraform apply`.

And finally, once you are done playing with the demo, you can destroy the AWS infrastructure by either:

* Run [`./cleanup.sh`](cleanup.sh) to destroy your Terraform deployment.
* Run `terraform destroy`.

## Demo Overview

You will find a series of NGINX configuration files in the [`nginx_proxy_cache_web_server_config`](nginx_proxy_cache_web_server_config/) folder. The folder is divided into individual steps, meant to be copied into their respective directory in order. By default, the folder is uploaded to your NGINX Plus instance.

A deployment script to help you copy the configuration files, [`deploy.sh`](nnginx_proxy_cache_web_server_config/deploy.sh), is also provided. To run the script, use the step number as a parameter, e.g. `./deploy.sh 1` for step 1. You might need to make the deployment script executable by running `sudo chmod +x deploy.sh`.

### Step 1 -> Deploy a simplified defaulf config file

To deploy:

`./deploy.sh 1`

To test:

`curl -s http://localhost:80`

Expected response:

```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

## Author Information

[Alessandro Fael Garcia](https://github.com/alessfg)
