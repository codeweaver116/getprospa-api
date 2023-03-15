# resource "aws_db_instance" "main" {
#   allocated_storage    = 10
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "5.7.16"
#   instance_class       = "db.t2.micro"
#   name                 = var.database_name
#   username             = var.database_username
#   password             = random_password.password.result
#   db_subnet_group_name = "my_database_subnet_group"
#   parameter_group_name = "default.mysql5.7"
# }


# resource "random_password" "password" {
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }
