terraform {
  backend "s3" {
    # state.config
    bucket = "terra-s3-1-4-2026" 
    key    = "dhagesh/terraform.tfstate"
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