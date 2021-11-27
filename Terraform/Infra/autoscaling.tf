    #creating launch configuration
    resource "aws_launch_configuration" "auto-launch" {
    name_prefix     = "auto-launch-config"
    image_id        = data.aws_ami.image.id
    instance_type   = "t2.micro"
    key_name        = "ub"
    security_groups = [aws_security_group.web-security.id]
    lifecycle {
        create_before_destroy = true
    }
    }
    #creating aws_autoscaling_group
    resource "aws_autoscaling_group" "auto-group" {
    name                      = "auto-group"
    max_size                  = 5
    min_size                  = 2
    health_check_grace_period = 300
    health_check_type         = "EC2"
    desired_capacity          = 2
    force_delete              = true
    launch_configuration      = aws_launch_configuration.auto-launch.name
    vpc_zone_identifier       = [aws_subnet.public[0].id, aws_subnet.public[1].id,aws_subnet.public[2].id, aws_subnet.public[3].id]
    }

    #creating aws_autoscaling_policy
    resource "aws_autoscaling_policy" "auto-policy" {
    name                      = "target-tracking-policy"
    adjustment_type           = "ChangeInCapacity"
    policy_type               = "TargetTrackingScaling"
    autoscaling_group_name    = aws_autoscaling_group.auto-group.name
    estimated_instance_warmup = 200

    target_tracking_configuration {
        predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = "60"
    }
    }

    #monitoring
    resource "aws_cloudwatch_metric_alarm" "auto-alarm" {
    alarm_name          = "metric alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = "55"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.auto-group.name
    }

    alarm_description = "This metric monitors ec2 cpu utilization"
    alarm_actions     = [aws_autoscaling_policy.auto-policy.arn]
    }