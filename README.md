# NGINX Proxy Cache Web Server Demo

## Overview

This demo uses Terraform to automate the setup of an NGINX Proxy Cache Web Server pseudo-production environment.

A PDF containing accompanying slides for this demo can also be found under the name of [`Using NGINX as a Web Server and Reverse Proxy Cache 101`](Using%20NGINX%20as%20a%20Web%20Server%20and%20Reverse%20Proxy%20Cache%101.pdf).

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

### Step 1 -> Deploy a simple web server

To deploy:

`./deploy.sh 1`

To test:

`curl -s http://localhost`

Expected response:

```html
<!DOCTYPE html>
<html>
<center>
    <style>
        div {
            border: 15px solid;
        }
        .btn {
            color: #fff;
            background-color: #e74c3c;
            outline: none;
            border: 0;
            color: #fff;
            padding: 10px 20px;
            text-transform: uppercase;
            margin-top: 50px;
            border-radius: 10px;
            cursor: pointer;
            position: relative;
            width: 25%;
            height: 45px;
        }
    </style>
    <div>
        <h1> Welcome to the Grand Canyon!!! </h1><br>
        <img src="grand-canyon.jpg" alt="Grand Canyon"
            style="width:650px;height:400px;" />
    </div>
</center>
</html>
```

### Step 2 -> Deploy a simple reverse proxy

To deploy:

`./deploy.sh 2`

To test:

`curl -s http://localhost`

Expected response:

```html
<!DOCTYPE html>
<html>
<center>
    <style>
        div {
            border: 15px solid;
        }
        .btn {
            color: #fff;
            background-color: #e74c3c;
            outline: none;
            border: 0;
            color: #fff;
            padding: 10px 20px;
            text-transform: uppercase;
            margin-top: 50px;
            border-radius: 10px;
            cursor: pointer;
            position: relative;
            width: 25%;
            height: 45px;
        }
    </style>
    <div>
        <h1> Welcome to the Grand Canyon!!! (Server 1/2) </h1><br>
        <img src="grand-canyon.jpg" alt="Grand Canyon"
            style="width:650px;height:400px;" />
    </div>
</center>
</html>
```

### Step 3 -> Deploy a simple reverse proxy content cache

To deploy:

`./deploy.sh 3`

To test:

`curl -s http://localhost/api/7/http/caches | jq`

Expected response:

```json
{
  "my_cache": {
    "size": 618496,
    "cold": false,
    "hit": {
      "responses": 26,
      "bytes": 6681729
    },
    "stale": {
      "responses": 0,
      "bytes": 0
    },
    "updating": {
      "responses": 0,
      "bytes": 0
    },
    "revalidated": {
      "responses": 0,
      "bytes": 0
    },
    "miss": {
      "responses": 3,
      "bytes": 607799,
      "responses_written": 3,
      "bytes_written": 607799
    },
    "expired": {
      "responses": 0,
      "bytes": 0,
      "responses_written": 0,
      "bytes_written": 0
    },
    "bypass": {
      "responses": 0,
      "bytes": 0,
      "responses_written": 0,
      "bytes_written": 0
    }
  }
}
```

## Author Information

[Alessandro Fael Garcia](https://github.com/alessfg)

[Amir Rawdat](https://github.com/rawdata123)
