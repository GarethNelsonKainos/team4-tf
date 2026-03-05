variable "resource_group_name" {
  description = "Name of the existing Azure resource group"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region (e.g. uksouth)"
  type        = string
  default     = "uksouth"
}
