data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "Oaklabs"
    workspaces = {
      name = "getprospa-${var.stack["networking"]}-${var.environment["qa"]}"
    }
  }
}
