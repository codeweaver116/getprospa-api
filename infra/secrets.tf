data "aws_ssm_parameter" "datadogs_key" {
  name =  "/${var.stack["api"]}/${var.environment["qa"]}/datadogs"
}

# resource "aws_ssm_parameter" "secret" {
#   name        =  "${var.stack["api"]}/${var.environment["qa"]}/database/password/master"
#   description = "The parameter description"
#   type        = "SecureString"
#   value       = aws_db_instance.main.password
# }