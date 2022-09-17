# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

## Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

## Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

## Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

## Instructions

This project contain a packer template, terraform template for creating virtual machines.

### Packer template


this packer template create a server image  with Linux OS (Ubuntu 18.04-LTS). 

**How to use the packer template to create an image**

1.Clone this repository.
2.Set the working directory to where the template is.
3.Run the command *packer build server.json* to create the image.
4.Run the command *az image list* to see the image created.

### Terraform template


Terraform template is mainly making Virtual Machines and associated resources. in terraform template/module, there is 3 files <main.tf>, <vars.tf>, <solution.plan>.
<main.tf> is the main script which describes the resources to be created. <vars.tf> file contains the variables that used in <main.tf> script.You can change the variable values by changing default values for each variable in the <vars.tf>. <solution.plan> is the file where terraform plan is saved for creating 2 VMs.

**How to use the terraform template to create an image**

1.Clone this repository.
2.Set the working directory to where the template is.
3.Run the command *terraform init* to get started.
4.Run the command *terraform plan*, if you want to save the plan add sub command *-out <filename>*.
5.Run the command *terraform apply*, if the plan is saved in a file then run *terraform apply <filename>*.
6.To see the deployed resources run *terraform show*.
7.You can destroy the resources created by terraform using the command *terraform destroy*.


### Output

We can check the output of these codes by running following commands
*az image list* to see the output produced by packer.
*terraform show* to see the output produced by terraform.
