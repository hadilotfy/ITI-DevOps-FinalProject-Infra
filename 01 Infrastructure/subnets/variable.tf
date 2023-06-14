variable "vpc_id" {type = string}
variable "vpc_igw_id" {type = string}

variable "pub_sub_index_to_put_ngw" {
    type = number
    description = "index of the public subnet to put ngw into."
}

# subnets are to be distributed to available availbility zones in the region.
variable "public_subnets_cidrs"     { type = list(string) }
variable "private_subnets_cidrs"    { type = list(string) }

variable "public_subnet_mapPubIps" { type = bool}

variable "eip_vpc" { type = bool}

variable "public_rt_cidr" { type = string}

variable "private_rt_cidr" { type = string}