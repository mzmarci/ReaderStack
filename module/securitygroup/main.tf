resource "aws_security_group" "lb_security_group" {
  name        = "lb_security_group"
  description = "Allow SSH and HTTP Connection"
  vpc_id      = var.vpc_id
 
  tags = {
    Name = "stock load balancer secuirty group"
  }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to internet
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}


resource "aws_security_group" "frontend_sg" {   //frontend layer
  name        = "web_security_group"
  description = "Allow SSH and HTTP Connection"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Reader-web"
  }
}

resource "aws_security_group_rule" "web_ingress2" {
  security_group_id        = aws_security_group.frontend_sg.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]  # Open to internet
}

resource "aws_security_group_rule" "web_ingress" {
  security_group_id        = aws_security_group.frontend_sg.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_security_group.id  # Allow traffic only from LB
}

resource "aws_security_group_rule" "web_ingress1" {
  security_group_id        = aws_security_group.frontend_sg.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_security_group.id  # Allow traffic only from LB
}

resource "aws_security_group_rule" "web_ingress3" {
  security_group_id        = aws_security_group.frontend_sg.id
  type                     = "ingress"
  from_port                = 5173
  to_port                  = 5173
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_security_group.id  # Allow traffic only from LB
}

resource "aws_security_group_rule" "web_ingress4" {
  security_group_id        = aws_security_group.frontend_sg.id
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]  # Allow traffic only from LB
}

resource "aws_security_group_rule" "web-egress-rule" {
  security_group_id = aws_security_group.frontend_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

}

# Backend Layer Security Group 

resource "aws_security_group" "backend_sg" {
  name        = "backend_security_group"
  description = "Allow traffic only from Web Servers"
  vpc_id      = var.vpc_id

}
resource "aws_security_group_rule" "backend-igress-rule" {
  security_group_id        = aws_security_group.backend_sg.id
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.frontend_sg.id
}

resource "aws_security_group_rule" "backend-egress-rule" {  //only allow traffic to the backend
  security_group_id        = aws_security_group.backend_sg.id
  type                     = "egress"
  from_port                = 5432  # Redis port
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.database_sg.id

}

# Backend Security Group (Attached to Redis)

resource "aws_security_group" "database_sg" {
  name        = "database_security_group"
  description = "Allow traffic only from Middle Layer"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "database-igress-rule" {
  security_group_id        = aws_security_group.database_sg.id
  type                     = "ingress"
  from_port                = 5432 # Redis default port
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_sg.id    # Only allow traffic from Middle Layer

}

// Restricted outbound traffic to only Middle Layer
resource "aws_security_group_rule" "database-egress-rule" {
  security_group_id = aws_security_group.database_sg.id
  type              = "egress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  source_security_group_id = aws_security_group.backend_sg.id
}


# Port 5173 → Vite frontend
# Port 8000 → FastAPI backend
# Port 5432 → PostgreSQL
