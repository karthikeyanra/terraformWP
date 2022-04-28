

resource "aws_db_subnet_group" "mysqldbsubnet" {
  name       = "mysqldbsubnet"
  subnet_ids = [aws_subnet.DBPrivateSubnet.id, aws_subnet.DBPrivateSubnet1.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "wpdb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.dbusername
  password             = var.dbpassword
  multi_az              = false
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.mysqldbsubnet.name
  vpc_security_group_ids = [ aws_security_group.dbSG.id ]
  skip_final_snapshot  = true
}