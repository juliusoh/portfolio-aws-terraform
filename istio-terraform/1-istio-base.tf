resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"   
  create_namespace = true
  version = "1.23.3"

  set {
    name = "global.istioNamespace"
    value = "istio-system"
  }
}
