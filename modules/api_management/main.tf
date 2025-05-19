resource "azurerm_api_management" "api_service" {
  name                = var.api_service_manager_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  publisher_name      = var.publisher_name  # Customize as needed
  publisher_email     = var.publisher_email  # Customize as needed

  sku_name = "Developer_1"  # Use sku_name directly at the root level
}

# Define the HTTP API within the API Management Service
resource "azurerm_api_management_api" "http_api" {
  name                = "http-api"
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  api_management_name = azurerm_api_management.api_service.name
  revision            = "1"
  display_name        = "DMAP API"
  protocols           = ["https"]

  # Optional: Description for the API
  description = "This is an HTTP API for accessing the DMAP service."

  # Specify the backend service URL
  service_url = "http://${var.vm_public_ip}:8080"

  # Set path as empty
  path = ""

  # Disable subscription requirement
  subscription_required = false
}


# Define the FRONTEND GET operation for GET /*
resource "azurerm_api_management_api_operation" "frontend_get" {
  operation_id        = "frontend-get"  # Unique ID for the frontend operation
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  display_name        = "Frontend GET Operation"
  method              = "GET"
  url_template        = "/*"  # The endpoint path for the frontend
  response {
    status_code = 200
    description = "Successful frontend response"
  }
}

# Define the BACKEND GET operation for /api/* with port override
resource "azurerm_api_management_api_operation" "backend_api_get" {
  operation_id        = "backend-api-get"  # Unique ID for the backend GET operation
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  display_name        = "Backend GET API Operation"
  method              = "GET"
  url_template        = "/api/*"  # The endpoint path for the backend
  response {
    status_code = 200
    description = "Successful backend GET response"
  }
}

# Override the backend URL for the backend GET API operation
resource "azurerm_api_management_api_operation_policy" "backend_override_policy_get" {
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  operation_id        = azurerm_api_management_api_operation.backend_api_get.operation_id

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service base-url="http://${var.vm_public_ip}:5002" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

# Define the FRONTEND POST operation for POST /*
resource "azurerm_api_management_api_operation" "frontend_post" {
  operation_id        = "frontend-post"  # Unique ID for the frontend POST operation
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  display_name        = "Frontend POST Operation"
  method              = "POST"
  url_template        = "/*"  # The endpoint path for the frontend
  response {
    status_code = 200
    description = "Successful frontend POST response"
  }
}

# Define the BACKEND POST operation for /api/* with port override
resource "azurerm_api_management_api_operation" "backend_api_post" {
  operation_id        = "backend-api-post"  # Unique ID for the backend POST operation
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  display_name        = "Backend POST API Operation"
  method              = "POST"
  url_template        = "/api/*"  # The endpoint path for the backend
  response {
    status_code = 200
    description = "Successful backend POST response"
  }
}

# Override the backend URL for the backend POST API operation
resource "azurerm_api_management_api_operation_policy" "backend_override_policy_post" {
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  operation_id        = azurerm_api_management_api_operation.backend_api_post.operation_id

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service base-url="http://${var.vm_public_ip}:5002" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

# Define the BACKEND POST operation for /api/* with port override
resource "azurerm_api_management_api_operation" "app_api_post" {
  operation_id        = "app-api-post"  # Unique ID for the backend POST operation
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  display_name        = "APP POST API Operation"
  method              = "POST"
  url_template        = "/appapi/*"  # The endpoint path for the backend
  response {
    status_code = 200
    description = "Successful backend POST response"
  }
}

# Override the backend URL for the backend POST API operation
resource "azurerm_api_management_api_operation_policy" "app_override_policy_post" {
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  operation_id        = azurerm_api_management_api_operation.app_api_post.operation_id

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service base-url="http://${var.vm_public_ip}:5001" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

# Define the BACKEND POST operation for /api/* with port override
resource "azurerm_api_management_api_operation" "app_api_get" {
  operation_id        = "app-api-get"  # Unique ID for the backend POST operation
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  display_name        = "APP GET API Operation"
  method              = "GET"
  url_template        = "/appapi/*"  # The endpoint path for the backend
  response {
    status_code = 200
    description = "Successful backend POST response"
  }
}

# Override the backend URL for the backend POST API operation
resource "azurerm_api_management_api_operation_policy" "app_override_policy_get" {
  api_name            = azurerm_api_management_api.http_api.name
  api_management_name = azurerm_api_management.api_service.name
  resource_group_name = azurerm_api_management.api_service.resource_group_name
  operation_id        = azurerm_api_management_api_operation.app_api_get.operation_id

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service base-url="http://${var.vm_public_ip}:5001" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}


