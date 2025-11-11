variable "topic_name" {
  description = "The name of the Pub/Sub topic."
  type        = string
}

variable "message_retention_duration" {
  description = "The amount of time to retain messages in the topic."
  type        = string
}


variable "subscription_name" {
  description = "The name of the Pub/Sub subscription."
  type        = string
}