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

resource "azurerm_application_insights" "insights" {
  name                = var.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

/* TODO: slack webhook support */
resource "azurerm_monitor_action_group" "email" {
  name                = "${var.name}-email"
  resource_group_name = var.resource_group_name
  short_name          = "email"

  email_receiver {
    name          = "sendtodevops"
    email_address = var.email
  }
}

resource "azurerm_monitor_metric_alert" "uptimez_alert" {
  name                = "${var.name}-uptimez-alert"
  resource_group_name = var.resource_group_name
  scopes              = [ azurerm_application_insights.insights.id ]
  auto_mitigate       = true
  frequency           = "PT1M"
  window_size         = "PT30M"
  criteria {
    metric_namespace  = "Microsoft.Insights/Components"
    metric_name       = "availabilityResults/availabilityPercentage"
    aggregation       = "Average"
    operator          = "LessThan"
    threshold         = 1
    dimension {
      name = "availabilityResult/location"
      operator = "Include"
      values = ["*"]
    }
  }
  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
  severity = 1
}
