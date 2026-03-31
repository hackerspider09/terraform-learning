terraform {
  backend "s3" {
    # state.config
    bucket = "terra-s3-1-4-2026" 
    key    = "dhagesh/terraform.tfstate"  # this is path where statefile is going to store in s3 so multiple project can use same s3 for locking
    dynamodb_table = "terra-dyno"
    region = "us-east-1"
  }


  required_providers {
    time = {
      source = "hashicorp/time"
    }
  }
}


resource "time_sleep" "hold_lock" {
  create_duration = "1m"
}