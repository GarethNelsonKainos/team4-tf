terraform {
  required_version = ">= 1.5.0"

  # NOTE: No backend block here — this folder bootstraps the storage account
  # that all OTHER folders will use as their remote backend.
  # Its own state is intentionally kept local and should be committed to the repo.

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}
