resource "random_string" "sufijo" {
    count = 5
    length = 4
    upper = false
    numeric = false
    special = false
}