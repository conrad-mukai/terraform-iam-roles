# IAM Roles Module

## Description

This module creates IAM roles used by other terraform modules. The module takes
no inputs.

## IAM Roles

| Name | Description |
| ---- | ----------- |
| `autoscale-ecs-role` | Allow autoscaling to call ECS |
| `ec2-instance-role` | Allow EC2 instances to call ECS |
| `ecs-service-role` | Allow the ECS service to call EC2 (register instances with load balancer) |
| `infra-instance-role` | Allow infra instance to create snapshots and put metrics into CloudWatch |

## Outputs

| Name | Description |
| ---- | ----------- |
| `autoscale_ecs_role_arn` | ARN for the autoscale-ecs-role role |
| `ec2_instance_profile` | Instance profile for the ec2-instance-role role |
| `ecs_service_role_arn` | ARN for the ecs-service-role role |
| `infra_instance_profile` | Instance profile for the infra-instance-role role |