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

/* Kubernetes: container registry pull permission */

resource "random_uuid" "kubernetes_acrpull_id" {
  count                = local.kubernetes.name != "" ? 1 : 0
  keepers = {
    acr_id  = azurerm_container_registry.acr.id
    sp_id   = azuread_service_principal.kubernetes[count.index].id
    role    = "AcrPull"
  }
}

resource "azurerm_role_assignment" "kubernetes_acrpull" {
  count                = local.kubernetes.name != "" ? 1 : 0

  principal_id         = azuread_service_principal.kubernetes[count.index].id
  name                 = random_uuid.kubernetes_acrpull_id[count.index].result
  scope                = azurerm_container_registry.acr.id
  # role_definition_id = data.azurerm_role_definition.acrpull.id
  role_definition_name = "AcrPull"
}

/* Owners: kubernetes admin permission */

resource "random_uuid" "owner_kubeadmin_id" {
  count                = local.kubernetes.name != "" ? length(local.owners) : 0
  keepers = {
    acr_id  = azurerm_container_registry.acr.id
    sp_id   = local.owners[count.index]
    role    = "Azure Kubernetes Service Cluster Admin Role"
  }
}

resource "azurerm_role_assignment" "owner_kubeadmin" {
  count                = local.kubernetes.name != "" ? length(local.owners) : 0

  principal_id         = local.owners[count.index]
  name                 = random_uuid.owner_kubeadmin_id[count.index].result
  scope                = azurerm_kubernetes_cluster.kubernetes[0].id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
}

/* Developers: kubernetes user permission */

resource "random_uuid" "developer_kubeuser_id" {
  count                = local.kubernetes.name != "" ? length(local.developers) : 0
  keepers = {
    acr_id  = azurerm_container_registry.acr.id
    sp_id   = local.developers[count.index]
    role    = "Azure Kubernetes Service Cluster User Role"
  }
}

resource "azurerm_role_assignment" "developer_kubeuser" {
  count                = local.kubernetes.name != "" ? length(local.developers) : 0

  principal_id         = local.developers[count.index]
  name                 = random_uuid.developer_kubeuser_id[count.index].result
  scope                = azurerm_kubernetes_cluster.kubernetes[0].id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
}
