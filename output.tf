output "jenkins_url" {
  value = join("", ["http://", aws_instance.this.public_dns, ":", "8080"])
}