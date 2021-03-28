# Kubernetes infrastructure for Azure

THIS MODULE HAS BEEN DEPRECATED IN FAVOR OF:

- [Admin](https://registry.terraform.io/modules/TaitoUnited/admin/azurerm)
- [DNS](https://registry.terraform.io/modules/TaitoUnited/dns/azurerm)
- [Network](https://registry.terraform.io/modules/TaitoUnited/network/azurerm)
- [Compute](https://registry.terraform.io/modules/TaitoUnited/compute/azurerm)
- [Kubernetes](https://registry.terraform.io/modules/TaitoUnited/kubernetes/azurerm)
- [Databases](https://registry.terraform.io/modules/TaitoUnited/databases/azurerm)
- [Storage](https://registry.terraform.io/modules/TaitoUnited/storage/azurerm)
- [Monitoring](https://registry.terraform.io/modules/TaitoUnited/monitoring/azurerm)
- [Integrations](https://registry.terraform.io/modules/TaitoUnited/integrations/azurerm)
- [PostgreSQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/postgresql)
- [MySQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/mysql)

---

Kubernetes infrastructure module designed to get you up and running in no time. Provides all the necessary components for running your projects: Kubernetes, NGINX ingress, cert-manager, container registry, databases, database proxies, networking, monitoring, and permissions. Use it either as a module, or as an example for your own customized infrastructure.

This module is used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). See the [azure template](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/azure/terraform) as an example on how to use this module.
