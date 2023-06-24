region                     = "us-east-2"
availability_zones         = ["us-east-2a", "us-east-2b"]
env                        = "Dev"
vpc_cidr_block             = "10.0.0.0/16"
public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
db_subnet_cidr_blocks      = ["10.0.5.0/24", "10.0.6.0/24"]

# EC2
instance_type = "t2.micro"
ami           = "ami-0331ebbf81138e4de"



# Load Balancer
load_balancer_name = "Blog-LB"