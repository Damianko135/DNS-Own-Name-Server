terraform {
    required_providers {
        dns = {
            source  = "hashicorp/dns"
            version = "3.4.0"
        }
    }
}

variable "tsig_key" {
    type = string
    sensitive = true 
}

## Configure the dns server
provider "dns" {
    update {
      server = "172.16.1.1"
      key_name = "tsig-key"
      key_algorithm = "hmac-sha256"
      key_secret = var.tsig_key
    }
}
