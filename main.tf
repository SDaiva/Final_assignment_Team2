provider "aws" {
  region = var.region
}

resource "aws_key_pair" "team2_final_assignment_key_pair" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "team2_final_assignment_security_group" {
  name = var.security_group_name

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "team2_final_assignment" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.team2_final_assignment_key_pair.key_name
  tags = {
    Name = "team2_instance"
  }
  vpc_security_group_ids = [aws_security_group.team2_final_assignment_security_group.id]

  provisioner "local-exec" {
    command = "ansible-playbook -i '${aws_instance.team2_final_assignment.public_ip},' -e ip_address=${aws_instance.team2_final_assignment.public_ip} final_playbook.yml --user ${var.aws_instance_user_id} --private-key ${var.private_key_path}"
  }
}
