/*
 * Outputs for the roles module
 */

output "ec2_instance_profile" {
  value = "${aws_iam_role.ec2-instance-role.name}"
}

output "ecs_service_role_arn" {
  value = "${aws_iam_role.ecs-service-role.arn}"
}

output "autoscale_ecs_role_arn" {
  value = "${aws_iam_role.autoscale-ecs-role.arn}"
}

output "infra_instance_profile" {
  value = "${aws_iam_role.infra-instance-role.name}"
}
