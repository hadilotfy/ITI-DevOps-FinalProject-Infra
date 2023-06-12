# computed vars to help in creating subnets
locals {
  pub_sub_count = length(var.public_subnets_cidrs)
  pri_sub_count = length(var.private_subnets_cidrs)
#  subnets_count = local.pub_count + local.pri_count
  num_of_zones = length(data.aws_availability_zones.azones.zone_ids)
}
