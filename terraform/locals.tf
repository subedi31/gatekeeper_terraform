locals {
  name = "gatekeeper"

  default_helm_config = {
    name       = local.name
    chart      = local.name
    repository = "https://open-policy-agent.github.io/gatekeeper/charts"
    version    = "3.9.0"
    namespace  = "gatekeeper-system"
    values = [
      <<-EOT
        clusterName: ${var.addon_context.eks_cluster_id}
      EOT
    ]
    description      = "gatekeeper Helm Chart deployment configuration"
    create_namespace = true
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  argocd_gitops_config = {
    enable      = true
    clusterName = var.addon_context.eks_cluster_id
  }
  addon_context = object({
    aws_caller_identity_account_id = "${data.aws_caller_identity.current.account_id}"
    aws_caller_identity_arn        = "${data.aws_caller_identity.current.arn}"
    aws_eks_cluster_endpoint       = "https://FD56FAC364424987C4C26267C5D5AE59.sk1.us-west-1.eks.amazonaws.com"
    aws_partition_id               = "${data.aws_partition.current.partition}"
    aws_region_name                = "us-west-1"
    eks_cluster_id                 = "gitaction"
    eks_oidc_issuer_url            = "https://oidc.eks.us-west-1.amazonaws.com/id/FD56FAC364424987C4C26267C5D5AE59"
    eks_oidc_provider_arn          = "arn:aws:eks:us-west-1:232048837608:cluster/gitaction"
    tags                           = {}
    irsa_iam_role_path             = {}
    irsa_iam_permissions_boundary  = {}
  })
}