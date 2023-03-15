data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "Oaklabs"
    workspaces = {
      name = "getprospa-networking-qa"
    }
  }
}
