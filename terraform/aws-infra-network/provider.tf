terraform {
  cloud {
    organization = "abdulhussain-internal-test-org"

    workspaces {
      name = "internal-test-workspace"
    }
  }
}
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      env                      = "test"
      app                      = "ecs"
    }
  }
}