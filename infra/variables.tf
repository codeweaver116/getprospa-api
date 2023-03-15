variable "environment" {
  type = map(string)
  default = {

    qa          = "qa"
    staging     = "staging"
    development = "development"
    production  = "production"
  }

}

variable "stack" {
  type = map(string)
  default = {

    api        = "api"
    monitoring = "monitoring"
    database   = "database"
    networking = "networking"
    security   = "security"

  }

}

variable "region" {
  default = "us-east-1"

}

variable "database_username" {
  default = "getprospa"
}

variable "database_name" {
  default = "getprospa_db"
}

variable "organization_name" {
  default = "getprospa"

}
variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  type        = map(number)
  default = {
    qa          = 1
    staging     = 1
    development = 2
    production  = 4
  }
}
variable "subnet_ids" {
  default = "subnet-0a2a8d839bec34b0d,subnet-0e31ea94468fac418,subnet-0c3de944c3221e68f"
}

variable "vpc_id" {
  default = "vpc-0532330bf1615770f"
}
variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 5000
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default = {
    qa          = 256
    staging     = 256
    development = 256
    production  = 256
  }
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default = {
    qa          = 512
    staging     = 512
    development = 512
    production  = 512
  }
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/" #change this to your default health check ideally 
}

variable "alb_tls_cert_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  default = {
    qa          = "qa arn for tls certificate"
    staging     = "staging arn for tls certificate"
    development = "development arn for tls certificate"
    production  = "production arn for tls certificate"
  }

}

