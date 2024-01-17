locals {
  ingress = { for k, v in var.ingress_lists: k => v }
  egress = { for k, v in var.egress_lists: k => v }
  tags = {Name = var.name}
}


resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags,local.tags)
}

resource "aws_security_group_rule" "egress" {
  for_each = local.egress
  type              = "egress"
  security_group_id = aws_security_group.this.id

  description = lookup(each.value,"description",null)
  from_port = lookup(each.value,"from_port",0)
  to_port = lookup(each.value,"to_port",0)
  protocol = lookup(each.value,"protocol","all")
  cidr_blocks = lookup(each.value,"cidr_blocks",null)
  prefix_list_ids = lookup(each.value,"prefix_list_ids",null)
  source_security_group_id = lookup(each.value,"source_security_group_id", null)
  self = lookup(each.value,"self", null)
}

resource "aws_security_group_rule" "ingress" {
  for_each = local.ingress
  type              = "ingress"
  security_group_id = aws_security_group.this.id

  description = lookup(each.value,"description",null)
  from_port = lookup(each.value,"from_port",0)
  to_port = lookup(each.value,"to_port",0)
  protocol = lookup(each.value,"protocol","all")
  cidr_blocks = lookup(each.value,"cidr_blocks",null)
  prefix_list_ids = lookup(each.value,"prefix_list_ids",null)
  source_security_group_id = lookup(each.value,"source_security_group_id", null)
  self = lookup(each.value,"self", null)
}

