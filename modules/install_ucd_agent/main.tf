#####################################################################
##
##      Created 1/16/20 by ucdpadmin for cloud aws-brad.
##
#####################################################################

## REFERENCE {"aws_network":{"type": "aws_reference_network"}}


#################################################################
#           Create the virtual machine for the agent            #
#################################################################

# Variables for testing
variable "ucd_user" {}
variable "ucd_password" {}
variable "ucd_server_url" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "server_name" {}

provider "aws" {
  version = "~> 1.8"
}

# Create the virtual machine
resource "aws_instance" "server" {
  ami = "ami-13be557e"
  key_name = "${aws_key_pair.auth.id}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  tags {
    Name = "${var.server_name}"
  }
}

# Public/private keypair for the virtual machine
resource "tls_private_key" "ssh" {
    algorithm = "RSA"
}

# Create a new keypair in AWS
resource "aws_key_pair" "auth" {
    key_name = "${var.server_name}.${random_id.stack.hex}"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}

# Random ID for uniqueness
resource "random_id" "stack" {
  byte_length = 6
}

# Output: The agent name
output "agent_name" {
  value = "${module.install_agent.agent_name}"
}

#################################################################
#       Install an UrbanCode Deploy agent on the AWS VM         #
#################################################################

# Required by the module
provider "ucd" {
  username       = "${var.ucd_user}"
  password       = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
}

# Module to install the agent
module "install_agent" {
  source = "./module"

  # Virtual machine information
  host = "${aws_instance.server.public_ip}"
  user = "ubuntu"
  private_key = "${tls_private_key.ssh.private_key_pem}"

  # UrbanCode Deploy information
  agent_name = "module-test"
  ucd_user = "${var.ucd_user}"
  ucd_password = "${var.ucd_password}"
  ucd_server_url = "${var.ucd_server_url}"
  agent_package_version = "8.0"
  os_type = "linux"
}
