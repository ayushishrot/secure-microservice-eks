resource "aws_security_group" "documentdb_sg" {
  name        = "docdb-sg"
  description = "Allow access to DocumentDB from ECS tasks"
  vpc_id      = var.vpc_id

  # Egress: Allow DocumentDB to reach the internet (e.g. for monitoring)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "mongo-sg"
  }
}


resource "aws_security_group_rule" "allow_ecs_to_docdb" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  security_group_id        = aws_security_group.documentdb_sg.id
  source_security_group_id = var.app-security-group
  description              = "Allow ECS tasks to connect to DocumentDB"
}
