resource "aws_codedeploy_app" "frontend" {
  compute_platform = "ECS"
  name             = local.frontend_name

  tags = local.tags
}