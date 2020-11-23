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

provider "azurerm" {
}

provider "helm" {
  install_tiller = false
  max_history    = 20
  kubernetes {
    config_context = var.kubernetes_context != "" ? var.kubernetes_context : var.name
  }
}

locals {
  ingress_nginx_version      = "1.26.2"
  cert_manager_version       = "0.11.0"
  socat_tunneler_version     = "0.1.0"

  authorizedNetworks = [
    for net in try(var.resources.authorizedNetworks, []):
    net.cidr
  ]

  owners = try(
    var.resources.owners != null ? var.resources.owners : [], []
  )

  /* TODO
  editors = try(
    var.resources.editors != null ? var.resources.editors : [], []
  )
  */

  /* TODO
  viewers = try(
    var.resources.viewers != null ? var.resources.viewers : [], []
  )
  */

  developers = try(
    var.resources.developers != null ? var.resources.developers : [], []
  )

  /* TODO
  externals = try(
    var.resources.externals != null ? var.resources.externals : [], []
  )
  */

  kubernetes = var.resources.kubernetes

  nodePools = try(
    var.resources.kubernetes.nodePools != null
    ? var.resources.kubernetes.nodePools
    : [],
    []
  )

  ingressNginxControllers = try(
    var.resources.kubernetes.ingressNginxControllers != null
    ? var.resources.kubernetes.ingressNginxControllers
    : [],
    []
  )

  postgresClusters = try(
    var.resources.postgresClusters != null
    ? var.resources.postgresClusters
    : [],
    []
  )

  mysqlClusters = try(
    var.resources.mysqlClusters != null
    ? var.resources.mysqlClusters
    : [],
    []
  )

}
