resource "helm_release" "argocd" {
  count = var.deploy_argocd ? 1 : 0

  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  namespace = "argocd"
  create_namespace = true 
  version = "3.35.4"

  values = [file("${path.module}/values/argocd.yaml")]
}
