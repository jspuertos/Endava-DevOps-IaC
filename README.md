# Endava-DevOps-IaC

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.49.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend_alb"></a> [backend\_alb](#module\_backend\_alb) | terraform-aws-modules/alb/aws | 9.9.0 |
| <a name="module_bastion_security_group"></a> [bastion\_security\_group](#module\_bastion\_security\_group) | terraform-aws-modules/security-group/aws | 5.1.2 |
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | 6.6.0 |
| <a name="module_ecs_backend_fargate"></a> [ecs\_backend\_fargate](#module\_ecs\_backend\_fargate) | terraform-aws-modules/ecs/aws | 5.11.1 |
| <a name="module_ecs_frontend_fargate"></a> [ecs\_frontend\_fargate](#module\_ecs\_frontend\_fargate) | terraform-aws-modules/ecs/aws | 5.11.1 |
| <a name="module_frontend_alb"></a> [frontend\_alb](#module\_frontend\_alb) | terraform-aws-modules/alb/aws | 9.9.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | 5.1.2 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.8.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.backend_ecs_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.frontend_ecs_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_repository.backend_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.frontend_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_instance_profile.ssm_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ssm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ssm_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_secretsmanager_secret.rds_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.rds_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_service_discovery_http_namespace.backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace) | resource |
| [aws_service_discovery_http_namespace.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_ssm_parameter.fluentbit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

No inputs.

## Outputs

No outputs.