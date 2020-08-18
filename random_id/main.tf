terraform {
  required_version = ">= 0.11.0"
}

resource "random_id" "test" {
  byte_length = 4
}

output "random_id" {
  value = "${random_id.test.id}"
}