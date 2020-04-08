#####################################################################
##
##  Install an UrbanCode Deploy agent
##
#####################################################################

resource "null_resource" "install_agent" {
  provisioner "ucd" {
    agent_name      = "${var.agent_name}.${random_id.id.hex}"
    ucd_server_url  = "${var.ucd_server_url}"
    ucd_user        = "${var.ucd_user}"
    ucd_password    = "${var.ucd_password}"
    agent_package_version = "${var.agent_package_version}"
    os_type = "${var.os_type}"
    
  }
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    curl -k -u ${var.ucd_user}:${var.ucd_password} ${var.ucd_server_url}/cli/agentCLI?agent=${var.agent_name}.${random_id.id.hex} -X DELETE
EOT
}
  connection {
    host = "${var.host}"
    user = "${var.user}"
    private_key = "${var.private_key}"
  }
}

resource "random_id" "id" {
  byte_length = 6
}

