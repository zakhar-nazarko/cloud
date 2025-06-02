# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "lambda-alerts-topic"
}

# Email subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "nazarkozakhar@gmail.com"
}

# Slack notifications via notify-slack module
module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 5.0"

  sns_topic_name    = aws_sns_topic.alerts.name
  slack_webhook_url = "https://hooks.slack.com/services/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"
  slack_channel     = "#general"
  slack_username    = "aws-monitor"
}

# CloudWatch Alarm on every Lambda invocation
resource "aws_cloudwatch_metric_alarm" "lambda_invocations" {
  for_each = toset(var.lambda_functions)

  alarm_name          = "${each.value}-invocation-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Invocations"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  alarm_description = "Alarm when ${each.value} is invoked"
  dimensions = {
    FunctionName = each.value
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}
