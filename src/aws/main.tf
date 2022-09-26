terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.75.2"
        }
    }
}

variable "aws_region" {}

variable "base_cidr_block" {
    description = "A /16 CIDR range definition, such as 10.1.0.0/16, that the VPC will use"
    default = "10.1.0.0/16"
}

variable "availability_zones" {
    description = "A list of availabitity zones in which to create subnet"
    type = list(string)
}

provider "aws" {
    region = var.aws_region
}

resource "aws_vpc" "test_vpc" {
    cidr_block = var.base_cidr_block
}

resource "aws_subnet" "az" {
    count = length(var.availability_zones)
    availability_zone = var.availability_zones[count.index]
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = cidrsubnet(aws_vpc.test_vpc.cidr_block, 4, count.index + 1)
}