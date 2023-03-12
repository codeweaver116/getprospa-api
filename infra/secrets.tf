data "aws_ssm_parameter" "datadogs_key" {
  name =  "${var.stack["api"]}/${var.environment["qa"]}/datadogs"
}

resource "aws_ssm_parameter" "secret" {
  name        =  "${var.stack["api"]}/${var.environment["qa"]}/database/password/master"
  description = "The parameter description"
  type        = "SecureString"
  value       = var.database_master_password

 tags = {
    Name        = "${var.stack["api"]}-tg-${var.environment["qa"]}"
    Environment = var.environment["qa"]
  }
}