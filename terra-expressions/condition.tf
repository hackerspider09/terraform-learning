variable "age" {
  default = 18
}

locals {
  age = var.age
  status = local.age >= 18 ? "Adult" : "Minor"
}

# While calling local var use 'local' not 'locals'
output "condition01_status" {
  value = "age = ${local.age} & status = ${local.status}"
}
