output "subnet_info" {
  description = "The info for the created subnets"
  value = {
    var.public_subnet_config
  }
}