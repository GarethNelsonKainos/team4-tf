variable "acr_name" {
  description = "Name of the existing Azure Container Registry"
  type        = string
  default     = "academyacrj3r5dv"
}

variable "acr_resource_group_name" {
  description = "Resource group the ACR lives in"
  type        = string
  default     = "rg-academy-acr"
}

variable "kv_suffix" {
  description = "Suffix for the Key Vault name — set to the existing value to prevent recreation"
  type        = string
  default     = "la0hde"
}

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

# ---- Container App variables ----

variable "backend_image_tag" {
  description = "Image tag for the backend container (e.g. git SHA)"
  type        = string
  default     = "latest"
}

variable "frontend_image_tag" {
  description = "Image tag for the frontend container (e.g. git SHA)"
  type        = string
  default     = "latest"
}

variable "postgres_image_tag" {
  description = "Image tag for the postgres container (e.g. git SHA)"
  type        = string
  default     = "latest"
}

variable "backend_port" {
  description = "Port the backend app listens on"
  type        = number
  default     = 8080
}

variable "frontend_port" {
  description = "Port the frontend app listens on"
  type        = number
  default     = 3000
}

variable "postgres_user" {
  description = "PostgreSQL admin username"
  type        = string
  default     = "postgres"
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "team4db"
}

variable "schema_name" {
  description = "Database schema name used by the backend"
  type        = string
  default     = "public"
}

variable "cors_origin" {
  description = "Allowed CORS origin for the backend. Leave empty to auto-derive from frontend URL."
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region for S3"
  type        = string
  default     = "eu-west-1"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for file uploads"
  type        = string
  default     = ""
}
