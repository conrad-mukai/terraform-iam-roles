/*
 * IAM resources
 */

data "aws_iam_policy_document" "ec2-instance-assume-policy" {
  statement {
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2-instance-role" {
  name = "ec2-instance-role"
  description = "Allow EC2 instances to call ECS"
  assume_role_policy = "${data.aws_iam_policy_document.ec2-instance-assume-policy.json}"
}

resource "aws_iam_role_policy_attachment" "ec2-instance-role-attachment" {
  policy_arn = "${var.ec2-instance-policy}"
  role = "${aws_iam_role.ec2-instance-role.name}"
}

resource "aws_iam_instance_profile" "ec2-instance-profile" {
  name = "ec2-instance-profile"
  role = "${aws_iam_role.ec2-instance-role.name}"
}

data "aws_iam_policy_document" "ecs-service-assume-policy" {
  statement {
    principals {
      identifiers = ["ecs.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs-service-role" {
  name = "ecs-service-role"
  description = "Allow the ECS service to call EC2 (register instances with load balancer)"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-service-assume-policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  policy_arn = "${var.ecs-service-policy}"
  role = "${aws_iam_role.ecs-service-role.name}"
}

data "aws_iam_policy_document" "autoscale-ecs-assume-policy" {
  statement {
    principals {
      identifiers = ["application-autoscaling.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "autoscale-ecs-role" {
  name = "autoscale-ecs-role"
  description = "Allow autoscaling to call ECS"
  assume_role_policy = "${data.aws_iam_policy_document.autoscale-ecs-assume-policy.json}"
}

resource "aws_iam_role_policy_attachment" "autoscale-ecs-role-attachment" {
  policy_arn = "${var.autoscale-ecs-policy}"
  role = "${aws_iam_role.autoscale-ecs-role.name}"
}

data "aws_iam_policy_document" "snapshot-policy" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DeleteSnapshot",
      "ec2:CreateSnapshot",
      "ec2:DescribeVolumes",
      "ec2:CreateTags"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "allow-snapshots-policy" {
  name = "AllowSnapshots"
  description = "Manage EBS snapshots for backups."
  policy = "${data.aws_iam_policy_document.snapshot-policy.json}"
}

data "aws_iam_policy_document" "allow-put-metrics-policy" {
  statement {
    actions = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "allow-put-metrics-policy" {
  name = "AllowPutMetrics"
  description = "Allow push of metrics to CloudWatch"
  policy = "${data.aws_iam_policy_document.allow-put-metrics-policy.json}"
}

resource "aws_iam_role" "infra-instance-role" {
  name = "infra-instance-role"
  description = "Allow infra instance to create snapshots and put metrics into CloudWatch"
  assume_role_policy = "${data.aws_iam_policy_document.ec2-instance-assume-policy.json}"
}

resource "aws_iam_role_policy_attachment" "infra-instance-role-attachment-1" {
  policy_arn = "${aws_iam_policy.allow-snapshots-policy.arn}"
  role = "${aws_iam_role.infra-instance-role.name}"
}

resource "aws_iam_role_policy_attachment" "infra-instance-role-attachment-2" {
  policy_arn = "${aws_iam_policy.allow-put-metrics-policy.arn}"
  role = "${aws_iam_role.infra-instance-role.name}"
}

resource "aws_iam_instance_profile" "infra-instance-profile" {
  name = "infra-instance-profile"
  role = "${aws_iam_role.infra-instance-role.name}"
}
