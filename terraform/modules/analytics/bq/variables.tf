variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "dataset_id" {
  description = "ID único do dataset"
  type        = string
  default     = "ds_analytics"
}

variable "dataset_name" {
  description = "Nome amigável do dataset"
  type        = string
  default     = "Analytics Dataset"
}

variable "description" {
  description = "Descrição do dataset"
  type        = string
  default     = "Dataset para análises de dados"
}

variable "location" {
  description = "Localização do dataset (US, EU, etc)"
  type        = string
  default     = "US"
}

variable "default_table_expiration_ms" {
  description = "Tempo de expiração padrão para tabelas (em ms)"
  type        = number
  default     = 36000000 # 1 hora em milissegundos
}

variable "default_partition_expiration_ms" {
  description = "Tempo de expiração padrão para partições (em ms)"
  type        = number
  default     = 311040000 # 1 dia em milissegundos
}

variable "labels" {
  description = "Labels para o dataset"
  type        = map(string)
  default     = {}
}

variable "delete_contents_on_destroy" {
  description = "Deletar conteúdo ao destruir o dataset"
  type        = bool
  default     = false
}

variable "encryption_key" {
  description = "KMS key para criptografia"
  type        = string
  default     = null
}

variable "access_roles" {
  description = "Lista de roles de acesso ao dataset"
  type = list(object({
    role           = string
    user_by_email  = optional(string)
    group_by_email = optional(string)
    domain         = optional(string)
    special_group  = optional(string)
    view = optional(object({
      project_id = string
      dataset_id = string
      table_id   = string
    }))
  }))
  default = []
}

variable "tables" {
  description = "Lista de tabelas para criar"
  type = list(object({
    table_id            = string
    description         = optional(string)
    schema              = optional(string)
    labels              = optional(map(string))
    deletion_protection = optional(bool)
    expiration_time     = optional(number)
    time_partitioning = optional(object({
      type                     = string
      field                    = optional(string)
      expiration_ms            = optional(number)
      require_partition_filter = optional(bool)
    }))
    range_partitioning = optional(object({
      field = string
      range = object({
        start    = number
        end      = number
        interval = number
      })
    }))
    clustering = optional(list(string))
  }))
  default = []
}

variable "views" {
  description = "Lista de views para criar"
  type = list(object({
    view_id             = string
    description         = optional(string)
    query               = string
    use_legacy_sql      = optional(bool)
    labels              = optional(map(string))
    deletion_protection = optional(bool)
  }))
  default = []
}

variable "materialized_views" {
  description = "Lista de materialized views"
  type = list(object({
    view_id                          = string
    description                      = optional(string)
    query                            = string
    enable_refresh                   = optional(bool)
    refresh_interval_ms              = optional(number)
    allow_non_incremental_definition = optional(bool)
    labels                           = optional(map(string))
  }))
  default = []
}

variable "scheduled_queries" {
  description = "Lista de queries agendadas"
  type = list(object({
    display_name       = string
    query              = string
    schedule           = string
    destination_table  = optional(string)
    write_disposition  = optional(string)
    partitioning_field = optional(string)
    disabled           = optional(bool)
  }))
  default = []
}

variable "iam_bindings" {
  description = "IAM bindings para o dataset"
  type        = map(list(string))
  default     = {}
}