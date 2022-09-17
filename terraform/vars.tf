variable "packer_resource_group" {
  description = "Name of the resource group where the packer image is"
  default     =  "Azuredevops"
}

variable "prefix" {
  description = "The prefix which should be used for all resources"
  default     = "dend-project3"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources should be created."
  default     = "East US"
}

variable "username" {
  description = "The login name of the virtual machines."
  default     = "firozdendshell"
  type        = string
}

variable "password" {
  description = "The password of the virtual machines."
  default     = "Ecproject#3"
  type        = string
}

variable "num_vms" {
  description = "The number of VMs to create."
  default     = 3
  type        = number
}
