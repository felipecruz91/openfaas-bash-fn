terraform {
  required_version = ">= 0.12.26"
}

variable "name" {
  description = "Name variable"
}

# The simplest possible Terraform module: it just outputs "Hello, ${name}!"
output "hello_world" {
  value = "Hello, ${var.name}!"
}
