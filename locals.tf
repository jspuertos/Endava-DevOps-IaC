locals {
  name   = "${terraform.workspace}-vpc"
  region = "us-east-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  db_name    = "${terraform.workspace}-mysql"
  db_sg_name = "${local.db_name}-sg"

  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  port                 = 3306
  storage_type         = "gp3"

  bastion_name    = "${terraform.workspace}-bastion"
  bastion_sg_name = "${local.bastion_name}-sg"
  my_public_ip    = "91.183.5.182/32"

  backend_name         = "movie-analyst-api-${terraform.workspace}"
  backend_port         = 3000
  alb_backend_name     = "alb-${local.backend_name}"
  alb_backend_internal = true
  ecs_backend_name     = "ecs-${local.backend_name}"

  frontend_name = "movie-analyst-ui-${terraform.workspace}"

  tags = {
    Terraform = "true"
  }
}
