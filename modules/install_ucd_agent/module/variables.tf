
variable "agent_name" {
  type = "string"
  description = "Agent name prefix. A random ID will be appended to this name to guarantee uniqueness."
}

variable "ucd_user" {
  type = "string"
  description = "UrbanCode Deploy user"
}

variable "ucd_password" {
  type = "string"
  description = "UrbanCode Deploy password"
}

variable "ucd_server_url" {
  type = "string"
  description = "UrbanCode Deploy server URL"
}

variable "host" {
 type = "string"
 description = "Hostname or IP address of the server"
}

variable "user" {
  type = "string"
  description = "VM user"
}
variable "private_key" {
  type = "string"
  description = "Private key used to connect to the server"
}

