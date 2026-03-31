locals {
  name = "terraform"
}

output "stringfunc01_upper_name" {
  value = upper(local.name)
}

output "stringfunc02_length" {
  value = length(local.name)
}

