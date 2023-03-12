resource "aws_db_instance" "main" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.16"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = var.database_master_password
  db_subnet_group_name = "my_database_subnet_group"
  parameter_group_name = "default.mysql5.7"
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