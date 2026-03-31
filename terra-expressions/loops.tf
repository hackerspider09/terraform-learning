
locals {
  squared = [for n in var.numbers : n * n]
}

output "loop01_squared_numbers" {
  value = local.squared
}

# Cant use variable in another variable 
# so we have to use local here to work on variable values
#variable "squared" {
#  default = [for n in var.numbers : n * n ]
#}

