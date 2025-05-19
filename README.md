# 2-Day Azure DMAP SaaS Trial Offering

## Introduction

This repository contains the Terraform configuration for deploying a 2-day trial environment in Azure for individual users. The design includes core components such as virtual machines, databases, and the DMAP application, along with additional features for notifications, logging, GitHub integration, and cost management.

## Project Structure

```plaintext
project/
├── main.tf
├── variables.tf
├── providers.tf
├── backend.tf
├── modules/
│   ├── virtual_machine/
│   ├── api_management/
│   ├── oracle_db/
│   ├── postgres_db/
│   ├── dmap_application/
│   ├── function_app/
│   ├── logic_app/
│   ├── application_insights/
│   └── storage_account/
├── environments/
│   └── trial/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
└── scripts/
    ├── github_webhook_handler.py
    └── cleanup_function.py

### Core Components

### 1. Azure Virtual Machine
- **Purpose**: Hosts the DMAP Application.
- **Configuration**: Standard_D2s_v3 VM with a dedicated Virtual Network and Subnet.
- **Security**: Network Security Group with inbound rules for HTTPS and SSH.
- **Installation**: DMAP, Python, and Postgres.

### 2. Azure API Management
- **Purpose**: Manages APIs for the DMAP Application.
- **Configuration**: Developer tier of API Management.
- **Security Policies**: OAuth 2.0 and JWT validation.
- **Rate Limiting**: Implements usage quotas.

### 3. Oracle Database
- **Purpose**: Provides data storage for the DMAP application.
- **Configuration**: Basic tier of Azure Database for Oracle.
- **Firewall Rules**: Allows access from the VM and API Management.
- **Schemas and Users**: Sets up initial configurations.

### 4. PostgreSQL Database
- **Purpose**: Offers additional data storage for the DMAP application.
- **Configuration**: Basic tier of Azure Database for PostgreSQL.
- **Connection Strings**: Configures connection settings and firewall rules.
- **Initialization**: Prepares necessary tables and structures.

### 5. DMAP Application
- **Purpose**: Main application deployed to the Azure VM.
- **Deployment**: Containerized application.
- **Configuration**: Sets connections to Oracle and Postgres databases.
- **Environment Variables**: Sets up application-specific settings.

### 6. Azure Function App
- **Purpose**: Handles cleanup tasks and notifications.
- **Trigger**: Timer-triggered functions to check for expired trials.
- **Bindings**: Output bindings to trigger Terraform destroy commands.

### 7. Azure Logic App
- **Purpose**: Manages notification services.
- **Workflows**: Configured for sending emails and SMS notifications.
- **Integration**: Works with Azure Monitor for automated alerts.

### 8. Application Insights
- **Purpose**: Monitors the DMAP application.
- **Custom Events**: Tracks user actions and feature usage.
- **Log Collection**: Establishes logging and storage policies.

### 9. Azure Storage Account
- **Purpose**: Stores logs and JSON outputs.
- **Blob Containers**: Configured for structured and unstructured data.
- **Lifecycle Policies**: Manages retention of logs and outputs.
## Notification Service

The notification service uses Azure Logic Apps to provide support for DMAP users:

### Trigger Conditions:

- Trial start (welcome message)
- 24 hours before expiration
- Trial end
- Error alerts from Application Insights

### Notification Channels:

- **Email** (primary)
- **SMS** (optional, requires user's phone number)

### Content:

- Trial status and time remaining
- Quick start guide and documentation links
- Support contact information

## Logging and Monitoring

### Application Insights Integration

- DMAP application instrumented with Application Insights SDK.
- Custom events tracked for key user actions and feature usage.
- Performance metrics collected for API calls and database queries.

### Log and JSON Output Storage

- Application logs stored in Azure Blob Storage.
- JSON outputs from DMAP operations saved to dedicated containers.
- Implemented retention policies:
  - Logs: 3 days
  - JSON outputs: 1 day post-trial

### Log Analysis

- Azure Log Analytics workspace configured for centralized logging.
- Custom queries created for common support scenarios.
- Dashboard for real-time trial usage monitoring.

## GitHub Webhook Integration

### Webhook Setup

- GitHub repository configured with a webhook pointing to an Azure Function.
- Webhook triggers on push events to the main branch.

### Azure Function for Terraform Apply

- Python-based Azure Function to handle webhook payload.
- Function authenticates GitHub requests using a secret token.
- Triggered function runs the following steps:
  1. Clone the Terraform repository
  2. Initialize Terraform
  3. Create a plan
  4. Apply the plan if no errors are found

### Security Considerations

- Use Managed Identities for Azure resource access.
- Store GitHub tokens and other secrets in Azure Key Vault.
- Implement IP restrictions on the Function App.

## Cost Estimation

Estimated daily cost for a single trial environment:

| Resource                           | Tier/Size              | Estimated Cost (USD)         |
|------------------------------------|------------------------|-------------------------------|
| Virtual Machine                     | Standard_D2s_v3       | $0.096/hour * 24 = $2.304    |
| API Management                      | Developer              | $0.05/hour * 24 = $1.20      |
| Azure Database for Oracle           | Basic                  | $0.02/hour * 24 = $0.48      |
| Azure Database for PostgreSQL      | Basic                  | $0.02/hour * 24 = $0.48      |
| Function App                        | Consumption            | $0.20/million executions      |
| Logic App                          | Consumption            | $0.000025/action * ~100 = $0.0025 |
| Application Insights               |                        | $2.30/GB ingested             |
| Storage Account                    | Standard_LRS           | $0.0152/GB/month              |

**Estimated total cost per trial**: $4.67 per day.

*Note: Actual costs may vary based on usage patterns and data transfer.*

## Cleanup Process

An Azure Function runs daily to check resource group tags:

- Identifies expired trials based on the `ExpirationTime` tag.
- For expired trials:
  - Sends final notification to the user.
  - Triggers Terraform destroy command using a service principal.
  - Removes the corresponding Terraform workspace.
  - Deletes the resource group as a fallback measure.

## Security Measures

- All sensitive data (connection strings, keys) stored in Azure Key Vault.
- HTTPS enforced for all public endpoints.
- Network security groups restrict inbound traffic.
- Managed Identities used for Azure resource access where possible.
- Regular automated security scans of the infrastructure.

## Scaling Considerations

- VM Scale Sets can be implemented for the DMAP application if needed.
- API Management configured with auto-scaling rules.
- Database connection pooling implemented in the application layer.

UPDATE :
COMPLETED UPTO FOLDER STRUCTURE,NEXT TASK IS TO CREATE TERRAFORM SCRIPT FOR CREATING VIRTUAL MACHINE
