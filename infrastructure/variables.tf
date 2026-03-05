variable "resource_group_name" {
  description = "Name of the existing Azure resource group"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod) — used in resource naming"
  type        = string
  default     = "dev"
}

variable "aad_group_object_id" {
  description = "Object ID of the Azure AD group whose members get Key Vault Secrets Officer access"
  type        = string
}

variable "sku_name" {
  description = "SKU tier for the Key Vault (standard or premium)"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be either 'standard' or 'premium'."
  }
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted vaults (7–90)"
  type        = number
  default     = 7
}
