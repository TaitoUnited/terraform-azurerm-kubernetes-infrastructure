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

/* Helm */

variable "helm_enabled" {
  type        = bool
  default     = "false"
  description = "Installs helm apps if set to true. Should be set to true only after Kubernetes cluster already exists."
}

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

variable "public_bucket" {
  type         = string
  default     = ""
  description = "Name of storage bucket used for storing public assets, etc."
}

/* Kubernetes */

variable "kubernetes_subnet_id" {
  type        = string
  description = "Subnet id for Kubernetes."
}

/* Postgres */

variable "postgres_subnet_id" {
  type        = string
  description = "Subnet id for PostgreSQL clusters."
}

# Resources as a json/yaml

variable "resources" {
  type        = any
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}
