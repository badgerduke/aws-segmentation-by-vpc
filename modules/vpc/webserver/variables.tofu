variable "vpc_id" {
  description = "The ID of the VPC to place the webserver"
  type = string
}

variable "load_balancer_security_group_id" {
  description = "The Id of the load balancer security group"
  type = string
}

variable "webserver_config" {
    description = "Configuration for webserver"
    type = object({
        key    = string
        instance_tag_name    = string
        instance_role_name   = string
        user_data_file      = string
        message  = string
        subnet_id = string
    })
}
