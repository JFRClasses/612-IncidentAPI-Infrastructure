output "app_insights_connection_string" {
  value     = azurerm_application_insights.incident_ai.connection_string
  sensitive = true
}

output "ip" {
  value = azurerm_linux_virtual_machine.incident_vm.public_ip_address
}