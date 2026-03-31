variable "fruits" {
  type = list(string)

  default = [
    "apple",
    "banana",
    "mango"
  ]
}

output "list_first_fruit" {
  value = var.fruits[0]
}

output "list_all_fruits" {
  value = var.fruits
}
