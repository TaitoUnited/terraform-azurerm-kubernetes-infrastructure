/**
 * Copyright 2019 Taito United
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
  count               = length(var.postgres_instances)

  length  = 32
  special = false
  upper   = true

  keepers = {
    username = var.postgres_admins[count.index]
  }
}

resource "azurerm_postgresql_server" "pg" {
  count               = length(var.postgres_instances)

  name                = var.postgres_instances[count.index]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.postgres_sku_names[count.index]
    capacity = var.postgres_sku_capacities[count.index]
    tier     = var.postgres_sku_tiers[count.index]
    family   = var.postgres_sku_families[count.index]
  }

  storage_profile {
    storage_mb            = var.postgres_storage_sizes[count.index]
    backup_retention_days = var.postgres_backup_retention_days[count.index]
    geo_redundant_backup  = var.postgres_geo_redundant_backups[count.index]
    auto_grow             = var.postgres_auto_grows[count.index]
  }

  administrator_login          = var.postgres_admins[count.index]
  administrator_login_password = random_string.postgresql_admin_password[count.index].result
  version                      = var.postgres_versions[count.index]
  ssl_enforcement              = "Enabled"

  lifecycle {
    prevent_destroy = true
  }
}

/* TODO: Open postgres firewall also for some external addresses
resource "azurerm_sql_firewall_rule" "postgres_external_access" {
  count               = var.kubernetes_name != "" ? length(var.postgres_instances) : 0
  name                = "postgres-external-access"
  resource_group_name = var.resource_group_name

  server_name         = azurerm_postgresql_server.pg[count.index].name
  start_ip_address    = var.something
  end_ip_address      = var.something
}
*/

resource "azurerm_postgresql_virtual_network_rule" "pg" {
  count                                = length(var.postgres_instances)

  name                                 = "${azurerm_postgresql_server.pg[count.index].name}-vnet-rule"
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.pg[count.index].name
  subnet_id                            = var.postgres_subnet_id
  ignore_missing_vnet_service_endpoint = true
}
