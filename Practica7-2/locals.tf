locals {
  sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}" #recurso-project-prod-region
}

resource "random_string" "random_sufix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  s3_sufix = random_string.random_sufix.id
}