variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region para o Cloud NAT"
  type        = string
}

variable "nat_name" {
  description = "Nome do Cloud NAT"
  type        = string
}

variable "router_name" {
  description = "Nome do Cloud Router"
  type        = string
}

variable "network" {
  description = "Nome ou self_link da VPC network"
  type        = string
}

variable "create_router" {
  description = "Criar um novo Cloud Router ou usar existente"
  type        = bool
  default     = true
}

variable "router_asn" {
  description = "ASN do Cloud Router"
  type        = number
  default     = 64514
}

variable "router_advertise_mode" {
  description = "Modo de anúncio BGP (DEFAULT ou CUSTOM)"
  type        = string
  default     = "DEFAULT"
}

variable "router_advertised_groups" {
  description = "Grupos de rotas para anunciar"
  type        = list(string)
  default     = []
}

variable "router_advertised_ip_ranges" {
  description = "Ranges IP customizados para anunciar"
  type = list(object({
    range       = string
    description = optional(string)
  }))
  default = []
}

variable "nat_ip_allocate_option" {
  description = "Como alocar IPs para NAT (MANUAL_ONLY ou AUTO_ONLY)"
  type        = string
  default     = "AUTO_ONLY"
  validation {
    condition     = contains(["MANUAL_ONLY", "AUTO_ONLY"], var.nat_ip_allocate_option)
    error_message = "nat_ip_allocate_option deve ser MANUAL_ONLY ou AUTO_ONLY"
  }
}

variable "nat_ips" {
  description = "Lista de self_links de IPs externos existentes para usar no NAT"
  type        = list(string)
  default     = null
}

variable "nat_ips_count" {
  description = "Número de IPs estáticos para criar (quando nat_ip_allocate_option = MANUAL_ONLY)"
  type        = number
  default     = 1
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "Como especificar as subnetworks (ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS)"
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "subnetworks" {
  description = "Lista de subnetworks para configurar NAT (usado quando source_subnetwork_ip_ranges_to_nat = LIST_OF_SUBNETWORKS)"
  type = list(object({
    name                     = string
    source_ip_ranges_to_nat  = list(string)
    secondary_ip_range_names = optional(list(string))
  }))
  default = []
}

variable "min_ports_per_vm" {
  description = "Número mínimo de portas alocadas por VM"
  type        = number
  default     = 64
}

variable "max_ports_per_vm" {
  description = "Número máximo de portas alocadas por VM"
  type        = number
  default     = null
}

variable "enable_dynamic_port_allocation" {
  description = "Habilitar alocação dinâmica de portas"
  type        = bool
  default     = false
}

variable "enable_endpoint_independent_mapping" {
  description = "Habilitar endpoint independent mapping"
  type        = bool
  default     = false
}

variable "icmp_idle_timeout_sec" {
  description = "Timeout de idle para ICMP (segundos)"
  type        = number
  default     = 30
}

variable "tcp_established_idle_timeout_sec" {
  description = "Timeout de idle para conexões TCP estabelecidas (segundos)"
  type        = number
  default     = 1200
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "Timeout de idle para conexões TCP transitórias (segundos)"
  type        = number
  default     = 30
}

variable "tcp_time_wait_timeout_sec" {
  description = "Timeout para estado TIME_WAIT do TCP (segundos)"
  type        = number
  default     = 120
}

variable "udp_idle_timeout_sec" {
  description = "Timeout de idle para UDP (segundos)"
  type        = number
  default     = 30
}

variable "enable_logging" {
  description = "Habilitar logging do Cloud NAT"
  type        = bool
  default     = false
}

variable "log_filter" {
  description = "Filtro de logs (ALL, ERRORS_ONLY, TRANSLATIONS_ONLY)"
  type        = string
  default     = "ERRORS_ONLY"
  validation {
    condition     = contains(["ALL", "ERRORS_ONLY", "TRANSLATIONS_ONLY"], var.log_filter)
    error_message = "log_filter deve ser ALL, ERRORS_ONLY ou TRANSLATIONS_ONLY"
  }
}

variable "nat_rules" {
  description = "Regras avançadas de NAT"
  type = list(object({
    rule_number = number
    description = optional(string)
    match       = string
    action = object({
      source_nat_active_ips    = optional(list(string))
      source_nat_drain_ips     = optional(list(string))
      source_nat_active_ranges = optional(list(string))
      source_nat_drain_ranges  = optional(list(string))
    })
  }))
  default = []
}

variable "labels" {
  description = "Labels para os recursos"
  type        = map(string)
  default     = {}
}