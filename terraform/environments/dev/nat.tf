# # Exemplo 1: NAT Automático (IPs alocados automaticamente)
# module "nat_auto" {
#   source = "../../modules/networking/nat"

#   project_id  = var.project_id
#   region      = "us-central1"
#   nat_name    = "nat-gateway-auto"
#   router_name = "nat-router-auto"
#   network     = var.network_name

#   nat_ip_allocate_option = "AUTO_ONLY"

#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

#   enable_logging = true
#   log_filter     = "ERRORS_ONLY"

#   min_ports_per_vm = 64
#   max_ports_per_vm = 512

#   enable_endpoint_independent_mapping = true

#   icmp_idle_timeout_sec            = 30
#   tcp_established_idle_timeout_sec = 1200
#   tcp_transitory_idle_timeout_sec  = 30
#   udp_idle_timeout_sec             = 30
# }

# # Exemplo 2: NAT com IPs Estáticos Específicos
# module "nat_static" {
#   source = "../../modules/networking/nat"

#   project_id  = var.project_id
#   region      = "us-east1"
#   nat_name    = "nat-gateway-static"
#   router_name = "nat-router-static"
#   network     = var.network_name

#   nat_ip_allocate_option = "MANUAL_ONLY"
#   nat_ips_count          = 2 # Criar 2 IPs estáticos

#   source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

#   subnetworks = [
#     {
#       name                     = "private-subnet-1"
#       source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
#       secondary_ip_range_names = []
#     },
#     {
#       name                     = "private-subnet-2"
#       source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE"]
#       secondary_ip_range_names = []
#     }
#   ]

#   enable_logging = true
#   log_filter     = "ALL"

#   enable_dynamic_port_allocation = true
#   min_ports_per_vm               = 32
# }

# # Exemplo 3: NAT com IPs Externos Existentes
# module "nat_existing_ips" {
#   source = "../../modules/networking/nat"

#   project_id  = var.project_id
#   region      = "europe-west1"
#   nat_name    = "nat-gateway-existing"
#   router_name = "nat-router-existing"
#   network     = var.network_name

#   create_router = true # Create router since it doesn't exist
#   # router_name   = "existing-router"

#   nat_ip_allocate_option = "MANUAL_ONLY"
#   nat_ips                = ["projects/my-project/regions/europe-west1/addresses/my-static-ip"]

#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

#   enable_logging = false
# }
