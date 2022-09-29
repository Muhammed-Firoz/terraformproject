# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure<br>

## Introduction<br>
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.<br>

## Getting Started<br>
1. Clone this repository<br>

2. Create your infrastructure as code<br>

3. Update this README to reflect how someone would use your code.<br>

## Dependencies<br>
1. Create an [Azure Account](https://portal.azure.com) <br>
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)<br>
3. Install [Packer](https://www.packer.io/downloads)<br>
4. Install [Terraform](https://www.terraform.io/downloads.html)<br>

## Instructions<br>

This project contain a packer template, terraform template for creating virtual machines.

### Packer template<br>


this packer template create a server image  with Linux OS (Ubuntu 18.04-LTS). <br>

**How to use the packer template to create an image**

1.Clone this repository.<br>
2.Set the working directory to where the template is.<br>
3.Run the command *packer build server.json* to create the image.<br>
4.Run the command *az image list* to see the image created.<br>

### Terraform template<br>


Terraform template is mainly making Virtual Machines and associated resources.<br> in terraform template/module, there is 3 files <main.tf>, <vars.tf>, <solution.plan>.<br>
<main.tf> is the main script which describes the resources to be created.<br> <vars.tf> file contains the variables that used in <main.tf> script.<br>You can change the variable values by changing default values for each variable in the <vars.tf>.<br> <solution.plan> is the file where terraform plan is saved for creating 2 VMs.<br>

**How to use the terraform template to create an image**

1.Clone this repository.<br>
2.Set the working directory to where the template is.<br>
3.Run the command *terraform init* to get started.<br>
4.Run the command *terraform plan*, if you want to save the plan add sub command *-out <filename>*.<br>
5.Run the command *terraform apply*, if the plan is saved in a file then run *terraform apply <filename>*.<br>
6.To see the deployed resources run *terraform show*.<br>
7.You can destroy the resources created by terraform using the command *terraform destroy*.<br>


### Output<br>

We can check the output of these codes by running following commands<br>
*az image list* to see the output produced by packer.<br>
*terraform show* to see the output produced by terraform.<br>
