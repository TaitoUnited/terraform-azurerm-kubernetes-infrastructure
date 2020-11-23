# Kubernetes infrastructure for Azure

Kubernetes infrastructure module designed to get you up and running in no time. Provides all the necessary components for running your projects: Kubernetes, NGINX ingress, cert-manager, container registry, databases, database proxies, networking, monitoring, and permissions. Use it either as a module, or as an example for your own customized infrastructure.

This module is used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). See the [azure template](https://github.com/TaitoUnited/taito-templates/tree/master/infrastructure/azure/terraform) as an example on how to use this module.

Example YAML for variables:

```
owners:
  - user:john.admin@mydomain.com
developers:
  - user:john.developer@mydomain.com

kubernetes:
  name: zone1-common-kube
  context: zone1
  releaseChannel: STABLE
  rbacSecurityGroup:
  privateNodesEnabled: true
  shieldedNodesEnabled: true
  networkPolicyEnabled: false
  dbEncryptionEnabled: false
  podSecurityPolicyEnabled: false # NOTE: not supported yet
  istioEnabled: false
  cloudEnabled: false
  # zones: # NOTE: Provide zones only if kubernes is ZONAL instead of REGIONAL
  # NOTE: Also CI/CD requires access if CI/CD is used for automatic deployment
  masterAuthorizedNetworks:
    - 0.0.0.0/0
  nodePools:
    - name: pool-1
      machineType: Standard_DS1_v2
      diskSizeGb: 100
      minNodeCount: 2
      maxNodeCount: 2
  ingressNginxControllers:
    - class: nginx
      replicas: 2

postgresClusters:
  - name: zone1-common-postgres
    version: 11
    # See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory
    skuTier: GeneralPurpose
    skuFamily: Gen5
    skuName: GP_Gen5_2 # name=TIER_FAMILY_CORES
    skuCapacity: 2
    nodeCount: 1
    storageSize: 10240 # Megabytes
    autoGrowEnabled: true
    backupRetentionDays: 7
    geoRedundantBackupEnabled: false
    adminUsername: admin
    # TODO: support for db users
    users:
      - username: john.doe
        read:
          - my-project-prod
        write:
          - another-project-prod
```
