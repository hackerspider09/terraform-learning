variable "user" {
  type = map(string)

  default = {
    name = "Prasad"
    city = "Pune"
    role = "DevOps"
  }
}

output "map01_username" {
  value = var.user["name"]
}

output "map02_user_city" {
  value = var.user["city"]
}

output "map03_all_data" {
  value = var.user
}
