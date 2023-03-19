resource "aws_security_group" "db" {
  name        = "tf-${var.stack_name}-db"
  description = "Rules for RDS instances."

  # MySQL port available for anything in the web security group
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
  }

  # Pinging available for anything within the vpc
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [var.cidr]
  }

  # Disable all outgoing connections
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc

  tags = {
    Name         = "${var.stack_name}-rds-sg"
    IngressRules = "Allows incoming connections to database from the web subnets only. Allows ssh and ping within the vpc."
    EgressRules  = "No outbound traffic allowed."
  }
}
