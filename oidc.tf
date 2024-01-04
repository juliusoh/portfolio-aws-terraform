# module "github_actions_oidc" {
#   source = "./tf_aws_oidc"  // path to the module

#   github_url      = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
#   oidc_url        = "https://token.actions.githubusercontent.com"
#   client_id_list  = ["sts.amazonaws.com"] 
#   org_repo        = "juliusoh/portfolio-aws-terraform"
#   allowed_actions = ["*"]
# }