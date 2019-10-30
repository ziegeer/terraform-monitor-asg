module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 1.0"

  sns_topic_name = "slack-topic"

  slack_webhook_url = "${var.slack_webhook_url}"
  slack_channel     = "it-sre-bot"
  slack_username    = "AWS"
}

# Make cloudwatch alerts for specified ASGs 
resource "aws_cloudwatch_metric_alarm" "asg_zero" {
  count               = "${length(var.asgs)}"
  alarm_name          = "testasg ASG has no instances"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = "${var.minimum_instances}"
  alarm_description   = "Alert if any AutoScalingGroup has no instances"
  alarm_actions       = ["${module.notify_slack.this_slack_topic_arn}"]
  ok_actions          = ["${module.notify_slack.this_slack_topic_arn}"]
  actions_enabled     = true
  metric_name         = "GroupTotalInstances"
  namespace           = "AWS/AutoScaling"
  period              = "60"
  statistic           = "Sum"

  dimensions {
    AutoScalingGroupName = "${var.asgs[count.index]}"
  }
}
