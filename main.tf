resource "aws_default_vpc" "this" {
  tags = var.vpc_tags
}

data "aws_availability_zones" "available" {}

resource "aws_default_subnet" "this" {
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = var.subnet_tags
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = aws_default_vpc.this.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = var.egress_rule.from_port
    to_port     = var.egress_rule.to_port
    protocol    = var.egress_rule.protocol
    cidr_blocks = var.egress_rule.cidr_blocks
  }
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_default_subnet.this.id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = var.key_name

  tags = var.instance_tags
}

resource "null_resource" "this" {
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    host        = aws_instance.this.public_ip
  }

  provisioner "file" {
    source      = var.script_source
    destination = var.script_destination
  }

  provisioner "remote-exec" {
    inline = [
      var.script_permission,
      var.script_execution
    ]
  }

  depends_on = [
    aws_instance.this
  ]
}
