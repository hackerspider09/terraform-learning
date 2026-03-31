
# normal=> condition ? true : false
# loop => true value if condition
locals {
  even_numbers = [for n in var.numbers : n if n % 2 == 0]
}

output "loop_cond01_evens" {
  value = local.even_numbers
}
