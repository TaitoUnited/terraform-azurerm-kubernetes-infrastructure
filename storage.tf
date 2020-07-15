/**
 * Copyright 2020 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "azurerm_storage_account" "zone" {
  name                     = replace(var.name, "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "state" {
  count                 = var.state_bucket != "" ? 1 : 0
  name                  = var.state_bucket
  storage_account_name  = azurerm_storage_account.zone.name
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "projects" {
  count                 = var.projects_bucket != "" ? 1 : 0
  name                  = var.projects_bucket
  storage_account_name  = azurerm_storage_account.zone.name
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "public" {
  count                 = var.public_bucket != "" ? 1 : 0
  name                  = var.public_bucket
  storage_account_name  = azurerm_storage_account.zone.name
  container_access_type = "blob"

  cors_rule {
    allowed_origins = [ "*" ]
    allowed_methods = ["GET", "HEAD"]
  }

  lifecycle {
    prevent_destroy = true
  }
}
