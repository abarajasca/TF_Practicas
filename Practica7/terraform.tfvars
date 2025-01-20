virginia_cidr = "10.10.0.0/16"
# public_subnet = "10.10.0.0/24"
# private_subnet = "10.10.1.0/24"

# Sample to use workspace.
# virginia_cidr = {
#   "prod" = "10.10.0.0/16"
#   "dev" = "172.16.0.0/16"
# }

subnets = ["10.10.0.0/24", "10.10.1.0/24"]

tags = {
  "env"         = "dev"
  "owner"       = "User1"
  "cloud"       = "AWS"
  "IAC"         = "Terraform"
  "IAC_Version" = "1.9.7"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  "ami"           = "ami-06b21ccaeff8cd686"
  "instance_type" = "t2.micro"
}

enable_monitoring = false