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

/* Labeling */

variable "name" {
  type = string
  description = "Name that groups all the created resources together. Preferably globally unique to avoid naming conflicts."
}

/* Azure provider */

variable "resource_group_name" {
  type = string
  description = "Azure resource group name that groups all the created resources together. Preferably globally unique to avoid naming conflicts."
}

variable "resource_group_location" {
  type = string
  description = "Azure resource group location."
}

/* Users */

variable "owners" {
  type = list(string)
  default = []
  description = "IDs of owners (e.g. [ \"1234567a-123b-123c-123d-1e2345a6c7e8\" ])."
}

variable "developers" {
  type = list(string)
  default = []
  description = "IDs of developers (e.g. [ \"1234567a-123b-123c-123d-1e2345a6c7e8\" ])."
}

/* Settings */

variable "email" {
  type        = string
  description = "Email address for DevOps support."
}

/* Buckets */

variable "state_bucket" {
  type        = string
  description = "Name of storage bucket used for storing remote Terraform state."
}

variable "projects_bucket" {
  type         = string
  default     = ""
  description = "Name of storage bucket used for storing function packages, etc."
}

# TODO: assets_bucket

/* Helm */

variable "helm_enabled" {
  type        = bool
  default     = "false"
  description = "Installs helm apps if set to true. Should be set to true only after Kubernetes cluster already exists."
}

variable "helm_nginx_ingress_classes" {
  type        = list(string)
  default     = []
  description = "NGINX ingress class for each NGINX ingress installation. Provide multiple if you want to install multiple NGINX ingresses."
}

variable "helm_nginx_ingress_replica_counts" {
  type        = list(string)
  default     = []
  description = "Replica count for each NGINX ingress installation. Provide multiple if you want to install multiple NGINX ingresses."
}

/* Kubernetes */

variable "kubernetes_name" {
  type        = string
  description = "Name for the Kubernetes cluster."
}

variable "kubernetes_context" {
  type        = string
  default     = ""
  description = "Kubernetes context. Value of var.name is used by default."
}

variable "kubernetes_authorized_networks" {
  type = list(string)
  description = "CIDRs that are authorized to access the Kubernetes master API."
}

variable "kubernetes_node_size" {
  type        = string
  description = "Size for Kubernetes nodes."
}

variable "kubernetes_node_count" {
  type        = number
  description = "Number of Kubernetes nodes."
}

variable "kubernetes_subnet_id" {
  type        = string
  description = "Subnet id for Kubernetes."
}

/* Postgres */

variable "postgres_subnet_id" {
  type        = string
  description = "Subnet id for PostgreSQL clusters."
}

variable "postgres_instances" {
  type    = list(string)
  default = []
  description = "Name for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_admins" {
  type    = list(string)
  default = []
  description = "Admin username for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_versions" {
  type    = list(string)
  default = []
  description = "Version for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_sku_names" {
  type    = list(string)
  default = []
  description = "SKU name for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters. See See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory"
}
variable "postgres_sku_capacities" {
  type    = list(number)
  default = []
  description = "SKU capability for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters. See See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory"
}
variable "postgres_sku_tiers" {
  type    = list(string)
  default = []
  description = "SKU tier for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters. See See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory"
}
variable "postgres_sku_families" {
  type    = list(string)
  default = []
  description = "SKU family for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters. See See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory"
}

variable "postgres_node_counts" {
  type    = list(number)
  default = []
  description = "Number of nodes for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_storage_sizes" {
  type    = list(number)
  default = []
  description = "Storage size for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_auto_grows" {
  type    = list(string)
  default = []
  description = "Auto grow Enabled/Disabled for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_backup_retention_days" {
  type    = list(number)
  default = []
  description = "Backup retention days for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

variable "postgres_geo_redundant_backups" {
  type    = list(string)
  default = []
  description = "Geo redundant backup Enabled/Disabled for each PostgreSQL cluster. Provide multiple if you require multiple PostgreSQL clusters."
}

/* TODO: MySQL */
