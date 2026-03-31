variable "users" {
  default = {
    user1 = "dev"
    user2 = "ops"
    user3 = "qa"
  }
}

locals {
  formatted = [
    for name, role in var.users :
    "${name} -> ${role}"
  ]
}

output "map_loop01_users_list" {
  value = local.formatted
}
