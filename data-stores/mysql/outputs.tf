# output "s3_bucket_arn" {
#   value       = data.terraform_remote_state.s3_arn.outputs
#   description = "The ARN of the S3 bucket"
# }

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.rds-lock-table.name
  description = "The name of the DynamoDB table"
}

output "DDB_address" {
  value = aws_db_instance.rds.address
}

output "DDB_port" {
  value = aws_db_instance.rds.port
}
# data "terraform_remote_state" "s3_arn" {
#     backend = "s3"

#     config = {
#       bucket = "terraform-state-bucket-akira"
#       key = "global/s3/terraform.tfstate"
#       region = "us-east-1"
#     }
# }