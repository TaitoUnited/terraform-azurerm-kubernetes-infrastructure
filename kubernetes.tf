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

resource "azuread_application" "kubernetes" {
  count                      = var.kubernetes_name != "" ? 1 : 0

  name                       = "${var.name}-${var.kubernetes_name}"
  identifier_uris            = ["http://${var.kubernetes_name}.${var.name}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource "azuread_service_principal" "kubernetes" {
  count   = var.kubernetes_name != "" ? 1 : 0

  application_id = azuread_application.kubernetes[count.index].application_id
  tags = ["aks", "kubernetes", "terraform", var.kubernetes_name, var.name]
}

resource "random_string" "kubernetes_password" {
  count   = var.kubernetes_name != "" ? 1 : 0

  length  = 32
  special = false
  upper   = true

  keepers = {
    service_principal = azuread_service_principal.kubernetes[count.index].id
  }
}

resource "azuread_service_principal_password" "kubernetes" {
  count                = var.kubernetes_name != "" ? 1 : 0

  service_principal_id = azuread_service_principal.kubernetes[count.index].id
  value                = random_string.kubernetes_password[count.index].result
  end_date_relative    = "8760h"  # one year
}

resource "azurerm_kubernetes_cluster" "kubernetes" {
  count   = var.kubernetes_name != "" ? 1 : 0

  name                = var.kubernetes_name
  dns_prefix          = var.kubernetes_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  api_server_authorized_ip_ranges = var.kubernetes_authorized_networks

  default_node_pool {
    name            = "default"
    vm_size         = var.kubernetes_node_size
    node_count      = var.kubernetes_node_count
    vnet_subnet_id  = var.kubernetes_subnet_id
  }

  service_principal {
    client_id     = azuread_application.kubernetes[count.index].application_id
    client_secret = azuread_service_principal_password.kubernetes[count.index].value
  }

  network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
  }

  tags = {
    zone = var.name
  }

  lifecycle {
    prevent_destroy = true
  }
}
