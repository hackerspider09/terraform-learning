resource "aws_instance" "get_instance_res" {
    ami = "ami-0ec10929233384c7f"
    instance_type = "t2.micro"

    # Added to include state
    tags = {
      "Environment" = "dev"
      "Name"        = "test-ec2"
    }
}

import {
  to = aws_instance.get_instance_res
  id =  "i-065741a9cdf92f2d9"
}