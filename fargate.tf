/*
resource "aws_service_discovery_http_namespace" "backend" {
  name        = local.backend_name
  description = "CloudMap namespace for ${local.backend_name}"
  tags        = local.tags
}

module "ecs_backend_fargate" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.1"

  cluster_name = local.backend_name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
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
                value = module.db.db_instance_endpoint
            },
            {
                name = "DB_USER"
                value = "applicationuser"
            },
            {
                name = "DB_NAME"
                value = "movie_db"
            },
          ]
          secrets = [
            {
                name = "DB_PASS"
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
*/