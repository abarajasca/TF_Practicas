resource "aws_s3_bucket" "proveedores" {
  count = 5
  bucket = "abc-proveedores-bucket-test1-${random_string.sufijo[count.index].id}"

  tags = {
    owner   = "abc"
    departament = "ventas",
    env = "prod"
  }
}

resource "random_string" "sufijo" {
    count = 5
    length = 8
    upper = false
    numeric = false
    special = false
}
