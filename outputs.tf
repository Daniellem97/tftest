output "dev_ip2" {
    value     = "test"
    sensitive = true
}

resource "random_string" "example5" {
  length  = 8
}
