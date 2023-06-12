output "public_subnets_ids" {
  value = aws_subnet.public_subnets[*].id
}
output "private_subnets_ids" {
  value = aws_subnet.private_subnets[*].id
}
output "pub_sub_count" {value = local.pub_sub_count}
output "pri_sub_count" {value = local.pri_sub_count}
