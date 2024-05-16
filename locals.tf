locals {
  name   = "${terraform.workspace}-vpc"
  region = "us-east-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  db_name    = "${terraform.workspace}-postgresql"
  db_sg_name = "${local.db_name}-sg"

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14"
  major_engine_version = "14"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  port                 = 5432
  storage_type         = "gp3"

  bastion_name    = "${terraform.workspace}-bastion"
  bastion_sg_name = "${local.bastion_name}-sg"
  my_public_ip    = "91.183.5.182/32"

  tags = {
    Terraform = "true"
  }
}
