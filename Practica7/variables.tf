variable "virginia_cidr" {
  description = "CIDR Virginia"
  type        = string
  sensitive   = false
}

# # Example using workspace
# variable "virginia_cidr" {
#   description = "CIDR Virginia"
#   type        = map(string)
#   sensitive   = false
# }

# variable "public_subnet" {
#     description = "CIDR public subnet"
#     type = string
# }

# variable "private_subnet" {
#     description = "CIDR privat subnet"
#     type = string
# }

variable "subnets" {
  description = "Lista de subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags del proyecto"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR for ingress traffic"
  type        = string
}

variable "ec2_specs" {
  description = "Parametros de la instancia"
  type        = map(string)
}

variable "enable_monitoring" {
  description = "Monitoring option"
  type        = bool
  default     = false
}