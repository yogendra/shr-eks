variable "project-name" {
  type = string
  description = "project-name"
}
variable "project-root-domain" {
  type = string
  description = "project root domain"
}
variable "project-owner" {
  type = string
  description = "project owner"
}
variable "project-owner-email" {
  type = string
  description = "project owner email"
}
variable tags {
  type = map(string)
  description = "Common tags for project resources"
  default = {
    yb_task    = "demo"
    yb_env     = "demo"

  }
}

variable "project-cidr" {
  type = string
  description = "Project CIDR"
  default = "10.97.0.0/16"
}
variable "cluster_service_ipv4_cidr" {
  type = string
  description = "EKS Service CIDR"
  default = "10.100.0.0/16"
}

variable "project-domain" {
  type = string
  description = "Project Domain"
  default = null
}

variable "yba-domain" {
  type = string
  description = "YBA Domain"
  default = null
}
variable "yba-prometheus-domain" {
  type = string
  description = "YBA Prometheus Domain"
  default = null
}

variable "yba-username" {
  type = string
  description = "YBA Username"
  default = "superadmin@yugabyte.com"
}
variable "yba-password" {
  type = string
  description = "YBA Username"
  default = "Password#123"
}
variable "eks-version" {
  type = string
  description = "YBA Version"
  default = "1.27"
}
variable "yba-version" {
  type = string
  description = "YBA Version"
  default = "v2.18.2"
}
variable "eks-worker-type" {
  type = string
  description = "YBA Username"
  default = "m6a.2xlarge"
}

variable "yugabyte_k8s_pull_secret" {
  type = string
  description = "YBA K8s Pull Secret"
  default = null
}
