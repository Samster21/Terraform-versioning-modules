resource "aws_db_instance" "rds" {
  instance_class = "db.t2.micro"
  engine = "mysql"
  identifier_prefix = "terraform"
  allocated_storage = 10
  skip_final_snapshot = true
  db_name = "${var.rds_name}"

  username = var.db_username
  password = var.db_password
}

resource "aws_dynamodb_table" "rds-lock-table" {
  name = "${var.rds_dynamo_table}"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
