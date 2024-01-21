variable "rds_name" {
  description = "Name for RDS instance"
  type = string
}

variable "rds_dynamo_table" {
  description = "Name for DynamoDB table for backend"
  type = string
}

variable "db_username" {
  description = "Username to access RDS DB"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "Password to access RDS DB"
  type = string
  sensitive = true
}