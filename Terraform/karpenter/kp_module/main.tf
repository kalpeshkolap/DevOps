resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  namespace = "kube-system"
  version = "1.0.8"
  upgrade_install = true
  set {
    name  = "settings.clusterName"
    value = var.clustername
  }
  set {
    name  = "settings.interruptionQueue"
    value = var.clustername
  }
  set {
    name  = "replicas"
    value = "1"
  }
}