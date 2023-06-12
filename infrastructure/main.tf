

module "vpc" {
    source   = "./vpc"
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "webapp-vpc"

}

module "subnets"{
    source = "./subnets"
    vpc_id = module.vpc.vpc_id
    vpc_igw_id = module.vpc.vpc_igw_id

    public_subnets_cidrs  = ["10.0.1.0/24","10.0.2.0/24"]
    private_subnets_cidrs = ["10.0.3.0/24","10.0.4.0/24"]

    # index of the public subnet to put ngw into.
    pub_sub_index_to_put_ngw = 0

    public_subnet_mapPubIps = true
    eip_vpc                 = true
    
    public_rt_cidr = "0.0.0.0/0"
    private_rt_cidr = "0.0.0.0/0"

}





















# module "sg"{
#     source = "./sg"
#     vpc_id = module.vpc.vpc_id

#     sg_http_port = 80
#     sg_http_protocol = "tcp"
#     sg_http_cidrs = ["0.0.0.0/0"]

#     sg_https_port = 443
#     sg_https_protocol = "tcp"
#     sg_https_cidrs = ["0.0.0.0/0"]

#     sg_ssh_port = 22
#     sg_ssh_protocol = "tcp"
#     sg_ssh_cidrs = ["0.0.0.0/0"]

#     sg_egress_from_port = 0
#     sg_egress_to_port = 0
#     sg_egress_protocol = "-1"
#     sg_egress_cidrs = ["0.0.0.0/0"]

# }

# module "ec2s" {
#     source = "./ec2"  
#     sg_id = module.sg.sg_id
#     public_subnets_ids = module.subnets.public_subnets_ids
#     private_subnets_ids = module.subnets.private_subnets_ids
#     private_dns = module.lb.private_dns
#     pub_sub_count = module.subnets.pub_sub_count
#     pri_sub_count = module.subnets.pri_sub_count

#     public_ec2s_per_subnet = 1
#     private_ec2s_per_subnet = 1
#     #public_ec2_user_data = templatefile("${path.module}/ec2/public_user_data.tftpl",{dnss = module.lb.private_dns})
#     private_ec2_user_data = file("${path.module}/ec2/private_user_data.tftpl")
#     ec2_type = "t2.micro"
#     ec2_vol_size = 10
#     ec2_replace_on_data_change = true
#     ec2_key_name = "aws_key2"
# }

# module "lb" {
#     source = "./lb"
#     vpc_id = module.vpc.vpc_id
#     sg_id = module.sg.sg_id
#     public_subnets_ids = module.subnets.public_subnets_ids
#     private_subnets_ids = module.subnets.private_subnets_ids
#     private_ec2s_ids = module.ec2s.private_ec2s_ids
#     public_ec2s_ids  = module.ec2s.public_ec2s_ids
# }
