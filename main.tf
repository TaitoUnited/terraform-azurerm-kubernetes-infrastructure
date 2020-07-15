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
  nginx_ingress_version      = "1.26.2"
  cert_manager_version       = "0.11.0"
  socat_tunneler_version     = "0.1.0"

  authorizedNetworks = [
    for net in try(var.variables.authorizedNetworks, []):
    net.cidr
  ]

  owners = try(
    var.variables.owners != null ? var.variables.owners : [], []
  )

  /* TODO
  editors = try(
    var.variables.editors != null ? var.variables.editors : [], []
  )
  */

  /* TODO
  viewers = try(
    var.variables.viewers != null ? var.variables.viewers : [], []
  )
  */

  developers = try(
    var.variables.developers != null ? var.variables.developers : [], []
  )

  /* TODO
  externals = try(
    var.variables.externals != null ? var.variables.externals : [], []
  )
  */

  kubernetes = var.variables.kubernetes

  nodePools = try(
    var.variables.kubernetes.nodePools != null
    ? var.variables.kubernetes.nodePools
    : [],
    []
  )

  nginxIngressControllers = try(
    var.variables.kubernetes.nginxIngressControllers != null
    ? var.variables.kubernetes.nginxIngressControllers
    : [],
    []
  )

  postgresClusters = try(
    var.variables.postgresClusters != null
    ? var.variables.postgresClusters
    : [],
    []
  )

  mysqlClusters = try(
    var.variables.mysqlClusters != null
    ? var.variables.mysqlClusters
    : [],
    []
  )

}
