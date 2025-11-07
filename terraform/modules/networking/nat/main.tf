# Cloud Router (se não existir)
resource "google_compute_router" "router" {
  count = var.create_router ? 1 : 0

  name    = var.router_name
  project = var.project_id
  region  = var.region
  network = var.network

  bgp {
    asn               = var.router_asn
    advertise_mode    = var.router_advertise_mode
    advertised_groups = var.router_advertised_groups

    dynamic "advertised_ip_ranges" {
      for_each = var.router_advertised_ip_ranges
      content {
        range       = advertised_ip_ranges.value.range
        description = try(advertised_ip_ranges.value.description, null)
      }
    }
  }
}

# Obter referência do router (existente ou criado)
data "google_compute_router" "router" {
  count = var.create_router ? 0 : 1

  name    = var.router_name
  project = var.project_id
  region  = var.region
  network = var.network
}

locals {
  router_name = var.create_router ? google_compute_router.router[0].name : data.google_compute_router.router[0].name
}

# Endereços IP Estáticos para NAT (se necessário)
resource "google_compute_address" "nat_ips" {
  count = var.nat_ip_allocate_option == "MANUAL_ONLY" && var.nat_ips == null ? var.nat_ips_count : 0

  name         = "${var.nat_name}-ip-${count.index + 1}"
  project      = var.project_id
  region       = var.region
  address_type = "EXTERNAL"

  labels = var.labels
}

locals {
  # Determinar quais IPs usar
  nat_ip_ids = (
    var.nat_ip_allocate_option == "MANUAL_ONLY" && var.nat_ips != null ? var.nat_ips :
    var.nat_ip_allocate_option == "MANUAL_ONLY" ? google_compute_address.nat_ips[*].self_link :
    []
  )
}

# Cloud NAT
resource "google_compute_router_nat" "nat" {
  name    = var.nat_name
  project = var.project_id
  region  = var.region
  router  = local.router_name

  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = local.nat_ip_ids
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  # Configuração de Subnetworks
  dynamic "subnetwork" {
    for_each = var.subnetworks
    content {
      name                     = subnetwork.value.name
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = try(subnetwork.value.secondary_ip_range_names, [])
    }
  }

  # Configuração de Portas
  min_ports_per_vm               = var.min_ports_per_vm
  max_ports_per_vm               = var.max_ports_per_vm
  enable_dynamic_port_allocation = var.enable_dynamic_port_allocation

  # Endpoint Independent Mapping
  enable_endpoint_independent_mapping = var.enable_endpoint_independent_mapping

  # Timeouts
  icmp_idle_timeout_sec            = var.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec  = var.tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec        = var.tcp_time_wait_timeout_sec
  udp_idle_timeout_sec             = var.udp_idle_timeout_sec

  # Logging
  dynamic "log_config" {
    for_each = var.enable_logging ? [1] : []
    content {
      enable = true
      filter = var.log_filter
    }
  }

  # Rules (para configurações avançadas de NAT)
  dynamic "rules" {
    for_each = var.nat_rules
    content {
      rule_number = rules.value.rule_number
      description = try(rules.value.description, null)
      match       = rules.value.match

      dynamic "action" {
        for_each = [rules.value.action]
        content {
          source_nat_active_ips    = try(action.value.source_nat_active_ips, [])
          source_nat_drain_ips     = try(action.value.source_nat_drain_ips, [])
          source_nat_active_ranges = try(action.value.source_nat_active_ranges, [])
          source_nat_drain_ranges  = try(action.value.source_nat_drain_ranges, [])
        }
      }
    }
  }
}
