# ── Postgres Container App ─────────────────────────────────────────────────────
# Internal TCP transport — accessible by backend via "postgres:5432"

resource "azurerm_container_app" "postgres" {
  name                         = "postgres"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.managed_identity.id]
  }

  registry {
    server   = data.azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.managed_identity.id
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "postgres"
      image  = "${data.azurerm_container_registry.acr.login_server}/team4-postgres:${var.postgres_image_tag}"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "POSTGRES_USER"
        value = var.postgres_user
      }

      env {
        name        = "POSTGRES_PASSWORD"
        secret_name = "postgres-password"
      }

      env {
        name  = "POSTGRES_DB"
        value = var.postgres_db
      }
    }
  }

  secret {
    name                = "postgres-password"
    key_vault_secret_id = data.azurerm_key_vault_secret.postgres_password.versionless_id
    identity            = azurerm_user_assigned_identity.managed_identity.id
  }

  ingress {
    external_enabled = false
    target_port      = 5432
    transport        = "tcp"
    exposed_port     = 5432

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    team        = "team4"
  }

  depends_on = [
    azurerm_role_assignment.identity_acr_pull,
    azurerm_role_assignment.identity_kv_secrets_user,
  ]
}

# ── Backend Container App ──────────────────────────────────────────────────────
# Internal only — frontend reaches it via its internal FQDN within the environment.

resource "azurerm_container_app" "backend" {
  name                         = "ca-backend-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.managed_identity.id]
  }

  registry {
    server   = data.azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.managed_identity.id
  }

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = "backend"
      image  = "${data.azurerm_container_registry.acr.login_server}/team4-back-app-cameron:${var.backend_image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name        = "DATABASE_URL"
        secret_name = "database-url"
      }

      env {
        name  = "SCHEMA_NAME"
        value = var.schema_name
      }

      env {
        name        = "JWT_SECRET"
        secret_name = "jwt-secret"
      }

      env {
        name  = "CORS_ORIGIN"
        value = var.cors_origin != "" ? var.cors_origin : "https://ca-frontend-${var.environment}.${azurerm_container_app_environment.cae.default_domain}"
      }

      env {
        name  = "PORT"
        value = tostring(var.backend_port)
      }

      env {
        name  = "AWS_REGION"
        value = var.aws_region
      }

      env {
        name        = "AWS_ACCESS_KEY_ID"
        secret_name = "aws-access-key-id"
      }

      env {
        name        = "AWS_SECRET_ACCESS_KEY"
        secret_name = "aws-secret-access-key"
      }

      env {
        name  = "S3_BUCKET_NAME"
        value = var.s3_bucket_name
      }
    }
  }

  secret {
    name                = "database-url"
    key_vault_secret_id = data.azurerm_key_vault_secret.database_url.versionless_id
    identity            = azurerm_user_assigned_identity.managed_identity.id
  }

  secret {
    name                = "jwt-secret"
    key_vault_secret_id = data.azurerm_key_vault_secret.jwt_secret.versionless_id
    identity            = azurerm_user_assigned_identity.managed_identity.id
  }

  secret {
    name                = "aws-access-key-id"
    key_vault_secret_id = data.azurerm_key_vault_secret.aws_access_key_id.versionless_id
    identity            = azurerm_user_assigned_identity.managed_identity.id
  }

  secret {
    name                = "aws-secret-access-key"
    key_vault_secret_id = data.azurerm_key_vault_secret.aws_secret_access_key.versionless_id
    identity            = azurerm_user_assigned_identity.managed_identity.id
  }

  ingress {
    external_enabled = false
    target_port      = var.backend_port
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    team        = "team4"
  }

  depends_on = [
    azurerm_role_assignment.identity_acr_pull,
    azurerm_role_assignment.identity_kv_secrets_user,
    azurerm_container_app.postgres,
  ]
}

# ── Frontend Container App ─────────────────────────────────────────────────────
# Publicly accessible. Reaches backend via its internal FQDN.

resource "azurerm_container_app" "frontend" {
  name                         = "ca-frontend-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.managed_identity.id]
  }

  registry {
    server   = data.azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.managed_identity.id
  }

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = "frontend"
      image  = "${data.azurerm_container_registry.acr.login_server}/team4-front-app-cameron:${var.frontend_image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "API_BASE_URL"
        value = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
      }

      env {
        name  = "PORT"
        value = tostring(var.frontend_port)
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.frontend_port
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    team        = "team4"
  }

  depends_on = [
    azurerm_role_assignment.identity_acr_pull,
    azurerm_role_assignment.identity_kv_secrets_user,
  ]
}
