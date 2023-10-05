terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    yba = {
      source  = "yugabyte/yba"
    }
  }
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}
locals {

  project-name              = var.project-name
  project-cidr              = var.project-cidr
  cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr
  project-root-domain       = var.project-root-domain
  eks-version               = var.eks-version
  project-domain            = (var.project-domain == null)? "${local.project-name}.${local.project-root-domain}": var.project-domain
  yba-domain                = "yba.${local.project-domain}"
  yba-api-url               = "https://${local.yba-domain}/api/v1"
  yba-username              = var.yba-username
  yba-password              = var.yba-password
  azs                       = slice(data.aws_availability_zones.available.names, 0, 3)
  eks-worker-type           = var.eks-worker-type
  yugabyte_k8s_pull_secret  = var.yugabyte_k8s_pull_secret == null ? "${path.root}/private/yugabyte-k8s-pull-secret.yaml": var.yugabyte_k8s_pull_secret
  owner-email               = var.project-owner-email
  yba-version               = var.yba-version

  # azs           = ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]
  private-subnets = [for k, v in local.azs : cidrsubnet(local.project-cidr, 4, k)]
  public-subbets  = [for k, v in local.azs : cidrsubnet(local.project-cidr, 8, k + 48)]
  intra-subnets   = [for k, v in local.azs : cidrsubnet(local.project-cidr, 8, k + 52)]

  # public-cidrs  = [for index, az in(local.azs) : cidrsubnet(local.project-cidr, 4, index)]
  # private-cidrs = [for index, az in local.azs : cidrsubnet(local.project-cidr, 4, length(local.azs) + index)]
  tags = merge(var.tags,{
    yb_owner   = var.project-owner
    yb_project = local.project-name
  })
  ebs_csi_service_account_namespace = "kube-system"
  ebs_csi_service_account_name      = "ebs-csi-controller-sa"
}

data "aws_route53_zone" "project-hosted-zone" {
  private_zone = false
  name         = "${local.project-root-domain}."
}
