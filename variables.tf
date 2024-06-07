variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_tags" {
  description = "Tags for the default VPC"
  type        = map(string)
  default = {
    Name = "Jenkin_VPC"
  }
}

variable "subnet_tags" {
  description = "Tags for the default subnet"
  type        = map(string)
  default = {
    Name = "jenkins_sub"
  }
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "Jenkins_sec"
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
  default     = "Allow port 22 and 8080 inbound for jenkins"
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Jenkins ssh access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS jenkins access"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "egress_rule" {
  description = "Egress rule"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-01e444924a2233b07"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name for the instance"
  type        = string
  default     = "toluwebserverkey"
}

variable "instance_tags" {
  description = "Tags for the instance"
  type        = map(string)
  default = {
    Name = "Jenkins_server"
  }
}

variable "ssh_user" {
  description = "SSH user"
  type        = string
  default     = "ubuntu"
}

variable "private_key_path" {
  description = "Path to the private key"
  type        = string
  default     = "C:/Users/deaja/awskeys/toluwebserverkey.pem"
}

variable "script_source" {
  description = "Source path of the Jenkins installation script"
  type        = string
  default     = "install_jenkins.sh"
}

variable "script_destination" {
  description = "Destination path of the Jenkins installation script on the instance"
  type        = string
  default     = "/tmp/install_jenkins.sh"
}

variable "script_permission" {
  description = "Permission setting for the Jenkins installation script"
  type        = string
  default     = "sudo chmod -x /tmp/install_jenkins.sh"
}

variable "script_execution" {
  description = "Command to execute the Jenkins installation script"
  type        = string
  default     = "sh /tmp/install_jenkins.sh"
}


