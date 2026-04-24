output "app_insights_connection_string" {
  value     = azurerm_application_insights.incident_ai.connection_string
  sensitive = true
}