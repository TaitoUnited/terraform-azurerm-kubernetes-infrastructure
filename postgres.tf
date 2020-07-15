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

resource "random_string" "postgresql_admin_password" {
  count               = length(local.postgresClusters)

  length  = 32
  special = false
  upper   = true

  keepers = {
    username = local.postgresClusters[count.index].adminUsername
  }
}

resource "azurerm_postgresql_server" "pg" {
  count               = length(local.postgresClusters)

  name                = local.postgresClusters[count.index].name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku {
    name     = local.postgresClusters[count.index].skuName
    capacity = local.postgresClusters[count.index].skuCapacity
    tier     = local.postgresClusters[count.index].skuTiers
    family   = local.postgresClusters[count.index].skuFamily
  }

  storage_profile {
    storage_mb            = local.postgresClusters[count.index].storageSize
    backup_retention_days = local.postgresClusters[count.index].backupRetentionDays
    geo_redundant_backup  = local.postgresClusters[count.index].geoRedundantBackupEnabled ? "Enabled" : "Disabled"
    auto_grow             = local.postgresClusters[count.index].autoGrowEnabled ? "Enabled" : "Disabled"
  }

  administrator_login          = local.postgresClusters[count.index].adminUsername
  administrator_login_password = random_string.postgresql_admin_password[count.index].result
  version                      = local.postgresClusters[count.index].version
  ssl_enforcement              = "Enabled"

  lifecycle {
    prevent_destroy = true
  }
}

/* TODO: Open postgres firewall also for some external addresses
resource "azurerm_sql_firewall_rule" "postgres_external_access" {
  count               = local.kubernetes.name != "" ? length(local.postgresClusters) : 0
  name                = "postgres-external-access"
  resource_group_name = var.resource_group_name

  server_name         = azurerm_postgresql_server.pg[count.index].name
  start_ip_address    = var.something
  end_ip_address      = var.something
}
*/

resource "azurerm_postgresql_virtual_network_rule" "pg" {
  count                                = length(local.postgresClusters)

  name                                 = "${azurerm_postgresql_server.pg[count.index].name}-vnet-rule"
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.pg[count.index].name
  subnet_id                            = var.postgres_subnet_id
  ignore_missing_vnet_service_endpoint = true
}
