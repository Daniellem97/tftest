output "dev_ip2" {
    value     = "test"
    sensitive = true
}

resource "random_string" "example" {
  length  = 8
}

output "trigger" {
  value     = random_string.example.result
}
