module "backend_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"

  name = local.alb_backend_name

  load_balancer_type = "application"
  internal           = local.alb_backend_internal

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = local.backend_port
      to_port     = local.backend_port
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    ex_http = {
      port     = local.backend_port
      protocol = "HTTP"

      forward = {
        target_group_key = "backend_ecs"
      }
    }
  }

  target_groups = {
    backend_ecs = {
      name                              = local.ecs_backend_name
      protocol                          = "HTTP"
      port                              = local.backend_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true
      vpc_id                            = module.vpc.vpc_id

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = local.backend_port
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      create_attachment = false
    }
  }

  tags = local.tags
}

module "frontend_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"

  name = local.alb_frontend_name

  load_balancer_type = "application"
  internal           = local.alb_frontend_internal

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = local.frontend_port
      to_port     = local.frontend_port
      ip_protocol = "tcp"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    ex_http = {
      port     = local.frontend_port
      protocol = "HTTP"

      forward = {
        target_group_key = "frontend_ecs"
      }
    }
  }

  target_groups = {
    frontend_ecs = {
      name                              = local.ecs_frontend_name
      protocol                          = "HTTP"
      port                              = local.frontend_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true
      vpc_id                            = module.vpc.vpc_id

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = local.frontend_port
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      create_attachment = false
    }
  }

  tags = local.tags
}