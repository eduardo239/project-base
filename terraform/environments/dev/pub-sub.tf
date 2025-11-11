module "pub-sub" {
  source = "../../modules/pub-sub"
  topic_name = "dev-topic"
  subscription_name = "dev-subscription"
  message_retention_duration = var.message_retention_duration

}