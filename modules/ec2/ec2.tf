#ami id나 filter 받는 경우
# 여러 대 생성하는 경우


#ami


data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Amazon Linux*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


# instance
resource "aws_instance" "ec2_instance" {

  ami                    = data.aws_ami.amazon_linux.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  iam_instance_profile = var.create_iam_instance_profile ? aws_iam_instance_profile.this[0].name : null
  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }
  tags = var.tags

}

# ssm



data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create_iam_instance_profile ? 1 : 0

  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create_iam_instance_profile ? 1 : 0

  name        = var.iam_role_name
  description = "ec2 ssm role"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  force_detach_policies = true
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in var.iam_role_policies : k => v if var.create_iam_instance_profile }

  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_iam_instance_profile ? 1 : 0

  role = aws_iam_role.this[0].name
  name        = var.iam_role_name
  tags = var.tags

}


#eip

resource "aws_eip" "bastion_ip" {
  instance = aws_instance.ec2_instance.id
  vpc      = true
}

