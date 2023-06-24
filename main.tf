# VPC
module "vpc" {
  source                     = "./modules/vpc"
  availability_zones         = var.availability_zones
  vpc_cidr_block             = var.vpc_cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  db_subnet_cidr_blocks      = var.db_subnet_cidr_blocks
}


# Security Groups
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

# Key Pair
module "key-pair" {
  source       = "./modules/key-pair"
  key_name     = "web-test"
  key_filename = "web-test.pem"
}


# EC2
module "ec2" {
  source             = "./modules/ec2"
  vpc_id             = module.vpc.vpc_id
  az                 = var.availability_zones
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  db_subnet_ids      = module.vpc.db_subnet_ids
  web_security_group = module.sg.app_sg_id
  key_pair           = module.key-pair.key_name
  ami                = var.ami
  type               = var.instance_type
}

# Load Balancer
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  alb_name          = var.load_balancer_name
  env               = var.env
  security_group    = module.sg.alb_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
  # certificate_arn
}


# Auto Scaling
module "asg" {
  source               = "./modules/asg"
  instance_id          = module.ec2.web_server_instance_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  security_groups_name = module.sg.app_sg_name
  key_name             = module.key-pair.key_name
  security_groups_id   = module.sg.app_sg_id
  alb_target_group_arn = module.alb.alb_target_group_arn
}