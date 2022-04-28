output "instance_ip_addr" {
  value = aws_instance.webserver.public_ip
}

output "dbInstance_address" {
    value = aws_db_instance.wpdb.address
     
}

output "dbInstance_dbname" {
  value = var.dbname
}
