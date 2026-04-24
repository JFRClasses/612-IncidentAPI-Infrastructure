
resource "azurerm_resource_group" "incident_rg" {
  name     = "612-incident-rg-${var.ENVIRONMENT}"
  location = var.LOCATION
}

resource "azurerm_application_insights" "incident_ai" {
  name                = "612-incident-api-telemetry-${var.ENVIRONMENT}"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.incident_rg.name
  application_type    = "web"
}

