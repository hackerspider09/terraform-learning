variable "cidr_block_eu" {
    description = "The CIDR block for the VPC europe region"
    type        = string
}

variable "cidr_block_mum" {
    description = "The CIDR block for the VPC mumbai region"
    type        = string
}

variable "req_region" {
    description = "The peer region for VPC peering"
    type        = string
}
variable "acc_region" {
    description = "The peer region for VPC peering"
    type        = string
}

variable "public_key_path" {
  description = "Path to your local public key file (e.g., ~/.ssh/id_rsa.pub)"
  type        = string
}

