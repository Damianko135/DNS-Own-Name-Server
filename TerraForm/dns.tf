resource "dns_a_record_set" "example" {
  zone = "internal_domain.example.com."  # Ensure the FQDN ends with a dot (.)
  name = "easy"
  ## Very handy if you have a load balancer, which would need multiple IP addresses
  addresses = [
    "192.168.1.1",
    "192.168.1.2",
    "192.168.1.3",
  ]
  ttl = 36000  
}
