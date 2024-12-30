data "aws_ami" "talos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["talos-v1.8.4-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["540036508848"]
}

resource "aws_instance" "talos" {
  ami           = data.aws_ami.talos.id
  instance_type = "m6a.large"

  instance_market_options {
    market_type = "spot"
  }
}

resource "aws_eip" "l2ip" {
  instance = aws_instance.talos.id
}
