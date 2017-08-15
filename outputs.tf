/*
 * Outputs for the roles module
 */

output "ec2_instance_profile" {
  value = "${aws_iam_instance_profile.ec2-instance-profile.name}"
}

output "ecs_service_role_arn" {
  value = "${aws_iam_role.ecs-service-role.arn}"
}

output "autoscale_ecs_role_arn" {
  value = "${aws_iam_role.autoscale-ecs-role.arn}"
}

output "infra_instance_profile" {
  value = "${aws_iam_instance_profile.infra-instance-profile.name}"
}
