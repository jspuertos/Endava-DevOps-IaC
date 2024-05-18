resource "aws_service_discovery_http_namespace" "backend" {
  name        = local.backend_name
  description = "CloudMap namespace for ${local.backend_name}"
  tags        = local.tags
}

resource "aws_cloudwatch_log_group" "backend_ecs_logs" {
  name              = "/aws/ecs/backend"
  retention_in_days = 14
}

module "ecs_backend_fargate" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.1"

  cluster_name = local.backend_name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.backend_ecs_logs.name
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  services = {
    ecs-backend = {
      cpu    = 1024
      memory = 4096

      container_definitions = {

        (local.ecs_backend_name) = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "${aws_ecr_repository.backend_service.repository_url}:latest"

          log_configuration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = aws_cloudwatch_log_group.backend_ecs_logs.name
              awslogs-region        = "us-east-1"
              awslogs-stream-prefix = "ecs"
            }
          }
          port_mappings = [
            {
              name          = local.ecs_backend_name
              containerPort = local.backend_port
              protocol      = "tcp"
            }
          ]

          # Example image used requires access to write to root filesystem
          readonly_root_filesystem = false

          environment = [
            {
              name = "DB_HOST"
              # value = module.db.db_instance_endpoint
              value = "10.0.8.139"
            },
            {
              name  = "DB_USER"
              value = "applicationuser"
            },
            {
              name  = "DB_NAME"
              value = "movie_db"
            },
          ]
          secrets = [
            {
              name      = "DB_PASS"
              valueFrom = aws_secretsmanager_secret_version.rds_password.arn
            },
          ]

          memory_reservation = 100
        }
      }

      service_connect_configuration = {
        namespace = aws_service_discovery_http_namespace.backend.arn
        service = {
          client_alias = {
            port     = local.backend_port
            dns_name = local.ecs_backend_name
          }
          port_name      = local.ecs_backend_name
          discovery_name = local.ecs_backend_name
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.backend_alb.target_groups["backend_ecs"].arn
          container_name   = local.ecs_backend_name
          container_port   = local.backend_port
        }
      }

      subnet_ids = module.vpc.private_subnets
      security_group_rules = {
        alb_ingress_3000 = {
          type                     = "ingress"
          from_port                = local.backend_port
          to_port                  = local.backend_port
          protocol                 = "tcp"
          description              = "Service port"
          source_security_group_id = module.backend_alb.security_group_id
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
      service_tags = {
        "ServiceTag" = local.ecs_backend_name
      }
    }
  }

  tags = local.tags
}

resource "aws_service_discovery_http_namespace" "frontend" {
  name        = local.frontend_name
  description = "CloudMap namespace for ${local.frontend_name}"
  tags        = local.tags
}

resource "aws_cloudwatch_log_group" "frontend_ecs_logs" {
  name              = "/aws/ecs/frontend"
  retention_in_days = 14
}

module "ecs_frontend_fargate" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.1"

  cluster_name = local.frontend_name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.frontend_ecs_logs.name
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  services = {
    ecs-frontend = {
      cpu    = 1024
      memory = 4096

      assign_public_ip = true

      container_definitions = {

        (local.ecs_frontend_name) = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "${aws_ecr_repository.frontend_service.repository_url}:latest"

          log_configuration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = aws_cloudwatch_log_group.frontend_ecs_logs.name
              awslogs-region        = "us-east-1"
              awslogs-stream-prefix = "ecs"
            }
          }
          port_mappings = [
            {
              name          = local.ecs_frontend_name
              containerPort = local.frontend_port
              protocol      = "tcp"
            }
          ]

          # Example image used requires access to write to root filesystem
          readonly_root_filesystem = false

          environment = [
            {
              name  = "BACKEND_URL"
              value = "${module.backend_alb.dns_name}:${local.backend_port}"
            },
          ]

          memory_reservation = 100
        }
      }

      service_connect_configuration = {
        namespace = aws_service_discovery_http_namespace.frontend.arn
        service = {
          client_alias = {
            port     = local.frontend_port
            dns_name = local.ecs_frontend_name
          }
          port_name      = local.ecs_frontend_name
          discovery_name = local.ecs_frontend_name
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.frontend_alb.target_groups["frontend_ecs"].arn
          container_name   = local.ecs_frontend_name
          container_port   = local.frontend_port
        }
      }

      subnet_ids = module.vpc.public_subnets
      security_group_rules = {
        alb_ingress_3030 = {
          type                     = "ingress"
          from_port                = local.frontend_port
          to_port                  = local.frontend_port
          protocol                 = "tcp"
          description              = "Service port"
          source_security_group_id = module.frontend_alb.security_group_id
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
      service_tags = {
        "ServiceTag" = local.ecs_frontend_name
      }
    }
  }

  tags = local.tags
}
