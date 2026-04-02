resource "aws_security_group" "ec2_sg" {
  name        = var.sg_name
  vpc_id = var.vpc_id
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = merge(
    {
      Name = var.sg_name
    },
    var.tags
  )
}


resource "aws_vpc_security_group_ingress_rule" "allow_ingress" {
  for_each = toset([ for port in var.ingress_ports  : tostring(port) ])
  
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"

  from_port         = tonumber(each.value)
  ip_protocol       = "tcp"
  to_port           = tonumber(each.value)
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}