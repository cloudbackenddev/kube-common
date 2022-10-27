locals {
  helm_repository     = "https://charts.jetstack.io"
  official_chart_name = "cert-manager"
}

data "aws_caller_identity" "current" {}

#
# Helm values
#
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")
  vars = {
    awsAccountID       = data.aws_caller_identity.current.account_id
    clusterName        = var.cluster_name
    serviceAccountName = local.official_chart_name
    chartName          = local.official_chart_name
  }
}


module "cert-manager" {
  source = "github.com/cloudbackenddev/kube-common//terraform-modules/aws/helm/helm_generic"

  repository          = local.helm_repository
  official_chart_name = local.official_chart_name
  user_chart_name     = var.user_chart_name
  helm_version        = var.helm_chart_version
  namespace           = var.k8s_namespace
  helm_values         = data.template_file.helm_values.rendered
  helm_values_2       = var.helm_values_2

}
