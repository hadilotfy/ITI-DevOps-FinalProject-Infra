# Public Subnets
resource "aws_subnet" "public_subnets"{
    vpc_id = var.vpc_id
    count = local.pub_sub_count
    cidr_block = var.public_subnets_cidrs[count.index]
    availability_zone = data.aws_availability_zones.azones.names[count.index % local.num_of_zones]
    # ture if use: public k8s instance groups
    map_public_ip_on_launch = var.public_subnet_mapPubIps
    tags = {
      "Name" = ""
      # to be used for private lb creation
      "kubernetes.io/role/elb" = "1"
      # owned : if  used by cluster only, 
      # shared: if used by other resources
      "kubernetes.io/cluster/app-k8s-cluster" = "owned"      #<<<<<<<<<<<<  app-k8s-cluster is the cluster name?????????????????????????
    }
}

# Private Subnets
resource "aws_subnet" "private_subnets"{
    vpc_id = var.vpc_id
    count = local.pri_sub_count
    cidr_block = var.private_subnets_cidrs[count.index]
    availability_zone = data.aws_availability_zones.azones.names[count.index % local.num_of_zones]
    tags = {
      "Name" = "private-subnet-${count.index}}"
      # to be used for private lb creation
      "kubernetes.io/role/internal-elb" = "1"
      # owned : if  used by cluster only, 
      # shared: if used by other resources
      "kubernetes.io/cluster/app-k8s-cluster" = "owned"      #<<<<<<<<<<<<  app-k8s-cluster is the cluster name????????????????????? 
    }
}

# elastic ip
resource "aws_eip" "eip" {
    vpc = var.eip_vpc
    tags = {
      "Name" = "WebApp-EIP"
    }
}
# ngw
resource "aws_nat_gateway" "ngw" {
    subnet_id = aws_subnet.public_subnets[var.pub_sub_index_to_put_ngw].id
    allocation_id = aws_eip.eip.id
    tags = {
      "Name" = "WebApp-NGW"
    }
}
# Public Routing Table
resource "aws_route_table" "public_rt" {
    vpc_id = var.vpc_id
    route {
        cidr_block = var.public_rt_cidr
        gateway_id = var.vpc_igw_id
    }
    tags = {
      "Name" = "WebApp-Private-RT"
    }
}
# Private Routing Table
resource "aws_route_table" "private_rt" {
    vpc_id = var.vpc_id
    route {
        cidr_block = var.private_rt_cidr
        gateway_id = aws_nat_gateway.ngw.id
    }
    tags = {
      "Name" = "WebApp-Public-RT"
    }
}


# public rt associations
resource "aws_route_table_association" "public_rtas" {
    count = local.pub_sub_count
    subnet_id =  aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

# private rt associations
resource "aws_route_table_association" "private_rtas" {
    count = local.pri_sub_count
    subnet_id =  aws_subnet.private_subnets[count.index].id
    route_table_id = aws_route_table.private_rt.id
}
