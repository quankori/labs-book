resource "aws_security_group" "prj_bastion_host_dev" {
  name        = "prj-bastion-host-dev"
  description = "Allow SSH access to the bastion host"
  vpc_id      = aws_vpc.prj_vpc_dev.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.project_name}-bastion-host-${var.project_env}"
  }

}

resource "aws_instance" "prj_ec2_bastion_dev" {
  ami                    = var.ec2_linux_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.prj_bastion_host_dev.id]
  subnet_id              = aws_subnet.prj_subnet_public1_dev.id
  key_name               = "${var.project_name}-bastion-key-${var.project_env}"

  associate_public_ip_address = true
  // Remove EIP bastion host for reducer cost
  # depends_on = [ aws_eip.prj_ec2_bastion_eip_dev ]
  tags = {
    "Name" = "${var.project_name}-ec2-bastion-${var.project_env}"
  }
}

resource "aws_ec2_instance_state" "prj_ec2_bastion_state_dev" {
  instance_id = aws_instance.prj_ec2_bastion_dev.id
  state       = "stopped"
}

# resource "aws_eip" "prj_ec2_bastion_eip_dev" {
#   domain = "vpc"
#   tags = {
#     Name = "${var.project_name}-bastion-eip-${var.project_env}"
#   }
# }

# resource "aws_eip_association" "prj_bastion_eip_association_dev" {
#   instance_id   = aws_instance.prj_ec2_bastion_dev.id
#   allocation_id = aws_eip.prj_ec2_bastion_eip_dev.id
#   depends_on    = [aws_eip.prj_ec2_bastion_eip_dev]
# }
