# Private AKS Cluster Infrastructure

This directory contains Terraform code to provision a secure, private Azure Kubernetes Service (AKS) cluster with firewall-controlled egress traffic.

## Architecture Overview

- **Private AKS Cluster**: No public IP exposure, accessible only via private endpoint
- **Azure CNI Overlay Networking**: Private IP addressing with custom network policies
- **Azure Firewall**: Primary + Secondary (failover) with application-layer rules
- **Egress Control**: User-defined routes (UDRs) routing all outbound traffic through firewall
- **Multi-Zone Deployment**: 3 nodes distributed across availability zones 1, 2, 3
- **GDPR Compliance**: 90-day audit log retention, encryption at rest/transit
- **99.9% Uptime SLO**: Multi-zone redundancy with automatic node recovery

## Firewall Rules

The firewall enforces an allow-list policy permitting traffic only to:
- **Docker Registry**: `*.docker.io`
- **Ubuntu Repositories**: `*.ubuntu.com`
- **Microsoft Services**: AKS system updates (*.microsoft.com, *.msft.net)

All other egress traffic is blocked by default.

## Prerequisites

1. **Azure CLI**: Install and authenticate
   ```bash
   az login
   ```

2. **Terraform**: >= 1.14.0
   ```bash
   terraform version
   ```

3. **Resource Group**: Must exist before deployment
   ```bash
   az group create --name rg-001-private-aks-prod --location eastus
   ```

4. **Storage Account for State**: Backend configuration
   ```bash
   # Create storage account for Terraform state
   az storage account create \
     --name tfstate001prod \
     --resource-group rg-001-private-aks-prod \
     --location eastus \
     --sku Standard_LRS

   # Create blob container
   az storage container create \
     --name aks-cluster-state \
     --account-name tfstate001prod
   ```

## Project Structure

```
iac/
├── backend.tf              # Terraform state backend configuration
├── provider.tf             # Azure provider setup
├── versions.tf             # Terraform and provider versions
├── vpc.tf                  # VNet, subnets, NSGs, private endpoint
├── firewall.tf             # Azure Firewall, policies, UDRs
├── aks.tf                  # AKS cluster, node pool, diagnostics
├── iam.tf                  # Key Vault, managed identity, role assignments
├── monitoring.tf           # Log Analytics, storage, alerts
├── data.tf                 # Data sources (resource group, client config)
├── variables.tf            # Input variable declarations
├── locals.tf               # Local values and naming conventions
├── outputs.tf              # Output declarations
├── terraform.tfvars.prod   # Production variables
└── README.md               # This file
```

## Deployment

### Step 1: Initialize Terraform

```bash
cd iac/

terraform init \
  -backend-config="resource_group_name=rg-001-private-aks-prod" \
  -backend-config="storage_account_name=tfstate001prod" \
  -backend-config="container_name=aks-cluster-state" \
  -backend-config="key=aks-001-prod.tfstate" \
  -backend-config="use_azuread_auth=true"
```

### Step 2: Review Plan

```bash
terraform plan -var-file=terraform.tfvars.prod -out=plan.tfplan
```

Review the output to understand what resources will be created:
- 1 Virtual Network (10.0.0.0/16)
- 4 Subnets (control plane, nodes, firewall, private endpoint)
- 3 Network Security Groups with rules
- 2 Azure Firewalls (primary + secondary for HA)
- 1 Firewall Policy with application rules
- 1 AKS Cluster (3 nodes across 3 AZs)
- 1 Key Vault
- 1 Log Analytics Workspace
- 1 Storage Account for firewall logs
- Multiple diagnostic settings and alerts

### Step 3: Deploy Infrastructure

```bash
terraform apply plan.tfplan
```

**Expected deployment time**: 20-30 minutes (AKS cluster creation is the longest step)

## Post-Deployment

### Access the Cluster

The cluster is private and accessible only via the private endpoint. To access kubectl:

```bash
# Get kubeconfig
az aks get-credentials \
  --name aks-001-private-aks-prod \
  --resource-group rg-001-private-aks-prod \
  --overwrite-existing

# Verify cluster access
kubectl get nodes

# Expected output: 3 nodes across AZs 1, 2, 3
# NAME                                STATUS   ROLES   AGE   VERSION
# aks-systempool-12345678-vmss000001  Ready    agent   5m    v1.28.x
# aks-systempool-12345678-vmss000002  Ready    agent   5m    v1.28.x
# aks-systempool-12345678-vmss000003  Ready    agent   5m    v1.28.x
```

### Verify Private Endpoint Connectivity

```bash
# Check private endpoint is configured
az network private-endpoint show \
  --name 001-pep-aks-cp-prod \
  --resource-group rg-001-private-aks-prod
```

### Test Firewall Egress Rules

```bash
# Deploy test pod to verify registry access
kubectl run test-pod --image=alpine:latest -- sleep 3600

# Verify pod pulls image (should succeed - docker.io allowed)
kubectl logs test-pod

# Deploy pod and test ubuntu.com access
kubectl run test-apt --image=ubuntu:22.04 -- bash -c "apt-get update && sleep 3600"
```

### Monitor Cluster & Firewall

Access monitoring in Azure Portal:
- **Log Analytics Workspace**: Search for "oms-001-private-aks-prod"
- **Metrics**: Monitor > Metrics, select AKS cluster resource
- **Firewall Logs**: Storage account > Containers > firewall-logs

### Key Queries for Log Analytics

```kusto
# Firewall denied connections (non-whitelisted traffic)
AzureDiagnostics
| where Category == "AzureFirewallNetworkRule" and Action_s == "Deny"
| summarize count() by DestinationIp, DestinationPort

# Allowed connections (docker.io, ubuntu.com)
AzureDiagnostics
| where Category == "AzureFirewallApplicationRule" and Action_s == "Allow"
| summarize count() by TargetFqdn

# Cluster health
KubePodInventory
| where TimeGenerated > ago(5m)
| summarize ready_pods = countif(PodStatus == "Running") by ClusterName
```

## Configuration

### Modify Variables

Edit `terraform.tfvars.prod` to customize:
- Number of nodes: `aks_node_count` (default: 3)
- VM size: `aks_vm_size` (default: Standard_D4s_v5)
- Log retention: `log_analytics_retention_days` (default: 90, GDPR minimum)
- Firewall SKU: `firewall_sku_tier` (Standard or Premium, default: Premium)
- Availability Zones: `availability_zones` (default: ["1", "2", "3"])

### Scale Cluster (Manual)

```bash
# Scale to 5 nodes (update variables)
terraform apply -var="aks_node_count=5" -var-file=terraform.tfvars.prod

# Scale back to 3 nodes
terraform apply -var="aks_node_count=3" -var-file=terraform.tfvars.prod
```

## Cost Optimization

- **Firewall**: Standard tier for cost savings (Premium for advanced threat protection)
- **VM Size**: Standard_D4s_v5 is the specified size for the workload
- **Auto-scaling**: Disabled (manually scale as needed)
- **Reserved Instances**: Consider Azure reserved instances for 1-3 year commitments
- **Logging**: 90-day retention balances compliance (GDPR) with storage costs

**Estimated Monthly Cost**:
- AKS Cluster (3 nodes): ~$200-250
- Azure Firewall (2x Premium): ~$400-450
- Networking & Storage: ~$50-100
- **Total**: ~$650-800/month

## Troubleshooting

### Firewall Rules Not Applied

```bash
# Verify firewall rules exist
az network firewall policy rule-collection-group show \
  --policy-name 001-policy-egress-control-prod \
  --name allow-registries \
  --resource-group rg-001-private-aks-prod
```

### Nodes Not Ready

```bash
# Check node status
kubectl get nodes -o wide

# Check node logs (via Azure Portal)
az vm run-command invoke \
  --command-id RunShellScript \
  --scripts "journalctl -u kubelet --no-pager" \
  --ids <node-vm-id>
```

### UDR Not Routing to Firewall

```bash
# Verify route table association
az network vnet subnet show \
  --name 001-subnet-nodes-prod \
  --vnet-name 001-vnet-private-aks-prod \
  --resource-group rg-001-private-aks-prod
```

## Disaster Recovery

### Firewall Failover

If primary firewall fails, update UDR to secondary:

```bash
az network route-table route update \
  --name 001-udr-node-egress-primary \
  --route-table-name 001-udr-node-egress-prod \
  --resource-group rg-001-private-aks-prod \
  --next-hop-ip-address <firewall-secondary-private-ip>
```

### Node Failure Recovery

Nodes are automatically replaced by Azure within 10 minutes of failure detection. Manual replacement:

```bash
# If manual intervention needed, scale down then up
terraform apply -var="aks_node_count=2" -var-file=terraform.tfvars.prod
terraform apply -var="aks_node_count=3" -var-file=terraform.tfvars.prod
```

## Maintenance

### Regular Tasks

1. **Review Firewall Logs** (Weekly)
   - Check for denied traffic patterns
   - Verify only whitelisted domains accessed

2. **Update Kubernetes Version** (Monthly)
   - AKS auto-updates patch version
   - Manual update: Change `kubernetes_version` in tfvars

3. **Audit Access Logs** (Monthly for GDPR)
   - Export audit logs from Log Analytics
   - Retain for 7 years per compliance requirements

4. **Cost Review** (Monthly)
   - Check Azure bill for unexpected charges
   - Review unused resources

## Support

For issues, see troubleshooting section above or consult:
- Azure AKS Documentation: https://docs.microsoft.com/azure/aks/
- Terraform Azure Provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest
- Azure Firewall: https://docs.microsoft.com/azure/firewall/

## License

Infrastructure code managed by [Team/Organization].
