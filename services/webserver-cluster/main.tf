
# resource "aws_instance" "Isaac"{
#     ami = "ami-03f4878755434977f"
#     instance_type = "t2.micro"
#     vpc_security_group_ids = [aws_security_group.my.id]

#     user_data = <<-EOF
#             #!/bin/bash
#             echo "Hello, World" > index.html
#             nohup busybox httpd -f -p ${var.my_port} &
#             EOF
#     user_data_replace_on_change = true
# }


resource "aws_security_group" "my" {
  name = "${var.asg_name}-sg"

  lifecycle {
    create_before_destroy = true
  }
  
}

resource "aws_security_group_rule" "i-http" {
  type = "ingress"
  security_group_id = aws_security_group.my.id

  
  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
  
}

resource "aws_security_group_rule" "i-8080" {
  type = "ingress"
  security_group_id = aws_security_group.my.id

    from_port = local.port_2
    to_port = local.port_2
    protocol = local.tcp_protocol
    cidr_blocks = local.all_ips

}

resource "aws_security_group_rule" "i-custom" {
  type = "ingress"
  security_group_id = aws_security_group.my.id

  from_port = local.custom_port
  to_port = local.custom_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "e-all" {
  type = "egress"
  security_group_id = aws_security_group.my.id


    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.all_ips

}

resource "aws_launch_configuration" "lc_1" {
  image_id = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.my.id]
  user_data = templatefile("/home/akira/DevOps-2/modules/services/webserver-cluster/userdata.sh", {
    server_port = local.custom_port
    db_port = data.terraform_remote_state.rds_db.outputs.DDB_port
    db_address = data.terraform_remote_state.rds_db.outputs.DDB_address
  })
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-1" {
  launch_configuration = aws_launch_configuration.lc_1.name
  vpc_zone_identifier = data.aws_subnets.my_subnets.ids
  target_group_arns = [ aws_lb_target_group.target.arn ]


  min_size = 1
  max_size = 2

  tag {
    key = "Name"
    value = "${var.asg_name}"
    propagate_at_launch = true
  }
}



resource "aws_dynamodb_table" "asg-lock-db" {
  name = "${var.asg_db_name}"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
