resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA1y4pYatWWZYwqoXfAOVSzExsrY8jusp+6oGB5pYvyPUx42V5vCKs7QLr5GQUNWHvOcyrV4yYGtM+8L/3Wq2vzl7mHO2cqqRTH0hQ2TaCkaU2rvKIYAlFOH/d7O5ygH+pL8IUIdfdTIT2AHMUE6LRuCb32U6qEwJmm/QQdZ8nl485EyfJ24GCZvZXlvblq76bj4MjoTU/4k/kxq6v5d5mzcNE/ELaCfD3+nTQvIgXFPXDFDdlrvCGaq//rfbUbxzeHgBLA9MzZOCEhFsfrpp3IojVMRs8+dbtTTPAGZcP6IaOsoQ/o4wL76+KI6Zs04h//rbwCfGIZkpj2DM3KzLGfQ== rsa-key-20220422"
}


resource "aws_instance" "webserver" {
    instance_type = "t2.micro"
    security_groups = [ "${aws_security_group.websrvSG.id}"]
    depends_on = [
      aws_db_instance.wpdb
      
    ]
    subnet_id = aws_subnet.WebPublicSubnet.id
    ami = "ami-0d2986f2e8c0f7d01"
    key_name = aws_key_pair.deployer.key_name
    tags = {
      "name" = "websrv"
    }

    connection {
        type     = "ssh"
        user     = "ec2-user"
        private_key = file("C://WPDemo_terraform//private_key.pem")
        host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd php mysql -y",
      "sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip,common,pear}  -y ",
      "sudo wget https://wordpress.org/latest.tar.gz",
      "sudo tar -xvf latest.tar.gz",
      "sudo cp -r wordpress/* /var/www/html/",
      "sudo chown apache:apache -R /var/www/html",
      "sudo amazon-linux-extras enable php7.4",
      "sudo yum clean metadata",
      "sudo yum install php php-common php-pear -y",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "mysql -h '${aws_db_instance.wpdb.address}' -u'${var.dbusername}' -p'${var.dbpassword}' -e 'create database ${var.dbname};'",
      
    ]
    on_failure = continue
  }
}    
