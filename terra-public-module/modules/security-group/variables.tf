variable "vpc_id"{
  type = string
}

variable "sg_name"{
  type = string
}

variable "ingress_ports"{
  type = list(number)
}

variable "tags" {
  type = map(string)
}


