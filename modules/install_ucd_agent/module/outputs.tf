output "agent_name" {
  value = "${var.agent_name}.${random_id.id.hex}"
}
