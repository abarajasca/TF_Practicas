resource "aws_instance" "public_instance" {
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("scripts/userdata.sh")
    
  # lifecycle {
  #   create_before_destroy = true
  #   prevent_destroy = true
  #   ignore_changes = [ key_name ]
  #   replace_triggered_by = [ aws_subnet.private_subnet ]
  # }

  provisioner "local-exec" {
    command = "echo instancia creada con IP ${aws_instance.public_instance.public_ip} >> datos_instancia.txt"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo instancia ${self.public_ip} destruida >> datos_instancia.txt"
  }

  # provisioner "remote-exec" {
  #   inline = [ 
  #     "echo 'hola mundo' > ~/saludo.txt"
  #    ]

  #   connection {
  #     type  = "ssh"
  #     host  = self.public_ip
  #     user  = "ec2-user"
  #     private_key = file("mykey.pem")
  #   } 
  # }

  tags = {
    Name = "public_instance"
  }
}

