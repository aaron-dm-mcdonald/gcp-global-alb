variable "region_a" {
  default = "europe-north1"
  type    = string
}

variable "subnet_a_cidr" {
  default = "10.100.10.0/24"
  type = string
}

variable "subnet_b_cidr" {
  default = "10.100.20.0/24"
  type = string
}

variable "region_b" {
  default = "asia-northeast1"
  type    = string
}


variable "app_name" {
  default = "test"
  type    = string
}

variable "backend_port_name" {
   default = "webserver"
   type    = string 
}