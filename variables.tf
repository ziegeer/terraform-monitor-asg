variable "slack_webhook_url" {}
variable "slack_channel" {}

variable "asgs" {
  type        = "list"
  description = "AWS ASGs to monitor"
}

variable "slack_username" {
  default = "AWS"
}

variable "minimum_instances" {
  default = "0"
}
