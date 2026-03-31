variable "name" {
  type = string
  default = "Prasad"
}

output "variables_user_info" {
  value = "Name: ${var.name}"
}
