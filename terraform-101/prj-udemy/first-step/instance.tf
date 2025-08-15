// Create EC2 instance

// Change your AMI and instance type as well
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type["example"]

  subnet_id = module.vpc.public_subnets[0]

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  key_name = aws_key_pair.my_key.key_name

  user_data_replace_on_change = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/mykey-demo")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx"
    ]

  }

  # user_data = templatefile("${path.module}/templates/web.tpl", {
  #   "region" = var.aws_region
  #   "bucketname" = var.bucket_name
  # })


  tags = {
    Name = "ec2_web"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id


  ingress = {
    from_port        = 22
    to_port          = 22
    ptotocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress = {
    from_port        = 0
    to_port          = 0
    ptotocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_key_pair" "my_key" {
  key_name = "my_key_demo"
  // ssh-keygen -f mykey-demo
  public_key = file("${path.module}/mykey-demo.pub")

}
