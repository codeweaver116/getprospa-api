data "aws_ssm_parameter" "datadogs_key" {
  name =  "/${var.stack["api"]}/${var.environment["qa"]}/datadogs"
}

# resource "aws_ssm_parameter" "database_secret" {
#   name        =  "/${var.stack["api"]}/${var.environment["qa"]}/database/password/master"
#   description = "Main databae password"
#   type        = "SecureString"
#   value       = aws_db_instance.main.password
# }